#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/ai-env.sh
. "$SCRIPT_DIR/lib/ai-env.sh"

echo "[ai-workbench] bootstrap start"

if [ ! -d .git ]; then
  git init
  echo "[ai-workbench] git repo initialized"
fi

if [ ! -f .env.local ]; then
  if [ -f .env.example ]; then
    cp .env.example .env.local
  else
    cat > .env.local <<'EOF'
AI_WORKBENCH_ROOT=""
AI_OBSIDIAN_VAULT=""
EOF
  fi
  echo "[ai-workbench] .env.local created"
fi

ai_env_bootstrap_if_missing

echo "[ai-workbench] done"
