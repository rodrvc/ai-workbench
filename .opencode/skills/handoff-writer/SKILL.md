---
name: handoff-writer
description: Genera handoff estructurado al final de sesión — archivos separados por rol (QA / Dev) para que el próximo agente cargue solo lo que necesita
---

# Skill — Handoff Writer

Al final de una sesión, genera documentación compacta en **archivos separados por rol**.
QA y Dev son sesiones distintas → cargar contexto del otro rol es desperdicio de tokens.

## Cuándo usar
- Al terminar una sesión de trabajo
- Cuando el contexto está por compactarse
- Cuando otro agente va a continuar el trabajo

## Principios
1. **No inventar** — sin dato concreto → `[FALTA DATA]`
2. **Sin narrativa** — viñetas, eliminar relleno conversacional
3. **Solo lo estrictamente necesario** — si no cambia el comportamiento del próximo agente, no va
4. **Archivos separados por rol** — QA no necesita estado de implementación; Dev no necesita test data activa ni escenarios QA
5. **Máx 1 pantalla por archivo** — si no cabe en una pantalla, está sobrando algo

---

## Paso 0 — Resolución de rutas (ANTES de escribir cualquier archivo)

Todas las rutas se derivan del scope file cargado al inicio de sesión. Su ruta tiene la forma:

```
[VAULT]/PARA/[tipo]/[proyecto]/_handoffs/[HU-ID]/scope-[flujo].md
```

Extraer y verificar con Glob/Read antes de escribir:

| Variable | Cómo obtenerla | Ejemplo |
|---|---|---|
| `VAULT` | Raíz del vault | `/home/rodvall/Obsidian` |
| `PROYECTO_DIR` | Directorio padre de `_handoffs/` | `PARA/Areas/Falabella` |
| `HU_ID` | Directorio dentro de `_handoffs/` | `TMS-11278` |
| `SCOPE_FILE` | Ruta completa del scope | `PARA/Areas/Falabella/_handoffs/TMS-11278/scope-cierre.md` |

Rutas para Destinos 1 y 2 — siempre dentro de `HU/`:

```
Destino 1  → [PROYECTO_DIR]/HU/[HU_ID] - <nombre>.md   (buscar con Glob)
Destino 2b → [PROYECTO_DIR]/HU/[HU_ID]-handoff-dev.md
Destino 2a → [PROYECTO_DIR]/HU/[HU_ID]-handoff-qa.md
```

> Si `HU/` no existe en el proyecto, crearla. Todo desarrollo está trackeado en un ticket.

---

## Destinos de escritura

### Destino 1 — Archivo HU / índice de proyecto (punto de entrada universal)

**Ruta**: `[PROYECTO_DIR]/HU/[HU_ID] - <nombre>.md` (buscar con Glob; crear si no existe)

Actualizar (no append) el bloque `## Estado actual`. Si no existe, crearlo.

```markdown
## Estado actual
> Última sesión: YYYY-MM-DD — Rol: QA / Dev

### Subflujos
| Subflujo | Estado |
|----------|--------|
| E1 — <nombre> | ✅ / ⬜ / ⚠️ |

### Pendientes (próxima sesión)
1. <acción concreta> — precondición: <qué debe estar listo>

### Continuar como:
- 🧪 QA → `[ruta handoff-qa]`
- 🧑‍💻 Dev → `[ruta handoff-dev]`
```

---

### Destino 2a — Handoff QA

**Ruta**: `[PROYECTO_DIR]/HU/[HU_ID]-handoff-qa.md`

**Cuándo escribir**: la sesión fue de QA, o hay escenarios QA pendientes.
**Modo**: sobreescribir — siempre refleja el estado actual.

```markdown
> Ticket: [HU_ID] | Sesión: YYYY-MM-DD | Entorno: UAT / local

## Escenarios
| ID | Descripción | Estado |
|----|-------------|--------|
| E4.1 | <descripción> | ✅ PASS |
| E4.2 | <descripción> | ⬜ pendiente |

## Pendientes — próxima sesión QA
**E4.2**
- Comando: `<comando exacto>`
- Esperado: <campo>=<valor exacto>
- Gotcha: <advertencia operacional concreta>

## Active Test Data
| Dato | Valor | Estado |
|------|-------|--------|
| <dato> | <valor> | activa |

## Dead Ends QA
- <error investigado> → <causa raíz confirmada> — no repetir
```

---

### Destino 2b — Handoff Dev

**Ruta**: `[PROYECTO_DIR]/HU/[HU_ID]-handoff-dev.md`

**Cuándo escribir**: la sesión fue de desarrollo, o hay código pendiente.
**Modo**: sobreescribir — siempre refleja el estado actual.

```markdown
> Ticket: [HU_ID] | Sesión: YYYY-MM-DD

## Estado de implementación
- ✅ <qué está hecho>
- ⬜ <qué falta>

## Dead Ends Dev
- <approach descartado> → <por qué no funciona>

## Notas de contexto
- Solo si hay algo que no cabe en el scope state XML pero el próximo dev necesita saber
- Ej: bug que solo se reproduce en UAT, advertencia sobre servicio externo inestable, razón de un naming no obvia
- Omitir sección entera si no hay nada
```

> **Qué NO va aquí** (vive en el scope state XML):
> `decisions`, `files_modified`, `next_step`, `blockers`, `flows_touched`.

---

### Destino 3 — Scope File (machine-readable state)

**Ruta**: `SCOPE_FILE` — el scope cargado al inicio de sesión (ya conocido).
**Cuándo escribir**: siempre — es el estado que el próximo agente carga primero.
**Modo**: Edit de campos específicos (nunca sobreescribir el archivo entero).

Actualizar en orden:

**1. Frontmatter YAML**:
- `updated`: fecha de hoy `YYYY-MM-DD`
- `state_updated`: timestamp `YYYY-MM-DDTHH:MM`
- `session_count`: incrementar en 1
- `has_blockers`: `true` / `false` según `<blockers>` activos
- `blocker_type`: `external` / `solvable` / `~`
- `status`: solo cambiar si la sesión cerró el scope (`COMPLETADO` / `BLOQUEADO`)

**2. Bloque `<state>`** — reemplazar el contenido completo:

```xml
<state version="1">
  <next_step>Primera acción exacta al inicio de la próxima sesión — sin ambigüedad</next_step>
  <dependencies>
    <scope>[HU_ID]/scope-flujo-del-que-depende</scope>
    <!-- vacío si no hay dependencias -->
  </dependencies>
  <flows_touched>
    <flow>nombre-del-flow-arquitectónico</flow>
  </flows_touched>
  <files_modified>
    <file>ruta/relativa/al/archivo.ts</file>
    <!-- solo archivos tocados esta sesión -->
  </files_modified>
  <decisions>
    <decision date="YYYY-MM-DD">
      <what>Decisión concreta tomada</what>
      <why>Razón técnica o de negocio</why>
    </decision>
    <!-- acumular, no reemplazar decisiones anteriores -->
  </decisions>
  <blockers>
    <!-- type="external": el agente DEBE parar y reportar -->
    <!-- type="solvable": el agente puede proponer solución -->
    <!-- vacío si no hay bloqueantes -->
  </blockers>
</state>
```

**3. Bloque `<close>`** — solo si el scope se cierra:

```xml
<close>
  <date>YYYY-MM-DD</date>
  <result>COMPLETADO</result><!-- COMPLETADO | PARCIAL | BLOQUEADO -->
  <summary>Qué se logró en 1-2 líneas</summary>
  <adr>ADR-XXX-slug</adr><!-- ninguno si no se generó -->
</close>
```

**4. Bitácora** — append:

```markdown
### YYYY-MM-DD
[2-4 líneas: qué pasó, decisiones importantes, contexto de debugging]
```

---

## Reglas de calidad

- **`next_step` es lo más importante** — si el próximo agente solo lee ese campo, debe saber exactamente qué hacer
- **`decisions` acumula, no reemplaza** — las decisiones de sesiones anteriores no se borran
- **`files_modified` es de la sesión actual** — no listar archivos de sesiones previas
- **Bloqueante `external`** → el agente para, reporta al usuario, no intenta workarounds
- **Bloqueante `solvable`** → el agente puede proponer solución y seguir
- **Nunca Write ciego** — siempre Read antes de cualquier escritura

---

## Cómo leer al iniciar sesión (para el agente que llega)

1. Glob `scope-*.md` en `_handoffs/[HU-ID]/` → abrir el scope del flujo correspondiente
2. Leer `<state>` → ir directo a `<next_step>`
3. Si hay `<blocker type="external">` → reportar al usuario antes de cualquier acción
4. Si hay `<dependencies>` → verificar que esos scopes estén en estado `COMPLETADO`
5. Si el state file tiene `Workspace:` en "Contexto relevante" → cargar artefactos del workspace según el rol (`dev/` o `qa/`)
6. Leer Destino 2a o 2b según rol de la sesión

---

## Flujo de ejecución (al generar handoff)

1. **Paso 0**: Resolver rutas desde el scope file cargado (ver sección "Resolución de rutas")
2. Leer el scope file actual (Destino 3) y el archivo HU/índice (Destino 1)
3. Extraer de la conversación: decisiones, archivos tocados, flows afectados, bloqueantes
4. Determinar qué destinos escribir:
   - Sesión QA → Destino 1 + Destino 2a + Destino 3
   - Sesión Dev → Destino 1 + Destino 2b + Destino 3
   - Sesión mixta → todos los destinos
5. Escribir Destino 3 primero (scope file) — es el más crítico
6. Escribir Destinos 1 y 2
7. Confirmar al usuario las rutas escritas y el `next_step` que quedó registrado
