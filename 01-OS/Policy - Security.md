---
type: policy
status: active
severity: critical
last_verified: 2026-04-09
---

# Policy - Security

## Reglas

- Nunca guardar tokens, passwords, api keys o credenciales en markdown.
- Usar placeholders (`${ENV_VAR}`) y/o secret manager local.
- Nunca ejecutar acciones destructivas en produccion sin aprobacion explicita.
- Toda automatizacion debe distinguir UAT vs PROD por variable obligatoria.

## Checklist rapido

- [ ] No hay secretos hardcodeados.
- [ ] Entorno objetivo esta validado.
- [ ] Comandos de escritura en BD fueron revisados.
