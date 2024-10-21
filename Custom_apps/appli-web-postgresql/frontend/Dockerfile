FROM docker.io/library/python:3.9-slim

# Installer les dépendances
RUN pip install flask psycopg2-binary

# Copier l'application
COPY app.py /app/app.py

# Copier le dossier templates pour les fichiers HTML
COPY templates /app/templates

# Copier le répertoire static pour les fichiers statiques
COPY static /app/static

# Définir le dossier de travail
WORKDIR /app

# Lancer l'application
CMD ["python", "app.py"]

# Exposer le port de l'application
EXPOSE 5000
