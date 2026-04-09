---
type: brief
status: active
last_verified: 2026-04-09
---

# TMS-11278 — Plate Replacement Brief

## Objetivo
Permitir el reemplazo de patentes en flotas dedicadas TRANSFER cuando un vehículo se daña. El pago se calcula siempre con la tarifa del vehículo **original**.

## Reglas de Negocio
- **Solo TRANSFER**: No aplica a LAST_MILE.
- **Mismo Carrier, Distinta Flota**: El reemplazo debe pertenecer al mismo transportista pero no estar en la misma flota del original.
- **Tarifa Original**: Los viajes del reemplazo se pagan con la tarifa del vehículo que está sustituyendo.
- **Vigencia**: Fechas inicio/fin opcionales (sin fechas = siempre vigente).

## Estado por Microservicio (2026-04-09)
- `ms-fleet`: feature/tms-11278-uat (v2.60.0) - ✅ MR abierto.
- `ms-task`: feature/tms-11278-uat (v3.175.0) - ⏳ Pendiente CP009.
- `ms-shipment`: feature/tms-11278-uat (v2.98.0) - ✅ OK.
- `frontend`: feature/tms-11278 (v3.54.0) - ✅ MR abierto.

## Escenarios
- **E1**: Mantenedor (Modal Config) - ✅ PASS.
- **E2/E3**: Presentación en Origen / Incidencias - ⏳ Pendiente UAT.
- **E4**: Cierre de periodo - ✅ PASS.
- **CP009**: Confirmación original en despacho - ✅ PASS (C7.3/C7.4).
