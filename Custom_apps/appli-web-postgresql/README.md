
# Application Web PostgreSQL

## Présentation du projet
Cette application web est entièrement containerisée et permet d’interagir avec une base de données PostgreSQL. Elle comprend une interface utilisateur (frontend), une API REST pour gérer les données, et une documentation Swagger pour tester et documenter les endpoints.

### Objectif du projet
L'objectif de ce projet est de fournir une application exemple pour la gestion de données, avec une architecture de microservices. Elle sert de démonstration pour tester et expérimenter l’intégration de plusieurs services (API, base de données, frontend).

### Attention : Utilisation en Environnement de Test Seulement
**Cette application est destinée uniquement à des fins de tests et d'apprentissage.** Elle n'est pas conçue pour être utilisée en production, et certaines configurations peuvent ne pas être sécurisées pour un environnement de production.

## Architecture
L’application se compose de quatre principaux composants :
- **Frontend** : Interface utilisateur pour interagir avec les données.
- **Backend** : Gestion de la base de données PostgreSQL.
- **API** : API REST qui expose les endpoints pour manipuler les données.
- **Swagger** : Interface de documentation et de test des endpoints de l'API, facilitant les tests et l'exploration de l'API.

## Arborescence du Projet
```
appli-web-postgresql/
├── API/                   # Composant API avec routes et configuration
│   ├── app.py             # Fichier principal de l'API
│   ├── Dockerfile         # Dockerfile pour construire l'image API
│   ├── nginx.conf         # Configuration Nginx pour l'API
│   └── requirements.txt   # Dépendances Python pour l'API
├── backend/               # Composant backend avec base de données PostgreSQL
│   ├── Dockerfile         # Dockerfile pour construire l'image backend
│   ├── entrypoint.sh      # Script de démarrage pour initialisation
│   └── init_db.sql        # Script SQL pour créer et initialiser la base de données
├── frontend/              # Composant frontend avec l'interface utilisateur
│   ├── app.py             # Fichier principal du frontend
│   ├── Dockerfile         # Dockerfile pour construire l'image frontend
│   └── templates/         # Fichiers HTML pour l'interface utilisateur
├── scripts/               # Scripts pour automatiser le déploiement et la gestion
│   ├── config.ini         # Fichier de configuration principal
│   ├── image_build.sh     # Script pour construire les images Docker
│   ├── image_push.sh      # Script pour pousser les images sur le registre
│   ├── ocp_cleanup.sh     # Script pour nettoyer les ressources OpenShift
│   ├── ocp_deploy.sh      # Script pour déployer sur OpenShift
│   ├── podman_deploy.sh   # Script pour déployer avec Podman
│   └── podman_remove.sh   # Script pour supprimer avec Podman
└── swagger/               # Composant Swagger pour documentation de l'API
    ├── app.py             # Fichier principal de Swagger
    ├── Dockerfile         # Dockerfile pour Swagger
    └── requirements.txt   # Dépendances Python pour Swagger
```

## Démarrage rapide

### Pré-requis
- OpenShift ou un environnement de conteneurisation compatible avec Podman.
- Accès à un registre de conteneurs pour pousser et récupérer les images Docker.

### Étapes de déploiement
1. **Construction des images** : Utilisez le script `image_build.sh` pour construire les images Docker des différents composants.
2. **Push des images** : Utilisez le script `image_push.sh` pour pousser les images vers le registre.
3. **Déploiement sur OpenShift** : Exécutez le script `ocp_deploy.sh` pour déployer l'application sur OpenShift.

## Composants

### API
- **Description** : L'API REST permet d'interagir avec la base de données PostgreSQL. Les routes sont définies dans `app.py` et une configuration Nginx (`nginx.conf`) est incluse pour gérer les requêtes.
- **Documentation Swagger** : Accessible à l’URL `/swagger` une fois déployée. Swagger fournit une interface pour tester les endpoints.
- **Fichiers principaux** : `app.py`, `nginx.conf`, `Dockerfile`.

### Backend
- **Description** : Ce composant gère la base de données PostgreSQL et initialise les données nécessaires.
- **Scripts d'initialisation** : `init_db.sql` contient les instructions SQL pour créer la base et y ajouter des données initiales.
- **Fichiers principaux** : `init_db.sql`, `entrypoint.sh`, `Dockerfile`.

### Frontend
- **Description** : Fournit l'interface utilisateur pour consulter et modifier les données.
- **Fichiers principaux** : `app.py`, `index.html`, `Dockerfile`.
- **Accès** : Une fois déployée, l'interface utilisateur est accessible pour visualiser et gérer les données.

### Swagger
- **Emplacement des fichiers** : `appli-web-postgresql/swagger/`.
- **Fichiers principaux** : `app.py` pour Swagger, `Dockerfile`, `requirements.txt`.
- **URL d'accès** : Accédez à Swagger via `/swagger` pour documenter et tester l'API.

## URLs du Projet
En utilisant `http://localhost` comme base URL :
- **Frontend** : `http://localhost:5000` - Interface utilisateur principale.
- **API** : `http://localhost:8000/api` - Endpoints pour accéder aux données via l'API REST.
- **Swagger** : `http://localhost:8000/swagger` - Documentation interactive de l'API, permettant de tester les endpoints.

## Scripts de déploiement

- **image_build.sh** : Construit les images Docker pour tous les composants. Ce script doit être exécuté depuis le répertoire racine du projet.
- **image_push.sh** : Pousse les images vers le registre de conteneurs configuré dans `config.ini`.
- **ocp_deploy.sh** : Déploie tous les composants sur OpenShift, en utilisant les fichiers de configuration et les images du registre.
- **ocp_cleanup.sh** : Supprime les ressources déployées sur OpenShift pour nettoyer l'environnement.
- **podman_deploy.sh** et **podman_redeploy.sh** : Déploiement et redéploiement avec Podman en local, utile pour les tests hors OpenShift.
- **podman_remove.sh** : Supprime les conteneurs et nettoie l'environnement local Podman.

## Configuration

Le fichier de configuration principal, `config.ini`, contient les paramètres nécessaires pour la connexion à la base de données, les configurations Nginx, et d'autres configurations de l'application.

## Instructions de test

- **Swagger** : Accédez à `/swagger` pour tester les endpoints de l'API.
- **Frontend** : Accédez à l'interface utilisateur pour interagir avec les données.

## Notes de mise à jour

Swagger a été ajouté pour la documentation de l'API, et ce fichier `README.md` est mis à jour pour inclure des instructions sur tous les composants.
