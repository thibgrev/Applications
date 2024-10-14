from flask import Flask, request, render_template_string
import psycopg2

app = Flask(__name__)

# Informations de connexion à la base de données
db_config = {
    'host': 'web-postgresql',
    'database': 'individu',
    'user': 'thibgrev',
    'password': 'azerty@12345'
}

# Template HTML
template = """
<!doctype html>
<html>
<head>
    <title>Application Web</title>
</head>
<body>
    <h1>Connexion à la base de données : {{ db_status }}</h1>
    <p>Configuration : {{ db_config }}</p>
    <h2>Données dans la table "personne"</h2>
    <table border="1">
        <tr>
            <th>Identifiant</th>
            <th>Nom</th>
            <th>Prénom</th>
            <th>Âge</th>
            <th>Informations</th>
            <th>Actions</th>
        </tr>
        {% for personne in personnes %}
        <tr>
            <td>{{ personne[0] }}</td>
            <td>{{ personne[1] }}</td>
            <td>{{ personne[2] }}</td>
            <td>{{ personne[3] }}</td>
            <td>{{ personne[4] }}</td>
            <td><a href="/delete/{{ personne[0] }}">-</a></td>
        </tr>
        {% endfor %}
    </table>
    <h2>Insérer une nouvelle personne</h2>
    <form action="/add" method="post">
        <p>Nom : <input type="text" name="nom"></p>
        <p>Prénom : <input type="text" name="prenom"></p>
        <p>Âge : <input type="number" name="age"></p>
        <p>Informations : <input type="text" name="informations"></p>
        <p><input type="submit" value="Insérer"></p>
    </form>
    <footer>
        <p>Version de PostgreSQL actuelle : {{ postgres_version }}</p>
    </footer>
</body>
</html>
"""

# Fonction pour se connecter à la base de données
def get_db_connection():
    conn = psycopg2.connect(**db_config)
    return conn

@app.route('/')
def index():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT * FROM personne")
        personnes = cur.fetchall()
        cur.execute("SELECT version()")
        postgres_version = cur.fetchone()[0]
        db_status = "Succès"
    except Exception as e:
        personnes = []
        postgres_version = "Inconnu"
        db_status = f"Échec ({e})"
    finally:
        if 'conn' in locals():
            conn.close()

    return render_template_string(template, db_status=db_status, db_config=db_config, personnes=personnes, postgres_version=postgres_version)

@app.route('/add', methods=['POST'])
def add_personne():
    nom = request.form['nom']
    prenom = request.form['prenom']
    age = request.form['age']
    informations = request.form['informations']

    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("INSERT INTO personne (Nom, Prenom, age, Informations) VALUES (%s, %s, %s, %s)", (nom, prenom, age, informations))
        conn.commit()
    except Exception as e:
        print(f"Erreur lors de l'insertion : {e}")
    finally:
        if 'conn' in locals():
            conn.close()

    return index()

@app.route('/delete/<int:id>')
def delete_personne(id):
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("DELETE FROM personne WHERE Identifiant = %s", (id,))
        conn.commit()
    except Exception as e:
        print(f"Erreur lors de la suppression : {e}")
    finally:
        if 'conn' in locals():
            conn.close()

    return index()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
