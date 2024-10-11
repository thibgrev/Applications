
# Déploiement d'une Application Web Conteneurisée avec Backend PostgreSQL sur OpenShift

## Objectifs Principaux

Ce projet a pour but de démontrer le processus de déploiement d'une application web conteneurisée comprenant un frontend et un backend. Le backend utilise PostgreSQL pour le stockage des données, tandis que le frontend permet de visualiser et de gérer ces données via une interface web.

L'application déployée sur OpenShift comprend les composants suivants :
- **Backend PostgreSQL** : Une base de données qui stocke les informations sur les personnes.
- **Frontend Web** : Une application Flask permettant de consulter, ajouter, et supprimer des enregistrements dans la base de données.

## Description de la Cible

- **OpenShift** : Le déploiement est prévu sur un cluster OpenShift (version 4).
- **Backend PostgreSQL** : Contient une base de données nommée `individu` avec une table `personne` ayant les colonnes `Identifiant`, `Nom`, `Prenom`, `age`, et `Informations`.
- **Frontend Web** : Permet de se connecter à la base de données, d'afficher les enregistrements, d'ajouter de nouvelles entrées, et de supprimer des enregistrements existants.
- **Infrastructure** : 
  - Namespace : `appli-web-postgresql`
  - Storage Class : `thin-csi`
  - Utilisation de secrets pour stocker les informations de connexion.

## Pré-requis

- Un accès à un cluster OpenShift version 4.
- Les outils CLI `oc` et `docker` installés et configurés.
- Un compte Docker Hub pour pousser les images conteneur.

## Arborescence des Fichiers

Le projet est structuré comme suit :

```
appli-web-postgresql/
├── scripts/
│   ├── create_structure.sh
│   ├── build_images.sh
│   ├── push_images.sh
│   ├── deploy_ocp.sh
│   ├── cleanup_ocp.sh
│   └── README.md
├── frontend/
│   ├── Dockerfile
│   └── app.py
└── backend/
    ├── Dockerfile
    ├── init_db.sql
    └── entrypoint.sh
```

## Étapes à Suivre

### 1. Créer l'Arborescence du Projet

Exécuter le script `create_structure.sh` pour générer les répertoires et les fichiers nécessaires.

```bash
./scripts/create_structure.sh
```

### 2. Construire les Images Docker

Utiliser le script `build_images.sh` pour construire les images Docker pour le frontend et le backend.

```bash
./scripts/build_images.sh
```

### 3. Pousser les Images sur la Registry Docker Hub

Exécuter le script `push_images.sh` pour pousser les images sur Docker Hub.

```bash
./scripts/push_images.sh
```

### 4. Déployer les Composants sur OpenShift

Le script `deploy_ocp.sh` permet de créer le namespace, les secrets, les PVC, les déploiements, les services et les routes nécessaires.

```bash
./scripts/deploy_ocp.sh
```

### 5. Vérifier le Déploiement

Après avoir exécuté le script de déploiement, vérifier que les composants sont bien déployés :
- Utiliser la commande `oc get pods -n appli-web-postgresql` pour voir l'état des pods.
- Utiliser `oc get svc -n appli-web-postgresql` pour voir les services créés.
- Accéder à l'application via l'URL fournie par la route OpenShift.

### 6. Nettoyer les Ressources

Pour supprimer toutes les ressources créées, exécuter le script `cleanup_ocp.sh`.

```bash
./scripts/cleanup_ocp.sh
```

## Explications sur Chaque Étape

### Arborescence des Fichiers

Le script `create_structure.sh` crée la structure des répertoires et des fichiers nécessaires pour le projet. Cela permet d'organiser le code source et les scripts de déploiement de manière claire.

### Construction des Images Docker

Le script `build_images.sh` construit deux images Docker :
- **Frontend** : Contient l'application web basée sur Flask.
- **Backend** : Basé sur PostgreSQL, avec un script d'initialisation pour créer la base de données et insérer des données de test.

### Déploiement sur OpenShift

Le script `deploy_ocp.sh` effectue les opérations suivantes :
1. **Création du namespace** : Un espace isolé sur OpenShift pour déployer les ressources.
2. **Configuration des secrets** : Stocke les informations de connexion à la base de données de manière sécurisée.
3. **Création du PVC** : Alloue de l'espace de stockage pour la base de données.
4. **Déploiement des composants** : Crée les déploiements pour le frontend et le backend.
5. **Services et routes** : Expose les services pour permettre l'accès aux composants.

### Nettoyage des Ressources

Le script `cleanup_ocp.sh` supprime le namespace et toutes les ressources associées, ce qui permet de libérer les ressources utilisées sur le cluster.

## Remarques

- Assurez-vous de changer les identifiants et mots de passe avant d'utiliser ce projet en production.
- Les scripts fournis sont des exemples et peuvent nécessiter des ajustements pour s'adapter à un environnement spécifique.

## Auteurs

Ce projet a été créé pour démontrer les bonnes pratiques de déploiement d'une application conteneurisée sur OpenShift.
