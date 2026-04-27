# e4-period-assign — QA Scenarios

## Escenarios
| ID | Descripción | Estado |
|----|-------------|--------|
| E4.1 | `getShipmentRequestInfo` retorna `originalVehicleId` cuando está en BD | ✅ PASS (2026-04-10, UAT) |
| E4.2 | Al despachar (`DISPATCH_TRUCK`), SR queda con `period_id` asignado | ⬜ pendiente |
| E4.3 | Si patente es de reemplazo, período se resuelve con patente original | ⬜ pendiente |
| E4.4 | Si patente no pertenece a flota ni es reemplazo → error bloqueante | ⬜ pendiente |

---

## E4.1 — PASS ✅ (2026-04-10)
- SR 27357 con `original_vehicle_id=10347` en Task DB
- CURL: `GET /shipment-request/27357` con apikey ms-task
- **Resultado:** response incluye `"originalVehicleId": 10347` ✅

---

## E4.2 — Pendiente ⬜
- Precondición: SR en estado ACCEPTED con flota TRANSFER y vehículo de reemplazo asignado
- Despachar desde frontend (Coordinación de Despacho)
- **Esperado:** `SELECT period_id FROM shipment_request WHERE id = <SR_ID>` → no null

---

## E4.3 — Pendiente ⬜
- Precondición: SR con `original_vehicle_id` seteado
- **Esperado:** `period_id` asignado corresponde al período del vehículo **original**, no del reemplazo

---

## E4.4 — Pendiente ⬜
- Precondición: SR con patente que no está en flota ni en `plate_replacement_config`
- **Esperado:** Error bloqueante en recepción — no permite avanzar
