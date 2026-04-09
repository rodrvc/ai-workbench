---
type: policy
status: active
last_verified: 2026-04-09
---

# Policy - Model Agnostic

## Principio

El sistema debe funcionar con cualquier modelo capaz de leer/escribir Markdown y ejecutar flujos basicos de ingenieria.

## Reglas

- Evitar sintaxis propietaria en la capa core (prompts, templates, handoffs).
- Mantener una capa de adaptadores por herramienta/modelo cuando sea necesario.
- Usar contratos de entrada/salida orientados a tarea, no a proveedor.

## Capa de adaptadores

- Core comun: `01-OS/`, `04-Router/`, `05-Templates/`, `06-Playbooks/`
- Adapter por runtime: `90-Projects/` o carpeta `adapters/` si crece el sistema.
