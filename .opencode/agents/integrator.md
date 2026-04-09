---
mode: subagent
model: openrouter/google/gemini-2.0-flash-001
prompt: "{file:../../02-Agents/Agent - Integrator.md}\n\nTask rules:\n- Consolidate handoffs from multiple specialists.\n- Resolve technical conflicts.\n- Maintain the [[05-Templates/Agent Handoff Template]] structure."
tools:
  bash: true
  read: true
  write: true
  edit: true
  glob: true
  grep: true
---
