# e3-incidents — Test Data

## Estado
[FALTA DATA] — No se han ejecutado pruebas en este scope.

## Precondiciones mínimas
- Viaje TRANSFER en estado con incidencia activa (TRUCK_MALFUNCTION o PLATE_NOT_VALID)
- Flota dedicada con `plate_replacement_config` activa para el vehículo del viaje
- JWT fresco con rol de operador que puede resolver incidencias

## Referencia
Usar mismas flotas de prueba que E2:
- Fleet 1000 (Flota Test Reemplazo B): ENR001→GOD007, DJKJS65→FAT002
- Fleet 1001 (PruebasFlotas): AT001→TSTS10
