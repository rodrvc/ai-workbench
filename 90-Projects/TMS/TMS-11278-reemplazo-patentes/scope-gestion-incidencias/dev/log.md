# e3-incidents — Dev Log

## Objetivo técnico
En Gestión de Incidencias, al cambiar patente a un vehículo de reemplazo, guardar `original_vehicle_id` y reasignar período con patente original.

## Decisiones técnicas
- Mismo componente Angular que E2 (Presentación en Origen) para los badges
- `findPeriodForShipmentRequest()` en ms-task resuelve período con patente original (E3.4)
- Implementación compartida con scope `e2-presentation` y `e4-period-assign`

## Estado
- Implementación: incluida en MR ms-task !897 (mergeado a `uat`)
- QA: ⬜ pendiente — no se han ejecutado pruebas
