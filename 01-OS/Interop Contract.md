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

## Relación con Scope State

El Interop Contract es el protocolo de mensaje efímero entre agentes. El scope state (`_handoffs/[HU]/scope-[flujo].md`) es su materialización persistente entre sesiones. Son complementarios, no redundantes.

Mapping de campos:

| Interop Contract (salida) | Scope State XML |
|---|---|
| `next_action` | `<next_step>` |
| `risks` | `<blockers>` |
| `artifacts` | `<files_modified>` |
| `status` + `result_summary` | `<close>` (al finalizar el scope) |

El handoff-writer persiste la salida del Interop Contract en el scope state al cerrar sesión. No duplicar status entre ambos.
