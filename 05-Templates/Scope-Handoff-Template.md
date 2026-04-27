---
type: template
status: active
created: 2026-04-27
generates: _handoffs/[HU]/scope-[flujo].md
---

# Scope Handoff Template

Copiar como `PARA/[Areas|Projects]/[proyecto]/_handoffs/[HU-ID]/scope-[flujo].md`
Flujos válidos: database, api, qa, docs, frontend
El frontmatter YAML permite queries Dataview sobre scopes activos.

---

```markdown
---
ticket: {{HU-ID}}
scope: {{flujo}}
status: IN_PROGRESS
opened: {{FECHA}}
closed: ~
---

## Objetivo
[1-2 líneas: qué hay que hacer en este flujo específico]

## Contexto relevante
- [[_decisions/ADR-XXX-descripcion]] — por qué X funciona así
- Archivos clave: `ruta/al/archivo`

## Estado actual
[Qué se hizo, dónde quedó exactamente, qué falta — actualizar cada sesión]

## Decisiones tomadas
[Lista de decisiones menores tomadas durante el trabajo]

## Cierre
- Fecha: ~
- Resultado: ~ (COMPLETADO | PARCIAL | BLOQUEADO)
- Resumen: ~
- ADR generado: ~ (ninguno | ADR-XXX-slug)
```
