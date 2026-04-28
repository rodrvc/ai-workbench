#!/usr/bin/env bash
# install.sh — Instala AI-Workbench hooks y configuración en una nueva máquina
#
# Qué hace:
#   1. Carga/configura AI_OBSIDIAN_VAULT desde .env.local
#   2. Instala hooks en ~/.claude/hooks/
#   3. Parchea ~/.claude/settings.json con el Stop hook
#   4. Agrega el lint semanal al crontab del sistema
#
# Uso:
#   bash scripts/install.sh
#   bash scripts/install.sh --dry-run   (solo muestra lo que haría)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DRY_RUN="${1:-}"

# ── Colores ───────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}!${NC} $*"; }
err()  { echo -e "${RED}✗${NC} $*" >&2; }
run()  { [[ "$DRY_RUN" == "--dry-run" ]] && echo "  [dry] $*" || eval "$@"; }

echo ""
echo "=== AI-Workbench Install ==="
echo "Repo: $REPO_ROOT"
echo ""

# ── 1. Cargar configuración de vault ─────────────────────────────────────────
. "$SCRIPT_DIR/lib/ai-env.sh"
ai_env_bootstrap_if_missing

VAULT="${AI_OBSIDIAN_VAULT:-}"
if [[ -z "$VAULT" ]] || [[ ! -d "$VAULT" ]]; then
    err "AI_OBSIDIAN_VAULT no configurado o no existe: '$VAULT'"
    err "Configura .env.local y vuelve a intentar."
    exit 1
fi
ok "Vault de Obsidian: $VAULT"

# ── 2. Instalar hooks en ~/.claude/hooks/ ─────────────────────────────────────
CLAUDE_HOOKS_DIR="$HOME/.claude/hooks"
run "mkdir -p '$CLAUDE_HOOKS_DIR'"

HOOK_SRC="$SCRIPT_DIR/hooks/obsidian-close-reminder.sh"
HOOK_DST="$CLAUDE_HOOKS_DIR/obsidian-close-reminder.sh"

# Renderizar con la ruta del vault usando placeholder explícito
if [[ "$DRY_RUN" != "--dry-run" ]]; then
    sed "s|__VAULT_PATH__|$VAULT|g" "$HOOK_SRC" > "$HOOK_DST"
    chmod +x "$HOOK_DST"
else
    echo "  [dry] Render $HOOK_SRC → $HOOK_DST (vault=$VAULT)"
fi
ok "Hook instalado: $HOOK_DST"

# ── 3. Parchear ~/.claude/settings.json ──────────────────────────────────────
SETTINGS="$HOME/.claude/settings.json"

# Crear settings.json mínimo si no existe (máquina nueva sin Claude Code configurado)
if [[ ! -f "$SETTINGS" ]]; then
    if [[ "$DRY_RUN" != "--dry-run" ]]; then
        mkdir -p "$(dirname "$SETTINGS")"
        echo '{}' > "$SETTINGS"
        ok "Creado settings.json vacío en $SETTINGS"
    else
        echo "  [dry] Crear $SETTINGS (no existe)"
    fi
fi

# Verificar dependencia jq
if ! command -v jq &>/dev/null; then
    warn "jq no encontrado. Instala jq para parchear settings.json automáticamente."
    warn "Luego agrega manualmente a ~/.claude/settings.json:"
    cat <<'JSON'
    "Stop": [
      {
        "hooks": [{
          "type": "command",
          "command": "bash ~/.claude/hooks/obsidian-close-reminder.sh",
          "statusMessage": "Verificando scopes abiertos..."
        }]
      }
    ]
JSON
else
    # Verificar si el hook ya está configurado
    ALREADY=$(jq -r '
        .hooks.Stop[]?.hooks[]?.command // ""
        | select(contains("obsidian-close-reminder"))
    ' "$SETTINGS" 2>/dev/null || true)

    if [[ -n "$ALREADY" ]]; then
        warn "Stop hook ya configurado en settings.json, omitiendo."
    else
        HOOK_CMD="bash $HOOK_DST"
        if [[ "$DRY_RUN" != "--dry-run" ]]; then
            # Backup + patch
            cp "$SETTINGS" "${SETTINGS}.bak"
            jq --arg cmd "$HOOK_CMD" '
                .hooks.Stop += [{
                    "hooks": [{
                        "type": "command",
                        "command": $cmd,
                        "statusMessage": "Verificando scopes abiertos..."
                    }]
                }]
            ' "$SETTINGS" > "${SETTINGS}.tmp" && mv "${SETTINGS}.tmp" "$SETTINGS"
        else
            echo "  [dry] jq patch: agregar Stop hook a $SETTINGS"
        fi
        ok "settings.json actualizado"
    fi
fi

# ── 4. Instalar skills en ~/.claude/skills/ ──────────────────────────────────
SKILLS_SRC="$REPO_ROOT/.opencode/skills"
SKILLS_DST="$HOME/.claude/skills"

if [[ -d "$SKILLS_SRC" ]]; then
    run "mkdir -p '$SKILLS_DST'"
    while IFS= read -r -d '' skill_dir; do
        SKILL_NAME=$(basename "$skill_dir")
        SKILL_DST_DIR="$SKILLS_DST/$SKILL_NAME"
        if [[ -d "$SKILL_DST_DIR" ]]; then
            warn "Skill '$SKILL_NAME' ya instalado, actualizando..."
        fi
        run "mkdir -p '$SKILL_DST_DIR'"
        run "cp '$skill_dir/SKILL.md' '$SKILL_DST_DIR/SKILL.md'"
        ok "Skill instalado: $SKILL_NAME"
    done < <(find "$SKILLS_SRC" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)
else
    warn "No se encontró directorio de skills en $SKILLS_SRC"
fi

# ── 5. Crontab — lint semanal (lunes 9:03am) ─────────────────────────────────
LINT_SCRIPT="$SCRIPT_DIR/lint-workbench.sh"
CRON_CMD="3 9 * * 1 bash $LINT_SCRIPT >> /tmp/workbench-lint.log 2>&1"

ALREADY_CRON=$(crontab -l 2>/dev/null | grep "lint-workbench" || true)
if [[ -n "$ALREADY_CRON" ]]; then
    warn "Crontab ya tiene la tarea de lint, omitiendo."
else
    run "(crontab -l 2>/dev/null; echo '$CRON_CMD') | crontab -"
    ok "Crontab: lint semanal lunes 9:03am"
fi

# ── Resumen ───────────────────────────────────────────────────────────────────
echo ""
echo "=== Instalación completa ==="
echo ""
echo "  Hook reminder:   $HOOK_DST"
echo "  Skills:          $SKILLS_DST"
echo "  Lint semanal:    $LINT_SCRIPT (lunes 9:03am)"
echo "  Settings:        $SETTINGS"
echo ""
echo "Para verificar que todo funciona:"
echo "  bash $HOOK_DST        # debe salir silencioso si no hay trabajo abierto"
echo "  bash $LINT_SCRIPT     # corre el lint ahora"
echo ""
[[ "$DRY_RUN" == "--dry-run" ]] && warn "Modo dry-run: ningún archivo fue modificado."
