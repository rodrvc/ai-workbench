# e4-period-assign — Tech Artifacts

## SQL verificación (SCHE_TRMG_TASKS_TEST)

```sql
-- Verificar original_vehicle_id guardado al recepcionar
SELECT src.original_vehicle_id, sr.period_id
FROM jt_shipmentrequest_carrier src
JOIN shipment_request sr ON sr.id = src.shipment_request_id
WHERE src.shipment_request_id = 27357;
```

```sql
-- Verificar period_id asignado post-DISPATCH_TRUCK
SELECT id, period_id, state FROM shipment_request WHERE id IN (27357, 27409, 27317);
```
