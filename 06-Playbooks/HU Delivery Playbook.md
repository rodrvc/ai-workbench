---
type: playbook
owner: rodvall
status: active
last_verified: 2026-04-27
token_budget: medium
---

# HU Delivery Playbook

## Cómo encontrar el proyecto

Los proyectos viven en `PARA/Areas/[proyecto]/` o `PARA/Projects/[proyecto]/`.
Ejemplo: trabajo de Falabella/TMS → `PARA/Areas/Falabella/`

## Carga de contexto al iniciar sesión (3 archivos)

1. `PARA/Areas/[proyecto]/_brief/project-context.md` — stack + estado actual
2. `PARA/Areas/[proyecto]/_agents/[agente-especialista].md` — comportamiento
3. `PARA/Areas/[proyecto]/_handoffs/[HU-ID]/scope-[flujo].md` — dónde quedamos

Si necesitás más contexto (ruta de un archivo, info del equipo, ADRs):
consultar `PARA/Areas/[proyecto]/_brief/index.md`

## Validación al abrir

Antes de empezar, verificar que el scope file anterior tenga el bloque `<close>` con `<result>` distinto de `PENDIENTE`.
Si le falta o dice PENDIENTE, completarlo retroactivamente con lo que se pueda inferir, luego continuar.

## Paso 1 - Brief

Crear HU usando [[05-Templates/Project-Context-Template]] y [[05-Templates/Scope-Handoff-Template]].
Ubicar scope file en: `PARA/Areas/[proyecto]/_handoffs/[HU-ID]/scope-[flujo].md`

## Paso 2 - Routing

Clasificar usando [[04-Router/Routing Rules v1]].

## Paso 3 - Plan

Armar plan con [[05-Templates/Execution Plan Template]].

## Paso 4 - Ejecución

Asignar `Task Pack` por agente con [[05-Templates/Task Pack Template]].

## Paso 5 - Consolidación

Unificar salida con [[05-Templates/Agent Handoff Template]].

## Paso 6 - Closing Protocol

Activar con el comando `cerrar scope` o `/close`.

### Pasos automáticos (siempre):
1. Actualizar `status` en frontmatter del scope file: `COMPLETADO | PARCIAL | BLOQUEADO`
2. Llenar bloque `<close>` del scope file: `<date>`, `<result>` (COMPLETADO|PARCIAL|BLOQUEADO), `<summary>`, `<adr>`
3. Agregar fila en `PARA/Areas/[proyecto]/_handoffs/project-log.md`
4. Sobrescribir sección `## Estado actual` en `_brief/project-context.md` (máx 8 líneas)

### Pasos condicionales (proponer al usuario, esperar confirmación):
5. Si se tomó decisión arquitectónica → crear `_decisions/ADR-XXX-SLUG.md` usando [[05-Templates/ADR-Template]]
6. Si surgió patrón nuevo → actualizar `_brief/conventions.md`
7. Si cambió el comportamiento esperado del agente → actualizar `_agents/[nombre].md`

## Límites de tamaño (hard limits)

| Archivo | Máximo | Acción si se supera |
|---------|--------|---------------------|
| `_brief/project-context.md` | 60 líneas | Sacar lo trivial antes de agregar |
| `_brief/conventions.md` | 40 líneas | Eliminar convenciones ya interiorizadas |
| `_brief/index.md` | 20 líneas | Solo rutas, sin explicaciones |
| `_agents/[nombre].md` | 30 líneas | Solo comportamiento, mover dominio a _brief/ |
