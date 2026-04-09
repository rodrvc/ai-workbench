---
type: policy
status: active
last_verified: 2026-04-09
---

# Policy - Token Budget

## Principios

- Contexto minimo viable primero.
- Cargar detalle solo bajo demanda.
- Evitar duplicacion entre global, agentes y skills.

## Budget base

- Router step: bajo (clasificacion + plan corto).
- Specialist step: medio (solo archivos y reglas relevantes).
- Integrator step: medio-bajo (consolidacion y conflictos).
- QA/reporting step: medio (evidencia y cierre).

## Reglas operativas

- Si un documento supera 250 lineas, crear version resumida operativa.
- Si una skill supera 300 lineas, modularizar por casos.
