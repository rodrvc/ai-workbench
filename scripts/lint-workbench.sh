#!/bin/bash
# lint-workbench.sh — Lint determinista del AI-Workbench
# Detecta: scopes sin cerrar, archivos stale, tamaño de project-context, HUs huérfanas
# Uso: bash lint-workbench.sh [--json]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cargar vault path desde ai-env.sh (portable entre máquinas)
if [[ -f "$SCRIPT_DIR/lib/ai-env.sh" ]]; then
    . "$SCRIPT_DIR/lib/ai-env.sh"
    ai_env_load 2>/dev/null || true
fi

VAULT="${AI_OBSIDIAN_VAULT:-/home/rodvall/Obsidian}"
OUTPUT_JSON="${1:---text}"

# Auto-discovery: todos los proyectos bajo PARA con _handoffs/
PROJECTS=()
while IFS= read -r -d '' dir; do
    PROJECTS+=("$(dirname "$dir")")
done < <(find "$VAULT/PARA" -name "_handoffs" -type d -print0 2>/dev/null)

ISSUES=()
WARNINGS=()

# Iterar sobre todos los proyectos descubiertos
for PROJECT_DIR in "${PROJECTS[@]}"; do
    HANDOFFS="$PROJECT_DIR/_handoffs"
    DECISIONS="$PROJECT_DIR/_decisions"
    BRIEF="$PROJECT_DIR/_brief"
    HU_DIR="$PROJECT_DIR/HU"
    PROJECT_NAME=$(basename "$PROJECT_DIR")

    # ─────────────────────────────────────────────
    # 1. Scopes sin sección de cierre
    # ─────────────────────────────────────────────
    if [[ -d "$HANDOFFS" ]]; then
        while IFS= read -r -d '' file; do
            BASENAME=$(basename "$file")
            DAYS_OLD=$(( ( $(date +%s) - $(stat -c %Y "$file") ) / 86400 ))

            HAS_CLOSE=$(grep -c "<result>COMPLETADO\|<result>PARCIAL\|<result>BLOQUEADO\|## Cierre" "$file" 2>/dev/null || true)
            IS_PENDING=$(grep -c "<result>PENDIENTE\|Resultado: PENDIENTE" "$file" 2>/dev/null || true)

            if [[ "$HAS_CLOSE" -eq 0 ]] || [[ "$IS_PENDING" -gt 0 ]]; then
                ISSUES+=("SCOPE_OPEN [$PROJECT_NAME]: $BASENAME (sin cerrar, ${DAYS_OLD}d sin modificar)")
            fi
        done < <(find "$HANDOFFS" -name "scope-*.md" -print0 2>/dev/null)
    fi

    # ─────────────────────────────────────────────
    # 2. project-context.md demasiado largo (>60 líneas)
    # ─────────────────────────────────────────────
    CONTEXT_FILE="$BRIEF/project-context.md"
    if [[ -f "$CONTEXT_FILE" ]]; then
        LINES=$(wc -l < "$CONTEXT_FILE")
        if [[ "$LINES" -gt 60 ]]; then
            ISSUES+=("FILE_TOO_LONG [$PROJECT_NAME]: project-context.md tiene $LINES líneas (límite: 60)")
        fi
    fi

    # ─────────────────────────────────────────────
    # 3. Handoffs sin actividad hace más de 14 días
    # ─────────────────────────────────────────────
    if [[ -d "$HANDOFFS" ]]; then
        while IFS= read -r -d '' file; do
            DAYS_OLD=$(( ( $(date +%s) - $(stat -c %Y "$file") ) / 86400 ))
            if [[ "$DAYS_OLD" -gt 14 ]]; then
                BASENAME=$(basename "$file")
                WARNINGS+=("STALE_HANDOFF [$PROJECT_NAME]: $BASENAME (${DAYS_OLD}d sin tocar)")
            fi
        done < <(find "$HANDOFFS" -name "*.md" -print0 2>/dev/null)
    fi

    # ─────────────────────────────────────────────
    # 4. ADRs con referencias a archivos inexistentes
    # ─────────────────────────────────────────────
    if [[ -d "$DECISIONS" ]]; then
        while IFS= read -r -d '' file; do
            while IFS= read -r link; do
                LINKED_NAME=$(echo "$link" | sed 's/\[\[//;s/\]\].*//')
                if ! find "$VAULT" -name "${LINKED_NAME}.md" -quit 2>/dev/null | grep -q .; then
                    BASENAME=$(basename "$file")
                    WARNINGS+=("DEAD_LINK [$PROJECT_NAME]: $BASENAME → [[${LINKED_NAME}]] no encontrado")
                fi
            done < <(grep -oP '\[\[[^\]]+\]\]' "$file" 2>/dev/null | head -10)
        done < <(find "$DECISIONS" -name "*.md" -print0 2>/dev/null)
    fi

    # ─────────────────────────────────────────────
    # 5. HU files con "en progreso" sin actividad >7 días
    # ─────────────────────────────────────────────
    if [[ -d "$HU_DIR" ]]; then
        while IFS= read -r -d '' file; do
            if grep -qi "en progreso\|in progress\|wip" "$file" 2>/dev/null; then
                DAYS_OLD=$(( ( $(date +%s) - $(stat -c %Y "$file") ) / 86400 ))
                if [[ "$DAYS_OLD" -gt 7 ]]; then
                    BASENAME=$(basename "$file")
                    WARNINGS+=("STALE_HU [$PROJECT_NAME]: $BASENAME (en progreso, ${DAYS_OLD}d sin actividad)")
                fi
            fi
        done < <(find "$HU_DIR" -name "*.md" -print0 2>/dev/null)
    fi
done

# ─────────────────────────────────────────────
# OUTPUT
# ─────────────────────────────────────────────
DATE=$(date '+%Y-%m-%d %H:%M')
REPORT_FILE="$VAULT/PARA/Areas/Falabella/_brief/lint-report.md"

if [[ "$OUTPUT_JSON" == "--json" ]]; then
    echo "{"
    echo "  \"date\": \"$DATE\","
    echo "  \"issues\": ["
    printf '    "%s"\n' "${ISSUES[@]}" | paste -sd ',' -
    echo "  ],"
    echo "  \"warnings\": ["
    printf '    "%s"\n' "${WARNINGS[@]}" | paste -sd ',' -
    echo "  ]"
    echo "}"
else
    echo "# Lint Report — $DATE"
    echo ""

    if [[ ${#ISSUES[@]} -eq 0 ]] && [[ ${#WARNINGS[@]} -eq 0 ]]; then
        echo "✅ Todo limpio. No se encontraron problemas."
    else
        if [[ ${#ISSUES[@]} -gt 0 ]]; then
            echo "## ❌ Issues (${#ISSUES[@]})"
            for issue in "${ISSUES[@]}"; do
                echo "- $issue"
            done
            echo ""
        fi

        if [[ ${#WARNINGS[@]} -gt 0 ]]; then
            echo "## ⚠️ Warnings (${#WARNINGS[@]})"
            for warn in "${WARNINGS[@]}"; do
                echo "- $warn"
            done
        fi
    fi

    # Guardar reporte en _brief/
    {
        echo "# Lint Report — $DATE"
        echo ""
        if [[ ${#ISSUES[@]} -gt 0 ]]; then
            echo "## Issues"
            for issue in "${ISSUES[@]}"; do echo "- $issue"; done
            echo ""
        fi
        if [[ ${#WARNINGS[@]} -gt 0 ]]; then
            echo "## Warnings"
            for warn in "${WARNINGS[@]}"; do echo "- $warn"; done
        fi
        [[ ${#ISSUES[@]} -eq 0 ]] && [[ ${#WARNINGS[@]} -eq 0 ]] && echo "✅ Sin problemas."
    } > "$REPORT_FILE"

    echo ""
    echo "→ Reporte guardado en: _brief/lint-report.md"
fi
