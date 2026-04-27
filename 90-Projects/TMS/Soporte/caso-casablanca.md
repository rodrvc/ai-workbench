# Caso Casablanca - Flota 481 - Period 23

## Contexto
- **Flota:** FLOTA DEDICADA CASABLANCA IMOLOG (fleet_id=481)
- **Carrier:** Casablanca (carrier_id=28, SOD CL)
- **Periodo:** Period 23 (id=257726), 2026-03-25 → 2026-04-10
- **Problema inicial:** Period 23 no generó solicitudes de pago (dfperd_dttm_update=None)

## Estado al 2026-04-14

### Resuelto ✅
19 de 22 vehículos con PR generada y en PROVISION_OK:

| Patente | PR ID | Monto |
|---------|-------|-------|
| FDJY97 | 23019987 | $2.132.722 |
| FDJY99 | 23020143 | $2.132.722 |
| FDJZ10 | 23019989 | $2.132.722 |
| FPVV89 | 23019994 | $2.132.722 |
| FPVV90 | 23019990 | $2.132.722 |
| GBSB74 | 23019992 | $2.132.722 |
| GBSB75 | 23020136 | $2.132.722 |
| GBSB76 | 23020135 | $2.132.722 |
| GBSB77 | 23020128 | $2.132.722 |
| GZKC67 | 23020140 | $2.132.722 |
| GZKC69 | 23019995 | $2.132.722 |
| GZKC71 | 23019993 | $2.132.722 |
| GZKC73 | 23020137 | $2.132.722 |
| GZKC76 | 23020142 | $2.132.722 |
| GZKJ37 | 23019986 | $2.132.722 |
| GZKJ38 | 23019985 | $2.132.722 |
| GZKJ39 | 23019988 | $2.132.722 |
| GZKJ40 | 23019991 | $2.132.722 |
| JFWC87 | 23020134 | $2.132.722 |

**Total:** $40.521.718

### Pendiente ⚠️ - Escalar a equipo ms-fleet

| Patente | vehicle_id | Situación |
|---------|-----------|-----------|
| GZKC77 | 15808 | Sin PR. Sus viajes van a **facility 69 (HC Paseo Estación)** — hipótesis: facility no configurada en Firebase para prorateo contable SOD-CL Transfer. |
| HHCG85 | 15813 | Sin PR. Sus viajes van a **facility 60 (HC Ñuñoa La Reina)** — hipótesis: facility no configurada en Firebase para prorateo contable SOD-CL Transfer. |

> JN7902 (32762): excluido correctamente, 0 viajes en el periodo.

## Hipótesis principal (no confirmada)
Facilities **60** y **69** no están en la configuración Firebase `erp.sap.SOD-CL.TRANSFER.accountingAccount`. Esto causa que ms-fleet falle silenciosamente el prorateo para esos vehículos (EWD se actualiza a FINALIZED pero no genera payment_request_dedicated_fleet).

Para confirmar: revisar Firebase config `erp.sap.SOD-CL.TRANSFER.accountingAccount` y verificar si incluye facility 60 y 69.

## Lo que se hizo
1. Detectamos que Period 23 no había procesado pagos (dfperd_dttm_update=None)
2. Llamamos `period-process` API manualmente → generó 11/22 PRs
3. Investigamos split 11/11: EWDs idénticos, sin errors en log
4. Reabrimos periodo + habilitamos 10 EWDs faltantes + llamamos period-process → 8 PRs nuevas
5. Eliminamos periodo del shipment 700371 (GZKC77, estado Created) + reintentamos → sin cambio
6. Las 19 PRs en DRAFT (state 14) fueron reprocesadas → PROVISION_OK
7. Se investigó prorateo: GZKC77 y HHCG85 tienen conexiones a facilities 69 y 60 que ningún vehículo con PR usa → hipótesis Firebase config

## API usada
```bash
curl --location 'https://tms-services.falabella.supply/api/v1/ms-transport-fleet/tmgr/transport-fleet/dedicated-fleet-execution/fleet/period-process' \
--header 'X-Country: CL' \
--header 'X-Commerce: SOD' \
--header 'apikey: t6cRgi19O5i8bJxz64tOC7r4hG6ya30S' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <JWT>' \
--data '{"datePeriod": "2026-04-10", "actions": {"openNextPeriod": false, "closePeriod": true}}'
```

## Próximos pasos
- [ ] Verificar Firebase config `erp.sap.SOD-CL.TRANSFER.accountingAccount` para facilities 60 y 69
- [ ] Si no están configuradas: agregar y volver a ejecutar el procedimiento (abrir periodo + habilitar EWDs + period-process)
- [ ] Escalar al equipo ms-fleet si no se puede resolver por configuración
