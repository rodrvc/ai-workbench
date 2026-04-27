# HU: Agente Soporte Proforma

**Proyecto**: TMS-support  
**Objetivo**: Documentar el flujo de proformas SAP/mock para construir un agente que pueda diagnosticar y reparar casos de proformas stuck autónomamente.

---

## Contexto de Dominio

### Estados de Proforma
| Estado | Nombre | Descripción |
|--------|--------|-------------|
| 1 | CREATED | Proforma creada |
| 2 | PAYMENT_PROCESS_PENDING | Pendiente de proceso de pago |
| 3 | PAYMENT_PROCESS_OK | Pago procesado correctamente |
| 4 | ERROR | Error en proceso |
| 5 | INVOICE_CHANGE_PENDING | Cambio de factura pendiente |
| 6 | ANNULLED | Anulada |
| 7 | POSTED | Contabilizada |
| 8 | PENDING | Factura asignada, esperando confirmación SAP/mock |
| 9 | CLAIMED | Reclamada |
| 11 | PAYED | Pagada |
| 12 | FINALIZED | Finalizada |

### Flujo Normal (países con SAP: CL, PE)
```
Operador asigna factura 
  → proforma estado 8 
  → Pub/Sub PROFORMA_INVOICE_ATTACH_REQUESTED 
  → ms-payment llama SAP 
  → SAP responde → payment_confirmation_response 
  → delivery plan event 
  → proforma estado 3
```

### Flujo Mock (sin SAP: AR, UY, MX, CO — has_financial_system=false)
```
Operador asigna factura 
  → proforma estado 8 
  → Pub/Sub PROFORMA_INVOICE_ATTACH_REQUESTED 
  → ms-payment: createProvisionMock() genera confirmación sintética 
  → INSERT payment_confirmation_response 
  → updateConfirmationOnMsShipment() 
  → delivery plan event 
  → proforma estado 3
```

---

## Traza de Datos en payment DB

Para diagnosticar cualquier proforma, seguir esta cadena:

| Paso | Tabla | Campo clave | Qué indica |
|------|-------|-------------|------------|
| 1 | `payment_request` (TMS-OF) | `pmtreq_guid` | El evento fue recibido y procesado |
| 2 | `payment_request_message` | `message = 'Sin integración'`, `action_type = INVOICE_ATTACHED` | Mock arrancó (misma transacción que paso 1) |
| 3 | `payment_confirmation_response` | `pmtcon_guid = pmtreq_guid` | Mock completó exitosamente |
| 4 | `payment_request` | `pmtreq_confirm_state = 1` | ms-shipment fue notificado |

Si el paso 1 y 2 existen pero el 3 no → el mock falló (rollback). El paso 4 nunca ocurre sin el paso 3.

---

## Caso Investigado: 7 Proformas AR/SOD Stuck en Estado 8

### Contexto
- País: Argentina (AR), Commerce: SOD
- `has_financial_system = false` → usa flujo mock
- 7 proformas en estado 8 (PENDING) sin avanzar

### IDs afectados
| proforma_id | factura | guid |
|-------------|---------|------|
| 29465 | SARfebrero20261 | BCA9A43A70CA4EED98B086C97FFE33C7 |
| 29898 | GLIfebrero20262 | D8B82A8788DA4321B6669DF328CFE128 |
| 30181 | SARfebrero20262 | DD81E70F634A400385C0479591E60C5A |
| 30183 | SARfebrero20263 | 7D6509631555446D830A7ABF585FED5B |
| 30523 | SARmarzo2026 | 1025CE0B43E34E319915504B9E2866CD |
| 30693 | SARmarzo20261 | 806C9E3BB8814E368C73D933F6CD1BA9 |
| 30980 | SARmarzo20262 | 15E64EC6BB3D42CB9BB1A0AD7F470803 |

### Causa Raíz
El campo `pmtcon_num_pos_purchase_doc` en `payment_confirmation_response` tiene límite **varchar(10)**.

El mock guarda el nombre de la factura en ese campo (`pNroPosDocCompra`). Las facturas recientes de AR tienen más de 10 caracteres:

| Factura | Largo | Resultado |
|---------|-------|-----------|
| PEP-Mayo-1 | 10 ✓ | Funcionó (última exitosa: 2025-06-10) |
| SARfebrero20261 | 15 ✗ | DataIntegrityViolationException |
| SARmarzo2026 | 12 ✗ | DataIntegrityViolationException |

### Mecanismo de Fallo
```
1. savePaymentWithPendingStatus() → COMMIT (payment_request + mensaje "Sin integración")
2. createProvisionMock() → DataIntegrityViolationException → ROLLBACK
3. payment_confirmation_response: 0 registros
4. updateConfirmationOnMsShipment(): nunca ejecuta
5. proforma: queda en estado 8 para siempre

En reintento Pub/Sub:
  validateIfTmsSentMessageToSap() → payment_request existe → retorna true → ack silencioso
  → stuck permanente
```

### Por qué las 74 "estado 3" también tienen confirm_state=null
Las proformas AR/SOD anteriores que están en estado 3 pero con `confirm_state=null` en payment DB fueron **movidas manualmente** a estado 3 en shipment DB. No pasaron por el flujo de confirmación.

---

## Fix Propuesto (pendiente aprobación del equipo)

### Fix de datos (las 7 proformas)
```sql
-- 1. Shipment DB: actualizar estado
UPDATE proforma 
SET profrm_id_state = 3, profrm_dttm_last_modified = now()
WHERE profrm_id IN (29465,29898,30181,30183,30523,30693,30980)
  AND profrm_id_state = 8;

-- 2. Payment DB: insertar confirmaciones (una por guid, con factura completa)
-- 3. Payment DB: actualizar pmtreq_confirm_state = 1
-- 4. Payment DB: actualizar mensaje con nota "registro creado sin limitacion de caracteres"
```

### Fix estructural (ms-payment)
```sql
ALTER TABLE payment_confirmation_response 
ALTER COLUMN pmtcon_num_pos_purchase_doc TYPE varchar(50);
```
Y actualizar la entidad Java `SapPaymentConfirmationEntity`:
```java
@Column(name = "pmtcon_num_pos_purchase_doc", length = 50)  // era 10
private String pNroPosDocCompra;
```

---

## Queries de Diagnóstico

### Buscar proformas stuck en estado 8 por país
```sql
SELECT profrm_id, profrm_id_state, profrm_nbr_invoice, 
       profrm_dttm_invoice, profrm_dttm_created
FROM proforma
WHERE cd_country = 'AR'
  AND cd_logistic_operator = 'SOD'
  AND profrm_id_state = 8
ORDER BY profrm_id;
```

### Verificar traza completa de una proforma en payment DB
```sql
SELECT 
  pr.pmtreq_bill_order_num AS proforma_id,
  pr.pmtreq_guid,
  COUNT(DISTINCT pr.pmtreq_id)  AS payment_request_rows,
  COUNT(DISTINCT m.id)          AS message_rows,
  COUNT(DISTINCT pcr.pmtcon_id) AS confirmation_rows,
  MAX(pr.pmtreq_confirm_state)  AS confirm_state
FROM payment_request pr
LEFT JOIN payment_request_message m ON m.guid = pr.pmtreq_guid
LEFT JOIN payment_confirmation_response pcr ON pcr.pmtcon_guid = pr.pmtreq_guid
WHERE pr.pmtreq_bill_order_num = '<PROFORMA_ID>'
  AND pr.pmtreq_reference_op = 'TMS-OF'
GROUP BY 1, 2;
```

### Ver última confirmación exitosa para un país
```sql
SELECT pmtreq_bill_order_num AS proforma_id,
       pmtreq_confirm_state, pmtreq_confirm_message,
       max(pmtreq_dttm_update) AS last_update
FROM payment_request
WHERE pmtreq_cd_iso_country = 'AR'
  AND pmtreq_cd_commerce = 'SOD'
  AND pmtreq_reference_op = 'TMS-OF'
  AND pmtreq_confirm_state = 1
GROUP BY 1,2,3
ORDER BY last_update DESC;
```

---

## Conexiones a DBs

| DB | Host | Puerto | Usuario | Base |
|----|------|--------|---------|------|
| Shipment | localhost | 5433 | SCHE_TRMG_SHIPMENT_PROD_USER | SCHE_TRMG_SHIPMENT_PROD |
| Payment | localhost | 5433 | SCHE_TRMG_PAYMENT_PROD_USER | SCHE_TRMG_PAYMENT_PROD |

---

## Log de Sesión

| Fecha | Acción | Resultado |
|-------|--------|-----------|
| 2026-04-16 | Investigación inicial: 7 proformas estado 8 AR/SOD | Causa raíz identificada: varchar(10) en pmtcon_num_pos_purchase_doc |
| 2026-04-16 | Fix propuesto | Pendiente aprobación del equipo |
