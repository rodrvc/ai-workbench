---
type: tech
status: active
last_verified: 2026-04-09
---

# TMS-11278 — Technical Assets

## Endpoints (ms-task)
- `GET /tmgr/transport-task/equipment/fleet-status?shipmentRequestId=$SR_ID`
- `GET /tmgr/transport-task/equipment/replacement-originals?dedicatedFleetId=$DF_ID&replacementVehicleId=$RV_ID`
- `POST /tmgr/transport-task/shipment-request/receive` (envía `originalVehicleId`)

## API Keys (UAT)
- `ms-transport-fleet`: `7FMz79r9zvk95plRSIhaj1UK2HGHixCO`
- `ms-transport-tasks`: `wQ20NV8XA5TqZYoKRDThzfQbe10gMfQ8`

## Queries SQL (Fleet DB)
### Buscar combinaciones con un solo original (C7.3)
```sql
SELECT defleet_id, replacement_vehicle_id, COUNT(*) AS originals
FROM plate_replacement_config
WHERE active = true
GROUP BY defleet_id, replacement_vehicle_id
HAVING COUNT(*) = 1
ORDER BY defleet_id, replacement_vehicle_id;
```

### Forzar respuesta vacía para originales (C7.4)
```sql
UPDATE plate_replacement_config
SET active = false
WHERE defleet_id = <DF_ID>
  AND replacement_vehicle_id = <RV_ID>
  AND active = true;
```

## Puertos Locales
- Frontend: `4200`
- ms-task: `8085`
- ms-fleet: `8082`
- ms-shipment: `8083`
