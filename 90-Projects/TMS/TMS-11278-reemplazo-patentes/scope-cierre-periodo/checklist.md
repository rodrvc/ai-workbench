# e5-period-close — Checklist

## Dev
- [x] `applyOriginalPlateSwap()` implementado en ms-fleet
- [x] `updateShipmentOriginalPlate()` en ms-shipment — commit `42e86d6a`
- [x] ms-shipment v2.101.1 deployado en UAT
- [x] MRs mergeados a `uat`

## QA
- [x] E5.1: cierre con 1 reemplazo → PR con vehículo original ✅ (2026-04-11)
- [x] E5.2: cierre con viajes propios + reemplazo → PRs correctos ✅ (2026-04-12)
- [x] E5.3: regresión sin reemplazos → sin cambios ✅ (2026-04-12)

## Pre-requisitos QA
- [ ] JWT fresco (Chrome CDP port 9222)
- [ ] Cloud SQL Proxy en localhost:5432
- [ ] Período 24682 en estado limpio (PRs borrados si los hay)
