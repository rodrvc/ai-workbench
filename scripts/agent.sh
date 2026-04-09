#!/usr/bin/env bash
set -euo pipefail

# Scripts de lanzamiento de agentes del AI Workbench
# Uso: ./scripts/agent.sh <agent-name> --input <file> --skill <skill-name>

AGENT_NAME=$1
shift

WORKBENCH_ROOT="/home/rodvall/projects/ai-workbench"
AGENT_FILE="$WORKBENCH_ROOT/02-Agents/Agent - $(echo $AGENT_NAME | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1').md"

if [ ! -f "$AGENT_FILE" ]; then
    # Intento búsqueda fuzzy si no existe exacto
    AGENT_FILE=$(find "$WORKBENCH_ROOT/02-Agents" -name "*$AGENT_NAME*" -print -quit)
fi

if [ -z "$AGENT_FILE" ] || [ ! -f "$AGENT_FILE" ]; then
    echo "Error: Agente '$AGENT_NAME' no encontrado en $WORKBENCH_ROOT/02-Agents/"
    exit 1
fi

echo "--- [ai-workbench] Iniciando Agente: $AGENT_NAME ---"
echo "Cargando Instrucciones: $(basename "$AGENT_FILE")"

# Construcción del contexto base (OS + Agent + Prompt)
CONTEXT_FILE="/tmp/agent_context.md"
{
    echo "# SYSTEM INSTRUCTIONS (OS)"
    cat "$WORKBENCH_ROOT/01-OS/Policy - Security.md"
    cat "$WORKBENCH_ROOT/01-OS/Policy - Token Budget.md"
    echo -e "\n# AGENT ROLE"
    cat "$AGENT_FILE"
    echo -e "\n# TASK"
    echo "Arguments: $@"
} > "$CONTEXT_FILE"

echo "Contexto preparado en: $CONTEXT_FILE"
echo "------------------------------------------------"
echo "Para ejecutar con Claude Code:"
echo "  claude \"Usando el contexto en $CONTEXT_FILE, ejecuta la tarea sobre $@\""
echo ""
echo "Para ejecutar con otros modelos, copia el contenido de $CONTEXT_FILE"
echo "------------------------------------------------"
