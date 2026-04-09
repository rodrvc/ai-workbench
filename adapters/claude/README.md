---
type: adapter
runtime: claude
status: active
last_verified: 2026-04-09
---

# Claude Adapter

Mapea tareas del core al runtime Claude sin romper el contrato comun.

## Input mapping

- `task_id` -> id de sesion o hilo actual
- `goal` -> instruccion principal del mensaje
- `constraints` -> reglas del sistema + proyecto
- `context_refs` -> rutas markdown relevantes
- `expected_output` -> formato de salida solicitado

## Output mapping

- `status` -> done|blocked|partial
- `result_summary` -> respuesta final breve
- `artifacts` -> paths de archivos tocados o notas creadas
- `risks` -> lista de riesgos residuales
- `next_action` -> siguiente paso recomendado

## Nota

Si el runtime usa herramientas propias, mantenerlas encapsuladas y devolver siempre el formato de `[[01-OS/Interop Contract]]`.
