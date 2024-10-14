# Utiliser une image Python de base
FROM python:3.9-slim

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de l'application dans le conteneur
COPY requirements.txt requirements.txt
COPY app.py /app/app.py

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Exposer le port sur lequel l'application écoute
EXPOSE 5000

# Démarrer l'application Flask
CMD ["python", "app.py"]
