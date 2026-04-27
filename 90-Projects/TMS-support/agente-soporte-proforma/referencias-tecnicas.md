# Referencias Técnicas — Agente Soporte Proforma SAP

---

## Enum Estados Proforma

```
ProformaStatusEnums:
  state=1 → CREATED (inicial)
  state=2 → APPROVED
  state=3 → [¿cuál es?]
  ...
  state=8 → PENDING (atascado aquí)
  state=X → [siguiente después de PENDING — FALTA DATA]
```

**Localización**: `sche-trmg-backend-ms-shipment/src/main/java/.../enums/ProformaStatusEnums.java`

---

## Clase ProformaServiceImpl

### Método saveInvoiceProforma()
**Responsabilidad**: Cambiar estado de proforma a PENDING (8) cuando carrier asocia factura.

**Ubicación**: `sche-trmg-backend-ms-shipment/src/main/java/.../service/impl/ProformaServiceImpl.java`

**Lógica esperada** (a confirmarse):
```java
public void saveInvoiceProforma(ProformaInvoiceRequest request) {
  // 1. Validar proforma existe
  // 2. Cambiar estado a 8 (PENDING)
  // 3. Guardar factura (invoice data)
  // 4. ENVIAR EVENTO → PROFORMA_INVOICE_ATTACH_REQUESTED
  // 5. Retornar confirmación
}
```

---

## Evento Pub/Sub: PROFORMA_INVOICE_ATTACH_REQUESTED

**Topic**: `PROFORMA_INVOICE_ATTACH_REQUESTED`  
**Productor**: `ms-shipment` (ProformaServiceImpl)  
**Consumidor**: `ms-payment` (desconocido — FALTA localizar)

**Payload esperado** (a verificar):
```json
{
  "proformaId": "<uuid>",
  "proformaStatus": 8,
  "invoiceDate": "<date>",
  "invoiceNumber": "<string>",
  "carrierId": "<id>"
}
```

---

## Listener en ms-payment

**Buscable por**:
- Clase o bean que escucha `PROFORMA_INVOICE_ATTACH_REQUESTED`
- Método anotado con `@PubsubListener` o similar
- Referencias a "proforma" + "invoice"

**Ubicación**: `sche-trmg-backend-ms-payment/src/main/java/.../...`

**¿Qué hace?**: [FALTA DATA]
- ¿Envía a SAP?
- ¿Valida datos de factura?
- ¿Cambia estado de proforma?

---

## Estados POST-PENDING

Después de que ms-payment procesa el evento, ¿a qué estado cambia la proforma?

| State | Nombre | Condición |
|-------|--------|-----------|
| 8 | PENDING | Mientras espera confirmación de SAP |
| ? | [SIGUIENTE] | Cuando [condición — FALTA DATA] |

---

## Queries de Diagnóstico

### Contar proformas PENDING
```sql
SELECT COUNT(*) as pending_count 
FROM proforma 
WHERE prf_status_id = 8;
```

### Detalles de proformas atascadas
```sql
SELECT 
  prf_id,
  prf_status_id,
  prf_creation_date,
  prf_invoice_date,
  prf_carrier_id
FROM proforma 
WHERE prf_status_id = 8
ORDER BY prf_creation_date DESC;
```

### PRs asociadas a una proforma
```sql
SELECT 
  pr.prs_id,
  pr.prs_status_id,
  pr.prs_creation_date,
  ppf.proforma_id
FROM payment_request_shipment pr
JOIN proforma_payment_request ppf ON ppf.payment_request_id = pr.prs_id
WHERE ppf.proforma_id = ?;
```

### Timeline de cambios de estado
```sql
SELECT 
  prf_id,
  prf_status_id,
  prf_updated_date
FROM proforma 
WHERE prf_id = ?
ORDER BY prf_updated_date DESC;
```

---

## Endpoints Hipotéticos

### Obtener detalles de proforma
```
GET /api/v1/ms-shipment/proforma/{proformaId}
Response:
{
  "id": "<uuid>",
  "status": 8,
  "invoiceDate": "<date>",
  "createdDate": "<date>",
  "paymentRequests": [...]
}
```

### Obtener PRs de una proforma
```
GET /api/v1/ms-shipment/proforma/{proformaId}/payment-requests
Response:
[
  {
    "id": "<uuid>",
    "status": "<enum>",
    "creationDate": "<date>"
  }
]
```

### Retry / manual process (hipotético)
```
POST /api/v1/ms-payment/proforma/{proformaId}/retry
Body: {}
Response: { "status": "reprocessing" }
```

---

## Logs a Revisar

1. **ms-shipment logs**
   - Búsqueda: "PROFORMA_INVOICE_ATTACH_REQUESTED"
   - Búsqueda: "saveInvoiceProforma"
   - Búsqueda: "proforma" + "invoice"

2. **ms-payment logs**
   - Búsqueda: "PROFORMA_INVOICE_ATTACH_REQUESTED"
   - Búsqueda: evento que no fue procesado
   - Búsqueda: errores de SAP integration

3. **Pub/Sub logs (GCP)**
   - Dead-letter queue: mensajes que no fueron entregados
   - Retry exhausted: intentos de reentrega agotados
   - Processing errors: listener falló

---

## Conexión a BD

**Host**: `10.44.2.12:5432` o via tunnel `localhost:5433`  
**User**: `usr_tms_shipment`  
**DB**: `SCHE_TRMG_SHIPMENT`

**Tablas principales**:
- `proforma` — estado de proformas
- `payment_request_shipment` — PRs individuales
- `payment_request_ref` — ref cruzada
- `proforma_payment_request` — join table

---

## Stack Técnico

| Componente | Tecnología |
|------------|------------|
| ms-shipment | Java 8 / Spring Boot 2.1 / Maven |
| ms-payment | Java 8 / Spring Boot 2.1 / Maven |
| Evento | Google Cloud Pub/Sub |
| BD | PostgreSQL (SCHE_TRMG_SHIPMENT) |
| Auth | JWT (vía ms-shipment) |

