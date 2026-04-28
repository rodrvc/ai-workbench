# AI Workbench

Repositorio personal para tu sistema agentico de desarrollo, independiente del modelo (Claude, GPT, Gemini, etc.).

Objetivo:
- Mantener configuracion de IA separada de cualquier codigo de negocio.
- Trabajar con Markdown plano para compatibilidad total con Obsidian + git + CLI.
- Ser portable entre proveedores/modelos sin reescribir todo el sistema.
- Estandarizar agentes, skills, workflows, handoffs y mejora continua.

## Como usar

1. Ubicación recomendada dentro de vault personal: `/home/rodvall/Obsidian/Work/AI-Workbench`.
2. Abre esa carpeta como espacio de trabajo en Obsidian.
3. Usa `MOC - Home.md` como punto de entrada.
4. Crea un `project profile` por cada proyecto real en `90-Projects/`.
5. Ejecuta playbooks desde `06-Playbooks/` para cada HU.
6. Mide aprendizaje y ajustes en `07-Knowledge/`.

### Configuracion portable (multi-PC)

Este proyecto soporta rutas configurables via entorno para evitar rutas hardcodeadas.

- `AI_WORKBENCH_ROOT`: ruta del workbench (recomendado `/home/rodvall/Obsidian/Work/AI-Workbench`).
- `AI_OBSIDIAN_VAULT`: ruta del vault de Obsidian (recomendado `/home/rodvall/Obsidian`).

Pasos recomendados:

1. Copiar `.env.example` a `.env.local`.
2. Ejecutar `scripts/bootstrap.sh`.
3. Si faltan rutas, el script las pedira de forma interactiva y guardara `.env.local`.

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
