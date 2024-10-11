#!/bin/bash

# Créer l'arborescence des répertoires
mkdir -p appli-web-postgresql/scripts
mkdir -p appli-web-postgresql/frontend
mkdir -p appli-web-postgresql/backend

# Créer les fichiers nécessaires
touch appli-web-postgresql/scripts/create_structure.sh
touch appli-web-postgresql/scripts/build_images.sh
touch appli-web-postgresql/scripts/push_images.sh
touch appli-web-postgresql/scripts/deploy_ocp.sh
touch appli-web-postgresql/scripts/cleanup_ocp.sh
touch appli-web-postgresql/scripts/README.md

touch appli-web-postgresql/frontend/Dockerfile
touch appli-web-postgresql/frontend/app.py

touch appli-web-postgresql/backend/Dockerfile
touch appli-web-postgresql/backend/init_db.sql
touch appli-web-postgresql/backend/entrypoint.sh

# Ajouter des permissions d'exécution aux scripts
chmod +x appli-web-postgresql/scripts/*.sh

echo "Arborescence de fichiers créée avec succès."