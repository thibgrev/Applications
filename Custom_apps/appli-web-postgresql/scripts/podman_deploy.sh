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

#Test of network existing
    if sudo podman network inspect "$NETWORK_NAME" > /dev/null 2>&1; then
        echo "Network $NETWORK_NAME exist."
    else
        #Network creation because it doesn t exist
        echo "Network $NETWORK_NAME doesn t exist. Creation in progress"
        sudo podman network create "$NETWORK_NAME"
        echo "Network $NETWORK_NAME created"
    fi

#Test of volume existing
    if sudo podman volume inspect "$STORAGE_NAME" > /dev/null 2>&1; then
        echo "Volume $STORAGE_NAME exist"
    else
        #Volume creation because it doesn t exist
        echo "Volume $STORAGE_NAME doesn t exist. Creation in progress"
        sudo podman volume create "$STORAGE_NAME"
        echo "Volume $STORAGE_NAME created"
    fi

#CNI Conf file path
    CNI_CONFIG_FILE="/etc/cni/net.d/$NETWORK_NAME.conflist"

#Test if file exist
    if [ -f "$CNI_CONFIG_FILE" ]; then
        #Modification from version CNI to "0.4.0"
        sudo sed -i 's/"cniVersion": ".*"/"cniVersion": "0.4.0"/' "$CNI_CONFIG_FILE"
        echo "CNI vers modified to 0.4.0 in $CNI_CONFIG_FILE."
    else
        echo "$CNI_CONFIG_FILE doesn t exist. Be sure network is created"
    fi

#Deployement of conteneur PostGreSQL
    sudo podman run -d --name $BACKEND  --network appli-web-postgresql_network \
        --network $NETWORK_NAME \
        -e POSTGRES_DB=$DB_NAME \
        -e POSTGRES_USER=$DB_USER \
        -e POSTGRES_PASSWORD=$DB_PASSWORD \
        -v $STORAGE_NAME:/bitnami/postgresql \
        $BACKEND_IMAGE

#Deployement of conteneur Frontend
    sudo podman run -d --name $FRONTEND --network appli-web-postgresql_network \
        --network $NETWORK_NAME \
        -e DB_HOST=$BACKEND \
        -e DB_NAME=$DB_NAME \
        -e DB_USER=$DB_USER \
        -e DB_PASSWORD=$DB_PASSWORD \
        -p $FRONTEND_PORT:5000 \
        $FRONTEND_IMAGE
#Deployement of conteneur API
    sudo podman run -d --name $API --network $NETWORK_NAME \
    -p $API_PORT:8000 $API_IMAGE

#Deployement of conteneur Swagger
    sudo podman run -d --name $SWAGGER --network $NETWORK_NAME \
    -p $SWAGGER_PORT:5000 $SWAGGER_IMAGE

#Deployement of conteneur PGAdmin
    sudo podman run -d --name $PGADMIN --network $NETWORK_NAME \
        -e 'PGADMIN_DEFAULT_EMAIL='$PGADMIN_EMAIL \
        -e 'PGADMIN_DEFAULT_PASSWORD='$PGADMIN_PASSWORD \
        -e 'PGADMIN_CONFIG_SERVER_MODE=False' \
        -e 'PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION=False' \
        -e 'PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED=False' \
        -v ../PGAdmin/config.json:/pgadmin4/servers.json \
        -p $PGADMIN_PORT:80 \
        $PGADMIN_IMAGE

# Attendre que pgAdmin soit prêt
sleep 10

# Copier le script de configuration dans le conteneur pgAdmin
sudo podman cp ../PGAdmin/setup_pgadmin.py $PGADMIN:/pgadmin4/setup_pgadmin.py

# Exécuter le script de configuration de pgAdmin
sudo podman exec -it $PGADMIN python /pgadmin4/setup_pgadmin.py