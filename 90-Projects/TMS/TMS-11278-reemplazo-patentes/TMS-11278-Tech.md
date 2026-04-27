---
type: tech
status: qa_in_progress
last_verified: 2026-04-10
---

# TMS-11278 — Technical Assets

## Endpoints (ms-task)
- `GET /tmgr/transport-task/equipment/fleet-status?shipmentRequestId=$SR_ID`
- `GET /tmgr/transport-task/equipment/replacement-originals?dedicatedFleetId=$DF_ID&replacementVehicleId=$RV_ID`
- `POST /tmgr/transport-task/shipment-request/receive` (envía `originalVehicleId`)

## Endpoints (ms-shipment)
- `POST /tmgr/transport-shipment/shipment/dispatch`
- `GET /tmgr/transport-shipment/shipment-request/{id}/info` (consumido por task en resolución)

## Endpoints (cierre de período)
- `POST /tmgr/transport-fleet/dedicated-fleet-execution/fleet/period-process`

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

## Queries SQL (validación QA cierre)
```sql
-- TASK: confirmar original_vehicle_id y period_id
SELECT sr.shrq_id, sr.period_id, src.original_vehicle_id
FROM shipment_request sr
LEFT JOIN shipment_request_carrier src
  ON src.asgn_shr_id = sr.shrq_id AND src.flg_active = true
WHERE sr.shrq_id = :shipmentRequestId;

-- SHIPMENT: confirmar patente original persistida
SELECT shpmnt_id, shpmnt_shrq_id, shpmnt_equipment_plate, shpmnt_original_plate
FROM shipment
WHERE shpmnt_shrq_id = :shipmentRequestId
ORDER BY shpmnt_id DESC;
```

## Puertos Locales
- Frontend: `4200`
- ms-task: `8085`
- ms-fleet: `8082`
- ms-shipment: `8083`

## Versiones UAT (post-merge)
- `ms-task`: `3.198.1`
- `ms-shipment`: `2.101.1`
- `ms-fleet`: `2.60.1`
- `frontend`: `3.60.0`
