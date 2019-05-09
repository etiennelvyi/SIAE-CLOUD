-- Insertion de données dans le modèle logique
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'A l''image des géants');
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'Dieux du Stade');
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'Le Monde comme je le vois');
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'Harry Potter, tome 6');
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'L''Arche des ombres, Tome 1');
INSERT INTO LIVRE VALUES (SEQ_Livre.NEXTVAL, 'Livre sans exemplaire');

INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Hawking', 'Stephen', null);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Goudon', 'Fred', null);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Jospin', 'Lionel', null);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Rowling', 'J.K.', null);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Hobb', 'Robin', null);

INSERT INTO Auteur 
       SELECT SEQ_Auteur.NEXTVAL, DECODE(Personne.nom, 'Goudon',0,1), Personne.id  FROM PERSONNE;

INSERT INTO Ecriture SELECT Livre.isbn, Auteur.id FROM Livre, Auteur where Livre.isbn = Auteur.id;

INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Hawking', 'Hans', 1);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Hawking', 'Jens', 6);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Hobb', 'Thierry', 5);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Shaw', 'Andrew', NULL);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Dieter', 'Fensen', NULL);
INSERT INTO Personne VALUES (SEQ_Personne.NEXTVAL, 'Baden', 'Thomas', NULL);

INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 26.60 , 1, 8, TO_DATE('01/04/2015', 'DD/MM/YYYY'));
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 26.60 , 1, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 26.60 , 1, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 26.60 , 1, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 26.60 , 1, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 24.70 , 2, 8, TO_DATE('15/03/2015', 'DD/MM/YYYY'));
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 24.70 , 2, 9, TO_DATE('10/01/2015', 'DD/MM/YYYY'));
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 24.70 , 2, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 24.70 , 2, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 24.70 , 2, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 22.33 , 3, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 22.33 , 3, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 22.33 , 3, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 23.75 , 4, NULL, NULL);
INSERT INTO Exemplaire VALUES (SEQ_Exemplaire.NEXTVAL, 32.78  ,5, NULL, NULL);