# Utiliser une image Python standard
FROM python:3.9-slim

# Installer les dépendances
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copier le code de l'application
COPY . /app

# Exposer le port de l'API
EXPOSE 8000

# Lancer l'application avec Uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
