#!/bin/bash
# obsidian-close-reminder.sh — Stop hook para Claude Code
# Detecta sesiones de Falabella sin cerrar scope y muestra un recordatorio.
#
# Variables de entorno esperadas (seteadas por install.sh):
#   OBSIDIAN_VAULT — path absoluto al vault de Obsidian
#
# Claude Code provee automáticamente:
#   CLAUDE_PROJECT_DIR — directorio del proyecto activo

VAULT="${OBSIDIAN_VAULT:-__VAULT_PATH__}"
PROJECT="${CLAUDE_PROJECT_DIR:-$PWD}"

# Si no tenemos vault configurado, intentar detectarlo por el proyecto activo
if [[ -z "$VAULT" ]] && [[ "$PROJECT" == *"Obsidian"* ]]; then
    VAULT="$PROJECT"
fi

# Salir silenciosamente si no estamos en el vault de Obsidian
if [[ -z "$VAULT" ]] || [[ "$PROJECT" != "$VAULT"* ]]; then
    exit 0
fi

# ── Auto-discovery: cualquier proyecto bajo PARA con _handoffs/ ───────────────
PARA_CHANGES=$(git -C "$VAULT" status --porcelain 2>/dev/null \
    | grep "PARA/" | grep -v "^??" | head -5)

# ── Scopes sin sección de Cierre (todos los proyectos) ───────────────────────
OPEN_SCOPES=""
while IFS= read -r -d '' handoffs_dir; do
    while IFS= read -r -d '' file; do
        HAS_CLOSE=$(grep -c "<result>COMPLETADO\|<result>PARCIAL\|<result>BLOQUEADO\|## Cierre" "$file" 2>/dev/null || true)
        IS_PENDING=$(grep -c "<result>PENDIENTE\|Resultado: PENDIENTE" "$file" 2>/dev/null || true)
        if [[ "$HAS_CLOSE" -eq 0 ]] || [[ "$IS_PENDING" -gt 0 ]]; then
            OPEN_SCOPES="$OPEN_SCOPES $(basename "$file")"
        fi
    done < <(find "$handoffs_dir" -name "scope-*.md" -print0 2>/dev/null)
done < <(find "$VAULT/PARA" -name "_handoffs" -type d -print0 2>/dev/null)

# ── Construir mensaje ─────────────────────────────────────────────────────────
if [[ -n "$PARA_CHANGES" ]] || [[ -n "$OPEN_SCOPES" ]]; then
    MSG="Recordatorio: sesión de trabajo sin cerrar."

    if [[ -n "$OPEN_SCOPES" ]]; then
        MSG="$MSG Scopes abiertos:$OPEN_SCOPES."
    fi

    if [[ -n "$PARA_CHANGES" ]]; then
        COUNT=$(echo "$PARA_CHANGES" | wc -l | tr -d ' ')
        MSG="$MSG ${COUNT} archivo(s) de proyecto modificado(s) sin commitear."
    fi

    MSG="$MSG → Ejecuta /close para cerrar el scope."

    printf '{"systemMessage": "%s"}' "$MSG"
fi
