# presentacion-origen - Dev Log

## Objetivo Técnico
Modificar ms-task para leer configuración de reemplazo y presentar información correcta en origen.

## Decisiones Tomadas
- **Endpoint fleet-status**: Retorna info de flota + vehículo reemplazo
- **Endpoint replacement-originals**: Retorna vehículos originales asociados a un reemplazo

## Archivos Modificados (Blast Radius)
[FALTA LISTADO DE ARCHIVOS]

## Bugs Corregidos
1. Correct carrier ID en shipment requests

## Deuda Técnica
- Issue: vehículo original no se muestra si no está en mismo carrier (pendiente)
