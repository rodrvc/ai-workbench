# Handoff Dev — Agente Soporte Proforma SAP

> Ticket: TMS-support | Sesión: 2026-04-16 | Rol: Dev (En curso)

---

## Estado de Implementación

- ⬜ Investigación de causa raíz — flow diagram Pub/Sub
- ⬜ Localización de listeners en ms-payment
- ⬜ Queries de diagnóstico BD
- ⬜ Endpoints de reparación manual
- ⬜ Agente para auto-diagnosis

---

## Bloqueos Actuales

**Falta data**: No hay acceso a código fuente de ms-payment en este contexto. Necesario:
1. Repo `ms-payment` (Java/Spring Boot)
2. Clase `ProformaServiceImpl` en `ms-shipment`
3. Configuration de Pub/Sub (listeners de `PROFORMA_INVOICE_ATTACH_REQUESTED`)

---

## Arquitectura Conocida

```
ms-shipment (saveInvoiceProforma)
  ↓ envía evento Pub/Sub
  PROFORMA_INVOICE_ATTACH_REQUESTED
  ↓ debe ser escuchado por
  ms-payment (desconocido: qué listener, qué hace)
  ↓ debería cambiar proforma a siguiente estado
  (¿cuál es el siguiente estado después de PENDING?)
```

---

## Next Actions Dev

1. **Acceder a repos**
   - `sche-trmg-backend-ms-payment` — buscar listeners de Pub/Sub
   - `sche-trmg-backend-ms-shipment` — verificar `ProformaServiceImpl.saveInvoiceProforma()`

2. **Queries BD para diagnóstico**
   ```sql
   -- Contar proformas PENDING
   SELECT COUNT(*) as pending_count 
   FROM proforma 
   WHERE prf_status_id = 8;
   
   -- Detalles de proformas atascadas
   SELECT prf_id, prf_status_id, prf_creation_date, prf_invoice_date
   FROM proforma 
   WHERE prf_status_id = 8
   ORDER BY prf_creation_date DESC;
   
   -- PRs asociadas
   SELECT prs_id, prs_status_id, prs_creation_date
   FROM payment_request_shipment
   WHERE payment_request_id IN (
    SELECT payment_request_id 
    FROM proforma_payment_request 
    WHERE proforma_id = ?
   );
   ```

3. **Logs / Debugging**
   - Revisar logs de Pub/Sub — ¿el evento se envió correctamente?
   - Revisar logs de ms-payment — ¿hubo errores al procesar el evento?
   - Buscar dead-letter queues o retry exhausted

4. **Crear endpoint de reparación** (si corresponde)
   - GET `/api/proforma-diagnosis/{proformaId}` — estado completo
   - POST `/api/proforma/{id}/retry-payment-process` — reenviar a SAP manualmente

---

## Decisiones Técnicas

- Usar strategy pattern (similar a `reprocess-shipment-tms`) para diagnostic strategies
- Crear módulo `ProformaService` con validaciones por estado
- Pub/Sub como fuente de verdad para eventos (no polling de BD)

---

## Dead Ends Dev

- (ninguno aún)

---

## MRs Pendientes

- (ninguno aún)
