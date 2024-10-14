from flask import Flask, request, jsonify
import psycopg2
import os

app = Flask(__name__)

# Fonction pour obtenir une connexion à la base de données PostgreSQL
def get_db_connection():
    conn = psycopg2.connect(
        host=os.getenv('DB_HOST', 'localhost'),     # Nom de l'hôte de la base de données
        database=os.getenv('DB_NAME', 'individu'),  # Nom de la base de données
        user=os.getenv('DB_USER', 'thibgrev'),      # Nom d'utilisateur PostgreSQL
        password=os.getenv('DB_PASSWORD', 'azerty@12345')  # Mot de passe PostgreSQL
    )
    return conn

# Route pour obtenir toutes les personnes
@app.route('/personnes', methods=['GET'])
def get_personnes():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM personne;')
    personnes = cur.fetchall()
    cur.close()
    conn.close()

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

# Route pour obtenir une personne par son identifiant
@app.route('/personnes/<int:id>', methods=['GET'])
def get_personne(id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM personne WHERE Identifiant = %s;', (id,))
    personne = cur.fetchone()
    cur.close()
    conn.close()

    if personne is None:
        return jsonify({'error': 'Personne non trouvée'}), 404

    result = {
        'Identifiant': personne[0],
        'Nom': personne[1],
        'Prenom': personne[2],
        'Age': personne[3],
        'Informations': personne[4]
    }
    return jsonify(result)

# Route pour ajouter une nouvelle personne
@app.route('/personnes', methods=['POST'])
def create_personne():
    new_personne = request.get_json()

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        'INSERT INTO personne (Nom, Prenom, Age, Informations) VALUES (%s, %s, %s, %s)',
        (new_personne['Nom'], new_personne['Prenom'], new_personne['Age'], new_personne['Informations'])
    )
    conn.commit()
    cur.close()
    conn.close()

    return jsonify({'message': 'Personne ajoutée avec succès'}), 201

# Route pour mettre à jour une personne existante
@app.route('/personnes/<int:id>', methods=['PUT'])
def update_personne(id):
    updated_personne = request.get_json()

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        'UPDATE personne SET Nom = %s, Prenom = %s, Age = %s, Informations = %s WHERE Identifiant = %s',
        (updated_personne['Nom'], updated_personne['Prenom'], updated_personne['Age'], updated_personne['Informations'], id)
    )
    conn.commit()
    cur.close()
    conn.close()

    return jsonify({'message': 'Personne mise à jour avec succès'}), 200

# Route pour supprimer une personne par son identifiant
@app.route('/personnes/<int:id>', methods=['DELETE'])
def delete_personne(id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('DELETE FROM personne WHERE Identifiant = %s;', (id,))
    conn.commit()
    cur.close()
    conn.close()

    return jsonify({'message': 'Personne supprimée avec succès'}), 200
