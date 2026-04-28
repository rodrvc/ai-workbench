TAREA T3 — Arquitectura de carpetas / Espacios de trabajo
Vault: /home/rodvall/Obsidian
=========================================================

CONTEXTO
--------
Rodrigo tiene un vault de Obsidian que necesita reorganización. El vault tiene estos
espacios de trabajo que actualmente no tienen una estructura clara:

- TMS Falabella (trabajo principal) → YA existe en Falabella/ — NO TOCAR
- Adondepo (proyecto personal, app de lugares en Chile) → NO existe aún
- Acuaria Labs (agencia de software personal) → NO existe aún
- Banda STP (proyecto musical) → existe en PARA/PROYECTOS/Banda/ — NO TOCAR

Sistema PARA actual (poco desarrollado):
- PARA/AREAS/Estudios/ — solo 2 archivos
- PARA/AREAS/Personal/ — vacío
- PARA/PROYECTOS/Banda/ — OK, funciona

Herramientas disponibles:
- obsidian CLI: flatpak run --command=/app/obsidian-cli md.obsidian.Obsidian
- Obsidian debe estar abierto para usar el CLI

TU TAREA
--------
Crear la estructura de carpetas y archivos índice para los proyectos que faltan.
NO mover ni modificar archivos existentes — solo CREAR nueva estructura.

ESTRUCTURA A CREAR
------------------

1. PARA/PROYECTOS/Adondepo/
   - index.md (ver template abajo)
   - handoff.md (ver template abajo)

2. PARA/PROYECTOS/Acuaria-Labs/
   - index.md (ver template abajo)
   - handoff.md (ver template abajo)

3. PARA/AREAS/Personal/
   - index.md simple que linkee a notas/personal/

4. PARA/AREAS/Trabajo/
   - index.md que linkee a Falabella/falabella-index

TEMPLATE index.md
-----------------
---
type: project
status: active
created: FECHA-HOY
tags:
  - proyecto
---

# [NOMBRE PROYECTO]

## Qué es
[descripción breve]

## Estado actual
- Progreso: 0%
- Fase: ideación

## Links importantes
- Repo: (pendiente)
- Handoff IA: [[handoff]]

## Notas recientes
(vacío — se llenará con el tiempo)


TEMPLATE handoff.md
-------------------
---
type: handoff
project: [NOMBRE]
updated: FECHA-HOY
---

# Handoff — [NOMBRE PROYECTO]

> Este archivo es el punto de entrada para agentes IA que trabajen en este proyecto.
> Mantenerlo actualizado después de cada sesión de trabajo.

## Estado actual
(pendiente — llenar en primera sesión de trabajo)

## Contexto técnico
- Stack: (pendiente)
- Repo: (pendiente)
- Entorno: (pendiente)

## Último trabajo realizado
(pendiente)

## Próximos pasos
(pendiente)

## Decisiones importantes tomadas
(pendiente)

## Dónde encontrar las cosas
(pendiente)


PASOS A EJECUTAR
----------------
1. Crear las 4 carpetas listadas
2. Crear los archivos index.md y handoff.md con los templates
3. Adaptar el contenido de cada index.md al proyecto correspondiente:
   - Adondepo: app de descubrimiento de lugares en Chile, stack React Native + NestJS
   - Acuaria Labs: agencia de software con IA, stack NestJS + Claude API
4. Verificar que todos los archivos fueron creados correctamente

VERIFICACIÓN FINAL
------------------
Mostrar el árbol de carpetas creadas con:
obsidian files folder="PARA/PROYECTOS" total
obsidian files folder="PARA/AREAS" total

NO tocar:
- Falabella/ (trabajo principal, ya organizado)
- PARA/PROYECTOS/Banda/ (ya existe y funciona)
- notas/ (daily notes, se trabaja en T1/T4)
- Work/AI-Workbench/ (sistema agéntico, no tocar)
