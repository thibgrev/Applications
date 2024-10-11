#!/bin/bash

#Identification des valeurs du fichier INI
    # Lire le fichier de configuration
    CONFIG_FILE="./config.ini"
    # Extraire les valeurs du fichier .ini
    NETWORK_NAME=$(grep -i 'network_name' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    STORAGE_NAME=$(grep -i 'storage_name' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    DB_NAME=$(grep -i 'db_name' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    DB_USER=$(grep -i 'db_user' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    DB_PASSWORD=$(grep -i 'db_password' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    FRONTEND=$(grep -i 'name_container_frontend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    BACKEND=$(grep -i 'name_container_backend' $CONFIG_FILE | awk -F ' = ' '{print $2}')

# Vérifier si le réseau existe
if sudo podman network inspect "$NETWORK_NAME" > /dev/null 2>&1; then
    echo "Le réseau $NETWORK_NAME existe déjà."
else
    # Créer le réseau s'il n'existe pas
    echo "Le réseau $NETWORK_NAME n'existe pas. Création en cours..."
    sudo podman network create "$NETWORK_NAME"
    echo "Réseau $NETWORK_NAME créé avec succès."
fi

if sudo podman volume inspect "$STORAGE_NAME" > /dev/null 2>&1; then
    echo "Le volume $STORAGE_NAME existe déjà."
else
    # Créer le volume s'il n'existe pas
    echo "Le volume $STORAGE_NAME n'existe pas. Création en cours..."
    sudo podman volume create "$STORAGE_NAME"
    echo "Volume $STORAGE_NAME créé avec succès."
fi

# Chemin du fichier de configuration CNI
CNI_CONFIG_FILE="/etc/cni/net.d/$NETWORK_NAME.conflist"

# Vérifier si le fichier existe
if [ -f "$CNI_CONFIG_FILE" ]; then
    # Modifier la version CNI à "0.4.0"
    sudo sed -i 's/"cniVersion": ".*"/"cniVersion": "0.4.0"/' "$CNI_CONFIG_FILE"
    echo "La version CNI a été modifiée à 0.4.0 dans $CNI_CONFIG_FILE."
else
    echo "Le fichier de configuration $CNI_CONFIG_FILE n'existe pas. Assurez-vous que le réseau est créé."
fi

sudo podman run -d --name $BACKEND \
    --network $NETWORK_NAME \
    -e POSTGRES_DB=$DB_NAME \
    -e POSTGRES_USER=$DB_USER \
    -e POSTGRES_PASSWORD=$DB_PASSWORD \
    -v $STORAGE_NAME:/bitnami/postgresql \
    docker.io/thibgrev/backend-postgresql:latest


sudo podman run -d --name $FRONTEND \
    --network $NETWORK_NAME \
    -e DB_HOST=$BACKEND \
    -e DB_NAME=$DB_NAME \
    -e DB_USER=$DB_USER \
    -e DB_PASSWORD=$DB_PASSWORD \
    -p 5000:5000 \
    docker.io/thibgrev/frontend-web:latest
