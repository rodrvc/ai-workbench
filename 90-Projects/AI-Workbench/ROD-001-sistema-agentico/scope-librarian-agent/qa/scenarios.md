- **Precondiciones:**
  - Archivo de agente disponible en `.opencode/agents/librarian.md`.
  - Raw log disponible para prueba.
- **Pasos de Reproduccion (bloqueo por falta de scopes):**
  1. Ejecutar `@librarian process <file>`.
  2. No entregar scopes en el prompt inicial.
  3. Revisar respuesta del agente.
- **Resultados Esperados (bloqueo):**
  - El agente solicita scopes explicitos.
  - El agente no escribe archivos antes de esa confirmacion.

- **Pasos de Reproduccion (flujo completo):**
  1. Repetir `@librarian process <file>`.
  2. Entregar scopes confirmados: `core-infrastructure`, `librarian-agent`, `handoff-skill`.
  3. Validar estructura espejo `dev/` y `qa/` por scope.
- **Resultados Esperados (flujo completo):**
  - Se crean/actualizan artefactos por scope sin mezclar contenido Dev y QA.
