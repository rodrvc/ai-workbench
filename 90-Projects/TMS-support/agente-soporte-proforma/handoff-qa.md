# Handoff QA — Agente Soporte Proforma SAP

> Ticket: TMS-support | Sesión: 2026-04-16 | Entorno: UAT

---

## Escenarios de Prueba

| ID | Descripción | Estado | Precondición |
|----|-------------|--------|--------------|
| E1 | Crear proforma y asociar factura | ⬜ pendiente | Proforma en estado inicial |
| E2 | Verificar cambio a PENDING (state=8) | ⬜ pendiente | E1 completado |
| E3 | Monitorear evento Pub/Sub | ⬜ pendiente | E2 completado |
| E4 | Simular fallo de listener en ms-payment | ⬜ pendiente | Control de Pub/Sub |
| E5 | Verify recovery / manual retry | ⬜ pendiente | E4 completado |

---

## Pendientes — Próxima Sesión QA

### E1 — Crear proforma y asociar factura
**Prerequisitos**: Acceso a TMS UAT, rol con permisos de carrier
- Crear `payment_request_shipment` (vía API o UI)
- Agrupar en `proforma`
- Desde UI de carrier: asociar factura a proforma
- Esperado: `proforma.prf_status_id = 8` (PENDING)
- Verificar evento en Pub/Sub: `PROFORMA_INVOICE_ATTACH_REQUESTED`

### E2 — Monitoreo de cambio de estado
- Query BD: `SELECT prf_status_id, prf_invoice_date FROM proforma WHERE prf_id = ?`
- Esperado: timestamp de cambio ≤ 1 segundo después de "asociar factura"
- Gotcha: Si el estado no cambia inmediatamente, revisar si `saveInvoiceProforma` fue llamado realmente

### E3 — Verificar evento Pub/Sub
- Acceder a Google Cloud Console → Pub/Sub → topic `PROFORMA_INVOICE_ATTACH_REQUESTED`
- Buscar mensaje con `proformaId=<tuId>`
- Esperado: mensaje presente, timestamp reciente
- Gotcha: Los mensajes se purgan después de cierto tiempo, así que revisar logs en tiempo real o poco después

### E4 — Simular fallo en listener
- Bajar ms-payment (o desactivar listener temporalmente)
- Crear proforma y asociar factura
- Verificar que proforma queda en PENDING (state=8) indefinidamente
- Esperado: Mensaje en Pub/Sub pero sin procesar, proforma atascada

### E5 — Recovery / manual retry
- Una vez identificado el fallo, reactivar ms-payment
- Opción A: Pub/Sub reentrega automático
- Opción B: Endpoint de retry manual (si existe)
- Esperado: Proforma sale de PENDING, llega a siguiente estado

---

## Active Test Data

| Dato | Valor | Estado |
|------|-------|--------|
| Carrier | [FALTA DATA] | pendiente |
| Proforma | [FALTA DATA] | pendiente |
| Payment Request | [FALTA DATA] | pendiente |

---

## Dead Ends QA

- (ninguno aún)

---

## Nota para próxima sesión

Coordinar con Dev para:
- Clarificar cuál es el siguiente estado después de PENDING (state=8)
- Endpoint para cambiar estado manualmente (si no existe listener)
- Logs de Pub/Sub o evento para verificación real
