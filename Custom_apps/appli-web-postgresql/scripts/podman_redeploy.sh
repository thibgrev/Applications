#!/bin/bash

#Identification des valeurs du fichier INI
    # Lire le fichier de configuration
    CONFIG_FILE="./config.ini"
    # Extraire les valeurs du fichier .ini
    FRONTEND=$(grep -i 'name_container_frontend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    BACKEND=$(grep -i 'name_container_backend' $CONFIG_FILE | awk -F ' = ' '{print $2}')

echo "Supression des conteneurs"
# Vérifier si le conteneur FRONTEND existe
if sudo podman ps -a --format "{{.Names}}" | grep -w "$FRONTEND" > /dev/null 2>&1; then
    echo "Le conteneur $FRONTEND existe. Suppression en cours..."
    sudo podman rm -f "$FRONTEND"
    echo "Conteneur $FRONTEND supprimé avec succès."
else
    echo "Le conteneur $FRONTEND n'existe pas. Aucune suppression nécessaire."
fi

# Vérifier si le conteneur BACKEND existe
if sudo podman ps -a --format "{{.Names}}" | grep -w "$BACKEND" > /dev/null 2>&1; then
    echo "Le conteneur $BACKEND existe. Suppression en cours..."
    sudo podman rm -f "$BACKEND"
    echo "Conteneur $BACKEND supprimé avec succès."
else
    echo "Le conteneur $BACKEND n'existe pas. Aucune suppression nécessaire."
fi

echo "Appel du script podman_deploy.sh pour deployer l application"
sh ./podman_deploy.sh