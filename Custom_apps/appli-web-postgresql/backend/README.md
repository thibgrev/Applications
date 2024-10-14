# PostgreSQL Conteneur avec Initialisation Automatique

Ce projet contient un conteneur Docker pour PostgreSQL qui utilise une image de base **Bitnami PostgreSQL**. Lors du démarrage, la base de données est automatiquement configurée avec des paramètres spécifiques (nom de la base, utilisateur, mot de passe) et un script SQL est exécuté pour initialiser la base de données.

## Prérequis

- **Docker** ou **Podman** installé.

## Structure du projet

- `Dockerfile` : Fichier Docker pour construire l'image PostgreSQL avec le script d'initialisation.
- `init_db.sql` : Script SQL pour initialiser la base de données avec des tables et des données.
- `README.md` : Ce fichier.

## Configuration

### Variables d'environnement PostgreSQL

Les variables suivantes sont définies pour initialiser la base de données PostgreSQL :

- `POSTGRES_DB=individu` : Nom de la base de données à créer.
- `POSTGRES_USER=thibgrev` : Nom d'utilisateur PostgreSQL.
- `POSTGRES_PASSWORD=azerty@12345` : Mot de passe de l'utilisateur PostgreSQL.

### Script SQL d'initialisation (`init_db.sql`)

Le fichier **`init_db.sql`** est automatiquement exécuté lors du premier démarrage du conteneur. Il doit contenir les instructions pour créer des tables ou insérer des données.

Exemple de contenu pour `init_db.sql` :

```sql
CREATE TABLE personne (
    Identifiant SERIAL PRIMARY KEY,
    Nom VARCHAR(50),
    Prenom VARCHAR(50),
    Age INTEGER,
    Informations TEXT
);
