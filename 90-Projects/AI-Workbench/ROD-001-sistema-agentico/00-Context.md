# ROD-001: AI-Workbench — Framework de Agentes IA

- **Goal:** Sistema operativo personal para trabajo asistido por IA con persistencia de contexto entre sesiones.
- **Problem:** Los LLMs pierden contexto entre sesiones. Los frameworks existentes (CrewAI, AutoGen) resuelven orquestación, no persistencia de conocimiento con humano en el loop.
- **Approach:** Markdown + XML estructurado en Obsidian. Agentes, skills, handoffs, flows y patterns que se acumulan entre sesiones.

## Estado actual — 2026-04-28

### Completado
- `scripts/install.sh` — setup portable en máquina nueva
- `scripts/hooks/obsidian-close-reminder.sh` — Stop hook: detecta scopes sin cerrar
- `scripts/lint-workbench.sh` — lint determinista semanal (cron lunes 9:03am)
- `05-Templates/Scope-Handoff-Template.md` — schema XML `<state>` para machine-readable state
- `handoff-writer` skill — Destino 3: escribe `<state>` XML al cerrar sesión

### Decisiones tomadas
- XML para state en scope files (no JSON, no YAML, no Markdown libre)
- `status` solo en frontmatter YAML — fuente de verdad única
- `type="external|solvable"` en blockers — guía al agente si parar o avanzar
- `dependencies` entre scopes — captura prerequisitos explícitos
- `date` en decisions — trazabilidad temporal

### Pendiente
- [ ] `_flows/` como entidades de primer nivel con backlinks a HUs
- [ ] Pattern extractor al cierre de HU → `_brief/patterns.md`
- [ ] Configurar remote git para este repo
- [ ] Validación end-to-end de handoff-writer con XML

## Próximo agente

Leer `05-Templates/Scope-Handoff-Template.md` para entender el schema XML.
Próxima tarea prioritaria: implementar `_flows/` — ver `PARA/Projects/AI-Workbench/index.md` en el vault.
