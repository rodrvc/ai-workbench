# LOGFTC-40829 — Viajes PEP sin proforma (SOD AR)

## Resumen
Proveedor PEP tiene 9 viajes transfer de febrero que no figuran en la proforma pero sí aparecen en monitor de estado.

| Campo | Valor |
|---|---|
| **Ticket** | LOGFTC-40829 |
| **Reportado por** | Laura Woltmann |
| **Asignado** | Rodrigo Valladares |
| **Estado actual** | Pending |
| **País / BU** | Argentina / SOD |
| **Tipo de viaje** | Transfer Normal (sin periodo) |

## Viajes afectados

| shipment_request_id | shpmnt_id | PR ID | Estado PR |
|---|---|---|---|
| 672129 | 653953 | 22824834 | 3 ✅ |
| 673267 | 654992 | 22824838 | 3 ✅ |
| 673803 | 656003 | 22824840 | **16 ❌** |
| 675262 | 656857 | 22824843 | **16 ❌** |
| 687401 | 667784 | 22824848 | 3 ✅ |
| 687402 | 667777 | 22824847 | 3 ✅ |
| 688398 | 668814 | 22584419 | 3 ✅ |
| 688399 | 668819 | 22824852 | **16 ❌** |
| 694561 | 674500 | 22630001 | 3 ✅ |

**3 viajes con error de prorateo (state 16):** 673803, 675262, 688399

## Diagnóstico

Los 3 viajes con state 16 tienen la combinación:
> **WAREHOUSE → SUPPLIER**

Esa combinación **no está configurada** en Firebase para SOD-AR:

- Ruta: `buConfig/accounting_config → erp.sap.SOD-AR.TRANSFER.accountingAccount`
- SOD-CL sí la tiene como "Despacho a Proveedores desde Local"
- SOD-AR solo tiene configuradas 4 combinaciones (falta esta)

## Solución pendiente

Agregar a Firebase `erp.sap.SOD-AR.TRANSFER.accountingAccount`:

```json
{
  "name": "Despacho a Proveedores desde Bodega",
  "filter": "_input['request']['data']['shipments'][0]['connections'].filter((con) => ['WAREHOUSE'].includes(con.originFacility.type) && ['SUPPLIER'].includes(con.destinationFacility.type));",
  "value": "<cuenta_SAP_AR_pendiente_confirmar>"
}
```

**Pendiente:** número de cuenta SAP Argentina para movimiento WAREHOUSE → SUPPLIER. Se solicitó al usuario vía comentario en Jira.

## Próximos pasos
1. Esperar número de cuenta SAP de equipo AR
2. Agregar entrada en Firebase prod
3. Reprocesar los 3 viajes con state 16 (eliminar PR + evento `shipmentRequestFinished`)
4. Verificar que nuevas PRs queden en state 3
5. Cerrar ticket

## Log

| Fecha | Acción |
|---|---|
| 2026-03-06 | Rodrigo deja comentario: pendiente revisión config contable SOD AR |
| 2026-04-14 | Diagnóstico completo: falta combinación WAREHOUSE→SUPPLIER en Firebase |
| 2026-04-14 | Comentario en Jira solicitando cuenta SAP al usuario |
