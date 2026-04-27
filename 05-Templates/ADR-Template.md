---
type: template
status: active
created: 2026-04-27
generates: _decisions/ADR-XXX-slug.md
---

# ADR Template

Copiar como `PARA/[Areas|Projects]/[proyecto]/_decisions/ADR-XXX-[slug].md`
XXX = número secuencial de 3 dígitos (001, 002, ...)
slug = descripción corta en kebab-case

---

```markdown
---
type: adr
id: ADR-{{XXX}}
status: activa
ticket: {{HU_ID}}
updated: {{FECHA}}
---

# ADR-{{XXX}} · {{Titulo corto}}

## Decisión
[Qué se decidió, en una oración clara]

## Por qué
[Razón real: constraint técnico, acuerdo de negocio, deuda técnica, etc.]

## Qué se descartó
- {{OPCION_A}} → descartado porque {{RAZON}}
- {{OPCION_B}} → descartado porque {{RAZON}}

## Consecuencias
[Qué implica esta decisión para el código o el proceso]
```
