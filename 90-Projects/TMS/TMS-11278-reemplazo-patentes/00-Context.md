# TMS-11278: Reemplazo de Patentes en Flotas Dedicadas

- **Goal:** Permitir usar vehículo de reemplazo en flota dedicada sin afectar el pago — el cierre de período liquida con la patente original.
- **Problem:** Sin esta HU, si se despacha con un reemplazo, el pago se genera con el vehículo incorrecto.
- **Jira:** https://jira.falabella.tech/browse/TMS-11278

## Scopes
| Scope | Descripción | MS | Estado |
|-------|-------------|----|--------|
| `e1-fleet-config` | Modal CRUD de configuración de reemplazos | Frontend + ms-fleet | ✅ Completo |
| `e2-presentation` | Presentación en Origen — badges + validación patente | ms-task + Frontend | ⬜ Pendiente QA UAT |
| `e3-incidents` | Gestión de Incidencias — mismo flujo que E2 | ms-task + Frontend | ⬜ Pendiente QA UAT |
| `e4-period-assign` | Asignación de período al despachar (`DISPATCH_TRUCK`) | ms-task | ⚠️ Parcial |
| `e5-period-close` | Cierre de período — `applyOriginalPlateSwap` | ms-fleet → ms-shipment | ✅ Completo (E5.1 + E5.2 + E5.3 PASS) |

## Current Status
- **State:** QA en curso (UAT)
- **MRs mergeados a `uat`:** ms-fleet !537, ms-shipment !1166, ms-task !897, frontend !783

## Next Agent Handoff
- **Immediate objective:** QA de E2 (Presentación en Origen) y E3 (Incidencias), luego completar E4.2–E4.4
- **Cargar según rol:**
  - 🧪 QA E2/E3 → `scope-presentacion-origen/qa/scenarios.md`
  - 🧪 QA E4 → `scope-period-assign/qa/scenarios.md`
  - 🧑‍💻 Dev → scope relevante según bug encontrado
- **E5 ya completo — Cypress E2E disponible en:**
  - Repo: `sche-trmg-e2e-tms-integration`
  - Spec: `cypress/e2e/ms-fleet/api/period-close-replacement.cy.ts`
  - README: `cypress/e2e/ms-fleet/api/README.md`
- **Hard constraints:**
  - No inventar datos — usar IDs reales de UAT
  - Siempre rollback después de cada test de cierre de período
  - Cloud SQL Proxy debe estar en localhost:5432 antes de correr Cypress
