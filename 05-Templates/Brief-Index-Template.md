---
type: template
status: active
created: 2026-04-27
generates: _brief/index.md
---

# Brief Index Template

Copiar como `PARA/[Areas|Projects]/[proyecto]/_brief/index.md`
Máximo 20 líneas. Solo rutas, sin explicaciones.

---

```markdown
---
type: brief-index
project: {{PROYECTO}}
updated: {{FECHA}}
---

# Índice — {{PROYECTO}}

## Dónde buscar
- Stack técnico: `_brief/project-context.md`
- Convenciones de código: `_brief/conventions.md`
- Equipo y contactos: `_brief/team.md`
- Decisiones arquitectónicas: `_decisions/` (leer solo el relevante)
- HUs activas: `HU/`
- Soporte previo: `Soporte/` (buscar por REQ)

## Scopes activos
[Listar aquí con link al scope file]
- [[_handoffs/HU-XXXX/scope-FLUJO]] — IN_PROGRESS
```
