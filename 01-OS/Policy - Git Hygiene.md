---
type: policy
status: active
last_verified: 2026-04-09
---

# Policy - Git Hygiene

## Reglas

- No mezclar cambios de configuracion agentica con cambios funcionales de producto.
- Un commit debe representar una sola intencion.
- No hacer `force push` a ramas protegidas.
- No hacer `--amend` sobre commits ya compartidos.

## Practica recomendada

- Mantener este repositorio separado de repos de negocio.
- Etiquetar releases de configuracion (`v0.1.0`, `v0.2.0`, etc.).
