# HU: Agente Soporte Proforma SAP

**Proyecto**: TMS-support  
**Objetivo**: Documentar el flujo de proformas atascadas en estado PENDING (state=8) en el sistema TMS de Falabella, para construir un agente que pueda diagnosticar y resolver estos casos automáticamente.

---

## Resumen del Problema

Las proformas son agrupaciones de `payment_request_shipment` que se envían a SAP para pago.

**Estado 8 (PENDING)** significa que el carrier ya asoció una factura y está esperando confirmación.

**Problema detectado**: 7 proformas llevan 2+ horas en este estado sin avanzar.

---

## Contexto Técnico

| Aspecto | Detalles |
|--------|----------|
| **Stack** | ms-shipment (Java/Spring Boot), ms-payment (Java/Spring Boot) |
| **BD Principal** | PostgreSQL — TMS Shipment (`SCHE_TRMG_SHIPMENT`) |
| **Eventos** | Pub/Sub — `PROFORMA_INVOICE_ATTACH_REQUESTED` |
| **Enum Estado** | `ProformaStatusEnums` — state=8 es PENDING |

---

## Lo que sabemos hasta ahora

### Flujo de Cambio de Estado
1. Proforma se crea en estado anterior (inicialmente)
2. Carrier asocia una factura → método `saveInvoiceProforma` en `ProformaServiceImpl`
3. Ese método cambia el estado a **PENDING (8)**
4. Se envía evento Pub/Sub tipo `PROFORMA_INVOICE_ATTACH_REQUESTED`
5. El siguiente paso depende de que **ms-payment** procese ese evento

### Preguntas Abiertas
- [ ] ¿Qué es exactamente lo que ms-payment debe hacer al recibir el evento?
- [ ] ¿Dónde está el listener del evento en ms-payment?
- [ ] ¿Hay un timeout después del cual se considera "atascado"?
- [ ] ¿Qué causa que el evento no sea procesado (dead-letter, retry exhausted, etc.)?
- [ ] ¿Cuáles son los estados posteriores a PENDING (8)?

---

## Estado Actual

> Última sesión: 2026-04-16 — Rol: Dev (en curso)

### Fases
| Fase | Estado |
|------|--------|
| Diagnóstico de causa raíz | ⬜ pendiente |
| Queries de diagnóstico en BD | ⬜ pendiente |
| Endpoints de reparación | ⬜ pendiente |
| Documentación de flujo | ⬜ pendiente |

### Pendientes (próxima sesión)
1. Localizar código fuente de `saveInvoiceProforma` — verificar donde exactamente se envía el evento
2. Buscar listeners de `PROFORMA_INVOICE_ATTACH_REQUESTED` en ms-payment
3. Queries en TMS Shipment para:
   - Contar proformas en state=8
   - Rango de tiempo en que entraron a estado 8
   - Detalles de PRs asociadas (payment_request_shipment)
4. Revisar logs de Pub/Sub — ¿el evento se envió? ¿fue entregado? ¿fue procesado?
5. Crear queries/endpoints de reparación manual si el evento no se procesa

---

## Arquitectura de Bases de Datos

**BD TMS Shipment** (`SCHE_TRMG_SHIPMENT`)
- Tabla `proforma` — estados de proformas
- Tabla `payment_request_shipment` — PRs que agrupa la proforma
- Tabla `payment_request_ref` — ref cruzada a payment_request_shipment

---

## Elementos Técnicos
> Se rellenan conforme se descubren queries, endpoints, CURLs, decisiones

- [ ] Enum `ProformaStatusEnums` — definición de estados
- [ ] Clase `ProformaServiceImpl.saveInvoiceProforma()` — método que cambia a PENDING
- [ ] Listener Pub/Sub en ms-payment para `PROFORMA_INVOICE_ATTACH_REQUESTED`
- [ ] Query: "SELECT COUNT(*) FROM proforma WHERE prf_status_id = 8"
- [ ] Endpoint: GET `/api/v1/ms-shipment/proforma/{id}` — detalles de proforma
- [ ] Endpoint: GET `/api/v1/ms-shipment/proforma/{id}/payment-requests` — PRs asociadas

---

## Dead Ends
> Enumeramos enfoques que ya fueron descartados (para no repetir)

- (ninguno aún)

---

## MRs / PRs
> Si se crean cambios de código

- (ninguno aún)

---

## Referencias
- Proyecto hermano: `reprocess-shipment-tms` — patrón de diagnostico similar
- CLAUDE.md del TMS: vea `[TMS Falabella - Ecosistema Completo]`
