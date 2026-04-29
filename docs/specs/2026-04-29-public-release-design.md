---
type: spec
status: approved
created: 2026-04-29
scope: ROD-001/scope-public-release
---

# AI-Workbench — Public Release Design

Tres problemas detectados al preparar el framework para uso público + un cuarto emergido durante el brainstorming.

---

## Pieza 1 — Parametrización de rutas en handoff-writer

**Problema:** El skill tiene referencias hardcodeadas a `PARA/Areas/Falabella/HU/` y nombres de proyectos privados.

**Solución: Opción C — cadena de discovery híbrida**

El skill resuelve rutas en este orden (Paso 0):

```
1. ¿Hay scope file cargado en el contexto de la sesión?
   → derivar PROYECTO_DIR y HU_ID desde su path

2. Si no → Glob("_handoffs/**/scope-*.md") desde CWD
   - 1 resultado  → usar ese
   - 2+ resultados → preguntar al usuario cuál
   - 0 resultados  → paso 3

3. Si no → leer AI_WORKBENCH_ROOT desde .env.local
   → pedir al usuario el HU_ID para construir las rutas
```

**Cambios al skill:**
- Eliminar todas las referencias a `Falabella`, `TMS`, `PARA/Areas/`
- Reemplazar ejemplos con nombres genéricos: `acme-app`, `FEAT-001`, `my-project`
- Variables en Paso 0: `VAULT`, `PROYECTO_DIR`, `HU_ID` derivadas dinámicamente

---

## Pieza 2 — README de onboarding

**Problema:** No existe un README que permita a un usuario nuevo entender y usar el framework en menos de 10 minutos.

**Requisitos explícitos:**
- Obsidian: requerido
- PARA: no requerido — cualquier estructura de carpetas funciona
- Sin menciones a proyectos privados

**Estructura del README (6 secciones):**

```markdown
# AI-Workbench
No pierdas contexto entre sesiones de Claude Code.

## El problema      ← 3 líneas
## Requisitos       ← Obsidian + Claude Code
## Quickstart       ← < 10 líneas, copy-pasteable
## Cómo funciona    ← diagrama ASCII del flujo
## Estructura       ← árbol del repo, 1 línea por carpeta
## Más              ← links a Playbook, templates, docs/obsidian-advanced.md
```

**Regla:** Si el quickstart tiene más de 10 líneas, está mal.

**Contenido avanzado** (PARA, Dataview, campos derivados) → `docs/obsidian-advanced.md`

---

## Pieza 3 — Gate HU en Playbook + scope retroactivo

**Problema:** El Playbook no obliga a crear HU antes de trabajar. Sin HU activa, el checkpoint incremental es inútil.

**Gate al inicio de sesión (nuevo Paso 0 en Playbook):**

```
¿Hay scope file activo para este trabajo?
  → sí: cargarlo y continuar
  → no: preguntar al usuario "¿qué vas a resolver?"
        con título y objetivo → crear HU → crear scope file → continuar
```

La HU da dirección. El scope da memoria. Sin la primera, el segundo no tiene sentido.

**Scope retroactivo (nuevo comportamiento en handoff-writer):**

Cuando handoff-writer detecta al cierre que no había scope activo:

```
1. Preguntar: "¿Qué HU/objetivo tenía esta sesión?"
2. Crear scope file con:
   - Las decisiones extraídas de la conversación
   - flag retroactive: true en frontmatter
3. Continuar con el cierre normal
```

El flag `retroactive: true` indica al próximo agente que no hubo captura incremental — la granularidad puede ser menor.

---

## Pieza 4 — Hooks de sesión

**Problema:** El agente puede trabajar sesiones enteras sin scope activo porque nada en el entorno lo detecta ni lo bloquea.

**Diseño: dos hooks, dos capas**

### Hook 1 — `UserPromptSubmit` (informativo)

Dispara al inicio de sesión. **No bloqueante.**

```bash
# Busca scope activo
ACTIVE=$(grep -rl "status: IN_PROGRESS" "$VAULT/PARA" \
  --include="scope-*.md" 2>/dev/null)

if [[ -n "$ACTIVE" ]]; then
  MSG="Scope activo: $(basename $(dirname $ACTIVE))/$(basename $ACTIVE)"
else
  MSG="No hay HU activa. Antes de empezar, pregunta al usuario en qué va a trabajar."
fi

printf '{"systemMessage": "%s"}' "$MSG"
```

Una línea de contexto. Cero fricción.

### Hook 2 — `PreToolUse` Write/Edit (bloqueante)

Dispara antes de cualquier escritura. **Bloqueante en paths protegidos.**

Paths protegidos: `_handoffs/`, `HU/`, `_decisions/`

Lógica:
```
¿El archivo destino está dentro de un path protegido?
  → no  : permitir sin validación
  → sí  : ¿es la creación de un scope-*.md?  ← excepción bootstrap (Alvaro)
      → sí: permitir (es el bootstrap del scope)
      → no: ¿hay scope activo (IN_PROGRESS)?
          → sí: permitir
          → no: bloquear + mensaje "Crea una HU antes de escribir aquí"
```

La excepción bootstrap evita el deadlock: no podés crear el scope porque no hay scope.

---

## Resumen de cambios por archivo

| Archivo | Cambio |
|---|---|
| `~/.claude/skills/handoff-writer/SKILL.md` | Cadena discovery + sacar Falabella + scope retroactivo |
| `AI-Workbench/06-Playbooks/HU Delivery Playbook.md` | Agregar Paso 0 — gate HU |
| `AI-Workbench/scripts/hooks/obsidian-close-reminder.sh` | Ya existe, sin cambios |
| `AI-Workbench/scripts/hooks/session-start.sh` | Nuevo — hook UserPromptSubmit |
| `AI-Workbench/scripts/hooks/pre-write-guard.sh` | Nuevo — hook PreToolUse |
| `AI-Workbench/scripts/install.sh` | Agregar pregunta AI_WORKBENCH_ROOT |
| `README.md` | Reescribir completo — 6 secciones |
| `docs/obsidian-advanced.md` | Nuevo — PARA, Dataview, configuración avanzada |
