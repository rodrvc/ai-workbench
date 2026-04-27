# e5-period-close — QA Scenarios

## Escenarios
| ID   | Descripción                                                            | Estado              |
| ---- | ---------------------------------------------------------------------- | ------------------- |
| E5.1 | 1 viaje de reemplazo → cierre → PR con vehículo original               | ✅ PASS (2026-04-11) |
| E5.2 | Viajes propios + viaje de reemplazo del mismo vehículo → PRs correctos | ✅ PASS (2026-04-12) |
| E5.3 | Regresión: cierre sin reemplazos → sin cambios                         | ✅ PASS (2026-04-12) |

---

## E5.1 — PASS ✅ (2026-04-11)
- Setup y ejecución: ver [[qa/test-data.md]]
- **Resultado:** PR 70188 con `vehicle_id=10514` (TRFS01, original) ✅
- Flujo: ms-shipment retornó `originalPlate=TRFS01` → swap ABC555→TRFS01 → tarifa TRFS01 → PR correcto

## E5.2 — PASS ✅ (2026-04-12)
- Setup: `python3 docs/TMS-11278-prueba-cierre-periodo-reemplazo.py e42`
- Detalle técnico: ver [[dev/tech-artifacts.md]]

## E5.3 — PASS ✅ (2026-04-12)
- Setup: `python3 docs/TMS-11278-prueba-cierre-periodo-reemplazo.py e43`
- Detalle técnico: ver [[dev/tech-artifacts.md]]

---

## Dead Ends
- Período 24681 (fleet 996, 2026-03-25): sin tarifa → CLOSED_ERROR. No usar.
- Fleet 1001 / AT001: sin tarifa → CLOSED_ERROR. No usar.
- `X-Commerce: SOD` con fleet FCM → response vacío. Siempre usar FCM.
- ms-shipment sin commit `42e86d6a` → `originalPlate` null → swap no ocurre. Ya resuelto (v2.101.1).
