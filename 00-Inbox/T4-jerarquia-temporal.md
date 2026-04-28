TAREA T4 — Jerarquía temporal (Weekly / Monthly / Yearly)
Vault: /home/rodvall/Obsidian
=========================================================

CONTEXTO
--------
Rodrigo tiene ~620 daily notes en notas/daily-notes/ con formato DD-MM-YYYY.md
y tag #journey/day. Las daily notes son la fuente de verdad diaria.

El problema: no existe jerarquía temporal activa para 2024-2026.
- notas/weekly-notes/ → solo tiene hasta 2025-W21 (desactualizado)
- notas/month-notes/  → solo tiene 2023 (abandonado)
- notas/Year/         → solo tiene 2023.md (abandonado)

IMPORTANTE: Las daily notes ya están siendo refactorizadas (T1) y tendrán
frontmatter con: date (YYYY-MM-DD), week (YYYY-Wnn), focus, resumen.
Tu trabajo es crear la capa superior de esa jerarquía.

Herramientas disponibles:
- obsidian CLI: flatpak run --command=/app/obsidian-cli md.obsidian.Obsidian
- Filesystem directo: /home/rodvall/Obsidian/

TU TAREA
--------
1. Crear templates para weekly, monthly y yearly notes
2. Generar notas faltantes para el período reciente (2024-01 hasta hoy)
3. Verificar que la jerarquía queda conectada

PARTE 1 — TEMPLATES
-------------------

Crear: templates/templater/dialy-notes/weekly-template.md
-------------------------------------------------------
---
week: "<% tp.date.now("YYYY-[W]WW") %>"
month: "<% tp.date.now("YYYY-MM") %>"
year: "<% tp.date.now("YYYY") %>"
date_start: "<% tp.date.now("YYYY-MM-DD", 0, "isoWeek") %>"
date_end: "<% tp.date.now("YYYY-MM-DD", 6, "isoWeek") %>"
type: weekly
tags:
  - journey/week
---

# Semana <% tp.date.now("[W]WW · YYYY") %>
<% tp.date.now("DD MMM", 0, "isoWeek") %> → <% tp.date.now("DD MMM", 6, "isoWeek") %>

## Foco de la semana
(qué era lo más importante esta semana)

## Objetivos de la semana
- [ ]

## Resumen
(qué se logró, se escribe al cerrar la semana)

## Dailys de esta semana
(Dataview llenará esto automáticamente cuando esté configurado)

## Para la próxima semana

#journey/week


Crear: templates/templater/dialy-notes/monthly-template.md
--------------------------------------------------------
---
month: "<% tp.date.now("YYYY-MM") %>"
year: "<% tp.date.now("YYYY") %>"
type: monthly
tags:
  - journey/month
---

# <% tp.date.now("MMMM YYYY") %>

## Intención del mes
(qué querías lograr)

## Proyectos activos este mes

## Resumen del mes
(se escribe al cerrar)

## Semanas del mes
(links a weekly notes)

#journey/month


Crear: templates/templater/dialy-notes/yearly-template.md
-------------------------------------------------------
---
year: "<% tp.date.now("YYYY") %>"
type: yearly
tags:
  - journey/year
---

# <% tp.date.now("YYYY") %>

## Palabra del año

## Áreas de foco

## Proyectos del año

## Meses
(links a monthly notes)

## Revisión anual
(se escribe en diciembre)

#journey/year


PARTE 2 — GENERAR NOTAS FALTANTES
----------------------------------

Generar weekly notes faltantes (2024-W01 hasta la semana actual):
- Carpeta: notas/weekly-notes/
- Formato nombre: YYYY-Wnn.md (ej: 2024-W01.md)
- Contenido mínimo: frontmatter + encabezado + tags
- Solo crear si el archivo NO existe ya
- NO usar el template completo — versión simplificada para backfill:

---
week: "YYYY-Wnn"
month: "YYYY-MM"
year: "YYYY"
type: weekly
tags:
  - journey/week
---

# Semana Wnn · YYYY

#journey/week


Generar monthly notes faltantes (2024-01 hasta mes actual):
- Carpeta: notas/month-notes/
- Formato nombre: YYYY-MM.md (ej: 2024-01.md)
- Contenido mínimo similar al anterior

---
month: "YYYY-MM"
year: "YYYY"
type: monthly
tags:
  - journey/month
---

# [Nombre Mes] YYYY

#journey/month


Generar yearly notes faltantes (2024, 2025, 2026):
- Carpeta: notas/Year/
- Formato: YYYY.md

---
year: "YYYY"
type: yearly
tags:
  - journey/year
---

# YYYY

#journey/year


PARTE 3 — VERIFICACIÓN
-----------------------

Al terminar reportar:
- Cuántas weekly notes creadas
- Cuántas monthly notes creadas
- Cuántas yearly notes creadas
- Listar las últimas 5 weekly notes creadas para verificar formato

Comandos de verificación:
obsidian files folder="notas/weekly-notes" total
obsidian files folder="notas/month-notes" total
obsidian files folder="notas/Year" total

RESTRICCIONES
-------------
- NO modificar archivos existentes (solo crear nuevos)
- NO tocar notas/daily-notes/ (se trabaja en T1)
- Hacer dry-run primero: listar todos los archivos a crear antes de crearlos
- Si hay dudas sobre fechas/formatos, preguntar antes de crear masivamente
- Respetar el formato de nombres existente en cada carpeta
