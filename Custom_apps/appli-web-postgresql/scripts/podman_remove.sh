#!/bin/bash

#Identification des valeurs du fichier INI
    # Lire le fichier de configuration
    CONFIG_FILE="./config.ini"
    # Extraire les valeurs du fichier .ini
    NETWORK_NAME=$(grep -i 'network_name' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    STORAGE_NAME=$(grep -i 'storage_name' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    FRONTEND=$(grep -i 'name_container_frontend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    BACKEND=$(grep -i 'name_container_backend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    API=$(grep -i 'name_container_api' $CONFIG_FILE | awk -F ' = ' '{print $2}')

# Utiliser les valeurs dans les commandes Podman
sudo podman rm -f $FRONTEND
sudo podman rm -f $API
sudo podman rm -f $BACKEND
sudo podman network rm "$NETWORK_NAME"
sudo podman volume rm "$STORAGE_NAME"