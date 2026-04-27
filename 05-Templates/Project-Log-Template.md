---
type: template
status: active
created: 2026-04-27
generates: _handoffs/project-log.md
---

# Project Log Template

Copiar como `PARA/[Areas|Projects]/[proyecto]/_handoffs/project-log.md`
Este archivo es para el HUMANO, no para el agente.
El agente lee project-context.md (sección Estado actual), no este archivo.

---

```markdown
---
type: project-log
project: {{PROYECTO}}
---

# Project Log — {{PROYECTO}}

## 🎯 Metas actuales
- [ ] {{meta_1}}
- [ ] {{meta_2}}

## ✅ Logros
| Fecha | Logro |
|-------|-------|
| {{FECHA}} | {{descripcion}} |

## 📋 Historial de scopes cerrados
| HU | Scope | Resultado | Fecha |
|----|-------|-----------|-------|
| {{HU-ID}} | {{scope}} | COMPLETADO | {{FECHA}} |
```
