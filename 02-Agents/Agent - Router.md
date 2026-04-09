---
type: agent
status: active
last_verified: 2026-04-09
model: openrouter/google/gemini-2.0-flash-001
token_budget: low
---

# Agent - Router

Clasifica la HU y decide qué agentes actúan y en qué orden. No implementa código.

| | |
|---|---|
| **Invocar** | `@router` |
| **Input** | HU Brief + Project Profile |
| **Output** | Tipo, riesgo, agentes requeridos, orden |
| **Definición IA** | `.opencode/agents/router.md` |
