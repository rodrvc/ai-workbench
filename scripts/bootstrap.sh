#!/usr/bin/env bash
set -euo pipefail

echo "[ai-workbench] bootstrap start"

if [ ! -d .git ]; then
  git init
  echo "[ai-workbench] git repo initialized"
fi

echo "[ai-workbench] done"
