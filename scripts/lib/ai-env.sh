#!/usr/bin/env bash
set -euo pipefail

_AI_ENV_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_AI_ENV_REPO_ROOT="$(cd "${_AI_ENV_LIB_DIR}/../.." && pwd)"

ai_env_load() {
  local env_file="${AI_WORKBENCH_ENV_FILE:-${_AI_ENV_REPO_ROOT}/.env.local}"

  if [ -f "$env_file" ]; then
    # shellcheck disable=SC1090
    . "$env_file"
  fi

  export AI_WORKBENCH_ROOT="${AI_WORKBENCH_ROOT:-${_AI_ENV_REPO_ROOT}}"
  export AI_OBSIDIAN_VAULT="${AI_OBSIDIAN_VAULT:-${AI_WORKBENCH_ROOT}}"
}

_ai_env_prompt_dir() {
  local var_name="$1"
  local prompt_text="$2"
  local current_value="$3"
  local input_value

  printf "%s [%s]: " "$prompt_text" "$current_value"
  read -r input_value
  if [ -n "$input_value" ]; then
    printf "%s" "$input_value"
  else
    printf "%s" "$current_value"
  fi
}

ai_env_bootstrap_if_missing() {
  ai_env_load

  if [ -d "$AI_WORKBENCH_ROOT" ] && [ -d "$AI_OBSIDIAN_VAULT" ]; then
    return 0
  fi

  local default_root="${_AI_ENV_REPO_ROOT}"

  if [ ! -t 0 ]; then
    local env_file_non_tty="${AI_WORKBENCH_ENV_FILE:-${_AI_ENV_REPO_ROOT}/.env.local}"
    cat > "$env_file_non_tty" <<EOF
AI_WORKBENCH_ROOT="$default_root"
AI_OBSIDIAN_VAULT="$default_root"
EOF
    echo "[ai-workbench] Non-interactive mode: default config saved in $env_file_non_tty"
    ai_env_load
    return 0
  fi

  echo "[ai-workbench] Initial configuration required."

  local selected_root
  local selected_vault

  selected_root="$(_ai_env_prompt_dir "AI_WORKBENCH_ROOT" "AI_WORKBENCH_ROOT path" "$default_root")"
  while [ ! -d "$selected_root" ]; do
    echo "[error] Directory does not exist: $selected_root"
    selected_root="$(_ai_env_prompt_dir "AI_WORKBENCH_ROOT" "AI_WORKBENCH_ROOT path" "$default_root")"
  done

  selected_vault="$(_ai_env_prompt_dir "AI_OBSIDIAN_VAULT" "AI_OBSIDIAN_VAULT path" "$selected_root")"
  while [ ! -d "$selected_vault" ]; do
    echo "[error] Directory does not exist: $selected_vault"
    selected_vault="$(_ai_env_prompt_dir "AI_OBSIDIAN_VAULT" "AI_OBSIDIAN_VAULT path" "$selected_root")"
  done

  local env_file="${AI_WORKBENCH_ENV_FILE:-${_AI_ENV_REPO_ROOT}/.env.local}"
  cat > "$env_file" <<EOF
AI_WORKBENCH_ROOT="$selected_root"
AI_OBSIDIAN_VAULT="$selected_vault"
EOF

  echo "[ai-workbench] Configuration saved in $env_file"
  ai_env_load
}

ai_env_require() {
  ai_env_bootstrap_if_missing

  if [ ! -d "$AI_WORKBENCH_ROOT" ]; then
    echo "[error] AI_WORKBENCH_ROOT is not a valid directory: $AI_WORKBENCH_ROOT" >&2
    return 1
  fi

  if [ ! -d "$AI_OBSIDIAN_VAULT" ]; then
    echo "[error] AI_OBSIDIAN_VAULT is not a valid directory: $AI_OBSIDIAN_VAULT" >&2
    return 1
  fi
}
