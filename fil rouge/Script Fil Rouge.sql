DROP DATABASE if exists fil_rouge;

CREATE DATABASE if NOT EXISTS fil_rouge;

USE fil_rouge;

CREATE TABLE Rubrique(
   rub_id MEDIUMINT AUTO_INCREMENT,
   rub_nom VARCHAR(50) NOT NULL,
   rub_libelle VARCHAR(250),
   rub_photo VARCHAR(254),
   rub_id_1 MEDIUMINT,
   PRIMARY KEY(rub_id),
   FOREIGN KEY(rub_id_1) REFERENCES Rubrique(rub_id)
);

CREATE TABLE Employé(
   emp_id MEDIUMINT AUTO_INCREMENT,
   emp_nom VARCHAR(50) NOT NULL,
   emp_prenom VARCHAR(50) NOT NULL,
   emp_telephone VARCHAR(20),
   emp_mail VARCHAR(50) UNIQUE,
   emp_password VARCHAR(255),
   emp_fonction VARCHAR(50),
   PRIMARY KEY(emp_id)
);

CREATE TABLE `CLIENT`(
   cli_id MEDIUMINT AUTO_INCREMENT,
   cli_nom VARCHAR(50) NOT NULL,
   cli_prenom VARCHAR(50) NOT NULL,
   cli_rue VARCHAR(50) NOT NULL,
   cli_code_postal VARCHAR(20) NOT NULL,
   cli_ville VARCHAR(50) NOT NULL,
   cli_pays VARCHAR(50) NOT NULL,
   cli_mail VARCHAR(50) UNIQUE,
   cli_password VARCHAR(255),   
   cli_telephone VARCHAR(20),
   cli_statut VARCHAR(50),
   cli_coefficient DECIMAL(4,2) NOT NULL DEFAULT 3 CHECK(cli_coefficient>1),
   cli_emp_id MEDIUMINT,
   PRIMARY KEY(cli_id),
   FOREIGN KEY(cli_emp_id) REFERENCES Employé(emp_id)
);

CREATE TABLE Fournisseur(
   fou_id MEDIUMINT AUTO_INCREMENT,
   fou_nom VARCHAR(50) NOT NULL,
   fou_rue VARCHAR(100) NOT NULL,
   fou_code_postal VARCHAR(20) NOT NULL,
   fou_ville VARCHAR(50) NOT NULL,
   fou_pays VARCHAR(50) NOT NULL,
   fou_mail VARCHAR(50),
   fou_telephone VARCHAR(20),
   fou_contact_nom VARCHAR(50),
   fou_contact_telephone VARCHAR(20),
   fou_emp_id MEDIUMINT,
   PRIMARY KEY(fou_id),
   FOREIGN KEY(fou_emp_id) REFERENCES Employé(emp_id)
);

CREATE TABLE Commande(
   com_id MEDIUMINT AUTO_INCREMENT,
   com_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
   com_reduction DECIMAL(3,2) DEFAULT 1 CHECK(com_reduction BETWEEN 0 AND 1),
   com_total_HT DECIMAL(12,2),
   com_total_TTC DECIMAL(12,2),
   com_etat VARCHAR(40),
   com_livraison_rue VARCHAR(100) NOT NULL,
   com_livraison_code_postal VARCHAR(20) NOT NULL,
   com_livraison_ville VARCHAR(50) NOT NULL,
   com_livraison_pays VARCHAR(50) NOT NULL,
   com_livraison_avancement VARCHAR(50),
   com_paiement_date DATE,
   com_facture_numero VARCHAR(10) UNIQUE,
   com_facture_date DATE,
   com_facture_rue VARCHAR(100) NOT NULL,
   com_facture_code_postal VARCHAR(20) NOT NULL,
   com_facture_ville VARCHAR(50) NOT NULL,
   com_facture_pays VARCHAR(50) NOT NULL,
   com_cli_id MEDIUMINT NOT NULL,
   PRIMARY KEY(com_id),
   FOREIGN KEY(com_cli_id) REFERENCES Client(cli_id)
);

CREATE TABLE Livraison(
   liv_id MEDIUMINT AUTO_INCREMENT,
   liv_datetime DATETIME,
   liv_com_id MEDIUMINT NOT NULL,
   PRIMARY KEY(liv_id),
   FOREIGN KEY(liv_com_id) REFERENCES Commande(com_id)
);

CREATE TABLE Produit(
   pro_id MEDIUMINT AUTO_INCREMENT,
   pro_libelle_court VARCHAR(60) NOT NULL,
   pro_libelle_long VARCHAR(300),
   pro_prix_achat DECIMAL(13,4) NOT NULL,
   pro_photo VARCHAR(254),
   pro_rub_id MEDIUMINT,
   pro_emp_id MEDIUMINT,
   pro_fou_id MEDIUMINT NOT NULL,   
   PRIMARY KEY(pro_id),
   FOREIGN KEY(pro_rub_id) REFERENCES Rubrique(rub_id),
   FOREIGN KEY(pro_emp_id) REFERENCES Employé(emp_id),
   FOREIGN KEY(pro_fou_id) REFERENCES Fournisseur(fou_id)
);

CREATE TABLE posseder(
	pos_id INT AUTO_INCREMENT NOT NULL,
   pos_pro_id MEDIUMINT,
   pos_com_id MEDIUMINT,
   pos_quantite_commandee DECIMAL(15,2) NOT NULL,
   pos_prix_achat DECIMAL(13,4),
   pos_prix_vente DECIMAL(11,2),
   pos_sous_total_HT DECIMAL(12,2),
   PRIMARY KEY(pos_id),
   FOREIGN KEY(pos_pro_id) REFERENCES Produit(pro_id),
   FOREIGN KEY(pos_com_id) REFERENCES Commande(com_id)
);

CREATE TABLE contenir(
	con_id int AUTO_INCREMENT NOT NULL,
   con_pro_id MEDIUMINT,
   con_liv_id MEDIUMINT,
   con_liv_quantite_BL DECIMAL(15,2) NOT NULL,
   PRIMARY KEY(con_id),
   FOREIGN KEY(con_pro_id) REFERENCES Produit(pro_id),
   FOREIGN KEY(con_liv_id) REFERENCES Livraison(liv_id)
);


DROP USER if EXISTS 'visiteur'@'%';
DROP USER if EXISTS 'client'@'%';
DROP USER if EXISTS 'gestion'@'%';
DROP USER if EXISTS 'administrateur'@'%';


CREATE USER if NOT EXISTS 'visiteur'@'%' IDENTIFIED BY 'visiteur';
CREATE USER if NOT EXISTS 'client'@'%' IDENTIFIED BY 'client';
CREATE USER if NOT EXISTS 'gestion'@'%' IDENTIFIED BY 'gestion';
CREATE USER if NOT EXISTS 'administrateur'@'%' IDENTIFIED BY 'administrateur';

GRANT SELECT 
ON fil_rouge.produit
TO 'visiteur'
IDENTIFIED BY 'visiteur';

GRANT SELECT
ON fil_rouge.*
TO 'client'
IDENTIFIED BY 'client';

GRANT INSERT, UPDATE ON fil_rouge.`client`
TO 'client'
IDENTIFIED BY 'client';

GRANT INSERT, UPDATE ON fil_rouge.commande
TO 'client'
IDENTIFIED BY 'client';

GRANT INSERT, UPDATE ON fil_rouge.contenir
TO 'client'
IDENTIFIED BY 'client';

GRANT SELECT, INSERT, UPDATE
ON fil_rouge.*
TO 'gestion'
IDENTIFIED BY 'gestion';

GRANT ALL PRIVILEGES ON fil_rouge.`*`
TO 'administrateur' IDENTIFIED BY 'administrateur';

insert INTO `client` (cli_id, cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone, cli_coefficient) VALUES (1, 'Yurtsev', 'Yurtsev', 'Maëly', '4588 Summit Junction', '94254 CEDEX', 'Gentilly', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'),'276-47-8726', 3);
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone, cli_coefficient) values ('Swanborrow', 'Swanborrow', 'Östen', '7 Vermont Road', '82037 CEDEX', 'Montauban', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '865-81-0304', 3);
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Bes','Bes', 'Anaëlle', '19 Bowman Junction', '74041 CEDEX', 'Annecy', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '280-83-8709');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Tolumello','Tolumello', 'Anaël', '576 Scoville Trail', '54046 CEDEX', 'Nancy', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '642-92-9923');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Salsberg','Salsberg', 'Michèle', '89 Pearson Point', '78897 CEDEX', 'Saint-Quentin-en-Yvelines', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '745-23-9796');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Loftus','Loftus', 'Kévina', '690 Steensland Junction', '94414 CEDEX', 'Saint-Maurice', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '119-03-7753');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Linfitt','Linfitt', 'Océane', '72 Nelson Street', '84304 CEDEX', 'Cavaillon', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '168-87-1106');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Loch','Loch', 'Gaïa', '916 Corben Place', '13253 CEDEX 06', 'Marseille', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '791-84-2097');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Laverock','Laverock', 'Loïc', '0136 Eastlawn Lane', '77794 CEDEX', 'Nemours', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '200-12-2825');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Vassman','Vassman', 'Zhì', '2673 Warrior Parkway', '14654 CEDEX', 'Carpiquet', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '218-95-0963');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Winspar','Winspar', 'Stévina', '4 Bluejay Terrace', '94525 CEDEX 1', 'Rungis', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '275-52-7061');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Papachristophorou','Papachristophorou', 'Daphnée', '4152 Logan Point', '89102 CEDEX', 'Sens', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '501-40-4761');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Orknay','Orknay', 'Maï', '914 Evergreen Plaza', '95761 CEDEX 1', 'Roissy Charles-de-Gaulle', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '542-30-0982');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Dwire','Dwire', 'Mégane', '44258 Pleasure Crossing', '77414 CEDEX', 'Claye-Souilly', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '179-04-9808');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Boscott','Boscott', 'Pò', '6135 Kropf Pass', '75976 CEDEX 20', 'Paris 20', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '523-65-0245');
insert into client (cli_nom, cli_password, cli_prenom, cli_rue, cli_code_postal, cli_ville, cli_pays, cli_mail, cli_telephone) values ('Duester','Duester', 'Sélène', '06804 Delaware Point', '01069 CEDEX 9', 'Bourg-en-Bresse', 'France', concat(substring(cli_prenom,1,3),'.',cli_nom,'@mail.com'), '517-82-7525');


UPDATE `client` SET cli_statut='professionel', cli_coefficient=2 WHERE cli_id=1;
UPDATE `client` SET cli_statut='professionel', cli_coefficient=2 WHERE cli_id=2;
UPDATE `client` SET cli_statut='professionel', cli_coefficient=2 WHERE cli_id=3;
UPDATE `client` SET cli_statut='professionel', cli_coefficient=2 WHERE cli_id=4;
UPDATE `client` SET cli_statut='professionel', cli_coefficient=2 WHERE cli_id=5;
UPDATE `client` SET cli_statut='professionel', cli_coefficient=2 WHERE cli_id=6;
UPDATE `client` SET cli_statut='professionel', cli_coefficient=2 WHERE cli_id=7;
UPDATE `client` SET cli_statut='professionel', cli_coefficient=2 WHERE cli_id=8;
UPDATE `client` SET cli_statut='professionel', cli_coefficient=2 WHERE cli_id=9;
UPDATE `client` SET cli_statut='professionel', cli_coefficient=2 WHERE cli_id=10;


insert into fournisseur (fou_id, fou_nom, fou_rue, fou_code_postal, fou_ville, fou_pays) VALUES (1,'Coolwind', '4 Bartelt Alley', '94675 CEDEX', 'Charenton-le-Pont', 'France');
insert into fournisseur (fou_id, fou_nom, fou_rue, fou_code_postal, fou_ville, fou_pays) VALUES (2, 'Getzen', '320 Emmet Avenue', '75778 CEDEX 16', 'Paris 16', 'France');
insert into fournisseur (fou_id, fou_nom, fou_rue, fou_code_postal, fou_ville, fou_pays) VALUES (3, 'Jupiter', '262 Morrow Crossing', '75080 CEDEX 02', 'Paris 02', 'France');
insert into fournisseur (fou_id, fou_nom, fou_rue, fou_code_postal, fou_ville, fou_pays) VALUES (4, 'Nuvo', '387 Eastwood Alley', '13327 CEDEX 15', 'Marseille', 'France');
insert into fournisseur (fou_id, fou_nom, fou_rue, fou_code_postal, fou_ville, fou_pays) VALUES (5, 'Altus', '23 Brentwood Road', '06293 CEDEX 3', 'Nice', 'France');
insert into fournisseur (fou_id, fou_nom, fou_rue, fou_code_postal, fou_ville, fou_pays) VALUES (6, 'Voomm', '04 Heath Street', '37205 CEDEX 3', 'Tours', 'France');
insert into fournisseur (fou_id, fou_nom, fou_rue, fou_code_postal, fou_ville, fou_pays) VALUES (7, 'SML Accessoires', '51 rue de l''anis', '13051', 'Pastaga', 'France');

insert into employé (emp_prenom, emp_nom, emp_password) values ('Celestyna', 'Stenbridge', 'Stenbridge');
insert into employé (emp_prenom, emp_nom, emp_password) values ('Jermaine', 'Pasek', 'Pasek');
insert into employé (emp_prenom, emp_nom, emp_password) values ('Lian', 'Kolyagin', 'Kolyagin');
insert into employé (emp_prenom, emp_nom, emp_password) values ('Jobina', 'MacTrustey', 'MacTrustey');
insert into employé (emp_prenom, emp_nom, emp_password) values ('Sayers', 'Hugo', 'Hugo');
insert into employé (emp_prenom, emp_nom, emp_password) values ('Nataniel', 'Liddel', 'Liddel');
insert into employé (emp_prenom, emp_nom, emp_password) values ('Vergil', 'Torricina', 'Torricina');
insert into employé (emp_prenom, emp_nom, emp_password) values ('Krisha', 'Folcarelli', 'Folcarelli');
insert into employé (emp_prenom, emp_nom, emp_password) values ('Yvette', 'Burrows', 'Burrows');
insert into employé (emp_prenom, emp_nom, emp_password) values ('Dory', 'Maso', 'Maso');
insert into employé (emp_prenom, emp_nom, emp_password) values ('Pattin', 'Whalley', 'Whalley');
insert into employé (emp_prenom, emp_nom, emp_password) values ('Giovanni', 'Berr', 'Berr');



INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (1, 'les instruments à vents', 'toute la panoplie des instruments à vents ainsi que leurs accessoires sont à votre disposition ici!!', NULL, 'rubrique1.jpeg');
INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (2,'les guitares', 'toute la panoplie des guitares ainsi que leurs accessoires sont à votre disposition ici!!', NULL, 'rubrique2.png');
INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES	(3,'les claviers', 'toute la panoplie des claviers ainsi que leurs accessoires sont à votre disposition ici!!', NULL, 'rubrique3.jpg');
INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES	(4,'les cordes frottées', 'toute la panoplie des instruments à cordes frottées ainsi que leurs accessoires sont à votre disposition ici!!', NULL, 'rubrique4.jpg');
INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES	(5,'les saxophones','toute la panoplie de nos saxophones !!', 1, 'rubrique5.jpg');
INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES	(6,'les clarinettes','toute la panoplie de nos plus belles clarinettes !!', 1, 'rubrique6.jpg');
INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES	(7,'les flûtes','toute la panoplie de nos plus belles flûtes avec en exclusivité nos plus beaux pipeaux !!', 1, 'rubrique7.jpg');
INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES	(8,'les trompettes','toute la panoplie de nos plus belles trompettes !!', 1, 'rubrique8.jpg');
INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES	(9,'les trombones','toute la panoplie de nos plus beaux trombones !!', 1, 'rubrique9.jpg');
INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES	(10,'les gros cuivres','toute la panoplie de nos plus beaux gros cuivres !!', 1, 'rubrique10.jpg');
INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES	(11,'les becs','toute la panoplie de nos plus beaux gros cuivres !!', 1, 'rubrique11.jpg');
INSERT INTO rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES	(12,'les embouchures','toute la panoplie de nos plus beaux gros cuivres !!', 1, 'rubrique12.jpg');
insert into rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (13, 'Guitare Acoustique', 'La guitare acoustique possède une caisse de résonance servant à amplifier les vibrations des cordes.', 2, 'rubrique13.jpg');
insert into rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (14, 'Guitare Classique', 'La guitare classique, également appelée guitare espagnole, est un instrument de musique de la famille des cordes pincées.', 2, 'rubrique14.jpg');
insert into rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (15, 'Guitare Electrique', 'La guitare électrique est un type de guitare qui produit des sons grâce à des capteurs électromagnétiques.', 2, 'rubrique15.jpg');
insert into rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (16, 'Guitare Basse', 'C''est un instrument de musique à cordes conçu selon le même principe que la guitare électrique, mais avec une tessiture plus grave.', 2, 'rubrique16.jpg');
insert into rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (17, 'Contrebasses', 'La contrebasse est un instrument grave de la famille des instruments à cordes.', 4, 'rubrique17.jpg');
insert into rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (18, 'Violons', 'Le violon est un instrument de musique à cordes frottées', 4, 'rubrique18.jpg');
insert into rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (19, 'Violoncelles', 'Le violoncelle est un instrument à cordes frottées (mises en vibration par l''action de l''archet) ou pincées (le pizzicato) de la famille des cordes frottées, qui compte aussi le violon, l''alto et la contrebasse.', 4, 'rubrique19.jpg');
insert into rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (20, 'Clavier Arrangeur', 'Le clavier est, en musique et plus précisément en organologie, un ensemble de touches enfoncées à l''aide des doigts pour jouer de certains instruments.', 3, 'rubrique20.jpg');
insert into rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (21, 'Piano Numérique', 'Un piano numérique est un instrument de musique électronique, équipé du clavier standard d''un piano, et reproduisant le son d''un piano acoustique grâce à un système électronique, la technologie la plus utilisée étant l''échantillonnage sonore.', 3, 'rubrique21.jpg');
insert into rubrique(rub_id, rub_nom, rub_libelle, rub_id_1, rub_photo) VALUES (22, 'Clavier Maitre','Le clavier maitre est un clavier sans son qui permet de piloter les instruments virtuels des logiciels de musique, et d''enregistrer dans ces logiciels les évènements MIDI lorsque l''on joue dessus.', 3, 'rubrique22.jpg');


INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (1, 'Coolwind Trompette Sib, plastique rouge','Fabriqués à base de plastique ABS, les produits Coolwind vous permettent de jouer partout ! Ne vous souciez plus d’abimer votre instrument principal lorsque vous vous déplacez ou jouez en extérieur',60,8,1, 'produit1.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (2, 'Getzen Trompette Sib étudiant vernie 490-SC','Une trompette d''étude, certes, mais avec des qualités de semi-professionnelle.',580,8,2, 'produit2.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (3, 'Coolwind Euphonium Sib en plastique rouge','Fabriqués à base de plastique ABS, les produits Coolwind vous permettent de jouer partout ! Ne vous souciez plus d’abimer votre instrument principal lorsque vous vous déplacez ou jouez en extérieur',170,10,1, 'produit3.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (4, 'Jupiter Saxhorn baryton de défilé verni JBR1000M','',476,10,3, 'produit4.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (5, 'Altus Flûte en Ut plateaux creux AS807RI','Cet instrument, fabriqué à la main, disponible en patte d’Ut ou en patte de Si, est une porte d’entrée vers le monde des flûtes japonaises.',753,7,5, 'produit5.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (6, 'Jupiter Flûte en Ut goutte d''eau JFL700WD','Avec sa flûte traversière goutte d’eau JFL700WD primée au Red Dot Design Award, Jupiter a su s’imposer sur le marché comme une marque novatrice au service des musiciens.',241,7,3, 'produit6.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (7, 'Coolwind Trombone complet plastique red CTB-200RD','Trombone complet en Sib et en Fa avec noix, un corps en plastique ABS et une coulisse en fibre de carbone, un pavillon au diamètre de 216 mm et une perce de 13,9 mm.',74,9,1, 'produit7.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (8, 'Jupiter Trombone ténor complet pro JTB1150FOQ','Tonalité : Sib/Fa Perce :13,89mm Pavillon : 215mm, laiton verni Noix, Open Wrap Tubes extérieurs coulisse de jeu : maillechort Tubes intérieurs : maillechort chromé',500,9,3, 'produit8.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (9, 'Nuvo Saxophone d''éveil ABS noir et rose','Le jSax n''est pas un jouet mais un véritable instrument de musique même si son aspect très coloré attire les plus jeunes !', 38, 5,4, 'produit9.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (10, 'Jupiter Saxophone baryton pro plaqué argent','Au-delà des brevets d''ergonomie de ses instruments d''étude, la marque Jupiter a su poursuivre ses innovations pour proposer ce modèle professionnel doté d''un bocal qui lui confère une sonorité unique au monde.', 1876, 5, 3, 'produit10.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (11, 'Jupiter Saxonett JRS700','Jupiter Clarinettes JRS700 présentation Le Saxonett JRS700 constitue un passage idéal pour les jeunes joueurs de flûtes à bec souhaitant apprendre à jouer du saxophone ou de la clarinette. Il associe le bec de la clarinette avec le corps de la flûte à bec.', 39, 6, 3, 'produit11.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (12, 'Jupiter Clarinette basse ABS clés argentées','Jupiter Clarinettes JRC1000S haut de gamme', 763, 6, 3, 'produit12.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (13, 'Nuvo Clarinette d''éveil ABS noire et bleue','Nuvo met la musique à la portée de tous les enfants ! Un concept simple et ingénieux pour de véritables instruments de qualité.', 14, 6, 4, 'produit13.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (14, 'Sml Accessoires Bec saxophone alto ébonite','Bec ébonite avec ligature métal et couvre-bec plastique', 9, 11, 7, 'produit14.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (15, 'Sml Accessoires Bec clarinette Sib ébonite','Bec ébonite avec ligature métal et couvre-bec plastique', 9.70, 11, 7, 'produit15.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (16, 'Sml Accessoires Extracteur d''embouchure','Prend appui sur le boisseau de la branche d''embouchure. Un système de vis sans fin retire l''embouchure coincée.', 39, 12, 7, 'produit16.png');
INSERT INTO produit(pro_id, pro_libelle_court, pro_libelle_long, pro_prix_achat, pro_rub_id, pro_fou_id, pro_photo) VALUES (17, 'Sml Accessoires Embouchure trompette plastique 3C','L''embouchure pour débutant par excellence !', 8.40, 12, 7, 'produit17.png');
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (18, 'CORT EARTH70 NATURAL OPEN PORES', 'CORTE70OP', 'produit18.JPG', 198, 13, 1);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (19, 'TAYLOR GUITARS GS MINI ACAJOU ', 'TAYLORGSMN', 'produit19.JPG', 599, 13, 2);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (20, 'YAMAHA ETUDE C40BL BLACK', 'YAMAHAC40BL', 'produit20.JPG', 140,  14, 3);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (21, 'ALHAMBRA CLASSIC SERIES 4 OP', 'ALHAMBRA7840', 'produit21.JPG', 570,  14, 4);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (22, 'GIBSON ES-335 DOT, ANTIQUE FADED CHERRY', 'GBIESDPFCNH1', 'produit22.JPG', 2749, 15, 5);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (23, 'EAGLETONE PHOENIX MP SUNBURST', 'EAGLETONEPHOENIX', 'produit23.JPG', 129, 15, 7);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (24, 'SIRE MARCUS MILLER V7 SWAMP ASH-5 LH NT MN LH NATUREL', 'MARCUSMILLERMM045K', 'produit24.JPG', 799, 16, 1);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (25, 'IBANEZ SR370EF-BBT BROWN BURST', 'IBANEZSR370EFBBT', 'produit25.JPG', 379, 16, 2);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (32, 'GEWA 3/4 CONTREBASSE ALLEGRO - TABLE MASSIVE', 'GEWA26293', 'produit32.JPG', 1469, 17, 2);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (33, 'NSDESIGN CONTREBASSE ELECTRIQUE 5 CORDES SATIN SUNBURST', 'NSDESIGN2NSNXT5', 'produit33.JPG', 1949, 17, 3);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (34, 'EAGLETONE RIMINI 3/4', 'EAGLETONER34', 'produit34.JPG', 169, 18, 4);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (35, 'YAMAHA 4/4 VIOLON V7SG44', 'KV7SG44', 'produit35.JPG', 687, 18, 5);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (36, 'GEWA 4/4 O.M. MONNICH ENSEMBLES VIOLONCELLE HW', 'GEWA+35731', 'produit36.JPG', 619, 19, 6);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (37, 'HERCULES STANDS STAND VIOLONCELLE DS580B', 'DS580B', 'produit37.JPG', 54, 19, 7);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (38, 'EAGLETONE MPW320 USB', 'EMPW320', 'produit38.JPG', 139, 20, 1);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (39, 'YAMAHA PSR-S670', 'YPSRS670', 'produit39.JPG', 555, 20, 2);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (40, 'BIRD INSTRUMENTS PACK DELUXE XP1 BK', 'BIRDXP1BK', 'produit40.JPG', 399, 21, 3);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (41, 'BIRD INSTRUMENTS DP1 ET BANQUETTE', 'BIRDDP1RW', 'produit41.JPG', 399, 21, 4);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (42, 'AKAI MPK MINI MK2', 'MPKMINI', 'produit42.JPG', 79, 22, 5);
insert into Produit (pro_id, pro_libelle_court, pro_libelle_long, pro_photo, pro_prix_achat, pro_rub_id, pro_fou_id) values (43, 'NATIVE INSTRUMENTS KOMPLETE KONTROL S61 MK2', 'KKS61MK2', 'produit43.JPG', 630, 22, 6);

-- création 30 commandes, n° 17 à 19 retards de paiement, n° 26 et27 partiellement livrés et n°28 à 30 non livrés

insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2016-03-05', '718 Ludington Lane', '5 Jana Pass', '68020 CEDEX', '14074 CEDEX 5', 'Colmar', 'France', 'Caen', 'France', 1, 'soldée', 'livrée 100%', '2016-03-26',1,'2016-04-04');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2019-07-25', '81 Moulton Hill', '96384 Spohn Way', '75100 CEDEX 01', '59425 CEDEX', 'Paris 01', 'France', 'Armentières', 'France', 3, 'soldée', 'livrée 100%', '2019-08-15',2,'2019-08-24');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2016-08-26', '8712 Kropf Place', '92 Lyons Street', '57016 CEDEX 01', '01009 CEDEX', 'Metz', 'France', 'Bourg-en-Bresse', 'France', 2, 'soldée', 'livrée 100%', '2016-09-16',3,'2016-09-25');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2017-06-16', '9954 Rowland Plaza', '86 Ludington Court', '35203 CEDEX 2', '44335 CEDEX 3', 'Rennes', 'France', 'Nantes', 'France', 2, 'soldée', 'livrée 100%', '2017-07-07',4,'2017-07-16');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2017-11-28', '685 Swallow Pass', '85627 Armistice Alley', '26109 CEDEX', '29825 CEDEX 9', 'Romans-sur-Isère', 'France', 'Brest', 'France', 3, 'soldée', 'livrée 100%', '2017-12-19',5,'2017-12-28');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2016-05-02', '66 Springview Street', '685 Chive Place', '94264 CEDEX', '56504 CEDEX', 'Fresnes', 'France', 'Locminé', 'France', 1, 'soldée', 'livrée 100%', '2016-05-23',6,'2016-06-01');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2016-01-31', '6195 Little Fleur Junction', '99 Mariners Cove Hill', '24111 CEDEX', '68504 CEDEX', 'Bergerac', 'France', 'Guebwiller', 'France', 4, 'soldée', 'livrée 100%', '2016-02-21',7,'2016-03-01');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2016-08-01', '6098 Oak Valley Park', '9181 Comanche Parkway', '95974 CEDEX 2', '78990', 'Roissy Charles-de-Gaulle', 'France', 'Élancourt', 'France', 5, 'soldée', 'livrée 100%', '2016-08-22',8,'2016-08-31');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2018-09-21', '160 Linden Place', '688 Barby Center', '75075 CEDEX 02', '26109 CEDEX', 'Paris 02', 'France', 'Romans-sur-Isère', 'France', 5, 'soldée', 'livrée 100%', '2018-10-20',9,'2018-10-21');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2018-08-31', '59165 Bunting Point', '93 Colorado Hill', '94309 CEDEX', '67098 CEDEX 2', 'Vincennes', 'France', 'Strasbourg', 'France', 6, 'soldée', 'livrée 100%', '2018-09-29',10,'2018-09-30');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2019-09-01', '513 Westend Center', '033 Transport Place', '56326 CEDEX', '79021 CEDEX', 'Lorient', 'France', 'Niort', 'France', 6, 'soldée', 'livrée 100%', '2019-09-30',11,'2019-10-01');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2019-01-29', '4471 Emmet Drive', '656 Bayside Lane', '13316 CEDEX 15', '35102 CEDEX 3', 'Marseille', 'France', 'Rennes', 'France', 6, 'soldée', 'livrée 100%', '2019-02-27',12,'2019-02-28');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2017-12-06', '993 Vermont Point', '99 Atwood Trail', '79004 CEDEX', '71024 CEDEX 9', 'Niort', 'France', 'Mâcon', 'France', 6, 'soldée', 'livrée 100%', '2018-01-04',13,'2018-01-05');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2018-03-04', '2 Carberry Lane', '65056 1st Alley', '42021 CEDEX 1', '92709 CEDEX', 'Saint-Étienne', 'France', 'Colombes', 'France', 7, 'soldée', 'livrée 100%', '2018-04-02',14,'2018-04-03');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2018-08-20', '8073 Twin Pines Parkway', '131 Darwin Way', '94685 CEDEX', '84274 CEDEX', 'Vincennes', 'France', 'Vedène', 'France', 7, 'soldée', 'livrée 100%', '2018-09-18',15,'2018-09-19');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2017-11-07', '5514 Lake View Alley', '07643 Eastlawn Terrace', '75166 CEDEX 19', '13540', 'Paris 19', 'France', 'Aix-en-Provence', 'France', 8, 'soldée', 'livrée 100%', '2017-12-06',16,'2017-12-07');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2016-05-04', '72117 Ronald Regan Park', '3 High Crossing Crossing', '67961 CEDEX 9', '12020 CEDEX 9', 'Strasbourg', 'France', 'Rodez', 'France', 9, 'retard de paiement', 'livrée 100%', NULL,17,'2016-06-03');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2019-02-26', '81050 Anderson Circle', '357 Maple Wood Crossing', '91295 CEDEX', '86104 CEDEX', 'Arpajon', 'France', 'Châtellerault', 'France', 10, 'retard de paiement', 'livrée 100%', NULL,18,'2019-03-28');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2019-03-07', '53 North Avenue', '51 Clemons Drive', '75270 CEDEX 06', '93604 CEDEX', 'Paris 06', 'France', 'Aulnay-sous-Bois', 'France', 10, 'retard de paiement', 'livrée 100%', NULL,19,'2019-04-06');
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2018-04-01', '58 Hudson Pass', '255 Becker Junction', '54039 CEDEX', '83164 CEDEX', 'Nancy', 'France', 'La Valette-du-Var', 'France', 11, 'soldée', 'livrée 100%', NULL,20, NULL);
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2019-06-22', '12 Drewry Park', '19 Clyde Gallagher Alley', '92179 CEDEX', '07309 CEDEX', 'Vanves', 'France', 'Tournon-sur-Rhône', 'France', 11, 'soldée', 'livrée 100%', NULL,21, NULL);
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2019-09-17', '03056 Muir Place', '572 Johnson Court', '35605 CEDEX', '93584 CEDEX', 'Redon', 'France', 'Saint-Ouen', 'France', 11, 'soldée', 'livrée 100%', NULL,22, NULL);
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2018-07-25', '7 Riverside Center', '9471 Westridge Road', '13540', '75151 CEDEX 03', 'Aix-en-Provence', 'France', 'Paris 03', 'France', 12,'soldée', 'livrée 100%', NULL,23, NULL);
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2018-10-13', '8 Dwight Hill', '78793 Grayhawk Drive', '13192 CEDEX 20', '80089 CEDEX 2', 'Marseille', 'France', 'Amiens', 'France', 13,'soldée', 'livrée 100%', NULL,24, NULL);
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2018-09-07', '64 Westerfield Lane', '3 Sycamore Center', '72029 CEDEX 2', '75567 CEDEX 12', 'Le Mans', 'France', 'Paris 12', 'France', 13,'soldée', 'livrée 100%', NULL,25, NULL);
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2016-08-21', '0 Waxwing Lane', '0900 Gateway Drive', '72404 CEDEX', '66845 CEDEX', 'La Ferté-Bernard', 'France', 'Perpignan', 'France', 13,'expédiée', 'livrée partiellement', NULL,26, NULL);
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2018-09-10', '6 Merry Drive', '86 Heath Hill', '27022 CEDEX', '25035 CEDEX', 'Évreux', 'France', 'Besançon', 'France', 14,'expédiée', 'livrée partiellement', NULL,27, NULL);
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2017-05-30', '5220 Birchwood Road', '9517 Express Lane', '62036 CEDEX', '60477 CEDEX', 'Arras', 'France', 'Compiègne', 'France', 15,'en préparation', 'à livrer', NULL,28, NULL);
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2017-04-21', '277 Crowley Junction', '38 Mayer Terrace', '37016 CEDEX 1', '64185 CEDEX', 'Tours', 'France', 'Bayonne', 'France', 16,'en préparation', 'à livrer', NULL,29, NULL);
insert into Commande (com_date, com_livraison_rue, com_facture_rue, com_facture_code_postal, com_livraison_code_postal, com_livraison_ville, com_livraison_pays, com_facture_ville, com_facture_pays, com_cli_id, com_etat,com_livraison_avancement,com_paiement_date,com_facture_numero,com_facture_date) values ('2018-08-13', '9 Monica Alley', '1 Mcbride Trail', '94414 CEDEX', '34934 CEDEX 9', 'Saint-Maurice', 'France', 'Montpellier', 'France', 16,'en préparation','à livrer', NULL,30, NULL);

UPDATE commande SET com_paiement_date=com_date,com_facture_date=com_date WHERE com_id=20;
UPDATE commande SET com_paiement_date=com_date,com_facture_date=com_date WHERE com_id=21;
UPDATE commande SET com_paiement_date=com_date,com_facture_date=com_date WHERE com_id=22;
UPDATE commande SET com_paiement_date=com_date,com_facture_date=com_date WHERE com_id=23;
UPDATE commande SET com_paiement_date=com_date,com_facture_date=com_date WHERE com_id=24;
UPDATE commande SET com_paiement_date=com_date,com_facture_date=com_date WHERE com_id=25;
UPDATE commande SET com_paiement_date=com_date,com_facture_date=com_date WHERE com_id=26;
UPDATE commande SET com_paiement_date=com_date,com_facture_date=com_date WHERE com_id=27;
UPDATE commande SET com_paiement_date=com_date,com_facture_date=com_date WHERE com_id=28;
UPDATE commande SET com_paiement_date=com_date,com_facture_date=com_date WHERE com_id=29;
UPDATE commande SET com_paiement_date=com_date,com_facture_date=com_date WHERE com_id=30;

INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (1,1,3);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (2,1,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (2,2,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (3,3,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (4,3,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (5,3,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (4,4,3);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (5,5,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (6,6,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (7,7,3);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (8,8,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (9,9,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (10,10,3);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (11,11,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (12,12,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (13,13,3);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (14,14,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (15,15,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (16,16,3);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (17,17,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (1,18,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (2,19,3);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (3,20,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (4,21,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (5,22,3);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (6,23,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (7,24,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (8,25,3);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (17,25,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (1,26,3);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (9,26,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (2,27,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (10,27,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (3,28,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (11,28,3);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (4,29,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (12,29,2);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (5,30,1);
INSERT INTO posseder (pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (13,30,1);

-- tentative calcul sous-total HT réussie!!!

UPDATE posseder 
JOIN produit ON pos_pro_id=pro_id
JOIN commande ON com_id=pos_com_id
JOIN `CLIENT` ON cli_id=com_cli_id
SET pos_sous_total_HT=pos_quantite_commandee*pro_prix_achat*com_reduction*cli_coefficient;

-- tentative MAJ com_total_HT réussie

UPDATE commande
JOIN posseder ON com_id=pos_com_id
SET com_total_HT=(SELECT SUM(pos_sous_total_HT)
						FROM posseder
						WHERE com_id=pos_com_id
						GROUP BY pos_com_id)
;


-- alimentation table livraison (1 livraison par commande donc liv_id=com_id)

INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (1,(select com_date+3 FROM commande WHERE com_id=1));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (2,(select com_date+3 FROM commande WHERE com_id=2));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (3,(select com_date+3 FROM commande WHERE com_id=3));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (4,(select com_date+3 FROM commande WHERE com_id=4));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (5,'2017-11-30');
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (6,(select com_date+3 FROM commande WHERE com_id=6));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (7,'2016-02-05');
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (8,(select com_date+4 FROM commande WHERE com_id=8));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (9,(select com_date+9 FROM commande WHERE com_id=9));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (10,'2018-09-04');
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (11,(select com_date+4 FROM commande WHERE com_id=11));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (12,'2019-02-02');
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (13,(select com_date+4 FROM commande WHERE com_id=13));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (14,(select com_date+4 FROM commande WHERE com_id=14));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (15,(select com_date+4 FROM commande WHERE com_id=15));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (16,(select com_date+5 FROM commande WHERE com_id=16));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (17,(select com_date+5 FROM commande WHERE com_id=17));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (18,'2019-03-02');
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (19,(select com_date+2 FROM commande WHERE com_id=19)); 
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (20,(select com_date+2 FROM commande WHERE com_id=20));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (21,(select com_date+2 FROM commande WHERE com_id=21));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (22,(select com_date+2 FROM commande WHERE com_id=22));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (23,(select com_date+2 FROM commande WHERE com_id=23));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (24,(select com_date+2 FROM commande WHERE com_id=24));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (25,(select com_date+2 FROM commande WHERE com_id=25));
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (26,(select com_date+2 FROM commande WHERE com_id=26)); -- livraison partielle
INSERT INTO livraison (liv_com_id,liv_datetime) VALUES (27,(select com_date+2 FROM commande WHERE com_id=27)); -- livraison partielle



INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (1,1,3);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (2,1,2);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (2,2,2);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (3,3,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (4,3,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (5,3,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (4,4,3);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (5,5,2);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (6,6,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (8,7,3);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (8,8,2);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (9,9,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (10,10,3);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (11,11,2);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (12,12,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (13,13,3);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (14,14,2);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (15,15,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (16,16,3);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (17,17,2);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (1,18,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (2,19,3);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (3,20,2);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (4,21,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (5,22,3);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (6,23,2);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (7,24,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (8,25,3);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (17,25,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (1,26,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (9,26,2);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (2,27,1);
INSERT INTO contenir (con_pro_id, con_liv_id, con_liv_quantite_BL) VALUES (10,27,1);



-- en attente à ce point

delimiter |

CREATE PROCEDURE Commande_etat(IN _com_id mediumint)

BEGIN
	SELECT com_etat AS 'état de la commande'
	FROM Commande
	WHERE com_id=_com_id;	
END |

delimiter ;

CALL commande_etat(18);

delimiter |

CREATE PROCEDURE Retard_paiement()

BEGIN
	SELECT cli_nom AS 'client en retard de paiement',com_id AS 'numéro de la commande'
	FROM `client`
	JOIN commande ON `client`.cli_id=commande.com_cli_id
	WHERE com_paiement_date IS null;
END |

delimiter ;

CALL retard_paiement();

CREATE VIEW v_produit_fournisseur AS
SELECT * FROM produit
JOIN fournisseur ON fou_id=pro_fou_id;

SELECT * FROM v_produit_fournisseur;

CREATE VIEW v_produit_rubrique AS
SELECT pro_libelle_court, a.rub_nom AS 'sous-rubrique', b.rub_nom AS 'rubrique secondaire', c.rub_nom AS 'rubrique principal' FROM produit
JOIN rubrique a ON a.rub_id=pro_rub_id
JOIN rubrique b ON a.rub_id_1=b.rub_id
JOIN rubrique c ON b.rub_id_1=c.rub_id;


SELECT * FROM v_produit_rubrique;

SHOW CREATE VIEW v_produit_fournisseur;

-- Requête 1 CA par mois pour une année selectionnée

SELECT  MONTH(com_date) AS 'Mois 2018', SUM(com_total_HT) AS 'Montant Ventes HT'
FROM Commande
WHERE YEAR(com_date)=2018
GROUP BY MONTH(com_date);

-- Requête 2 CA généré par fournisseur

SELECT fou_nom AS 'nom fournisseur', SUM(com_total_HT) AS 'CA'
FROM commande
JOIN posseder ON com_id=pos_com_id
JOIN produit ON pos_pro_id=pro_id
JOIN fournisseur ON pro_fou_id=fou_id
GROUP BY fou_id;

-- Requête 3 top 10 des produits les plus commandées pour une année

SELECT pro_id AS 'numéro produit', pro_libelle_court AS 'nom produit', SUM(pos_quantite_commandee) AS 'quantité commandée',fou_nom AS 'nom fournisseur'
FROM posseder
JOIN produit ON pos_pro_id=pro_id
JOIN fournisseur ON pro_fou_id=fou_id
GROUP BY pro_id
ORDER BY SUM(pos_quantite_commandee) DESC
LIMIT 10;

-- Requête 4 top 10 des produits rémunérateurs

SELECT pro_id AS 'numéro produit', pro_libelle_court AS 'nom produit', ROUND((SUM(pos_sous_total_HT)-(SUM(pos_quantite_commandee)*pro_prix_achat)),2) AS 'marge produit',fou_nom AS 'nom fournisseur'
FROM posseder
JOIN produit ON pos_pro_id=pro_id
JOIN fournisseur ON pro_fou_id=fou_id
GROUP BY pro_id
ORDER BY (SUM(pos_sous_total_HT)-(SUM(pos_quantite_commandee)*pro_prix_achat)) DESC
LIMIT 10;

-- Requêtes 5 top 10 clients en nombre de commande

SELECT cli_nom AS 'nom client', COUNT(com_id) AS 'nombre de commande passée'
FROM `client`
JOIN commande ON cli_id=com_cli_id
GROUP BY cli_id
ORDER BY COUNT(com_id) DESC
LIMIT 10;

-- Requête 6 top 10 clients en CA

SELECT cli_nom AS 'nom client', sum(com_total_HT) AS 'CA'
FROM `client`
JOIN commande ON cli_id=com_cli_id
GROUP BY cli_id
ORDER BY sum(com_total_HT) DESC
LIMIT 10;

-- requête 7 répartition CA par type de client

SELECT cli_statut AS 'statut client', sum(com_total_HT) AS 'CA'
FROM `client`
JOIN commande ON cli_id=com_cli_id
GROUP BY cli_statut
ORDER BY sum(com_total_HT) DESC;

-- requête 8 nombre de commande en cours de livraison

SELECT COUNT(com_id) AS 'nombre de commande en cours de livraison'
FROM commande
WHERE com_livraison_avancement NOT LIKE 'livrée 100%';

CREATE VIEW vue1 AS 
SELECT com_id,pro_id,pos_quantite_commandee
FROM commande
JOIN posseder ON pos_com_id=com_id
JOIN produit ON pos_pro_id=pro_id;

CREATE VIEW vue2 AS 
SELECT com_id,pro_id,con_liv_quantite_BL
FROM contenir
join livraison ON liv_id=con_liv_id
join commande ON com_id=liv_com_id
JOIN produit ON con_pro_id=pro_id;

SELECT * 
FROM vue1
left JOIN vue2 ON vue1.com_id=vue2.com_id AND vue1.pro_id=vue2.pro_id
WHERE pos_quantite_commandee>con_liv_quantite_BL;


 








