---
type: agent
status: active
last_verified: 2026-04-27
model: openrouter/google/gemini-2.0-flash-001
token_budget: medium
---

# Agent - Specialist Developer

Implementa cambios en un alcance acotado. No expande scope sin documentar.

| | |
|---|---|
| **Invocar** | `@specialist` |
| **Input** | Task Pack + `_brief/project-context.md` + scope file activo |
| **Output** | Implementation Handoff + evidencia |
| **Definición IA** | `.opencode/agents/specialist.md` |

## Carga de contexto

1. `PARA/Areas/[proyecto]/_brief/project-context.md`
2. `PARA/Areas/[proyecto]/_agents/[especialista-del-proyecto].md` si existe
3. Scope file activo: `_handoffs/[HU-ID]/scope-[flujo].md`

## Al cerrar scope

Ejecutar closing protocol del [[06-Playbooks/HU Delivery Playbook]].
Trigger: cuando el usuario dice `cerrar scope` o `/close`.
