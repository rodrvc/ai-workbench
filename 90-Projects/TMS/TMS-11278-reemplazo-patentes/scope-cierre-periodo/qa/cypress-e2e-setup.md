# E5 — Cypress E2E Setup (UAT)

Guía para correr los tests de cierre de período desde cualquier máquina.

## Pre-requisitos

### 1. Cloud SQL Proxy en localhost:5432

El test necesita acceso directo a las BDs de Fleet y Shipment.
Verificar que el proxy esté corriendo:

```bash
ss -tlnp | grep 5432
# Debe mostrar algo. Si no:
# Iniciar cloud_sql_proxy apuntando a la instancia UAT
```

### 2. Python + psycopg2

```bash
pip install psycopg2-binary playwright
python3 -m playwright install chromium
```

### 3. Node + Cypress

```bash
cd /path/to/sche-trmg-e2e-tms-integration
npm install
```

### 4. Variables de entorno

Crear/verificar el archivo `.env` en `sche-trmg-e2e-tms-integration/`:

```env
CYPRESS_APP_ENV=uat
CYPRESS_BASE_UAT_URL=https://tms-uat.falabella.supply
CYPRESS_TMS_COUNTRY=CL
CYPRESS_TMS_COMMERCE=FCM
```

---

## Cómo obtener el JWT (requerido)

El test usa `CYPRESS_TMS_JWT_TOKEN` (token estático) porque el usuario `cypress@gmail.cl`
no puede generarse vía Firebase automáticamente desde Cypress.

### Opción A — Desde Chrome con sesión activa (recomendado)

1. Abrir Chrome y loguearse en https://tms-uat.falabella.supply con `cypress@gmail.cl`
2. Correr este script:

```bash
python3 -c "
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser = p.chromium.connect_over_cdp('http://localhost:9222')
    page = browser.contexts[0].pages[0]
    data = page.evaluate(\"() => JSON.parse(sessionStorage.getItem('token') || '{}')\")
    jwt = data.get('token', '')
    if jwt:
        print('JWT obtenido. Expira en ~1h.')
        print(jwt)
    else:
        print('Sin JWT — asegúrate de estar logueado en UAT')
"
```

> **Nota:** Chrome debe estar corriendo con `--remote-debugging-port=9222`.
> Si no: `google-chrome --remote-debugging-port=9222 https://tms-uat.falabella.supply &`

### Opción B — Desde el browser manualmente

1. Abrir DevTools (F12) en `tms-uat.falabella.supply`
2. Consola: `JSON.parse(sessionStorage.getItem('token')).token`
3. Copiar el valor

---

## Correr los tests

```bash
cd /path/to/sche-trmg-e2e-tms-integration

# Exportar JWT (reemplazar con el token real)
export CYPRESS_TMS_JWT_TOKEN="eyJhbGci..."

# Correr solo E5
CYPRESS_APP_ENV=uat npx cypress run \
  --browser chrome \
  --headed \
  --spec 'cypress/e2e/ms-fleet/api/period-close-replacement.cy.ts'
```

---

## Qué hace cada test

| Test | Script Python | Verifica |
|------|--------------|---------|
| E5.3 | `e43` (regresión sin reemplazo) | PR generado con vehículo normal — sin swap |
| E5.2 | `e42` (viaje propio + reemplazo) | Todos los PRs asignados al vehículo original |

El flujo de cada test:
1. **before()**: corre el script Python (`e43` o `e42`) que prepara datos en BD
2. **test**: lee `/tmp/tms-11278-test-state.json` para saber qué período/flota/fecha usar
3. **test**: llama a `POST /period-process` en UAT con el JWT
4. **test**: espera 8s y verifica en BD que el PR tiene el `vehicle_id` correcto
5. **after()**: rollback automático vía script Python

---

## Credenciales BD (para cy.task interno)

Estas ya están hardcodeadas en `cypress.config.ts`. No hace falta configurarlas:

| BD | Host | Puerto | Usuario | DB |
|----|------|--------|---------|-----|
| Fleet | localhost | 5432 | SCHE_TRMG_FLEET_TEST_USER | SCHE_TRMG_FLEET_TEST |
| Shipment | localhost | 5432 | SCHE_TRMG_SHIPMENT_TEST_USER | SCHE_TRMG_SHIPMENT_TEST |

---

## Problemas conocidos y soluciones

### Script `e42` falla con `TypeError: cannot unpack non-iterable NoneType`

**Causa:** el script eligió un período sin datos completos de flota.
**Solución:** correr rollback y volver a correr el test (elige otro período):

```bash
python3 docs/TMS-11278-prueba-cierre-periodo-reemplazo.py --rollback
# Luego re-correr Cypress
```

Si sigue fallando repetidamente, es un bug de robustez en el script Python (pendiente fix).
**Workaround manual:**
```bash
# Verificar qué período encontró
python3 docs/TMS-11278-prueba-cierre-periodo-reemplazo.py e42 2>&1 | head -20
# Si falla, buscar un período manualmente en Fleet DB y ajustar el script
```

### PR no aparece en BD después de 8 segundos

**Causa probable:** el período elegido por el script es de una flota con procesamiento más lento
(ej: "prorrateo lineal") o el mensaje Pub/Sub tardó más.

**Verificación manual:**
```sql
-- En Shipment DB: buscar PRs del período que usó el test
SELECT payment_request_id, vehicle_id
FROM payment_request_dedicated_fleet
WHERE period_id = <period_id_del_state_file>;
```

**Solución:** aumentar el `cy.wait` a 15000 en el test o correr el test nuevamente.

### JWT expirado (error 401 en period-process)

Los tokens duran ~1 hora. Si falla con 401:
1. Obtener nuevo JWT (ver sección arriba)
2. Re-exportar `CYPRESS_TMS_JWT_TOKEN` y volver a correr

---

## Archivos relevantes

```
sche-trmg-e2e-tms-integration/
  cypress/e2e/ms-fleet/api/
    period-close-replacement.cy.ts    ← test E5.2 y E5.3
  cypress.config.ts                   ← cy.task db:fleet:query y db:shipment:query

falabella/docs/
  TMS-11278-prueba-cierre-periodo-reemplazo.py  ← script setup/teardown/verify
  /tmp/tms-11278-test-state.json                ← generado por el script, leído por Cypress
```

---

## Estado actual (2026-04-12)

| Test | Estado | Nota |
|------|--------|------|
| E5.3 | ⚠️ Infraestructura lista | PR a veces no aparece en 8s (depende del período que elige el script) |
| E5.2 | ⚠️ Infraestructura lista | Script e42 falla si elige período sin datos completos de flota |

**Lo que funciona end-to-end:** cy.task DB ✅ · cy.exec Python ✅ · cy.request API ✅ · cy.readFile state ✅

**Pendiente para PASS completo:**
1. Filtrar en el script Python que solo use flotas conocidas con tarifas (ej: fleet_id IN (991, 993, 996, 946))
2. O aumentar `cy.wait` a 15s para flotas lentas
