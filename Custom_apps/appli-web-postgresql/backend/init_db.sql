CREATE TABLE personne (
    Identifiant SERIAL PRIMARY KEY,
    Nom VARCHAR(50),
    Prenom VARCHAR(50),
    age INTEGER,
    Informations TEXT
);

INSERT INTO personne (Nom, Prenom, age, Informations) VALUES
('Dupont', 'Jean', 30, 'Employé administratif'),
('Martin', 'Lucie', 25, 'Développeur web'),
('Bernard', 'Paul', 45, 'Chef de projet'),
('Durand', 'Marie', 28, 'Designer graphique'),
('Petit', 'Sophie', 35, 'Responsable RH');
