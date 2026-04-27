# menu-flota - QA Scenarios

## CP001-CP009: Manual QA Testing
[FALTA DETALLE DE CADA CASO]

## Precondiciones
- Flota dedicada activa con tipo TRANSFER
- Vehículos disponibles en el carrier
- Usuario con permisos de edición de flota

## Escenarios Clave

### CP-Create: Crear configuración de reemplazo
1. Navegar a menú Flota
2. Seleccionar flota dedicada
3. Abrir modal de reemplazo de patentes
4. Ingresar vehículo original
5. Ingresar vehículo reemplazo
6. Ingresar fechas vigencia
7. Guardar

**Esperado**: Configuración creada, visible en grilla

### CP-Date-Validation: Validación fechas
1. Intentar crear config con fecha inicio < primer periodo liquidación
2. Intentar crear config con fechas solapadas para mismo vehículo

**Esperado**: Error de validación mostrado

### CP-Delete: Eliminar configuración
1. Seleccionar config existente
2. Click eliminar
3. Confirmar

**Esperado**: Config eliminada, no visible en grilla

## E2E Tests
- `sche-trmg-e2e-tms-integration/cypress/e2e/ms-fleet/ui/plate-replacement-modal.cy.ts`
