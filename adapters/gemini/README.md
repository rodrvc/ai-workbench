---
type: adapter
runtime: gemini
status: active
last_verified: 2026-04-09
---

# Gemini Adapter

Mapea el core agnostico a ejecuciones con modelos Google Gemini.

## Input mapping

- `task_id` -> id unico de contexto
- `goal` -> prompt/instruccion de alta fidelidad
- `constraints` -> limitaciones tecnicas y operativas
- `context_refs` -> referencias a documentos markdown
- `expected_output` -> formato solicitado (Markdown/JSON)

## Output mapping

- `status` -> done|blocked|partial
- `result_summary` -> resumen de ejecucion
- `artifacts` -> rutas de archivos o entregables
- `risks` -> riesgos de la implementacion
- `next_action` -> recomendacion de siguiente paso

## Nota

Aprovechar la ventana de contexto larga de Gemini para revisiones completas si es necesario, pero mantener los handoffs segun el `[[01-OS/Interop Contract]]`.
