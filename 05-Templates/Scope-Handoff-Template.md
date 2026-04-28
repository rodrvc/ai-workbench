---
type: template
status: active
created: 2026-04-27
updated: 2026-04-28
generates: _handoffs/[HU]/scope-[flujo].md
---

# Scope Handoff Template

Copiar como `PARA/[Areas|Projects]/[proyecto]/_handoffs/[HU-ID]/scope-[flujo].md`
Flujos válidos: database, api, qa, docs, frontend

**Convención**: el bloque `<state>` es para el agente (XML estricto).
El resto es narrativa humana en Markdown libre.

---

```markdown
---
ticket: {{HU_ID}}
scope: {{FLUJO}}
status: IN_PROGRESS
opened: {{FECHA}}
closed: ~
updated: {{FECHA}}
---

## Objetivo
[1-2 líneas: qué hay que hacer en este flujo específico]

## Contexto relevante
- [[_decisions/ADR-XXX-descripcion]] — por qué X funciona así
- Archivos clave: `ruta/al/archivo`

<!-- STATE: bloque machine-readable para el agente. No editar a mano. -->
<state>
  <status>IN_PROGRESS</status>
  <next_step>Describir exactamente qué hacer al inicio de la próxima sesión</next_step>
  <flows_touched>
    <flow>nombre-del-flow</flow>
  </flows_touched>
  <files_modified>
    <file>ruta/al/archivo.ts</file>
  </files_modified>
  <decisions>
    <decision>
      <what>Qué se decidió</what>
      <why>Por qué</why>
    </decision>
  </decisions>
  <blockers>
    <blocker>Descripción del bloqueo si existe</blocker>
  </blockers>
</state>

## Bitácora
[Narrativa libre: qué pasó, qué se intentó, contexto de debugging — para humanos]

## Cierre
<close>
  <date>~</date>
  <result>PENDIENTE</result><!-- COMPLETADO | PARCIAL | BLOQUEADO -->
  <summary>~</summary>
  <adr>ninguno</adr><!-- ADR-XXX-slug si se generó -->
</close>
```
