# e5-period-close — Dev Log

## Objetivo técnico
`applyOriginalPlateSwap()` en ms-fleet detecta shipments con vehículo de reemplazo y hace swap antes de calcular tarifa → PR generado con vehículo original.

## Decisiones técnicas
- ms-fleet busca shipments por `periodId` (NO por placa) → URL: `/period/%d/shipment`
- `applyOriginalPlateSwap` corre en línea 177, **antes** de `payEquipmentByBetterRate` (línea 201)
- Swap condicional: `originalPlate != null && originalPlate != numPlate`
- `closeWorkingDay` matchea por plateNumber **después** del swap → correcto
- ms-shipment usa `default-property-inclusion: non_null` → campo null no aparece en JSON response

## Fix crítico deployado
- **Commit:** `42e86d6a` en ms-shipment
- **Qué hace:** `updateShipmentOriginalPlate()` en `ShipmentServiceImpl.dispatchShipment()` — persiste `shpmnt_original_plate` cuando ms-task devuelve `originalVehicleId`
- **Sin este commit:** `getOriginalPlate()` siempre retorna null → swap nunca ocurre
- **Versión deployada:** ms-shipment 2.101.1

## Archivos modificados
| Archivo | MS | Cambio |
|---------|-----|--------|
| `ShipmentServiceImpl.java` | ms-shipment | `updateShipmentOriginalPlate()` en `dispatchShipment()` |
| `ShipmentRequestInfoDto.java` | ms-shipment | +campo `originalPlate` |
| `DedicatedFleetPeriodImpl.java` | ms-fleet | `applyOriginalPlateSwap()` líneas 1257-1278 |

## Dead Ends
- Buscar shipments por placa en lugar de periodId → descartado, URL ya usa `%d` (periodId)
- `ViewVehicleRecordEntity` vs `VehicleRecordEntity`: misma tabla `vehicle`, usar View para `plate`
