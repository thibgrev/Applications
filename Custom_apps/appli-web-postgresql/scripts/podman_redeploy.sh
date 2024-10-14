#!/bin/bash

#Identification des valeurs du fichier INI
    # Lire le fichier de configuration
    CONFIG_FILE="./config.ini"
    # Extraire les valeurs du fichier .ini
    FRONTEND=$(grep -i 'name_container_frontend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    BACKEND=$(grep -i 'name_container_backend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    API=$(grep -i 'name_container_api' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    SWAGGER=$(grep -i 'name_container_swagger' $CONFIG_FILE | awk -F ' = ' '{print $2}')

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

# Vérifier si le conteneur API existe
if sudo podman ps -a --format "{{.Names}}" | grep -w "$API" > /dev/null 2>&1; then
    echo "Le conteneur $API existe. Suppression en cours..."
    sudo podman rm -f "$API"
    echo "Conteneur $API supprimé avec succès."
else
    echo "Le conteneur $API n'existe pas. Aucune suppression nécessaire."
fi

# Vérifier si le conteneur SWAGGER existe
if sudo podman ps -a --format "{{.Names}}" | grep -w "$SWAGGER" > /dev/null 2>&1; then
    echo "Le conteneur $SWAGGER existe. Suppression en cours..."
    sudo podman rm -f "$SWAGGER"
    echo "Conteneur $SWAGGER supprimé avec succès."
else
    echo "Le conteneur $SWAGGER n'existe pas. Aucune suppression nécessaire."
fi

echo "Appel du script podman_deploy.sh pour deployer l application"
sh ./podman_deploy.sh