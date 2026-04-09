---
type: dashboard
status: active
last_verified: 2026-04-09
---

# Dashboard - IA Workbench

## Estado de Agentes

> [!INFO] Para ver esto como tabla dinámica, instala el plugin **Dataview** en Obsidian.

### Dataview Query (Auto)
```dataview
TABLE status, last_verified, token_budget
FROM "02-Agents"
SORT last_verified ASC
```

### Tabla Estática (Manual)
| Agente | Status | Last Verified | Budget |
|---|---|---|---|
| [[02-Agents/Agent - Router\|Router]] | active | 2026-04-09 | low |
| [[02-Agents/Agent - Specialist Developer\|Specialist Dev]] | active | 2026-04-09 | medium |
| [[02-Agents/Agent - Integrator\|Integrator]] | active | 2026-04-09 | medium |
| [[02-Agents/Agent - QA Verifier\|QA Verifier]] | active | 2026-04-09 | medium |

---

## Estado de Skills

### Dataview Query (Auto)
```dataview
TABLE status, last_verified, token_budget
FROM "03-Skills"
SORT last_verified ASC
```

### Tabla Estática (Manual)
| Skill | Status | Last Verified | Budget |
|---|---|---|---|
| [[03-Skills/Skill - HU Triage\|HU Triage]] | active | 2026-04-09 | low |
| [[03-Skills/Skill - Handoff Writer\|Handoff Writer]] | active | 2026-04-09 | low |
| [[03-Skills/Skill - Retrospective Extractor\|Retro Extractor]] | active | 2026-04-09 | low |

---

## HUs Activas (Muestra)

### Dataview Query (Auto)
```dataview
TABLE status, priority, last_verified
FROM "00-Inbox"
WHERE type = "hu-brief"
SORT priority DESC
```

---

## Mantenimiento Requerido (Vencimiento > 30 días)

### Dataview Query (Auto)
```dataview
TABLE last_verified
WHERE last_verified < date(today) - dur(30 days)
SORT last_verified ASC
```
