---
type: router
owner: rodvall
status: active
last_verified: 2026-04-09
token_budget: low
---

# Routing Rules v1

## Regla 1

Si HU toca un solo servicio y bajo riesgo:

- Router -> Specialist -> QA

## Regla 2

Si HU toca multiples servicios o contratos API:

- Router -> Specialist(s) -> Integrator -> QA

## Regla 3

Si HU incluye cambios de datos/operacion:

- Agregar verificacion explicita de seguridad y entorno
