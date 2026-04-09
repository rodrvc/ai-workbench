---
type: standard
status: active
last_verified: 2026-04-09
---

# Frontmatter Schema

Usar este esquema minimo en todas las notas:

```yaml
---
type: policy|agent|skill|template|playbook|project-profile|memory|moc
owner: <persona-o-equipo>
status: draft|active|deprecated
last_verified: YYYY-MM-DD
token_budget: low|medium|high
---
```

Campos opcionales recomendados:

- `inputs:` lista de entradas esperadas
- `outputs:` lista de salidas esperadas
- `risk_level:` low|medium|high|critical
