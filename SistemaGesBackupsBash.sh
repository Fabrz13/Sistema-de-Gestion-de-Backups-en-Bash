#!/bin/bash

# Directorios de origen y destino
SOURCE_DIR="/home/fabrizio/Escritorio/ProyectoSO/DirectorioPrueba"
BACKUP_DIR="/home/fabrizio/Escritorio/ProyectoSO/Backups"
LOG_FILE="$BACKUP_DIR/backup.log"
DELETED_BACKUPS_FILE="$BACKUP_DIR/deleted_backups.log"  # Archivo para registrar backups eliminados

# Número máximo de versiones a mantener
MAX_VERSIONS=6

# Función para registrar en el log
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Función para registrar backups eliminados
log_deleted_backup() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup eliminado: $1" >> "$DELETED_BACKUPS_FILE"
}

# Función para crear un nuevo backup
create_backup() {
    timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
    new_backup_dir="$BACKUP_DIR/$timestamp"
    
    mkdir -p "$BACKUP_DIR"
    
    rsync -av --delete "$SOURCE_DIR/" "$new_backup_dir"
    
    if [ $? -eq 0 ]; then
        log "Backup creado exitosamente en $new_backup_dir"
        echo "El backup se ha generado exitosamente."
    else
        log "Error al crear el backup en $new_backup_dir"
        echo "Error al crear el backup."
        return 1
    fi
}

# Función para verificar si hay cambios desde el último backup
check_changes() {
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR")" ]; then
        log "No hay backups previos. Se creará uno nuevo."
        return 0
    fi
    
    latest_backup=$(ls -t "$BACKUP_DIR" | head -n1)
    if [ -z "$latest_backup" ];then
        return 0
    fi
    
    if ! diff -r "$SOURCE_DIR" "$BACKUP_DIR/$latest_backup" > /dev/null 2>&1; then
        log "Se detectaron cambios desde el último backup"
        return 0
    else
        log "No se detectaron cambios desde el último backup"
        return 1
    fi
}

# Función para eliminar versiones antiguas
cleanup_old_versions() {
    versions_count=$(ls -1 "$BACKUP_DIR" | wc -l)
    if [ $versions_count -gt $MAX_VERSIONS ]; then
        # Listar versiones ordenadas por fecha en orden ascendente y seleccionar la más antigua
        oldest_version=$(ls -1t "$BACKUP_DIR" | tail -n1)
        rm -rf "$BACKUP_DIR/$oldest_version"
        log "Versión antigua eliminada: $oldest_version"
    fi
}

# Función para restaurar una versión específica
restore_backup() {
    version="$1"
    if [ ! -d "$BACKUP_DIR/$version" ]; then
        log "Error: La versión $version no existe"
        echo "Error: La versión $version no existe."
        return 1
    fi
    
    rsync -av --delete "$BACKUP_DIR/$version/" "$SOURCE_DIR"
    if [ $? -eq 0 ]; then
        log "Restauración exitosa de la versión $version"
        echo "Se ha restaurado exitosamente el backup $version."
    else
        log "Error al restaurar la versión $version"
        echo "Error al restaurar el backup $version."
        return 1
    fi
}

# Función para eliminar un backup específico
delete_backup() {
    echo "Contenido del directorio Backups:"
    ls -1 "$BACKUP_DIR"
    echo
    while true; do
        echo -n "Escriba el nombre del backup que desea eliminar (formato YYYY-MM-DD_HH-MM-SS): "
        read backup_name
        if [ -d "$BACKUP_DIR/$backup_name" ]; then
            rm -rf "$BACKUP_DIR/$backup_name"
            log "Backup eliminado: $backup_name"
            log_deleted_backup "$backup_name"
            echo "El backup ha sido eliminado"
            echo "Contenido del directorio Backups después de la eliminación:"
            ls -1 "$BACKUP_DIR"
            break
        else
            echo "Nombre erróneo o no existente. Intente otra vez."
        fi
    done
}

# Nueva función para mostrar los backups generados
show_backups() {
    echo "Backups generados:"
    if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR")" ]; then
        ls -1 "$BACKUP_DIR"
    else
        echo "No hay backups generados."
    fi
}

# Nueva función para mostrar los backups eliminados recientemente
show_deleted_backups() {
    echo "Backups eliminados recientemente:"
    if [ -f "$DELETED_BACKUPS_FILE" ]; then
        cat "$DELETED_BACKUPS_FILE"
    else
        echo "No hay registros de backups eliminados recientemente."
    fi
}

# Nueva función para crear un archivo .txt en el directorio de origen
create_file() {
    echo -n "Ingrese un nombre para el archivo: "
    read file_name
    full_path="$SOURCE_DIR/$file_name.txt"
    touch "$full_path"
    
    if [ $? -eq 0 ]; then
        echo "Archivo '$file_name.txt' creado correctamente en $SOURCE_DIR."
    else
        echo "Error al crear el archivo."
    fi
}

# Nueva función para mostrar el contenido del directorio de origen
show_directory_content() {
    echo "Contenido del directorio $SOURCE_DIR:"
    ls -1 "$SOURCE_DIR"
}

# Nueva función para eliminar todo el contenido del directorio de origen
delete_directory_content() {
    rm -rf "$SOURCE_DIR"/*
    echo "Se han borrado todos los archivos."
    echo "Presione Enter para continuar."
    read
}

# Función para mostrar el menú
show_menu() {
    clear
    echo "* Menu *"
    echo "1. Crear archivos para el directorio"
    echo "2. Mostrar contenido del directorio"
    echo "3. Generar backup del directorio"
    echo "4. Mostrar Backups generados"
    echo "5. Eliminar un backup"
    echo "6. Eliminar todo el contenido del directorio"
    echo "7. Restaurar un backup"
    echo "8. Salir"
    echo -n "Seleccione una opción: "
}

# Función principal del menú
main_menu() {
    while true; do
        show_menu
        read option
        case $option in
            1)
                create_file
                echo "Presione Enter para volver al menú principal"
                read
                ;;
            2)
                show_directory_content
                echo "Presione Enter para volver al menú principal"
                read
                ;;
            3)
                if check_changes; then
                    create_backup
                    cleanup_old_versions
                else
                    echo "No se requiere un nuevo backup. No hay cambios desde el último backup."
                fi
                echo "Presione Enter para volver al menú principal"
                read
                ;;
            4)
                show_backups
                echo "Presione Enter para volver al menú principal"
                read
                ;;
            5)
                delete_backup
                show_deleted_backups  # Mostrar backups eliminados recientemente
                echo "Presione Enter para volver al menú principal"
                read
                ;;
            6)
                delete_directory_content
                ;;
            7)
                while true; do
                    show_backups
                    echo -n "Ingrese el nombre del backup a restaurar (formato YYYY-MM-DD_HH-MM-SS): "
                    read backup_name
                    if restore_backup "$backup_name"; then
                        break
                    else
                        echo "El nombre ingresado no existe o es erróneo. Por favor, intente de nuevo."
                    fi
                done
                echo "Presione Enter para volver al menú principal"
                read
                ;;
            8)
                echo "Saliendo del programa..."
                exit 0
                ;;
            *)
                echo "Opción no válida. Por favor, seleccione una opción válida."
                echo "Presione Enter para continuar"
                read
                ;;
        esac
    done
}

# Iniciar el menú principal
main_menu
