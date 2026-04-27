# e3-incidents — QA Scenarios

## Escenarios
| ID | Descripción | Estado |
|----|-------------|--------|
| E3.1 | Selector de patentes muestra badges (En flota / Reemplazo / No asociada) | ⬜ pendiente |
| E3.2 | Cambiar a patente de reemplazo → resolución exitosa + `original_vehicle_id` guardado | ⬜ pendiente |
| E3.3 | Cambiar a patente no asociada → error bloqueante | ⬜ pendiente |
| E3.4 | Cambio con período asignado → reasignación de período con patente original | ⬜ pendiente |
| E3.5 | Viaje lastmile → sin badges, cualquier patente permitida | ⬜ pendiente |

## Precondiciones
- Viaje TRANSFER con flota dedicada y `plate_replacement_config` activa
- Incidencia de tipo TRUCK_MALFUNCTION o PLATE_NOT_VALID
- Frontend en UAT o local con cambios mergeados

## Nota
Mismo componente frontend que E2 (Presentación en Origen). Si E2 pasa, E3 debería pasar también para los escenarios de badges y validación.
