# menu-flota - Tech Artifacts

## API Endpoints (ms-fleet)

```
GET  /api/v1/fleets/{fleetId}/replacement-vehicles?originalEquipmentId={id}
POST /api/v1/fleets/{fleetId}/plate-replacement-config
DELETE /api/v1/fleets/{fleetId}/plate-replacement-config/{configId}
```

## SQL Queries

### Check single replacements
```sql
SELECT defleet_id, replacement_vehicle_id, COUNT(*) AS originals
FROM plate_replacement_config
WHERE active = true
GROUP BY defleet_id, replacement_vehicle_id
HAVING COUNT(*) = 1
ORDER BY defleet_id, replacement_vehicle_id;
```

### Deactivate replacement config
```sql
UPDATE plate_replacement_config
SET active = false
WHERE defleet_id = <DF_ID>
  AND replacement_vehicle_id = <RV_ID>
  AND active = true;

-- rollback
UPDATE plate_replacement_config
SET active = true
WHERE defleet_id = <DF_ID>
  AND replacement_vehicle_id = <RV_ID>;
```

## Code Snippets

### Angular: mat-autocomplete con dos controles
```typescript
replacementVehicleControl = new UntypedFormControl(null, Validators.required); // vehicleId
replacementSearchControl = new UntypedFormControl(''); // texto input

onReplacementSelected(event): void { 
  this.replacementVehicleControl.setValue(event.option.value); 
}

displayFn(vehicleId: number): string { 
  // ... return vehicle?.numPlate ?? ''; 
}

// Fix form-error cleared
this.replacementSearchControl.enable({emitEvent: false});
```

### Java: Validación liquid period
```java
String liquidBegPeriod = fleet.getLiquidBegPeriod();
if (liquidBegPeriod != null) {
    LocalDateTime liquidStart = LocalDate.parse(liquidBegPeriod).atStartOfDay();
    if (startDate.isBefore(liquidStart)) {
        throw new BusinessException("...", 
          "La fecha de inicio no puede ser anterior al primer periodo de liquidación de la flota");
    }
}
```

### TypeScript: datesOverlap con null
```typescript
// null en ambos extremos = sin límite = cubre TODO el tiempo
if (!startA && !endA) return true;  // A siempre vigente → siempre solapa
if (!startB && !endB) return true;  // B siempre vigente → siempre solapa
```

## JSON Payloads
[FALTA EJEMPLOS DE REQUEST/RESPONSE]
