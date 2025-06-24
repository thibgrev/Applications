FROM python:3.11-slim

# Installer les dépendances nécessaires
RUN pip install --no-cache-dir requests
# Copier ton script de configuration
COPY setup_pgadmin.py /app/setup_pgadmin.py

# Définir le point d’entrée
CMD ["python", "/app/setup_pgadmin.py"]
