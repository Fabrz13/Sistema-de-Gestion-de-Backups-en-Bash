# Script de Gestión de Backups y Archivos en Bash

## Descripción

**Proyecto Creado Por:** Ing. Fabrizio Castro

Este proyecto es un **script en Bash** que facilita la gestión de archivos y backups en un sistema Linux. El script permite crear archivos, generar backups automáticos, eliminar contenido y restaurar versiones anteriores mediante un menú interactivo. Además, mantiene registros detallados de todas las actividades realizadas.

---

## Configuración Inicial

### Ajuste de Rutas
Antes de ejecutar el script, asegúrate de configurar las rutas del directorio de origen y del directorio de backups en el archivo:
```bash
SOURCE_DIR="/ruta/a/tu/directorio/de/origen"
BACKUP_DIR="/ruta/a/tu/directorio/de/backups"
```

## Parámetros del Script
* El script **no acepta parámetros de línea de comandos**.
* Todas las opciones se seleccionan desde un **menú interactivo** que se presenta al ejecutar el script.

## Funcionalidades

### 1. Crear archivos para el directorio
* Permite crear un archivo `.txt` en el **directorio de origen**.
* El usuario proporciona el nombre del archivo a través del menú.

### 2. Mostrar contenido del directorio
* Muestra una lista de todos los archivos y subdirectorios en el **directorio de origen**.

### 3. Generar backup del directorio
* Crea un **backup** del directorio de origen en el **directorio de backups**.
* **Optimización:** Solo se genera un nuevo backup si se detectan cambios desde el último backup.
* **Límite de versiones:** El script mantiene hasta **6 versiones** de backups. Si se supera este número, la versión más antigua se elimina automáticamente.

### 4. Mostrar backups generados
* Lista todos los backups disponibles en el **directorio de backups**.

### 5. Eliminar un backup
* Permite eliminar un backup específico del **directorio de backups**.
* El nombre del backup debe ingresarse en formato `YYYY-MM-DD_HH-MM-SS`.
* El backup eliminado se registra en un archivo de logs.

### 6. Eliminar todo el contenido del directorio
* Elimina todos los archivos del **directorio de origen**.
* Muestra un mensaje de confirmación y espera a que el usuario presione **Enter** para continuar.

### 7. Restaurar un backup
* Restaura una versión específica del backup en el **directorio de origen**.
* El usuario debe proporcionar el nombre del backup en el formato `YYYY-MM-DD_HH-MM-SS`.

### 8. Salir
* Sale del programa.

## Ejemplo de Ejecución

### Ejecutar el script
Para iniciar el menú interactivo, ejecuta el script en la terminal:

```bash
./script.sh
```

### Crear un nuevo archivo
1. Selecciona la opción `1` en el menú.
2. Ingresa el nombre del archivo que deseas crear.

### Generar un backup
1. Selecciona la opción `3`.
2. El script verificará si hay cambios en el **directorio de origen**.
3. Si se detectan cambios, se generará un nuevo backup en el **directorio de backups**.

### Restaurar un backup
1. Selecciona la opción `7`.
2. Ingresa el nombre del backup a restaurar (formato: `YYYY-MM-DD_HH-MM-SS`).

### Eliminar todos los archivos del directorio de origen
1. Selecciona la opción `6`.
2. El script eliminará todos los archivos y mostrará un mensaje de confirmación.

## Logs Generados
El script registra todas las operaciones importantes en dos archivos de log ubicados en el **directorio de backups**:

1. `backup.log`:
   * Registra las actividades de creación y restauración de backups.
2. `deleted_backups.log`:
   * Registra los backups eliminados manualmente.

## Notas
* El script **evita la creación de backups innecesarios** al verificar si hay cambios en el directorio de origen.
* Asegúrate de tener **permisos adecuados** para los directorios especificados (`SOURCE_DIR` y `BACKUP_DIR`) para evitar errores durante la ejecución.
* Es recomendable ejecutar el script con permisos suficientes si trabajas en directorios restringidos.

## Requisitos
* **Sistema Operativo:** Linux con Bash.
* **Dependencias:** `rsync` (para la sincronización de archivos).
