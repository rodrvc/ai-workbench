# LOGFTC-43077 — Viajes UM FCM-CL

**Ticket**: https://jira.falabella.tech/browse/LOGFTC-43077
**Fecha inicio**: 2026-04-15
**Estado**: En investigación 🔴
**Reporter**: Nicol Patricia Morales Castillo

## Viajes solicitados

| reference_id | Acción solicitada | Estado |
|---|---|---|
| 14210040 | Corregir origen lof1 (9006) + Asignar periodo + Reprocesar FD | En progreso |
| 14213593 | Corregir origen lof1 (9006) + Asignar periodo + Reprocesar FD | Pendiente |
| 14213605 | Corregir origen lof1 (9006) + Asignar periodo + Reprocesar FD | Pendiente |
| 14199110 | Reprocesar por FD | Pendiente |
| 14212161 | Reprocesar por FD | Pendiente |

## Estado actual — viaje de prueba 14210040

### ✅ Lo que se hizo
1. **Origen corregido** en BD:
   - `shipment_delivery.connection_origin_code = '9006'` (era `'2000'`)
   - `transport_order_delivery.origin_node_id = '9006'` (94 TOs, era `'2000'`)
2. **Periodo asignado**: `dfperd_id = 262966` (via script --repair --reprocess)
3. **PR generada**: `prdf_id = 405100`, `pr_ref_id = 23029205`
4. **`delivery_consolidated_id` limpiado** en 94 TOs (era no null)
5. **reprocess-status-to ejecutado** → TMS respondió 200 para todos los TOs

### ❌ Problema persistente
- PR quedó en **state 16 (PRORATE_ACCOUNTING_ERROR)**
- `size = NULL` en los 94 TOs (después del reprocess-status-to sigue null)
- `rate_value = NULL` en los 94 TOs

## Investigación state 16

### Datos del viaje
- `cd_logistic_operator = FCM`
- `shipment_id = 1465083`
- `carrier_id = 315`
- `dispatch_date = 2026-04-06`
- TOs: `origin_type_reference = SOC_CLIENTE`, `type = DELIVERY`, destination = `ADDRESS`

### Firebase — buConfig/accounting_config → erp.sap.FCM-CL.LAST_MILE
- 10 filtros disponibles
- **Filtro 6 "Viajes CD Tienda"** (cuenta `7012010021`) debería matchear:
  - `DELIVERY` ✅
  - `originFacility.type` IN `['WAREHOUSE', 'CARRIER_WAREHOUSE_RM']` ✅ (lof1 = WAREHOUSE)
  - `destination.type = 'ADDRESS'` ✅
  - `originTypeReference` NOT IN `[PICK, F21, F22, RLO, F3]` ✅ (SOC_CLIENTE no está excluido)

### Facility lof1 (origin 9006)
- Task DB: `fclity_id = 305`, `fclity_desc_name = "CD Lof1"`, `cd_key = WAREHOUSE` (tipo 301)
- Shipment DB: `fclity_id = 305`, `extra_configuration = "RATE_DESTINATION_ATOMICITY_THEN_LOWER"`

### Hipótesis activa
**ms-accounting falla porque `size = NULL`** en los TOs. El servicio no puede calcular el prorateo sin dimensiones/tamaño. Los TOs SÍ tienen `weight` y `volume` (>0), y los items tienen `height`, `length`, `width` (>0), pero `size` es NULL en todos.

El `rate_value` también es NULL → posiblemente `size` y `rate_value` se generan juntos desde la API de rates antes del reproceso.

## Pendiente / Próximos pasos

1. **Entender por qué `size` y `rate_value` no se generaron** con el reprocess-status-to
   - ¿Necesita pasar por la API de rates primero?
   - ¿El `size` viene de otro proceso?
2. **Una vez con size y rate_value**: eliminar PR state 16 + llamar API reprocess
3. **Si funciona 14210040**: repetir para 14213593 y 14213605 (también necesitan corrección de origen)
4. **14199110 y 14212161**: solo necesitan `--repair --reprocess` (sin corrección de origen)

## Queries útiles

```sql
-- TMS DB: estado actual del viaje
SELECT reference_id, shipment_id, connection_origin_code, dfperd_id, carrier_id, dispatch_date
FROM shipment_delivery WHERE reference_id = '14210040';

-- TMS DB: PR estado
SELECT prdf.id AS prdf_id, prdf.period_id, prdf.vehicle_id, prr.id AS pr_ref_id, prr.state_id, ps.prsts_name
FROM shipment_delivery sd
JOIN equipment_delivery ed ON ed.shipment_id = sd.shipment_id
JOIN view_vehicle vv ON vv.id = ed.vehicle_id
JOIN payment_request_dedicated_fleet prdf ON prdf.vehicle_id = vv.id AND prdf.period_id = sd.dfperd_id
JOIN payment_request_ref prr ON prdf.payment_request_id = prr.id
JOIN paymentrequest_state ps ON prr.state_id = ps.prsts_id
WHERE sd.reference_id = '14210040';

-- TMS DB: size y rate_value en TOs
SELECT COUNT(*), COUNT(size), COUNT(rate_value), COUNT(delivery_consolidated_id)
FROM transport_order_delivery tod
JOIN shipment_delivery sd ON sd.shipment_id = tod.shipment_id
WHERE sd.reference_id = '14210040';
```

## PR a eliminar (cuando se resuelva size)

Procedimiento desde [[procedures/prorateo-state-16-um-flota]]:
1. EWD → state 5 (Fleet DB)
2. DELETE prorate_cost_ref → payment_request_dedicated_fleet → payment_request_ref
3. API reprocess LAST_MILE
4. Verificar nueva PR
5. EWD → state 3

PR actual a eliminar:
- `prdf_id = 405100`
- `pr_ref_id = 23029205`
- `period_id = 262966`
- `vehicle_id = 34911`

## Log de sesión

| Fecha | Acción |
|---|---|
| 2026-04-15 | Corrección origen 9006, asignación periodo, PR generada en state 16 |
| 2026-04-15 | Investigación Firebase: filtro 6 debería matchear pero falla |
| 2026-04-15 | size=NULL identificado como causa probable |
| 2026-04-15 | delivery_consolidated_id limpiado, reprocess-status-to ejecutado, size sigue NULL |
