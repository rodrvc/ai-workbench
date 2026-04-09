---
mode: subagent
model: openrouter/google/gemini-2.0-flash-001
prompt: "{file:../../02-Agents/Agent - Efficiency Dev.md}\n\nTask rules:\n- Use absolute paths for all file operations.\n- Prioritize brevity and token efficiency.\n- Follow security policies in [[01-OS/Policy - Security]]."
tools: true
permission:
  bash: allow
  edit: allow
  read: allow
  write: allow
  glob: allow
  grep: allow
---
