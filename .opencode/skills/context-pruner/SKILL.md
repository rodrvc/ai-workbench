---
name: context-pruner
description: Transforma logs de sesion densos en briefs operativos compactos, extrayendo tech artifacts.
---

# Skill - Context Pruner

## What I do
Analizo archivos de contexto masivos (HUs gigantes, logs extensos) y extraigo solo la información operativa necesaria para el desarrollo, desechando el ruido.

## Workflow
1. **Identificar el "North Star"**: Objetivo final de la HU.
2. **Filtrar historial**: Eliminar errores de sintaxis o intentos fallidos.
3. **Extraer Tech Artifacts**: SQL, CURLs y Endpoints a [[Tech Registry]].
4. **Resumir estado actual**: Máximo 10 líneas de "donde estamos".

## When to use me
Cuando un archivo de HU o log supera las 250 líneas o el costo de tokens se vuelve ineficiente.
