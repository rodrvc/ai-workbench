# menu-flota - Checklist

## Frontend
- [ ] Modal abre correctamente
- [ ] Autocomplete muestra vehículos disponibles
- [ ] Validación de campos requeridos
- [ ] Fechas: validación de rangos
- [ ] Botón guardar habilitado/deshabilitado según formulario
- [ ] Mensajes de error claros
- [ ] Grid actualiza después de CRUD

## Backend (ms-fleet)
- [ ] GET replacement-vehicles retorna vehículos correctos
- [ ] POST crea config con datos válidos
- [ ] DELETE elimina config (soft delete)
- [ ] Validación de fechas solapadas
- [ ] Validación de fleet type (TRANSFER only - TMS-11331 pendiente)

## Integración
- [ ] Flujo completo create/read/update/delete
- [ ] Manejo de errores HTTP

## Pendientes
- [ ] TMS-11331: Prevenir reemplazos en flotas non-TRANSFER
