-- création d'un trigger pour calculer le sous_total_HT de la table posséder

DROP TRIGGER if exists maj_pos_sous_total_ht;

DELETE FROM posseder;

delimiter $
CREATE TRIGGER maj_pos_sous_total_ht BEFORE INSERT ON posseder
    FOR EACH ROW
    BEGIN
        DECLARE _pos_id INT;
        DECLARE _pro_id INT;
        DECLARE _com_id INT;
        DECLARE _pos_sous_total_ht DOUBLE;
        SET _pos_id = new.pos_id; 
        SET _pro_id = new.pos_pro_id; 
        SET _com_id = new.pos_com_id; 
        SET _pos_sous_total_ht = (SELECT pro_prix_achat*com_reduction*cli_coefficient*pos_quantite_commandee
		  FROM produit
		  JOIN posseder ON pro_id=pos_pro_id
		  JOIN commande ON com_id=pos_com_id
		  JOIN `client` ON cli_id=com_cli_id
		  WHERE pos_com_id=_com_id AND pos_pro_id=_pro_id); 
        SET new.pos_sous_total_ht=_pos_sous_total_ht;
	END $

delimiter ;

INSERT INTO posseder(pos_pro_id, pos_com_id, pos_quantite_commandee) VALUES (2, 1, 1);

SELECT round(pro_prix_achat*com_reduction*cli_coefficient*pos_quantite_commandee,2)
		  FROM produit
		  JOIN posseder ON pro_id=pos_pro_id
		  JOIN commande ON com_id=pos_com_id
		  JOIN `client` ON cli_id=com_cli_id
	