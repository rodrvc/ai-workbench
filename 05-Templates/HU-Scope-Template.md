# Plantilla de HU por Scopes

Estructura base para organizar una Historia de Usuario compleja.

Convencion de nombre de carpeta HU (obligatoria):
- Formato: `<HU-ID>-<short-description>`
- Sin espacios
- `short-description` en lowercase kebab-case
- Ejemplos: `ROD-001-sistema-agentico`, `TMS-11278-reemplazo-patentes`

```text
<HU-ID>-<short-description>/
├── 00-Context.md          # Resumen de negocio, Jira link, problema que resuelve
├── scope-<nombre_1>/
│   ├── dev/
│   │   ├── log.md             # Narrativa, decisiones, archivos tocados
│   │   └── tech-artifacts.md  # Queries SQL, CURLs, endpoints
│   ├── qa/
│   │   ├── scenarios.md       # Casos de prueba ejecutables
│   │   └── test-data.md       # Datos semilla, scripts de setup
│   └── checklist.md       # Checklist manual de completitud
└── scope-<nombre_2>/
    └── ...
```

## Checklist Manual (checklist.md)
- [ ] ¿Tiene el link de Jira en el contexto?
- [ ] ¿Están las queries SQL reales de prueba en `test-data.md`?
- [ ] ¿Están documentados los CURLs o payloads en `tech-artifacts.md`?
- [ ] ¿Hay pasos exactos de reproducción para QA?
