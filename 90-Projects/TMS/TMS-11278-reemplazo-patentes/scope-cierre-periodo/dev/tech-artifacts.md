# e5-period-close — Tech Artifacts

## CURLs UAT

```bash
# Verificar que ms-shipment retorna originalPlate
curl -s "https://tms-uat-services.falabella.supply/api/v1/ms-transport-shipment/tmgr/transport-shipment/dedicated-fleet/period/24682/shipment" \
  -H "Authorization: Bearer $JWT" \
  -H "apikey: PdWYRvcOfLLL4kJ9G7i7oRYInTlsgE87" \
  -H "X-Country: CL" -H "X-Commerce: FCM"
# Esperado: {"shipments":[{..., "numPlate":"...", "originalPlate":"TRFS01"}]}
```

```bash
# Period-process — fleet 996, fecha 2026-03-26
curl -s -X POST "https://tms-uat-services.falabella.supply/api/v1/ms-transport-fleet/tmgr/transport-fleet/dedicated-fleet-execution/fleet/period-process" \
  -H "Authorization: Bearer $JWT" \
  -H "apikey: 7FMz79r9zvk95plRSIhaj1UK2HGHixCO" \
  -H "X-Country: CL" -H "X-Commerce: FCM" \
  -H "Content-Type: application/json" \
  -d '{"datePeriod":"2026-03-26","actions":{"openNextPeriod":true,"closePeriod":true}}'
```

## SQLs (SCHE_TRMG_SHIPMENT_TEST)

```sql
-- Verificar PR generado con vehículo original
SELECT payment_request_id, vehicle_id FROM payment_request_dedicated_fleet WHERE period_id = 24682;
-- Esperado: vehicle_id = 10514 (TRFS01)
```

```sql
-- Limpiar PRs antes de cada test
DELETE FROM payment_request_dedicated_fleet WHERE period_id = 24682;
```

## SQLs (SCHE_TRMG_FLEET_TEST)

```sql
-- Resetear período a IN_PROCESS
UPDATE dedicatedfleet_period SET dfperd_sts_id = 4, dfperd_flg_closed = false WHERE dfperd_id = 24682;

-- Verificar estado post-cierre (5=FINALIZED)
SELECT dfperd_id, dfperd_sts_id, dfperd_flg_closed FROM dedicatedfleet_period WHERE dfperd_id = 24682;
```
