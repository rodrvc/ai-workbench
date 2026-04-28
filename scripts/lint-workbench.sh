#!/bin/bash
# lint-workbench.sh — Lint determinista del AI-Workbench
# Detecta: scopes sin cerrar, archivos stale, tamaño de project-context, HUs huérfanas
# Uso: bash lint-workbench.sh [--json]

VAULT="/home/rodvall/Obsidian"
FALABELLA="$VAULT/PARA/Areas/Falabella"
HANDOFFS="$FALABELLA/_handoffs"
DECISIONS="$FALABELLA/_decisions"
BRIEF="$FALABELLA/_brief"
OUTPUT_JSON="${1:---text}"

ISSUES=()
WARNINGS=()

# ─────────────────────────────────────────────
# 1. Scopes sin sección de cierre
# ─────────────────────────────────────────────
if [[ -d "$HANDOFFS" ]]; then
    while IFS= read -r -d '' file; do
        if ! grep -q "## Cierre" "$file" 2>/dev/null; then
            BASENAME=$(basename "$file")
            DAYS_OLD=$(( ( $(date +%s) - $(stat -c %Y "$file") ) / 86400 ))
            ISSUES+=("SCOPE_OPEN: $BASENAME (sin cerrar, ${DAYS_OLD}d sin modificar)")
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
        ISSUES+=("FILE_TOO_LONG: project-context.md tiene $LINES líneas (límite: 60)")
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
            WARNINGS+=("STALE_HANDOFF: $BASENAME (${DAYS_OLD}d sin tocar)")
        fi
    done < <(find "$HANDOFFS" -name "*.md" -print0 2>/dev/null)
fi

# ─────────────────────────────────────────────
# 4. ADRs con referencias a archivos inexistentes
# ─────────────────────────────────────────────
if [[ -d "$DECISIONS" ]]; then
    while IFS= read -r -d '' file; do
        # Buscar wikilinks [[archivo]] y verificar que existan
        while IFS= read -r link; do
            LINKED_NAME=$(echo "$link" | sed 's/\[\[//;s/\]\].*//')
            if ! find "$VAULT" -name "${LINKED_NAME}.md" -quit 2>/dev/null | grep -q .; then
                BASENAME=$(basename "$file")
                WARNINGS+=("DEAD_LINK: $BASENAME → [[${LINKED_NAME}]] no encontrado")
            fi
        done < <(grep -oP '\[\[[^\]]+\]\]' "$file" 2>/dev/null | head -10)
    done < <(find "$DECISIONS" -name "*.md" -print0 2>/dev/null)
fi

# ─────────────────────────────────────────────
# 5. HU files con "en progreso" sin actividad >7 días
# ─────────────────────────────────────────────
HU_DIR="$FALABELLA/HU"
if [[ -d "$HU_DIR" ]]; then
    while IFS= read -r -d '' file; do
        if grep -qi "en progreso\|in progress\|wip" "$file" 2>/dev/null; then
            DAYS_OLD=$(( ( $(date +%s) - $(stat -c %Y "$file") ) / 86400 ))
            if [[ "$DAYS_OLD" -gt 7 ]]; then
                BASENAME=$(basename "$file")
                WARNINGS+=("STALE_HU: $BASENAME (en progreso, ${DAYS_OLD}d sin actividad)")
            fi
        fi
    done < <(find "$HU_DIR" -name "TMS-*.md" -print0 2>/dev/null)
fi

# ─────────────────────────────────────────────
# OUTPUT
# ─────────────────────────────────────────────
DATE=$(date '+%Y-%m-%d %H:%M')
REPORT_FILE="$FALABELLA/_brief/lint-report.md"

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
