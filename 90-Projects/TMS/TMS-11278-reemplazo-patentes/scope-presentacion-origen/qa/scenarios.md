# presentacion-origen - QA Scenarios

## Precondiciones
- Shipment request creado
- Configuración de reemplazo existente
- Vehículo reemplazo asignado

## Escenarios Clave

### EP-Fleet-Status: Consultar estado de flota
1. Crear shipment request con vehículo reemplazo
2. Llamar GET /equipment/fleet-status?shipmentRequestId={id}

**Esperado**: Response incluye:
- Info de flota dedicada
- Vehículo reemplazo identificado
- Datos para presentación en origen

### EP-Replacement-Originals: Ver originales
1. Tener config con vehículo reemplazo que tiene múltiples originales
2. Llamar GET /equipment/replacement-originals?dedicatedFleetId={id}&replacementVehicleId={id}

**Esperado**: Lista de vehículos originales asociados

### EP-Cross-Carrier: Vehículo original en otro carrier
1. Config con vehículo original en carrier diferente al reemplazo
2. Consultar replacement-originals

**Esperado**: [BUG PENDIENTE] Vehículo original no se muestra

## Validación
- API validation tests en `sche-trmg-e2e-tms-integration/`
