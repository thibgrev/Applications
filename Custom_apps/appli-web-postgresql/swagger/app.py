from flask import Flask, request, jsonify
import psycopg2
from flasgger import Swagger

app = Flask(__name__)
swagger = Swagger(app)

db_config = {
    'host': 'web-postgresql',
    'database': 'individu',
    'user': 'thibgrev',
    'password': 'azerty@12345'
}

# Connexion à la base de données
def get_db_connection():
    conn = psycopg2.connect(**db_config)
    return conn

@app.route('/personnes', methods=['GET'])
def get_personnes():
    """
    Récupérer la liste des personnes
    ---
    responses:
      200:
        description: Liste de toutes les personnes
        schema:
          type: array
          items:
            type: object
            properties:
              Identifiant:
                type: integer
                description: L'ID de la personne
              Nom:
                type: string
                description: Le nom de la personne
              Prenom:
                type: string
                description: Le prénom de la personne
              Age:
                type: integer
                description: L'âge de la personne
              Informations:
                type: string
                description: Informations supplémentaires
    """
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT * FROM personne")
        personnes = cur.fetchall()
        cur.close()
        conn.close()
    except Exception as e:
        return jsonify({'error': str(e)})

    results = []
    for row in personnes:
        results.append({
            'Identifiant': row[0],
            'Nom': row[1],
            'Prenom': row[2],
            'Age': row[3],
            'Informations': row[4]
        })
    return jsonify(results)

@app.route('/add', methods=['POST'])
def add_personne():
    """
    Ajouter une nouvelle personne
    ---
    parameters:
      - name: nom
        in: formData
        type: string
        required: true
        description: Nom de la personne
      - name: prenom
        in: formData
        type: string
        required: true
        description: Prénom de la personne
      - name: age
        in: formData
        type: integer
        required: true
        description: Âge de la personne
      - name: informations
        in: formData
        type: string
        description: Informations supplémentaires
    responses:
      201:
        description: Personne ajoutée avec succès
    """
    nom = request.form['nom']
    prenom = request.form['prenom']
    age = request.form['age']
    informations = request.form['informations']

    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("INSERT INTO personne (Nom, Prenom, age, Informations) VALUES (%s, %s, %s, %s)", (nom, prenom, age, informations))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"message": "Personne ajoutée avec succès"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
