---
type: agent
status: active
last_verified: 2026-04-10
model: openrouter/google/gemini-2.0-flash-001
token_budget: low
---

# Agent - Librarian

Organiza la documentación caótica en una estructura limpia por "alcances" (scopes). Separa el contexto de Dev y QA. Extrae artefactos técnicos reales. 
**Regla de oro:** Siempre pregunta por los subflujos (scopes) antes de actuar.

**Resolución de ubicación AI Workbench (orden):**
1. `AI_WORKBENCH_ROOT`
2. `/home/rodvall/Obsidian/Work/AI-Workbench`
3. `/home/rodvall/projects/ai-workbench`

| | |
|---|---|
| **Invocar** | `@librarian` |
| **Input** | Log crudo de HU o mención de la tarea |
| **Output** | Estructura de carpetas por scope con Dev/QA separados |
| **Definición IA** | `.opencode/agents/librarian.md` |
