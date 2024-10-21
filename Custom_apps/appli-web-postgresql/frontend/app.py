from flask import Flask, request, render_template, redirect, url_for, flash
import psycopg2

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Nécessaire pour utiliser flash()

db_config = {
    'host': 'web-postgresql',
    'database': 'individu',
    'user': 'thibgrev',
    'password': 'azerty@12345'
}

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
    except Exception as e:
        personnes = []
        print(f"Erreur de connexion à la base de données : {e}")
    finally:
        if 'conn' in locals():
            conn.close()

    return render_template('index.html', personnes=personnes, db_config=db_config)

@app.route('/add', methods=['POST'])
def add_personne():
    nom = request.form['nom']
    prenom = request.form['prenom']
    age = request.form['age']
    informations = request.form['informations']

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        # Insertion sans gestion manuelle de l'identifiant (la base de données le gère)
        cur.execute("INSERT INTO personne (Nom, Prenom, age, Informations) VALUES (%s, %s, %s, %s)", 
                    (nom, prenom, age, informations))
        conn.commit()
        flash('Utilisateur ajouté avec succès', 'success')
    except Exception as e:
        flash(f'Erreur lors de l\'ajout de l\'utilisateur : {e}', 'error')
    finally:
        if 'conn' in locals():
            conn.close()

    return redirect(url_for('index'))

@app.route('/delete/<int:id>')
def delete_personne(id):
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("DELETE FROM personne WHERE Identifiant = %s", (id,))
        conn.commit()
        flash('Utilisateur supprimé avec succès', 'success')
    except Exception as e:
        flash(f'Erreur lors de la suppression : {e}', 'error')
    finally:
        if 'conn' in locals():
            conn.close()

    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
