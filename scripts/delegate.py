import os
import sys
import argparse
from typing import List

# Este script emula el llamado a una API de bajo costo (ej: Claude-3-Haiku o GPT-4o-mini)
# Recibe: prompt, archivos, modelo
# Devuelve: el resultado procesado


def delegate_task(model: str, prompt: str, input_file: str):
    """
    Funcion core para delegar una tarea de carpinteria a un modelo barato.
    """
    print(f"--- [ai-workbench] Delegando tarea a {model} ---")
    print(f"Input: {input_file}")
    print(f"Goal: {prompt}")

    # AQUI iria el llamado real a la API usando keys de secrets/
    # (Por ahora emulamos el comportamiento agnostico)

    # 1. Leer input_file
    # 2. Leer prompt de la Skill
    # 3. Request API con baja temperatura
    # 4. Guardar resultado

    print(f"--- [ai-workbench] Tarea completada con {model} (Costo: $0.00x) ---")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Delegate tasks to cheaper models")
    parser.add_argument(
        "--model", default="haiku", help="Model to use (haiku, gpt-4o-mini, flash)"
    )
    parser.add_argument("--skill", help="Skill to apply")
    parser.add_argument("--input", help="Input file to process")

    args = parser.parse_args()
    delegate_task(args.model, args.skill, args.input)
