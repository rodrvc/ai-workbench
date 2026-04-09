---
type: skill
owner: rodvall
status: active
last_verified: 2026-04-09
token_budget: low
---

# Skill - Context Pruner

Habilidad para transformar logs de sesion densos en briefs operativos compactos.

## Procedimiento

1.  **Identificar el "North Star"**: Cuál es el objetivo final de la HU (regla de negocio principal).
2.  **Filtrar el historial**: Ignorar errores de sintaxis, intentos fallidos o conversaciones redundantes.
3.  **Extraer "Tech Artifacts"**: SQL, CURLs y Endpoints a su propia nota de referencia.
4.  **Resumir el estado actual**: Qué se hizo, qué se rompió y qué falta por hacer (en maximo 10 lineas).
5.  **Desechar el resto**: El log antiguo se puede mover a un `appendix/` o borrar si no es critico.

## Resultado

- `HU Brief` actualizado.
- `Tech Registry` actualizado.
- `Log` limpio y accionable.
