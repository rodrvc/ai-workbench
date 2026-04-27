---
type: hu
status: pendiente
date: 2026-04-16
---

# ROD-002: Dictado por Voz con Whisper en Fedora

## Identificacion
- Ticket: ROD-002
- Tipo: Setup / Productividad personal
- Prioridad: Media

## Objetivo

Configurar un shortcut de teclado global en Fedora que active el microfono, grabe el audio, lo transcriba con Whisper (modelo local) y escriba el texto donde este posicionado el cursor — funciona en cualquier app.

## Criterios de aceptacion
- [ ] Presionar shortcut activa la grabacion
- [ ] Soltar shortcut (o segundo press) detiene la grabacion
- [ ] El texto transcripto aparece en el campo activo donde esta el cursor
- [ ] Funciona en terminal, browser y editor de codigo
- [ ] Transcripcion en espanol con buena precision

## Alcance
- In: Script de dictado, shortcut GNOME, modelo Whisper local
- Out: Integracion con apps especificas, nube, OpenAI API

## Riesgos
- Wayland vs X11: `ydotool` en Wayland requiere permisos extra (`uinput` group)
- Primera carga del modelo Whisper puede tardar (descarga ~500MB)
- Latencia segun modelo elegido (`tiny` = rapido, `medium` = preciso)

## Stack Tecnico
- STT: Whisper local (`small` o `medium` para espanol)
- Typing: `xdotool` (X11) o `ydotool` (Wayland)
- Grabacion: `sox` o `arecord`
- Shortcut: GNOME Settings > Keyboard > Custom Shortcuts

## Servicios/Modulos implicados
- `~/bin/whisper-dictate.sh` (script a crear)
- GNOME Keyboard Shortcuts
