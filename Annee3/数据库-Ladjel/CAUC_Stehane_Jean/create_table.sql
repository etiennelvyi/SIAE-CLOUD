DROP TABLE Personne CASCADE CONSTRAINT;
DROP TABLE Auteur CASCADE CONSTRAINT;
DROP TABLE Livre CASCADE CONSTRAINT;
DROP TABLE Ecriture CASCADE CONSTRAINT;
DROP TABLE Exemplaire CASCADE CONSTRAINT;

DROP SEQUENCE SEQ_Personne;
DROP SEQUENCE SEQ_Auteur;
DROP SEQUENCE SEQ_Livre;
DROP SEQUENCE SEQ_Exemplaire;

CREATE TABLE Personne (
	id number(8,0),
	nom varchar2(32),
	prenom varchar2(32),
	pere number(8,0),
	CONSTRAINT pk_Personne PRIMARY KEY(id),
	CONSTRAINT fk_pere FOREIGN KEY(pere) REFERENCES Personne(id)
);

-- Séquence à utiliser pour valuer la colonne id de la table Personne
CREATE SEQUENCE SEQ_Personne START WITH 1;

CREATE TABLE Auteur (
	id number(8,0),
	goncourt number(1),
	idPersonne number(8,0),
	CONSTRAINT pk_Auteur PRIMARY KEY(id),
	CONSTRAINT fk_idPersonne FOREIGN KEY(idPersonne) REFERENCES Personne(id)
);

-- Séquence à utiliser pour valuer la colonne id de la table Auteur
CREATE SEQUENCE SEQ_Auteur START WITH 1;

CREATE TABLE Livre (
	ISBN number(8,0),
	titre varchar2(32),
	CONSTRAINT pk_Livre PRIMARY KEY(ISBN)
);

-- Séquence à utiliser pour valuer la colonne ISBN de la table Livre
CREATE SEQUENCE SEQ_Livre START WITH 1;

CREATE TABLE Ecriture (
	idAuteur number(8,0),
	idLivre number(8,0),
	CONSTRAINT pk_Ecriture PRIMARY KEY(idAuteur, idLivre),
	CONSTRAINT fk_idAuteur FOREIGN KEY(idAuteur) REFERENCES Auteur(id),
	CONSTRAINT fk_idLivre FOREIGN KEY(idLivre) REFERENCES Livre(ISBN)
);

CREATE TABLE Exemplaire (
	id number(8,0),
	prix number(10,2),
	duLivre number(8,0),
	emprunteur number(8,0), 
	dateEmprunt date,
	CONSTRAINT pk_Exemplaire PRIMARY KEY(id),
	CONSTRAINT fk_emprunteur FOREIGN KEY(emprunteur) REFERENCES Personne(id),
	CONSTRAINT fk_duLivre FOREIGN KEY(duLivre) REFERENCES Livre(ISBN)
);

-- Séquence à utiliser pour valuer la colonne id de la table Exemplaire
CREATE SEQUENCE SEQ_Exemplaire START WITH 1;


