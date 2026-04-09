---
type: agent
status: active
last_verified: 2026-04-09
model: openrouter/google/gemini-2.0-flash-001
token_budget: low
---

# Agent - Efficiency Dev

Tareas de "carpintería": poda de contexto, formateo, limpieza. Modelo barato, ventana grande.

| | |
|---|---|
| **Invocar** | `@efficiency` |
| **Input** | Archivo denso o log largo |
| **Output** | Brief compacto + Tech Registry |
| **Skills** | `context-pruner` |
| **Definición IA** | `.opencode/agents/efficiency.md` |
