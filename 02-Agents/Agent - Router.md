---
type: agent
status: active
last_verified: 2026-04-27
model: openrouter/google/gemini-2.0-flash-001
token_budget: low
---

# Agent - Router

Clasifica la HU y decide qué agentes actúan y en qué orden. No implementa código.

| | |
|---|---|
| **Invocar** | `@router` |
| **Input** | HU Brief + `_brief/project-context.md` del proyecto |
| **Output** | Tipo, riesgo, agentes requeridos, orden |
| **Definición IA** | `.opencode/agents/router.md` |

## Cómo encontrar el proyecto

Los proyectos están en `PARA/Areas/[proyecto]/` o `PARA/Projects/[proyecto]/`.
Cargar `_brief/project-context.md` antes de clasificar la HU.
Si llegaste a una ruta antigua (`Work/AI-Workbench/90-Projects/`), leer el `MOVED.md` ahí.
