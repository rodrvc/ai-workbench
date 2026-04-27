```yaml
# .opencode/agents/librarian.md
---
mode: subagent
model: openrouter/google/gemini-2.0-flash-001
prompt: |
  {file:../../02-Agents/Agent - Librarian.md}
  
  Task rules:
  1. CRITICAL: ALWAYS ask user for logical scopes (subflows) first.
  2. CRITICAL: If missing data, ask user. Don't invent.
  3. Once scopes confirmed, create mirrored dev/qa folders per scope.
  4. Apply `handoff-writer` skill for extraction.
  5. Mark missing info as [FALTA DATA].
---
```

```bash
# Create agent file
touch .opencode/agents/librarian.md
```

```text
[FALTA DATA] Configuracion final de tools habilitadas en el agente para esta HU.
[FALTA DATA] Evidencia de contenido final en 02-Agents/Agent - Librarian.md.
```
