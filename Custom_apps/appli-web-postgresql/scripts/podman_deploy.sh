#!/bin/bash

#Use of INI file to get value
    #Path of INI file
    CONFIG_FILE="./config.ini"
    #Get all values of INI file
        #System values to use
            NETWORK_NAME=$(grep -i 'network_name' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            STORAGE_NAME=$(grep -i 'storage_name' $CONFIG_FILE | awk -F ' = ' '{print $2}')
        #SGBD values
            DB_NAME=$(grep -i 'db_name' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            DB_USER=$(grep -i 'db_user' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            DB_PASSWORD=$(grep -i 'db_password' $CONFIG_FILE | awk -F ' = ' '{print $2}')
        #Name of image to use
            FRONTEND_IMAGE=$(grep -i 'name_image_frontend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            BACKEND_IMAGE=$(grep -i 'name_image_backend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            API_IMAGE=$(grep -i 'name_image_api' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            PGADMIN_IMAGE=$(grep -i 'name_image_pgadmin' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            SWAGGER_IMAGE=$(grep -i 'name_image_swagger' $CONFIG_FILE | awk -F ' = ' '{print $2}')
        #Name of deployed conteneurs
            FRONTEND=$(grep -i 'name_container_frontend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            BACKEND=$(grep -i 'name_container_backend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            API=$(grep -i 'name_container_api' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            SWAGGER=$(grep -i 'name_container_swagger' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            PGADMIN=$(grep -i 'name_container_pgadmin' $CONFIG_FILE | awk -F ' = ' '{print $2}')
        #Value for PGAdmin deplyment
            PGADMIN_EMAIL=$(grep -i 'pgadmin_email' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            PGADMIN_PASSWORD=$(grep -i 'pgadmin_password' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            PGADMIN_PORT=$(grep -i 'pgadmin_port' $CONFIG_FILE | awk -F ' = ' '{print $2}')
        #Network Port
            FRONTEND_PORT=$(grep -i 'frontend_port' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            API_PORT=$(grep -i 'api_port' $CONFIG_FILE | awk -F ' = ' '{print $2}')
            SWAGGER_PORT=$(grep -i 'swagger_port' $CONFIG_FILE | awk -F ' = ' '{print $2}')

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

sudo podman run -d --name $BACKEND  --network appli-web-postgresql_network \
    --network $NETWORK_NAME \
    -e POSTGRES_DB=$DB_NAME \
    -e POSTGRES_USER=$DB_USER \
    -e POSTGRES_PASSWORD=$DB_PASSWORD \
    -v $STORAGE_NAME:/bitnami/postgresql \
    $BACKEND_IMAGE


sudo podman run -d --name $FRONTEND --network appli-web-postgresql_network \
    --network $NETWORK_NAME \
    -e DB_HOST=$BACKEND \
    -e DB_NAME=$DB_NAME \
    -e DB_USER=$DB_USER \
    -e DB_PASSWORD=$DB_PASSWORD \
    -p $FRONTEND_PORT:5000 \
    $FRONTEND_IMAGE

sudo podman run -d --name $API --network $NETWORK_NAME \
  -p $API_PORT:8000 $API_IMAGE

sudo podman run -d --name $SWAGGER --network $NETWORK_NAME \
  -p $SWAGGER_PORT:5000 $SWAGGER_IMAGE

sudo podman run -d --name $PGADMIN --network $NETWORK_NAME \
    -e 'PGADMIN_DEFAULT_EMAIL='$PGADMIN_EMAIL \
    -e 'PGADMIN_DEFAULT_PASSWORD='$PGADMIN_PASSWORD \
    -e 'PGADMIN_CONFIG_SERVER_MODE=False' \
    -e 'PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION=False' \
    -e 'PGADMIN_DISABLE_POSTGRES_MASTER_PASSWORD=True' \
    -v ../PGAdmin/config.json:/pgadmin4/servers.json \
    -p $PGADMIN_PORT:80 \
    $PGADMIN_IMAGE