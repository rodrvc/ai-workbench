#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/ai-env.sh
. "$SCRIPT_DIR/lib/ai-env.sh"
ai_env_require

usage() {
  cat <<'EOF'
Usage:
  scripts/new-hu.sh <PROJECT> <HU_ID> <SHORT_DESCRIPTION> [SCOPE ...]

Examples:
  scripts/new-hu.sh TMS TMS-11278 reemplazo-patentes menu-flota presentacion-origen cierre-periodo
  scripts/new-hu.sh AI-Workbench ROD-001 sistema-agentico core-infrastructure librarian-agent handoff-skill

Rules:
  - HU folder format: <HU_ID>-<short-description>
  - No spaces in folder name (description is slugified to kebab-case)
EOF
}

slugify() {
  local input="${1,,}"
  input="$(printf '%s' "$input" | tr -cs 'a-z0-9' '-')"
  input="${input#-}"
  input="${input%-}"
  printf '%s' "$input"
}

if [ "$#" -lt 3 ]; then
  usage
  exit 1
fi

PROJECT="$1"
HU_ID="$2"
SHORT_DESCRIPTION_RAW="$3"
shift 3

SHORT_DESCRIPTION="$(slugify "$SHORT_DESCRIPTION_RAW")"
if [ -z "$SHORT_DESCRIPTION" ]; then
  echo "[error] short description invalid after slugify"
  exit 1
fi

WORKBENCH_ROOT="$AI_WORKBENCH_ROOT"
PROJECT_ROOT="$WORKBENCH_ROOT/90-Projects/$PROJECT"
HU_FOLDER="$HU_ID-$SHORT_DESCRIPTION"
HU_ROOT="$PROJECT_ROOT/$HU_FOLDER"

if [ ! -d "$PROJECT_ROOT" ]; then
  echo "[error] project path does not exist: $PROJECT_ROOT"
  exit 1
fi

if [ -e "$HU_ROOT" ]; then
  echo "[error] HU folder already exists: $HU_ROOT"
  exit 1
fi

if [ "$#" -eq 0 ]; then
  SCOPES=("general")
else
  SCOPES=("$@")
fi

mkdir -p "$HU_ROOT"

cat > "$HU_ROOT/00-Context.md" <<EOF
# $HU_ID: [Title Pending]

- Goal: [What problem this HU solves]
- Jira: [LINK_PENDING]
- Status: active
- Naming: $HU_FOLDER

## Scopes
$(for scope in "${SCOPES[@]}"; do printf -- "- scope-%s\n" "$(slugify "$scope")"; done)
EOF

for scope in "${SCOPES[@]}"; do
  scope_slug="$(slugify "$scope")"
  scope_root="$HU_ROOT/scope-$scope_slug"
  mkdir -p "$scope_root/dev" "$scope_root/qa"

  cat > "$scope_root/dev/log.md" <<EOF
- Objective: [Technical objective for scope-$scope_slug]
- Decisions:
  - [Decision + rationale]
- Files Modified:
  - [PATH_PENDING]
- Risks / Technical Debt:
  - [RISK_PENDING]
EOF

  cat > "$scope_root/dev/tech-artifacts.md" <<'EOF'
```sql
-- [SQL_PENDING]
```

```bash
# [CURL_OR_COMMAND_PENDING]
```

```json
{
  "payload": "[JSON_PENDING]"
}
```
EOF

  cat > "$scope_root/qa/scenarios.md" <<EOF
- Preconditions:
  - [PRECONDITION_PENDING]
- Reproduction Steps:
  1. [STEP_1_PENDING]
  2. [STEP_2_PENDING]
- Expected Result:
  - [EXPECTED_RESULT_PENDING]
EOF

  cat > "$scope_root/qa/test-data.md" <<'EOF'
```sql
-- [TEST_DATA_SETUP_PENDING]
```

```sql
-- [TEST_DATA_ROLLBACK_PENDING]
```
EOF

  cat > "$scope_root/checklist.md" <<'EOF'
- [ ] Jira link present in 00-Context.md
- [ ] Dev log completed
- [ ] Tech artifacts are real (no invented data)
- [ ] QA scenarios executable end-to-end
- [ ] Test data setup and rollback documented
EOF
done

echo "[ok] created HU scaffold: $HU_ROOT"
