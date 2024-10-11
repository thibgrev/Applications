FROM docker.io/bitnami/postgresql:latest

# Variables d'environnement pour PostgreSQL
ENV POSTGRES_DB=individu
ENV POSTGRES_USER=thibgrev
ENV POSTGRES_PASSWORD=azerty@12345

# Copier le script d'initialisation dans le dossier de démarrage de PostgreSQL
COPY init_db.sql /docker-entrypoint-initdb.d/

# Exposer le port PostgreSQL
EXPOSE 5432
