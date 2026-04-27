# Obsidian Migration Plan (AI Workbench)

## Objective

Move AI Workbench from `/home/rodvall/projects/ai-workbench` into personal Obsidian vault under `/home/rodvall/Obsidian/Work/AI-Workbench` without breaking agent flows.

## Target State

- Canonical path: `/home/rodvall/Obsidian/Work/AI-Workbench`
- `AI_WORKBENCH_ROOT` points to canonical path
- `AI_OBSIDIAN_VAULT` points to `/home/rodvall/Obsidian`
- Agents resolve path by env vars first, then safe fallbacks

## Constraints

- Keep folder naming convention: `<HU-ID>-<short-description>`
- Keep Dev/QA mirrored structure by scope
- Do not lose git history and hidden folders (`.opencode`, `.obsidian`, `.git`)

## Execution Steps

1. Precheck
   - Confirm destination parent exists: `/home/rodvall/Obsidian/Work`
   - Confirm no existing folder conflict: `/home/rodvall/Obsidian/Work/AI-Workbench`

2. Move repository
   - Move full folder with metadata:
     - from `/home/rodvall/projects/ai-workbench`
     - to `/home/rodvall/Obsidian/Work/AI-Workbench`

3. Compatibility bridge (optional but recommended)
   - Create symlink to preserve old integrations:
     - `/home/rodvall/projects/ai-workbench -> /home/rodvall/Obsidian/Work/AI-Workbench`

4. Update env vars
   - `AI_WORKBENCH_ROOT=/home/rodvall/Obsidian/Work/AI-Workbench`
   - `AI_OBSIDIAN_VAULT=/home/rodvall/Obsidian`

5. Verify agents
   - `@librarian` can read/write under `90-Projects/`
   - Obsidian Claude context can find AI Workbench location

6. Verify scripts
   - `scripts/new-hu.sh` works from new location
   - Existing HU paths remain valid

## Rollback Plan

1. Remove compatibility symlink if created
2. Move folder back to `/home/rodvall/projects/ai-workbench`
3. Restore previous env vars

## Validation Checklist

- [ ] New path exists and includes `.git`
- [ ] `.opencode/agents/librarian.md` resolvers work
- [ ] `falabella/CLAUDE.md` points to new canonical path
- [ ] `Obsidian/CLAUDE.md` contains AI Workbench location reference
- [ ] `TMS-11278-reemplazo-patentes` and `ROD-001-sistema-agentico` still accessible
