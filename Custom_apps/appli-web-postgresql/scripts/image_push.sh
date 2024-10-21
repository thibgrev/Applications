#!/bin/bash

#Identification des valeurs du fichier INI
    # Lire le fichier de configuration
    CONFIG_FILE="./config.ini"
    # Extraire les valeurs du fichier .ini
    FRONTEND_IMAGE=$(grep -i 'name_image_frontend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    BACKEND_IMAGE=$(grep -i 'name_image_backend' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    API_IMAGE=$(grep -i 'name_image_api' $CONFIG_FILE | awk -F ' = ' '{print $2}')
    SWAGGER_IMAGE=$(grep -i 'name_image_swagger' $CONFIG_FILE | awk -F ' = ' '{print $2}')

# Vérifier si l'utilisateur est déjà authentifié sur docker.io
if podman login --get-login docker.io > /dev/null 2>&1; then
    echo "Vous êtes déjà connecté à docker.io."
else
    # Si l'utilisateur n'est pas connecté, demander le mot de passe
    echo "Vous n'êtes pas connecté à docker.io. Veuillez vous connecter."

    # Demander le nom d'utilisateur Docker
    echo -n "Nom d'utilisateur Docker : "
    read DOCKER_USERNAME

    # Demander le mot de passe, sans l'afficher
    echo -n "Mot de passe Docker : "
    stty -echo
    read DOCKER_PASSWORD
    stty echo
    echo

    # Effectuer la connexion
    echo "$DOCKER_PASSWORD" | podman login docker.io --username "$DOCKER_USERNAME" --password-stdin

    # Vérifier si la connexion a réussi
    if [ $? -eq 0 ]; then
        echo "Connexion réussie à docker.io."
    else
        echo "Échec de la connexion à docker.io. Vérifiez vos identifiants."
        exit 1
    fi
fi

# Push des images
echo "Poussée de l'image frontend..."
podman push $FRONTEND_IMAGE

echo "Poussée de l'image backend..."
podman push $BACKEND_IMAGE

echo "Poussée de l'image api..."
podman push $API_IMAGE

echo "Poussée de l'image swagger..."
podman push $SWAGGER_IMAGE

echo "Images poussées sur la registry avec succès."