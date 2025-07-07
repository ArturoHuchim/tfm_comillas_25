import os

def listar_contenido(directorio, nivel=0):
    for nombre in sorted(os.listdir(directorio)):
        ruta = os.path.join(directorio, nombre)
        print("  " * nivel + nombre)
        if os.path.isdir(ruta):
            listar_contenido(ruta, nivel + 1)

# Reemplaza con la ruta deseada o usa input para hacerlo interactivo
directorio_objetivo = "."
listar_contenido(directorio_objetivo)
