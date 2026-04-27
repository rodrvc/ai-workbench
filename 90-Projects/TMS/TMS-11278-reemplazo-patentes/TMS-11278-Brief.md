---
type: brief
status: qa_in_progress
last_verified: 2026-04-10
---

# TMS-11278 — Plate Replacement Brief

## Objetivo
Permitir el reemplazo de patentes en flotas dedicadas TRANSFER cuando un vehículo se daña. El pago se calcula siempre con la tarifa del vehículo **original**.

## Reglas de Negocio
- **Solo TRANSFER**: No aplica a LAST_MILE.
- **Mismo Carrier, Distinta Flota**: El reemplazo debe pertenecer al mismo transportista pero no estar en la misma flota del original.
- **Tarifa Original**: Los viajes del reemplazo se pagan con la tarifa del vehículo que está sustituyendo.
- **Vigencia**: Fechas inicio/fin opcionales (sin fechas = siempre vigente).

## Estado por Microservicio (2026-04-10)
- `ms-task` !897 - mergeado a `uat`.
- `ms-shipment` !1166 - mergeado a `uat`.
- `ms-fleet` !537 - mergeado a `uat`.
- `frontend` !783 - mergeado a `uat`.
- Estado general: **QA en curso en UAT**.

## Foco QA actual
- **Subflujo 1 - Asignación de período**: validar asignación en `DISPATCH_TRUCK` (ms-task).
- **Subflujo 2 - Cierre de período**: validar `period-process` + swap a patente original (ms-fleet).
- Evidencias mínimas DB: `original_vehicle_id` (task) y `shpmnt_original_plate` (shipment).

## Hallazgo funcional clave migrado
- El cierre (`applyOriginalPlateSwap`) no se ejecuta si `shpmnt_original_plate` está `NULL`.
- Fix aplicado: `ms-shipment` persiste `originalPlate` al despachar, resolviendo la placa original desde `originalVehicleId` expuesto por `ms-task`.
