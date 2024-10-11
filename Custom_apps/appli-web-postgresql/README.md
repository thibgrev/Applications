
# Projet Appli-Web-PostgreSQL

Ce projet présente une application web conteneurisée avec un backend PostgreSQL et un frontend web. Il permet de déployer les composants sur OpenShift ou avec Podman en utilisant différents scripts.

## Structure du Projet

L'arborescence du projet est la suivante :

```
appli-web-postgresql/
├── README.md
├── backend/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── init_db.sql
├── frontend/
│   ├── app.py
│   └── Dockerfile
└── scripts/
    ├── config.ini
    ├── image_build.sh
    ├── image_push.sh
    ├── ocp_cleanup.sh
    ├── ocp_deploy.sh
    ├── podman_deploy.sh
    ├── podman_redeploy.sh
    └── podman_remove.sh
```

## Description des Composants

### 1. Backend

Le dossier `backend` contient les fichiers nécessaires pour le déploiement d'un serveur PostgreSQL :
- **Dockerfile** : Définit l'image du serveur PostgreSQL, incluant un script d'initialisation.
- **entrypoint.sh** : Point d'entrée du conteneur PostgreSQL.
- **init_db.sql** : Script SQL pour créer la base de données et les tables initiales.

### 2. Frontend

Le dossier `frontend` contient le code de l'application web :
- **app.py** : Application Flask permettant de se connecter à la base de données PostgreSQL et de gérer les données.
- **Dockerfile** : Définit l'image pour l'application web.

### 3. Scripts

Le dossier `scripts` contient les différents scripts pour automatiser les tâches de déploiement :
- **config.ini** : Fichier de configuration pour les variables d'environnement.
- **image_build.sh** : Script pour construire les images Docker.
- **image_push.sh** : Script pour pousser les images sur le registre Docker Hub.
- **ocp_deploy.sh** : Script de déploiement sur OpenShift.
- **ocp_cleanup.sh** : Script pour nettoyer les ressources sur OpenShift.
- **podman_deploy.sh** : Script pour déployer les conteneurs avec Podman.
- **podman_redeploy.sh** : Script pour redéployer les conteneurs avec Podman.
- **podman_remove.sh** : Script pour supprimer les conteneurs avec Podman.

## Instructions d'Utilisation

### 1. Configuration

Avant de lancer les scripts, assurez-vous que les variables dans `config.ini` sont correctement définies pour votre environnement.

### 2. Construction des Images

Utilisez `image_build.sh` pour construire les images du frontend et du backend :

```bash
./scripts/image_build.sh
```

### 3. Pousser les Images

Poussez les images sur Docker Hub avec `image_push.sh` :

```bash
./scripts/image_push.sh
```

### 4. Déploiement sur OpenShift

Déployez l'application sur OpenShift avec `ocp_deploy.sh` :

```bash
./scripts/ocp_deploy.sh
```

Pour nettoyer les ressources, utilisez :

```bash
./scripts/ocp_cleanup.sh
```

### 5. Déploiement avec Podman

Pour déployer les conteneurs avec Podman, utilisez `podman_deploy.sh` :

```bash
./scripts/podman_deploy.sh
```

Pour redéployer ou supprimer les conteneurs, utilisez `podman_redeploy.sh` ou `podman_remove.sh` respectivement.

## Remarques

- Les scripts sont conçus pour être exécutés dans un environnement Unix/Linux.
- Veillez à avoir les outils nécessaires installés : `Podman`, `oc`, `Docker`, etc.
- Les configurations de sécurité et les identifiants doivent être correctement gérés pour éviter toute fuite d'information.

## Auteur

Ce projet a été réalisé pour démontrer le déploiement d'applications web conteneurisées avec PostgreSQL et Flask.
