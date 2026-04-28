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

FALABELLA="$VAULT/PARA/Areas/Falabella"
HANDOFFS="$FALABELLA/_handoffs"

# ── Cambios de Falabella sin commitear ────────────────────────────────────────
FALABELLA_CHANGES=$(git -C "$VAULT" status --porcelain 2>/dev/null \
    | grep "Falabella" | grep -v "^??" | head -5)

# ── Scopes sin sección de Cierre ─────────────────────────────────────────────
OPEN_SCOPES=""
if [[ -d "$HANDOFFS" ]]; then
    while IFS= read -r -d '' file; do
        # Detecta cierre en formato XML nuevo y formato Markdown legacy
        HAS_CLOSE=$(grep -c "<result>COMPLETADO\|<result>PARCIAL\|<result>BLOQUEADO\|## Cierre" "$file" 2>/dev/null || true)
        IS_PENDING=$(grep -c "<result>PENDIENTE\|Resultado: PENDIENTE" "$file" 2>/dev/null || true)
        if [[ "$HAS_CLOSE" -eq 0 ]] || [[ "$IS_PENDING" -gt 0 ]]; then
            OPEN_SCOPES="$OPEN_SCOPES $(basename "$file")"
        fi
    done < <(find "$HANDOFFS" -name "scope-*.md" -print0 2>/dev/null)
fi

# ── Construir mensaje ─────────────────────────────────────────────────────────
if [[ -n "$FALABELLA_CHANGES" ]] || [[ -n "$OPEN_SCOPES" ]]; then
    MSG="Recordatorio: sesión de Falabella sin cerrar."

    if [[ -n "$OPEN_SCOPES" ]]; then
        MSG="$MSG Scopes abiertos:$OPEN_SCOPES."
    fi

    if [[ -n "$FALABELLA_CHANGES" ]]; then
        COUNT=$(echo "$FALABELLA_CHANGES" | wc -l | tr -d ' ')
        MSG="$MSG ${COUNT} archivo(s) de Falabella modificado(s)."
    fi

    MSG="$MSG → Ejecuta /close para cerrar el scope."

    printf '{"systemMessage": "%s"}' "$MSG"
fi
