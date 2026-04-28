---
name: handoff-writer
description: Genera handoff estructurado al final de sesión — extrae solo el contexto estrictamente necesario para que el próximo agente continúe sin fricción
---

# Skill — Handoff Writer

Al final de una sesión, genera documentación compacta dividida por rol (Dev/QA).
Se escribe en Obsidian personal vía `obsidian-vault-manager`.

## Cuándo usar
- Al terminar una sesión de trabajo
- Cuando el contexto está por compactarse
- Al cambiar de sombrero Dev → QA o viceversa
- Cuando otro agente va a continuar el trabajo

## Principios
1. **No inventar** — sin dato concreto → `[FALTA DATA]`
2. **Sin narrativa** — viñetas, eliminar relleno conversacional
3. **Solo lo estrictamente necesario** — si no cambia el comportamiento del próximo agente, no va
4. **Artefactos separados** — todo código va a su sección, nunca inline en Dev/QA
5. **Máx 1 pantalla por rol** — Dev + QA + Artefactos ≈ 3 secciones compactas

---

## Estructura

### 🧑‍💻 Dev — `[TMS-XXXXX]`
- **Estado**: qué está implementado / qué falta
- **Decisiones técnicas**: el *por qué*, no el qué (el qué está en el código)
- **Blast radius**: archivos y servicios tocados
- **Next Actions**: máx 5, ordenadas por urgencia real (prerequisitos primero)
- **⚠️ Bloqueante**: omitir sección si no hay bloqueante activo
- **Dead Ends**: lo ya investigado que NO funciona (para no repetir)

### 🧪 QA — `[TMS-XXXXX]`
- **Escenarios cubiertos**: con resultado `✅ PASS / ❌ FAIL / ⏭ SKIP`
- **Escenarios pendientes**: con precondiciones mínimas Y criterio de éxito explícito
- **Active Test Data**: IDs, estados en BD, configs activas *ahora mismo*
- **Dead Ends**: errores ya investigados con causa raíz confirmada

### 📎 Artefactos — `[TMS-XXXXX]`
Solo bloques de código con comentario de una línea.
CURLs completos (JWT truncado), SQLs, scripts de setup.
Referenciados desde Dev/QA con `→ ver Artefactos`.

---

## Reglas de calidad

- **Next Actions en orden real**: si el paso 3 depende del 1, el 1 va primero aunque sea menos urgente
- **Bloqueante**: solo incluir si existe algo concreto que impide avanzar. Si no hay, omitir la sección entera
- **Criterio de éxito en QA**: cada escenario pendiente debe tener "Esperado: X" concreto (IDs, campos, valores)
- **Encabezado de contexto**: la nota debe abrir con `> **Ticket:** TMS-XXXXX | **Sesión:** YYYY-MM-DD` para orientar al lector en frío
- **Obsidian append**: siempre hacer Read del archivo antes de escribir — nunca sobreescribir contenido existente

---

## Dónde escribir

- **Vault**: `/home/rodvall/Obsidian/notas/`
- **Archivo**: `daily-notes/DD-MM-YYYY.md` (fecha de hoy)
- **Sección**: agregar bajo `## Handoff — [TMS-XXXXX]` al final de la daily note
- Hacer **Read primero** → si existe contenido, hacer **Edit/append** — nunca Write ciego

## Flujo de ejecución

1. Leer `docs/hu/TMS-XXXXX.md` si existe (estado oficial)
2. Extraer de la conversación actual los **deltas** desde el último handoff
3. Estructurar en Dev / QA / Artefactos según lo que aplique
4. Lanzar `obsidian-vault-manager`: Read del archivo → append del contenido
5. Confirmar ruta final al usuario (sin re-explicar el contenido)
