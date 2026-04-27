# presentacion-origen - Tech Artifacts

## API Endpoints (ms-task)

```
GET /equipment/fleet-status?shipmentRequestId={id}
GET /equipment/replacement-originals?dedicatedFleetId={id}&replacementVehicleId={id}
POST /equipment/shipment-request/validate
```

## CURL Commands

### Fleet Status
```bash
TASK_URL="http://localhost:8085"
TOKEN="Bearer <TOKEN>"
APIKEY_TASK="wQ20NV8XA5TqZYoKRDThzfQbe10gMfQ8"
SR_ID="<shipment_request_id>"

curl -s "$TASK_URL/tmgr/transport-task/equipment/fleet-status?shipmentRequestId=$SR_ID" \
  -H "Authorization: $TOKEN" \
  -H "apikey: $APIKEY_TASK" \
  -H "X-Country: CL" \
  -H "X-Commerce: SOD"
```

### Replacement Originals
```bash
# usar dedicatedFleetId + replacementVehicleId del response anterior
DF_ID="<dedicated_fleet_id>"
RV_ID="<replacement_vehicle_id>"

curl -s "$TASK_URL/tmgr/transport-task/equipment/replacement-originals?dedicatedFleetId=$DF_ID&replacementVehicleId=$RV_ID" \
  -H "Authorization: $TOKEN" \
  -H "apikey: $APIKEY_TASK" \
  -H "X-Country: CL" \
  -H "X-Commerce: SOD"
```

## SQL Queries

### Corregir carrier ID
```sql
UPDATE jt_shipmentrequest_carrier 
SET carrier_id = 330 
WHERE shpreq_id IN (27318, 27357) 
AND active = true;
```

## JSON Payloads
[FALTA EJEMPLOS DE REQUEST/RESPONSE]
