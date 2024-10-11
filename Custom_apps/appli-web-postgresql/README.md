
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

Le dossier `scripts` contient les différents scripts pour automatiser les tâches de déploiement.

#### Description des scripts

- **config.ini** : Fichier de configuration pour les variables d'environnement nécessaires aux scripts (par exemple, noms de réseau, volume, etc.).

- **image_build.sh** : 
  - Ce script permet de construire les images Docker pour le frontend et le backend. Il utilise les fichiers Dockerfile situés dans les répertoires correspondants pour créer les images.
  - Commande : `podman build` ou `docker build` pour créer les images.

- **image_push.sh** :
  - Ce script pousse les images Docker construites vers un registre Docker, tel que Docker Hub. Il vérifie si l'utilisateur est déjà authentifié, sinon il demande les identifiants.
  - Commande : `podman push` ou `docker push` pour pousser les images vers le registre.

- **ocp_deploy.sh** :
  - Permet de déployer les composants de l'application sur un cluster OpenShift. Le script crée les ressources nécessaires (namespace, déploiements, services, routes, etc.) pour le backend PostgreSQL et le frontend.
  - Commandes utilisées : `oc create`, `oc apply`, etc., pour déployer les ressources sur OpenShift.

- **ocp_cleanup.sh** :
  - Ce script supprime les ressources créées sur OpenShift pour nettoyer le déploiement. Il supprime le namespace utilisé, ainsi que les objets associés (pods, services, routes, etc.).
  - Commande : `oc delete` pour supprimer les ressources sur OpenShift.

- **podman_deploy.sh** :
  - Déploie les conteneurs en utilisant Podman en mode rootless ou root. Il crée les réseaux et volumes nécessaires, puis lance les conteneurs du frontend et du backend en utilisant les images Docker.
  - Commande : `podman run`, `podman network create`, `podman volume create`.

- **podman_redeploy.sh** :
  - Redéploie les conteneurs en les arrêtant et les supprimant, puis en les relançant avec les nouvelles configurations ou images.
  - Commande : `podman rm -f`, suivi de `podman run` pour redéployer les conteneurs.

- **podman_remove.sh** :
  - Ce script supprime les conteneurs, les réseaux et les volumes créés avec Podman pour le projet. Il assure un nettoyage complet des ressources utilisées.
  - Commande : `podman rm`, `podman network rm`, `podman volume rm` pour supprimer les ressources associées.

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
