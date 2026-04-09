---
mode: subagent
model: openrouter/google/gemini-2.0-flash-001
prompt: "{file:../../02-Agents/Agent - Router.md}\n\nTask rules:\n- Analyze the HU brief and project profile.\n- Decide which agents should be involved.\n- Follow security policies in [[01-OS/Policy - Security]]."
tools:
  read: true
  glob: true
  grep: true
---
