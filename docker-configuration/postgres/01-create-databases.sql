-- Script d'initialisation pour créer les bases de données nécessaires
-- Ce script s'exécute automatiquement au premier démarrage de PostgreSQL

-- Création de la base de données pour Metabase
CREATE DATABASE metabase;

-- ============================================================================
-- CRÉATION DE LA BASE DE DONNÉES ALEXANDRIE 2.0
-- ============================================================================

CREATE DATABASE alexandrie;

\c alexandrie;

-- Création des tables pour l'application Alexandrie 2.0

CREATE TABLE auteurs (
    id SERIAL PRIMARY KEY,
    nom_complet VARCHAR(255),
    pseudonymes TEXT[],
    date_naissance DATE,
    date_deces DATE,
    nationalite VARCHAR(100),
    biographie TEXT,
    site_web VARCHAR(255),
    reseaux_sociaux TEXT[]
);

CREATE TABLE livres (
    isbn VARCHAR(13) PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    categorie VARCHAR(100),
    annee_publication INT,
    editeur VARCHAR(100),
    langue VARCHAR(50),
    nb_pages INT,
    format VARCHAR(50),
    nb_exemplaires INT,
    localisation VARCHAR(100),
    etat VARCHAR(50),
    mots_cles TEXT[]
);

CREATE TABLE livre_auteurs (
    livre_isbn VARCHAR(13),
    auteur_id INT,
    PRIMARY KEY (livre_isbn, auteur_id),
    CONSTRAINT fk_livre_auteurs_livre FOREIGN KEY (livre_isbn) REFERENCES livres(isbn),
    CONSTRAINT fk_livre_auteurs_auteur FOREIGN KEY (auteur_id) REFERENCES auteurs(id)
);

CREATE TABLE utilisateurs (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    date_naissance DATE,
    adresse TEXT,
    telephone VARCHAR(20),
    type_compte VARCHAR(50),
    date_inscription DATE DEFAULT CURRENT_DATE,
    statut VARCHAR(50),
    nb_max_emprunts INT
);

CREATE TABLE emprunts (
    id SERIAL PRIMARY KEY,
    utilisateur_id INT,
    ressource_isbn VARCHAR(13),
    date_emprunt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_retour_prevue TIMESTAMP,
    date_retour_effective TIMESTAMP,
    statut VARCHAR(50),
    penalites DECIMAL(10, 2),
    CONSTRAINT fk_emprunts_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id),
    CONSTRAINT fk_emprunts_ressource FOREIGN KEY (ressource_isbn) REFERENCES livres(isbn)
);

CREATE TABLE reservations (
    id SERIAL PRIMARY KEY,
    utilisateur_id INT,
    ressource_isbn VARCHAR(13),
    date_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_expiration TIMESTAMP,
    statut VARCHAR(50),
    position_file_attente INT,
    CONSTRAINT fk_reservations_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id),
    CONSTRAINT fk_reservations_ressource FOREIGN KEY (ressource_isbn) REFERENCES livres(isbn)
);

-- Création des index
CREATE INDEX idx_livres_titre ON livres(titre);
CREATE INDEX idx_livres_categorie ON livres(categorie);
CREATE INDEX idx_utilisateurs_email ON utilisateurs(email);
CREATE INDEX idx_emprunts_utilisateur_id ON emprunts(utilisateur_id);
CREATE INDEX idx_emprunts_ressource_isbn ON emprunts(ressource_isbn);
CREATE INDEX idx_reservations_utilisateur_id ON reservations(utilisateur_id);
CREATE INDEX idx_reservations_ressource_isbn ON reservations(ressource_isbn);