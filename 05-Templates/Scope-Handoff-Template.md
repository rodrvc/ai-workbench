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

**Convención de fuentes de verdad:**
- `status`, `has_blockers`, `blocker_type`, `state_updated` en frontmatter YAML → consultables por Dataview
- bloque `<state version="1">` → fuente de verdad estructurada para el agente (estructura rica, no duplicar status aquí)
- Markdown libre → narrativa humana, no la lee el agente directamente

---

```markdown
---
ticket: {{HU_ID}}
scope: {{FLUJO}}
status: IN_PROGRESS
opened: {{FECHA}}
closed: ~
updated: {{FECHA}}
state_updated: {{FECHA}}
session_count: 1
has_blockers: false
blocker_type: ~
---

## Objetivo
[1-2 líneas: qué hay que hacer en este flujo específico]

## Contexto relevante
- Workspace: `90-Projects/[proyecto]/[HU-ID]/scope-[flujo]/` — si existe (artefactos dev/qa)
- [[_decisions/ADR-XXX-descripcion]] — por qué X funciona así
- Archivos clave: `ruta/al/archivo`

<!-- STATE: bloque machine-readable para el agente. Actualizar al cerrar cada sesión. -->
<state version="1">
  <next_step>Describir exactamente qué hacer al inicio de la próxima sesión</next_step>
  <dependencies>
    <scope>{{HU_ID}}/scope-otro-flujo</scope><!-- scopes de los que depende este -->
  </dependencies>
  <flows_touched>
    <flow>nombre-del-flow</flow>
  </flows_touched>
  <files_modified>
    <file>ruta/al/archivo.ts</file>
  </files_modified>
  <decisions>
    <decision date="{{FECHA}}">
      <what>Qué se decidió</what>
      <why>Por qué</why>
    </decision>
  </decisions>
  <blockers>
    <!-- type="external" = el agente no puede avanzar, debe reportar y parar -->
    <!-- type="solvable" = el agente puede proponer solución -->
    <blocker type="solvable">Descripción del bloqueo si existe</blocker>
  </blockers>
</state>

## Bitácora
[Narrativa libre: qué pasó, qué se intentó, contexto de debugging — para humanos]

<close>
  <date>~</date>
  <result>PENDIENTE</result><!-- COMPLETADO | PARCIAL | BLOQUEADO -->
  <summary>~</summary>
  <adr>ninguno</adr><!-- ADR-XXX-slug si se generó -->
</close>
```
