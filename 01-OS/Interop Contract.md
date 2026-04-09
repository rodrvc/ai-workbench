---
type: standard
status: active
last_verified: 2026-04-09
---

# Interop Contract

Contrato minimo para interoperar entre modelos/agentes.

## Entrada estandar

```yaml
task_id: string
goal: string
constraints:
  - string
context_refs:
  - path-or-note
expected_output: string
```

## Salida estandar

```yaml
task_id: string
status: done|blocked|partial
result_summary: string
artifacts:
  - path-or-note
risks:
  - string
next_action: string
```

## Regla

Si un runtime no soporta una capacidad, debe devolver `status: blocked` con causa y alternativa sugerida.
