# API Flask avec PostgreSQL

Ce projet contient une API Flask qui interagit avec une base de données PostgreSQL pour manipuler les données d'une table `personne`. L'API est conteneurisée avec Docker/Podman et communique avec un conteneur PostgreSQL via un réseau Docker/Podman.

## Prérequis

- **Docker** ou **Podman** installé.
- Un conteneur PostgreSQL existant.
- Un réseau Docker/Podman partagé pour permettre la communication entre les conteneurs.

## Structure du projet

- `app.py` : Fichier principal qui contient l'API Flask.
- `requirements.txt` : Fichier des dépendances Python.
- `Dockerfile` : Définit l'image Docker pour l'API.
- `conf.ini` : Fichier optionnel de configuration (si utilisé).
- `README.md` : Ce fichier.

## Configuration

### Base de données PostgreSQL

La base de données utilisée est PostgreSQL avec la table suivante :

```sql
CREATE TABLE personne (
    Identifiant SERIAL PRIMARY KEY,
    Nom VARCHAR(50),
    Prenom VARCHAR(50),
    Age INTEGER,
    Informations TEXT
);
