# menu-flota - Test Data

## Setup
[FALTA SCRIPT DE SETUP]

## Data de Prueba Conocida

### Corregir carrier ID en SRs
```sql
UPDATE jt_shipmentrequest_carrier 
SET carrier_id = 330 
WHERE shpreq_id IN (27318, 27357) 
AND active = true;
```

## Variables de Entorno
```bash
FLEET_URL="http://localhost:8080"  # [FALTA CONFIRMAR PUERTO]
TOKEN="Bearer <TOKEN>"
APIKEY="[FALTA API KEY]"
```
