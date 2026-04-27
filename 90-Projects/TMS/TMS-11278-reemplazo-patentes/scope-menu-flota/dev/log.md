# menu-flota - Dev Log

## Objetivo Técnico
Implementar modal en frontend Angular + endpoints CRUD en ms-fleet para configurar reemplazos de patentes.

## Decisiones Tomadas
- **Dos controles FormControl**: Uno para búsqueda (string), otro para valor (id) - evita issues de sincronización
- **mat-autocomplete**: Con displayFn para convertir id → patente
- **Validación liquidBegPeriod**: Fecha inicio no puede ser anterior al primer periodo de liquidación
- **Fechas null = sin límite**: Cobertura total del tiempo

## Archivos Modificados (Blast Radius)
[FALTA LISTADO DE ARCHIVOS]

## Bugs Corregidos
1. Form-error message cleared prematurely → `enable({emitEvent: false})`
2. Validaciones de fechas en backend
3. Filtrado y UI issues

## Deuda Técnica
- Reescribir Cypress E2E specs post-QA approval
