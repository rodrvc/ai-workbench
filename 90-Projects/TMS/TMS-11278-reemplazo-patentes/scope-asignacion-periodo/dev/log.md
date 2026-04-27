# e4-period-assign — Dev Log

## Objetivo técnico
Al despachar (`DISPATCH_TRUCK`), ms-task debe asignar `period_id` buscando el período por la patente **original** (no la del reemplazo).

## Decisiones técnicas
- `findPeriodForShipmentRequest()` debe resolver con `originalVehicleId` cuando está seteado
- `original_vehicle_id` se persiste en `jt_shipmentrequest_carrier` al recepcionar con vehículo de reemplazo
- ms-task recibe `originalVehicleId` desde `getShipmentRequestInfo()` — ya verificado ✅

## Archivos clave
| Archivo | MS | Rol |
|---------|-----|-----|
| `ShipmentRequestServiceImpl.java` | ms-task | `findPeriodForShipmentRequest()` |
| `jt_shipmentrequest_carrier` | Task DB | campo `original_vehicle_id` |

## Estado
- Lectura de `originalVehicleId` en API: ✅ verificado (SR 27357)
- Escritura de `period_id` al despachar: ⬜ pendiente verificación
