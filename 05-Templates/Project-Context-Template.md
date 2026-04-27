---
type: template
status: active
created: 2026-04-27
generates: _brief/project-context.md
---

# Project Context Template

Copiar como `PARA/[Areas|Projects]/[proyecto]/_brief/project-context.md`
LÍMITE: 60 líneas. Si se supera, sacar lo trivial antes de agregar.
La sección ## Estado actual se SOBREESCRIBE en cada closing (no acumula).

---

```markdown
---
type: project-context
project: {{PROYECTO}}
updated: {{FECHA}}
---

# Contexto — {{PROYECTO}}

## Stack técnico
- Backend: {{STACK_BACKEND}}
- DB: {{DB}}
- Auth: {{AUTH}}
- Cloud: {{CLOUD}}

## Arquitectura clave
[2-3 decisiones arquitectónicas que todo agente debe saber]

## Convenciones rápidas
Ver `_brief/conventions.md` para lista completa (crear si aplica).
- Naming: {{EJEMPLO}}
- Patrón principal: {{PATRON}}

## Estado actual
[Máx 8 líneas — se sobreescribe en cada cierre de scope, no acumula]
- Sprint actual: {{SPRINT}}
- HU en curso: {{HU_ACTUAL}}
- Bloqueantes: ninguno
```
