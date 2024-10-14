# Utiliser une image Python de base
FROM python:3.9-slim

# Installer Flask, psycopg2-binary, et Gunicorn
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copier l'application Flask
COPY app.py /app/app.py

# Exposer le port sur lequel l'application écoutera
EXPOSE 8000

# Utiliser ENTRYPOINT pour démarrer Gunicorn
ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
