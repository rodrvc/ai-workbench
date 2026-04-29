# AI-Workbench

Persistent context management for Claude Code sessions.

## The Problem

You open Claude Code. It doesn't know where you left off.
You spend the first 10 minutes re-explaining context instead of working.
AI-Workbench solves this.

## Requirements

- [Obsidian](https://obsidian.md) — your vault is where the framework lives
- [Claude Code](https://claude.ai/code) — the agent that runs your sessions

## Quickstart

```bash
# Clone inside your Obsidian vault
cd ~/your-vault
git clone https://github.com/rodrvc/ai-workbench AI-Workbench

# Install hooks and configure paths
cd AI-Workbench && ./scripts/install.sh

# Open Claude Code in your vault and type:
"create a HU for [what you're about to work on]"

# The agent generates a scope file. Work. When done:
"close scope"

# Next session — the agent picks up exactly where you left off.
```

## How It Works

```
session opens → reads scope file → works
                                      ↓
                               "close scope"
                                      ↓
                  handoff-writer writes XML state
                                      ↓
             next session reads state → continues without losing context
```

## Structure

```
AI-Workbench/
├── 01-OS/          → policies and interoperability contract
├── 02-Agents/      → agent definitions (Librarian, Router, Specialist...)
├── 03-Skills/      → installable skills for ~/.claude/skills/
├── 04-Router/      → routing rules between agents
├── 05-Templates/   → scope, handoff, and context templates
├── 06-Playbooks/   → HU Delivery Playbook and closing protocol
├── 07-Knowledge/   → patterns catalog and continuous improvement
├── 90-Projects/    → active project state
└── scripts/
    ├── install.sh                       → machine setup
    ├── lint-workbench.sh                → deterministic weekly lint
    └── hooks/
        ├── session-start.sh             → warns if no active HU
        └── obsidian-close-reminder.sh   → detects unclosed scopes
```

## Further Reading

- Full HU delivery flow → `06-Playbooks/HU Delivery Playbook.md`
- Scope and handoff templates → `05-Templates/`
- Advanced setup (PARA, Dataview, derived fields) → `docs/obsidian-advanced.md`
