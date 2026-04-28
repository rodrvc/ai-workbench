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
4. **Archivos separados por rol** — QA no necesita blast radius; Dev no necesita test data activa
5. **Máx 1 pantalla por archivo** — si no cabe en una pantalla, está sobrando algo

---

## Destinos de escritura

### Destino 1 — Archivo HU en Obsidian (punto de entrada universal)

**Ruta**: `/home/rodvall/Obsidian/PARA/Areas/Falabella/HU/TMS-XXXXX - <nombre>.md`

Actualizar (no append) el bloque `## Estado actual`. Si no existe, crearlo antes de `## MRs`.

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
- 🧪 QA → `docs/hu/TMS-XXXXX-handoff-qa.md`
- 🧑‍💻 Dev → `docs/hu/TMS-XXXXX-handoff-dev.md`
```

---

### Destino 2a — Handoff QA

**Ruta**: `docs/hu/TMS-XXXXX-handoff-qa.md`
**Cuándo escribir**: la sesión fue de QA, o hay escenarios QA pendientes.
**Modo**: sobreescribir — siempre refleja el estado actual.

```markdown
> Ticket: TMS-XXXXX | Sesión: YYYY-MM-DD | Entorno: UAT / local

## Escenarios
| ID | Descripción | Estado |
|----|-------------|--------|
| E4.1 | Cierre con reemplazo | ✅ PASS |
| E4.2 | Viajes propios + reemplazo | ⬜ pendiente |

## Pendientes — próxima sesión QA
**E4.2**
- Comando: `python3 docs/TMS-XXXXX-prueba.py e42`
- Esperado: <campo>=<valor exacto>
- Gotcha: <advertencia operacional concreta>

## Active Test Data
| Dato | Valor | Estado |
|------|-------|--------|
| Fleet | 996 | activa |

## Dead Ends QA
- <error investigado> → <causa raíz confirmada> — no repetir
```

---

### Destino 2b — Handoff Dev

**Ruta**: `docs/hu/TMS-XXXXX-handoff-dev.md`
**Cuándo escribir**: la sesión fue de desarrollo, o hay código pendiente.
**Modo**: sobreescribir — siempre refleja el estado actual.

```markdown
> Ticket: TMS-XXXXX | Sesión: YYYY-MM-DD

## Estado de implementación
- ✅ <qué está hecho>
- ⬜ <qué falta>

## Decisiones técnicas
- <decisión>: <por qué, no qué>

## Blast radius
- `<archivo>`: <qué cambió y por qué>

## Next Actions Dev
1. <acción> — precondición: <qué debe estar listo>

## ⚠️ Bloqueante
<omitir sección si no hay bloqueante activo>

## Dead Ends Dev
- <approach descartado> → <por qué no funciona>
```

---

### Destino 3 — Scope File (machine-readable state)

**Ruta**: `/home/rodvall/Obsidian/PARA/Areas/Falabella/_handoffs/[HU-ID]/scope-[flujo].md`
**Cuándo escribir**: siempre — es el estado que el próximo agente carga primero.
**Modo**: Edit del bloque `<state>` existente (nunca sobreescribir el archivo entero).

Actualizar estos campos en orden:

**1. Frontmatter YAML** — Edit de campos específicos:
- `updated`: fecha de hoy `YYYY-MM-DD`
- `session_count`: incrementar en 1
- `status`: solo cambiar si la sesión cerró el scope (`COMPLETED` / `BLOCKED`)

**2. Bloque `<state>`** — reemplazar el contenido completo del bloque:

```xml
<state>
  <next_step>Primera acción exacta al inicio de la próxima sesión — sin ambigüedad</next_step>
  <dependencies>
    <scope>TMS-XXXXX/scope-flujo-del-que-depende</scope>
    <!-- vacío si no hay dependencias -->
  </dependencies>
  <flows_touched>
    <flow>nombre-del-flow-arquitectónico</flow>
    <!-- solo flows que realmente se modificaron esta sesión -->
  </flows_touched>
  <files_modified>
    <file>ruta/relativa/al/archivo.ts</file>
    <!-- solo archivos tocados esta sesión, no los de sesiones anteriores -->
  </files_modified>
  <decisions>
    <decision date="YYYY-MM-DD">
      <what>Decisión concreta tomada</what>
      <why>Razón técnica o de negocio</why>
    </decision>
    <!-- acumular, no reemplazar decisiones anteriores -->
  </decisions>
  <blockers>
    <!-- type="external": el agente DEBE parar y reportar, no puede avanzar -->
    <!-- type="solvable": el agente puede proponer solución y continuar -->
    <!-- vacío si no hay bloqueantes -->
  </blockers>
</state>
```

**3. Bloque `<close>`** — solo si el scope se cierra en esta sesión:

```xml
<close>
  <date>YYYY-MM-DD</date>
  <result>COMPLETADO</result><!-- COMPLETADO | PARCIAL | BLOQUEADO -->
  <summary>Qué se logró en 1-2 líneas</summary>
  <adr>ADR-XXX-slug</adr><!-- ninguno si no se generó ADR -->
</close>
```

**4. Sección Bitácora** — append de una entrada de sesión:

```markdown
### YYYY-MM-DD
[2-4 líneas: qué pasó, decisiones importantes, contexto de debugging]
```

---

## Reglas de calidad

- **`next_step` es lo más importante** — si el próximo agente solo lee ese campo, debe saber exactamente qué hacer. Sin ambigüedad.
- **`decisions` acumula, no reemplaza** — las decisiones de sesiones anteriores no se borran
- **`files_modified` es de la sesión actual** — no listar archivos de sesiones previas salvo que se volvieron a tocar
- **Bloqueante `external`** → el agente para, reporta al usuario, no intenta workarounds
- **Bloqueante `solvable`** → el agente puede proponer solución y seguir
- **Nunca Write ciego** — siempre Read antes de cualquier escritura

---

## Cómo leer al iniciar sesión (para el agente que llega)

1. Glob `scope-*.md` en `_handoffs/[HU-ID]/` → abrir el scope del flujo correspondiente
2. Leer `<state>` → ir directo a `<next_step>`
3. Si hay `<blocker type="external">` → reportar al usuario antes de cualquier acción
4. Si hay `<dependencies>` → verificar que esos scopes estén en estado `COMPLETADO`
5. Leer Destino 2a o 2b según rol de la sesión

---

## Flujo de ejecución (al generar handoff)

1. Leer el scope file actual: `_handoffs/[HU-ID]/scope-[flujo].md`
2. Leer el archivo HU en Obsidian
3. Extraer de la conversación: decisiones, archivos tocados, flows afectados, bloqueantes
4. Determinar qué destinos escribir:
   - Sesión QA → Destino 1 + Destino 2a + Destino 3
   - Sesión Dev → Destino 1 + Destino 2b + Destino 3
   - Sesión mixta → todos los destinos
5. Escribir Destino 3 primero (scope file) — es el más crítico
6. Escribir Destinos 1 y 2
7. Confirmar al usuario las rutas escritas y el `next_step` que quedó registrado
