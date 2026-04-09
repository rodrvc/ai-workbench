---
type: adapter
runtime: gpt
status: active
last_verified: 2026-04-09
---

# GPT Adapter

Mapea el core agnostico a ejecuciones con modelos GPT.

## Input mapping

- `task_id` -> identificador interno de tarea
- `goal` -> prompt principal
- `constraints` -> politicas + restricciones operativas
- `context_refs` -> notas/archivos markdown incluidos
- `expected_output` -> formato de salida esperado

## Output mapping

- `task_id` -> eco del id recibido
- `status` -> done|blocked|partial
- `result_summary` -> resumen ejecutable
- `artifacts` -> rutas y entregables
- `risks` -> puntos de riesgo o incertidumbre
- `next_action` -> accion concreta siguiente

## Nota

Privilegiar pasos cortos y handoffs frecuentes para no sobrecargar contexto.
