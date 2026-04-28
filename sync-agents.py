#!/usr/bin/env python3
"""
sync-agents.py — Sincroniza agentes entre OpenCode y Claude Code.

Fuente canónica: AI-Workbench/02-Agents/Agent - X.md
OpenCode:        AI-Workbench/.opencode/agents/*.md
Claude Code:     ~/.claude/agents/*.md

Uso:
  python3 sync-agents.py          # muestra diff entre herramientas
  python3 sync-agents.py --apply  # aplica cambios a Claude Code
"""

import os
import re
import sys
from pathlib import Path

# Rutas
WORKBENCH = Path(os.environ.get("AI_WORKBENCH_ROOT", "/home/rodvall/Obsidian/Work/AI-Workbench"))
OPENCODE_AGENTS = WORKBENCH / ".opencode" / "agents"
CLAUDE_AGENTS = Path.home() / ".claude" / "agents"
CANONICAL_AGENTS = WORKBENCH / "02-Agents"

# Mapa: nombre opencode → nombre claude
NAME_MAP = {
    "librarian":  "librarian",
    "efficiency": "efficiency",
    "qa":         "qa-verifier",
    "router":     "router",
    "specialist": "specialist",
    "integrator": "integrator",
}

def read_canonical(agent_name: str) -> str | None:
    """Lee la definición canónica desde 02-Agents/"""
    # Buscar archivo que matchee el nombre
    for f in CANONICAL_AGENTS.glob("Agent - *.md"):
        if agent_name.lower() in f.name.lower():
            return f.read_text()
    return None

def read_opencode_agent(name: str) -> dict | None:
    """Parsea un agente de OpenCode extrayendo modelo y task rules."""
    path = OPENCODE_AGENTS / f"{name}.md"
    if not path.exists():
        return None
    content = path.read_text()
    model = re.search(r"model:\s*(.+)", content)
    return {
        "model": model.group(1).strip() if model else "unknown",
        "content": content,
    }

def read_claude_agent(name: str) -> str | None:
    path = CLAUDE_AGENTS / f"{name}.md"
    return path.read_text() if path.exists() else None

def generate_claude_agent(oc_name: str, claude_name: str) -> str:
    """Genera un agente Claude a partir del agente OpenCode + definición canónica."""
    oc = read_opencode_agent(oc_name)
    canonical = read_canonical(oc_name)

    if not oc:
        return ""

    # Extraer task rules del agente OpenCode (todo después del frontmatter)
    task_rules = re.sub(r"^---.*?---\s*", "", oc["content"], flags=re.DOTALL).strip()
    # Limpiar la referencia {file:...}
    task_rules = re.sub(r"\{file:[^}]+\}\s*\n?", "", task_rules).strip()

    canonical_path = ""
    if canonical:
        for f in CANONICAL_AGENTS.glob("Agent - *.md"):
            if oc_name.lower() in f.name.lower():
                canonical_path = str(f)
                break

    description = {
        "librarian":  "Organiza logs crudos en documentación estructurada por scopes en AI Workbench.",
        "efficiency": "Poda de contexto, formateo y limpieza de archivos densos o logs largos.",
        "qa":         "Verifica criterios de aceptación y reporta brechas con evidencia.",
        "router":     "Clasifica una HU y decide qué agentes actúan y en qué orden.",
        "specialist": "Implementa cambios en un scope acotado siguiendo un task pack.",
        "integrator": "Consolida entregas de varios agentes y produce una salida unificada.",
    }.get(oc_name, "")

    return f"""---
name: {claude_name}
description: {description}
---

# Agent - {claude_name.replace("-", " ").title()}

## Canonical definition
Read `{canonical_path}` for full agent definition.

## AI Workbench root (en orden)
1. `AI_WORKBENCH_ROOT` env var
2. `/home/rodvall/Obsidian/Work/AI-Workbench`
3. `/home/rodvall/projects/ai-workbench`

## Task rules
{task_rules}
"""

def main():
    apply = "--apply" in sys.argv

    print("=== Agent Sync: OpenCode ↔ Claude Code ===\n")

    for oc_name, claude_name in NAME_MAP.items():
        oc_exists = (OPENCODE_AGENTS / f"{oc_name}.md").exists()
        claude_exists = (CLAUDE_AGENTS / f"{claude_name}.md").exists()

        status = "✅" if (oc_exists and claude_exists) else "⚠️ " if oc_exists else "❌"
        print(f"{status} {oc_name:12} → {claude_name}")

        if oc_exists and not claude_exists and apply:
            content = generate_claude_agent(oc_name, claude_name)
            if content:
                out = CLAUDE_AGENTS / f"{claude_name}.md"
                out.write_text(content)
                print(f"   → Creado: {out}")

    print()
    if not apply:
        print("Ejecuta con --apply para sincronizar agentes faltantes.")
    else:
        print("Sync completado.")

if __name__ == "__main__":
    main()
