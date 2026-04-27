# INDEX — Agente Soporte Proforma SAP

**Carpeta base**: `/home/rodvall/Obsidian/Work/AI-Workbench/90-Projects/TMS-support/agente-soporte-proforma/`

---

## Archivos de la HU

### 1. HU-agente-soporte-proforma.md
**Punto de entrada universal**. Contiene:
- Problema resumido
- Contexto técnico
- Lo que sabemos hasta ahora
- Estado actual + pendientes
- Arquitectura de BD

**Leer cuando**: Necesitas orientarte en la HU, revisar preguntas abiertas, o dejar comentarios para el próximo agente.

---

### 2. handoff-dev.md
**Punto de entrada para Dev**. Contiene:
- Estado de implementación
- Bloqueos técnicos
- Arquitectura del sistema
- Next actions específicas para código
- Queries SQL de diagnóstico

**Leer cuando**: Vas a trabajar en código, integración con APIs, o investigar listeners de Pub/Sub.

---

### 3. handoff-qa.md
**Punto de entrada para QA**. Contiene:
- Escenarios de prueba (E1-E5)
- Procedimientos paso a paso
- Datos activos de test
- Gotchas operacionales

**Leer cuando**: Vas a probar el flujo end-to-end, simular fallos, o verificar eventos.

---

### 4. referencias-tecnicas.md
**Diccionario técnico rápido**. Contiene:
- Enums de estados
- Clases clave (ubicación exacta)
- Evento Pub/Sub
- Queries SQL predefinidas
- Endpoints hipotéticos
- Stack técnico

**Consultar cuando**: Necesitas la ubicación exacta de una clase, una query SQL, o la estructura de un payload.

---

## Cómo Navegar

### Si eres Dev
1. Lee **handoff-dev.md** → entiende bloqueos y next actions
2. Consulta **referencias-tecnicas.md** → ubica código fuente
3. Escribe hallazgos en **HU-agente-soporte-proforma.md** → sección "Elementos Técnicos"

### Si eres QA
1. Lee **handoff-qa.md** → entiende escenarios
2. Consulta **referencias-tecnicas.md** → queries de diagnóstico
3. Escribe resultados de pruebas en **HU-agente-soporte-proforma.md** → sección "Estado Actual"

### Si eres investigador (mixto)
1. Lee **HU-agente-soporte-proforma.md** → contexto general
2. Decide si necesitas ir a Dev o QA
3. Consulta **referencias-tecnicas.md** según necesites

---

## Estado Global

| Archivo | Última actualización | Estado |
|---------|---------------------|--------|
| HU-agente-soporte-proforma.md | 2026-04-16 | ⬜ Inicial |
| handoff-dev.md | 2026-04-16 | ⬜ Bloqueos |
| handoff-qa.md | 2026-04-16 | ⬜ Escenarios listos |
| referencias-tecnicas.md | 2026-04-16 | ⬜ Diccionario |

---

## Próximas Acciones

**Para continuar la sesión**:
1. Dev: Acceder a repos de ms-payment y ms-shipment
2. Dev: Localizar `ProformaServiceImpl.saveInvoiceProforma()`
3. Dev: Buscar listeners de `PROFORMA_INVOICE_ATTACH_REQUESTED` en ms-payment
4. QA: Preparar datos de test en UAT

**Punto de sincronización**: handoff-dev.md y handoff-qa.md deben estar sincronizados — si Dev descubre que el estado POST-PENDING es X, QA necesita actualizarlo en su E2.

