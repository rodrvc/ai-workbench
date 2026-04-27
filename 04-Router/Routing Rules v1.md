---
type: router
owner: rodvall
status: active
last_verified: 2026-04-27
token_budget: low
---

# Routing Rules v1

## Dónde viven los proyectos

- Trabajo/laboral → `PARA/Areas/[proyecto]/`
- Proyectos personales → `PARA/Projects/[proyecto]/`
- Ejemplo TMS: `PARA/Areas/Falabella/`

## Punto de entrada de cualquier proyecto

Siempre empezar por `_brief/project-context.md` del proyecto.
Si no existe, crear usando [[05-Templates/Project-Context-Template]].

## Regla 1

Si HU toca un solo servicio y bajo riesgo:
- Router → Specialist → QA

## Regla 2

Si HU toca múltiples servicios o contratos API:
- Router → Specialist(s) → Integrator → QA

## Regla 3

Si HU incluye cambios de datos/operación:
- Agregar verificación explícita de seguridad y entorno
