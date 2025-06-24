import requests
import json
import time

# Configuration de pgAdmin
pgadmin_url = "http://localhost:5050"
pgadmin_email = "test@test.fr"
pgadmin_password = "azerty@12345"

# Configuration du serveur PostgreSQL
server_config = {
    "name": "PostgreSQL Server",
    "group": "Servers",
    "host": "web-postgresql",
    "port": 5432,
    "maintenance_db": "postgres",
    "username": "thibgrev",
    "password": "azerty@12345",
    "ssl_mode": "prefer",
    "comment": "Auto-configured PostgreSQL server"
}

# Attendre que pgAdmin soit prêt
time.sleep(10)

# Authentification à pgAdmin
session = requests.Session()
login_payload = {
    "email": pgadmin_email,
    "password": pgadmin_password
}
response = session.post(f"{pgadmin_url}/login", data=login_payload)
response.raise_for_status()

# Ajouter le serveur PostgreSQL
add_server_payload = {
    "name": server_config["name"],
    "group": server_config["group"],
    "host": server_config["host"],
    "port": server_config["port"],
    "maintenance_db": server_config["maintenance_db"],
    "username": server_config["username"],
    "password": server_config["password"],
    "ssl_mode": server_config["ssl_mode"],
    "comment": server_config["comment"]
}
headers = {
    "Content-Type": "application/json"
}
response = session.post(f"{pgadmin_url}/browser/server/obj/", headers=headers, data=json.dumps(add_server_payload))
response.raise_for_status()

print("Server added successfully")