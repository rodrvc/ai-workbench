# e4-period-assign — Test Data

## SRs disponibles en UAT para pruebas

| shipmentRequestId | dedicatedFleetId | Fleet | replacementVehicleId | Reemplazo |
|---|---|---|---|---|
| 27357 | 991 | Prueba Flujo MAX | 10604 | DURN02 |
| 27318 | 991 | Prueba Flujo MAX | 10604 | DURN02 |
| 27409 | 1000 | Flota Test Reemplazo B | 5861 | GOD007 |
| 27317 | 1001 | PruebasFlotas | 10619 | TSTS10 |

## CURLs UAT

```bash
# Verificar getShipmentRequestInfo
curl -s "https://tms-uat-services.falabella.supply/api/v1/ms-transport-tasks/tmgr/transport-task/shipment-request/27357" \
  -H "Authorization: Bearer $JWT" \
  -H "apikey: wQ20NV8XA5TqZYoKRDThzfQbe10gMfQ8"
# Esperado: { "originalVehicleId": 10347 }
```

```bash
# Verificar fleet-status
curl -s "https://tms-uat-services.falabella.supply/api/v1/ms-transport-tasks/tmgr/transport-task/equipment/fleet-status?shipmentRequestId=27357" \
  -H "Authorization: Bearer $JWT" \
  -H "apikey: wQ20NV8XA5TqZYoKRDThzfQbe10gMfQ8"
```

## SQL verificación (SCHE_TRMG_TASKS_TEST)

```sql
-- Verificar period_id asignado post-despacho
SELECT id, period_id, original_vehicle_id FROM shipment_request WHERE id = 27357;
```
