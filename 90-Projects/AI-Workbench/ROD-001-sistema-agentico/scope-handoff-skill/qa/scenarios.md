- **Precondiciones:**
  - Skill `handoff-writer` disponible y cargable.
  - Texto dummy con contenido mixto (narrativo + artefactos tecnicos).
- **Pasos de Reproduccion:**
  1. Ejecutar skill `handoff-writer` sobre texto dummy.
  2. Revisar archivos generados por scope.
  3. Verificar ubicacion de SQL/JSON/cURL en `tech-artifacts.md` o `test-data.md`.
  4. Verificar que `dev/log.md` no mezcla pasos QA.
  5. Verificar que `qa/scenarios.md` contiene pasos ejecutables y resultado esperado.
- **Resultados Esperados:**
  - Salida en bullets, sin relleno conversacional.
  - Estructura espejo Dev/QA respetada.
  - Datos faltantes marcados con `[FALTA DATA]`.
