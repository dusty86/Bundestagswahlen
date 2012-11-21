DELIMITER $$

USE `bundestagswahlen`$$

DROP PROCEDURE IF EXISTS `calculate_unterverteilung`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_unterverteilung`(IN bundestagswahl INT)
BEGIN
	
	# declarations
        DECLARE partei VARCHAR(100);
        DECLARE bundesland VARCHAR(100);
        DECLARE seats INT DEFAULT 0;
	DECLARE votes INT DEFAULT 0;
        DECLARE divisor DECIMAL(10,1) DEFAULT 0.5;
        DECLARE rowcount INT DEFAULT 0;
        DECLARE rowcount2 INT DEFAULT 0;
	DECLARE i INT DEFAULT 0;
	DECLARE j INT DEFAULT 0;  
	DECLARE k INT DEFAULT 0; 
    
	# cursor for oberverteilung
        DECLARE oberverteilungCursor CURSOR FOR	
	SELECT o.partei_fk, o.sitze
	  FROM tmp_oberverteilung o 
	 WHERE o.wahljahr = bundestagswahl
	   AND o.partei_fk != 'CSU/CDU';
	 
	# cursor for unterverteilung_punkte
        DECLARE unterverteilung_punkteCursor CURSOR FOR	
	SELECT tp.partei_fk, tp.bundesland_fk
	  FROM tmp_unterverteilung_punkte tp
	  WHERE tp.wahljahr = bundestagswahl
	  ORDER BY tp.punkte DESC;
	 
	
	#delete content of temporary tables
	DELETE FROM tmp_unterverteilung2 WHERE wahljahr = bundestagswahl;
	DELETE FROM tmp_unterverteilung_punkte WHERE wahljahr = bundestagswahl;
        
        # open cursor oberverteilung
        OPEN oberverteilungCursor;
        SELECT FOUND_ROWS() INTO rowcount;
        
        REPEAT # iterate over oberverteilung entries
        
           FETCH oberverteilungCursor INTO partei, seats;
           
		NESTED_BLOCK: BEGIN
		
			# cursor for bundesland
			DECLARE landergCursor CURSOR FOR 
			SELECT bundesland_fk, stimmen 
			  FROM tmp_landerg 
			 WHERE partei_fk = partei AND wahljahr = bundestagswahl;
		   
			# open cursor landerg
			OPEN landergCursor;
			SELECT FOUND_ROWS() INTO rowcount2;
									
			SET k = 0;
			
			REPEAT # iterate over landerg entries
		
				FETCH landergCursor INTO bundesland, votes;		
		   
				SET divisor = 0.5;
				SET j = 0;
				   
				# insert start tmp_unterverteilung entry
				INSERT INTO tmp_unterverteilung2 VALUES (partei, bundesland, 0, bundestagswahl);
				   
				REPEAT # calculate tmp_unterverteilung_punkte by iterating over amount of seats
									
					INSERT INTO tmp_unterverteilung_punkte (partei_fk, bundesland_fk, punkte, wahljahr) VALUES (partei, bundesland, FLOOR((votes / divisor)), bundestagswahl);
				   
					SET divisor = divisor + 1.0;	      
					SET j = j + 1;	      
				   
				UNTIL j = seats END REPEAT;
			
				SET k = k + 1;
			
			UNTIL k = rowcount2 END REPEAT;	   
			
			# close cursor landerg	   
			CLOSE landergCursor;
		
		END NESTED_BLOCK;
           
           SET i = i + 1;
           
        UNTIL i = rowcount END REPEAT;
        
	# reset counters
        SET j = 0;
        SET i = 0;
        SET k = 0;
	
	# close cursor oberverteilung
        CLOSE oberverteilungCursor;    
		
        
        # calculate tmp_unterverteilung
	# open cursor unterverteilung_punkte
        OPEN unterverteilung_punkteCursor;
        
        REPEAT # iterate over partei_stimmen entreies
        
	   FETCH unterverteilung_punkteCursor INTO partei, bundesland;
	   
	   UPDATE tmp_unterverteilung2 SET sitze = sitze + 1 WHERE partei_fk = partei AND bundesland_fk = bundesland AND wahljahr = bundestagswahl;
	   
	   SET j = j + 1;
	   
	UNTIL j = seats END REPEAT;  
	
	# close cursor unterverteilung_punkte
        CLOSE unterverteilung_punkteCursor; 
        
        # remove empty bundesländer from unterverteilung       
        DELETE FROM tmp_unterverteilung2 WHERE sitze = 0 AND wahljahr = bundestagswahl;
	 
    END$$

DELIMITER ;