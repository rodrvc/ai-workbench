# AI-Workbench

No pierdas contexto entre sesiones de Claude Code.

## El problema

Abres Claude Code. No sabe dónde quedaste.
Repites contexto. Pierdes 10 minutos antes de arrancar.
AI-Workbench lo resuelve.

## Requisitos

- [Obsidian](https://obsidian.md) — tu vault es donde vive el framework
- [Claude Code](https://claude.ai/code) — el agente que ejecuta las sesiones

## Quickstart

```bash
# 1. Clona dentro de tu vault de Obsidian
cd ~/tu-vault
git clone https://github.com/rodrvc/ai-workbench AI-Workbench

# 2. Instala hooks y configura rutas
cd AI-Workbench && ./scripts/install.sh

# 3. Abre Claude Code en tu vault y escribe:
"crea una HU para [lo que vas a hacer]"

# La IA genera el scope file, trabajas, y al cerrar:
"cerrar scope"

# Próxima sesión — retoma desde donde quedó.
```

## Cómo funciona

```
sesión abre → lee scope file → trabaja
                                   ↓
                            "cerrar scope"
                                   ↓
                   handoff-writer escribe estado XML
                                   ↓
              próxima sesión lee estado → continúa sin perder contexto
```

## Estructura

```
AI-Workbench/
├── 01-OS/          → políticas y contrato de interoperabilidad
├── 02-Agents/      → definiciones de agentes (Librarian, Router, Specialist...)
├── 03-Skills/      → skills instalables en ~/.claude/skills/
├── 04-Router/      → reglas de routing entre agentes
├── 05-Templates/   → templates de scope, handoff y contexto
├── 06-Playbooks/   → HU Delivery Playbook y protocolo de cierre
├── 07-Knowledge/   → catálogo de patrones y mejora continua
├── 90-Projects/    → estado de proyectos activos
└── scripts/
    ├── install.sh                       → setup en máquina nueva
    ├── lint-workbench.sh                → lint semanal determinista
    └── hooks/
        ├── session-start.sh             → avisa si no hay HU activa
        └── obsidian-close-reminder.sh   → detecta scopes sin cerrar
```

## Más

- Flujo completo de una HU → `06-Playbooks/HU Delivery Playbook.md`
- Templates de scope y handoff → `05-Templates/`
- Configuración avanzada (PARA, Dataview, campos derivados) → `docs/obsidian-advanced.md`
