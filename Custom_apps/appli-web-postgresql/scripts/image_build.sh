#!/bin/bash

#Identification des valeurs du fichier INI
    # Lire le fichier de configuration
    CONFIG_FILE="./config.ini"
    # Extraire les valeurs du fichier .ini
    FRONTEND_IMAGE=$(grep -i 'name_image_frontend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    BACKEND_IMAGE=$(grep -i 'name_image_backend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    API_IMAGE=$(grep -i 'name_image_api' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    SWAGGER_IMAGE=$(grep -i 'name_image_swagger' $CONFIG_FILE | awk -F ' = ' '{print $2}')

# Build de l'image frontend
echo "Construction de l'image frontend..."
podman build -t $FRONTEND_IMAGE ../frontend/

# Build de l'image backend
echo "Construction de l'image backend..."
podman build -t $BACKEND_IMAGE ../backend/

# Build de l'image api
echo "Construction de l'image api..."
podman build -t $API_IMAGE ../API/

# Build de l'image swagger
echo "Construction de l'image swagger..."
podman build -t $SWAGGER_IMAGE ../swagger/

echo "Images podman construites."