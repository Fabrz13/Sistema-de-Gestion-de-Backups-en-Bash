Proyecto Creado Por Ing. Fabrizio Castro

# Script de Backup y Restauración en Bash

Este script en Bash automatiza el proceso de respaldo y restauración de archivos y directorios en un sistema Linux.
Se encarga de realizar backups, gestionar versiones, registrar logs, eliminar backups y restaurar versiones específicas.

## Requisitos

- Sistema operativo Linux.
- Permisos de ejecución en el script.
- Herramienta rsync instalada.

## Configuración

Asegúrate de ajustar las rutas del directorio de origen (SOURCE_DIR) y el directorio de backup (BACKUP_DIR)
en el script antes de ejecutarlo:

SOURCE_DIR="/ruta/a/tu/directorio/de/origen"
BACKUP_DIR="/ruta/a/tu/directorio/de/backups"

Parámetros del Script
El script no acepta parámetros de línea de comandos.
Todas las opciones se seleccionan desde un menú interactivo que se presenta al ejecutar el script.

Funcionalidades
1. Crear archivos para el directorio
Crea un archivo .txt en el directorio de origen especificado.

2. Mostrar contenido del directorio
Muestra una lista de los archivos y directorios en el directorio de origen.

3. Generar backup del directorio
Crea un backup del directorio de origen en el directorio de backups.
Solo se genera un nuevo backup si hay cambios desde el último backup.
El script mantiene hasta 6 versiones de backups.
Si se supera este número, la versión más antigua se elimina automáticamente.

4. Mostrar Backups generados
Lista todos los backups generados en el directorio de backups.

5. Eliminar un backup
Elimina un backup específico del directorio de backups. El backup eliminado se registra en un archivo de logs.

6. Eliminar todo el contenido del directorio
Elimina todos los archivos en el directorio de origen. Después de la eliminación,
se muestra un mensaje de confirmación y se espera que el usuario presione Enter para continuar.

7. Restaurar un backup
Permite restaurar una versión específica del backup en el directorio de origen.
Se solicita al usuario que ingrese el nombre del backup en el formato YYYY-MM-DD_HH-MM-SS.

8. Salir
Sale del programa.

Ejemplos de Ejecución
Ejecutar el script: ./script.sh

Crear un nuevo archivo:

Selecciona la opción 1 en el menú.
Ingresa el nombre del archivo que deseas crear.
Generar un backup:

Selecciona la opción 3. El script verificará si hay cambios en el directorio de origen y, de ser así,
generará un nuevo backup.

Restaurar un backup:

Selecciona la opción 7.
Introduce el nombre del backup a restaurar en el formato YYYY-MM-DD_HH-MM-SS.
Eliminar todos los archivos del directorio de origen:

Selecciona la opción 6. Se eliminarán todos los archivos del directorio de origen.
Logs
El script genera dos archivos de logs:

backup.log: Registra las actividades de backup y restauración.
deleted_backups.log: Registra los backups eliminados.

Notas:
El script asegura que no se realicen backups innecesarios si no hay cambios en el directorio de origen.
Asegúrate de tener permisos adecuados en los directorios especificados para evitar errores durante la ejecución.
