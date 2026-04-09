# AI Workbench

Repositorio personal para tu sistema agentico de desarrollo, independiente del modelo (Claude, GPT, Gemini, etc.).

Objetivo:
- Mantener configuracion de IA separada de cualquier codigo de negocio.
- Trabajar con Markdown plano para compatibilidad total con Obsidian + git + CLI.
- Ser portable entre proveedores/modelos sin reescribir todo el sistema.
- Estandarizar agentes, skills, workflows, handoffs y mejora continua.

## Como usar

1. Abre esta carpeta como Vault en Obsidian.
2. Usa `MOC - Home.md` como punto de entrada.
3. Crea un `project profile` por cada proyecto real en `90-Projects/`.
4. Ejecuta playbooks desde `06-Playbooks/` para cada HU.
5. Mide aprendizaje y ajustes en `07-Knowledge/`.

## Estructura

- `00-Inbox/` captura rapida
- `01-OS/` politicas globales (seguridad, git, DoD, token budget)
- `02-Agents/` definicion de agentes
- `03-Skills/` skills modulares
- `04-Router/` reglas de enrutamiento
- `05-Templates/` plantillas operativas
- `06-Playbooks/` guias de ejecucion
- `07-Knowledge/` memoria y lecciones
- `90-Projects/` perfiles por proyecto

## Convenciones

- Cada nota debe tener frontmatter YAML.
- Usar enlaces `[[Wiki Links]]` para navegacion.
- Mantener contenido corto y operativo (resumen + enlaces profundos).
- No guardar secretos en texto plano.
- Diseñar prompts y contratos en lenguaje neutral de proveedor.

## Modelo agnostico

Este repositorio usa:

- Plantillas y contratos orientados a tareas (no a features de un solo modelo).
- Frontmatter estandar para que cualquier agente pueda interpretar documentos.
- Ruteo por capacidades (analizar, implementar, validar, reportar), no por marca del modelo.
