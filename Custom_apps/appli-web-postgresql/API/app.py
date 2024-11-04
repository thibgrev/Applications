from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
from psycopg2 import connect, OperationalError
from psycopg2.extras import RealDictCursor

# Initialisation de l'application FastAPI
app = FastAPI()

# Configuration de la base de données
DB_CONFIG = {
    "dbname": "individu",
    "user": "thibgrev",
    "password": "azerty@12345",
    "host": "web-postgresql"
}

# Modèle Pydantic pour les données de la table personne
class Person(BaseModel):
    identifiant: int = None
    nom: str
    prenom: str
    age: int
    informations: str

# Route de test de connexion à la base de données
@app.get("/")
def test_db_connection():
    try:
        # Tentative de connexion à la base de données
        with connect(**DB_CONFIG) as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute("SELECT 1")
        return {"message": "Connexion OK"}
    except OperationalError as e:
        # En cas d'erreur de connexion, retour de l'erreur
        return {"error": str(e)}

# Route pour obtenir la liste de toutes les personnes
@app.get("/personnes", response_model=List[Person])
def get_personnes():
    try:
        with connect(**DB_CONFIG) as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute("SELECT * FROM personne")
                personnes = cursor.fetchall()
        return personnes
    except OperationalError as e:
        raise HTTPException(status_code=500, detail=str(e))

# Route pour créer une nouvelle personne
@app.post("/personnes", response_model=Person)
def create_personne(person: Person):
    try:
        with connect(**DB_CONFIG) as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    "INSERT INTO personne (nom, prenom, age, informations) VALUES (%s, %s, %s, %s) RETURNING *",
                    (person.nom, person.prenom, person.age, person.informations)
                )
                conn.commit()
                new_person = cursor.fetchone()
        return new_person
    except OperationalError as e:
        raise HTTPException(status_code=500, detail=str(e))

# Route pour mettre à jour une personne existante
@app.put("/personnes/{identifiant}", response_model=Person)
def update_personne(identifiant: int, person: Person):
    try:
        with connect(**DB_CONFIG) as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    "UPDATE personne SET nom=%s, prenom=%s, age=%s, informations=%s WHERE identifiant=%s RETURNING *",
                    (person.nom, person.prenom, person.age, person.informations, identifiant)
                )
                conn.commit()
                updated_person = cursor.fetchone()
                if updated_person is None:
                    raise HTTPException(status_code=404, detail="Person not found")
        return updated_person
    except OperationalError as e:
        raise HTTPException(status_code=500, detail=str(e))

# Route pour supprimer une personne
@app.delete("/personnes/{identifiant}")
def delete_personne(identifiant: int):
    try:
        with connect(**DB_CONFIG) as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute("DELETE FROM personne WHERE identifiant=%s RETURNING *", (identifiant,))
                conn.commit()
                if cursor.rowcount == 0:
                    raise HTTPException(status_code=404, detail="Person not found")
        return {"message": "Person deleted"}
    except OperationalError as e:
        raise HTTPException(status_code=500, detail=str(e))
