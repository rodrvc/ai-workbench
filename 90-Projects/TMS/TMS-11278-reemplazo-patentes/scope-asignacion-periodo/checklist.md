# e4-period-assign — Checklist

## Dev
- [x] `getShipmentRequestInfo` expone `originalVehicleId` en response
- [x] `original_vehicle_id` persiste en `jt_shipmentrequest_carrier`
- [ ] `findPeriodForShipmentRequest` resuelve con patente original cuando hay reemplazo

## QA
- [x] E4.1: API retorna `originalVehicleId` ✅ (2026-04-10)
- [ ] E4.2: DISPATCH_TRUCK → `period_id` asignado en SR
- [ ] E4.3: período resuelto con patente original
- [ ] E4.4: patente no asociada → error bloqueante
