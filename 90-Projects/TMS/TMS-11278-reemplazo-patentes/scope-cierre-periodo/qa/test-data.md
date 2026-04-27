# e5-period-close — Test Data (estado: 2026-04-11, post-rollback)

## Datos activos en UAT

| Dato | Valor | Estado |
|------|-------|--------|
| Fleet | 996 (PruebaFixT) | TRANSFER, FCM/CL, carrier 330 |
| Período | 24682 | fecha 2026-03-26, tiene tarifa ✅ |
| Shipment | 6341 | plate=TRFS01, originalPlate=NULL ← limpio |
| Vehículo original | 10514 (TRFS01) | carrier 330, tipo 64 |
| Vehículo reemplazo | 5707 (ABC555) | carrier 330, tipo 64 |
| plate_replacement_config | eliminada | id=21 borrado en rollback |
| PR existente | 70188 | vehicle=10514, period=24682 (del test E5.1) |

## Setup por escenario

```bash
# E5.1 (ya ejecutado — referencia)
python3 docs/TMS-11278-prueba-cierre-periodo-reemplazo.py e41

# E5.2
python3 docs/TMS-11278-prueba-cierre-periodo-reemplazo.py e42

# E5.3
python3 docs/TMS-11278-prueba-cierre-periodo-reemplazo.py e43
```

## Rollback universal
```bash
python3 docs/TMS-11278-prueba-cierre-periodo-reemplazo.py --rollback
```

## Obtener JWT fresco
```python
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser = p.chromium.connect_over_cdp("http://localhost:9222")
    page = browser.contexts[0].pages[0]
    data = page.evaluate("() => JSON.parse(sessionStorage.getItem('token') || '{}')")
    print(data.get('token', ''))
```

## API Keys UAT
| Servicio | API Key |
|----------|---------|
| ms-fleet | `7FMz79r9zvk95plRSIhaj1UK2HGHixCO` |
| ms-shipment | `PdWYRvcOfLLL4kJ9G7i7oRYInTlsgE87` |
| ms-task | `wQ20NV8XA5TqZYoKRDThzfQbe10gMfQ8` |
