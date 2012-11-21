DELIMITER $$

USE `bundestagswahlen`$$

DROP PROCEDURE IF EXISTS `calculate_oberverteilung`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_oberverteilung`(IN seats INT, IN bundestagswahl INT)
BEGIN
	
	# declarations
        DECLARE partei VARCHAR(100);
        DECLARE stimmen INT DEFAULT 0;
        DECLARE strangers INT DEFAULT 0;
        DECLARE divisor DECIMAL(10,1) DEFAULT 0.5;
	DECLARE rowcount INT DEFAULT 0;
	DECLARE i INT DEFAULT 0;
	DECLARE j INT DEFAULT 0;   
    
	# cursor for partei and stimmen
        DECLARE partei_stimmenCursor CURSOR FOR	
	SELECT t1.partei_fk, t1.stimmen
	  FROM tmp_bunderg t1 
	 WHERE (prozent >=5 OR 
	       (SELECT COUNT(*) 
	          FROM tmp_direktkandidaten t2 
	         WHERE t1.partei_fk = t2.partei_fk 
	           AND t1.wahljahr = t2.wahljahr) >= 3) 
	   AND t1.wahljahr = bundestagswahl;
	   
	# cursor for oberverteilung_punkte
        DECLARE oberverteilung_punkteCursor CURSOR FOR	
	SELECT tp.partei_fk
	  FROM tmp_oberverteilung_punkte tp
	  WHERE tp.wahljahr = bundestagswahl
	  ORDER BY tp.punkte DESC;
	  
	# fetch amount of strange candidates and substract from sitze
	SELECT COUNT(*) INTO strangers
	  FROM tmp_direktkandidaten_strange WHERE wahljahr = bundestagswahl;
	  
	SET seats = seats - strangers;
	
	#delete content of temporary tables
	DELETE FROM tmp_oberverteilung_punkte WHERE wahljahr = bundestagswahl;
        DELETE FROM tmp_oberverteilung WHERE wahljahr = bundestagswahl;
        
        # calculate tmp_oberverteilung_punkte
	# open cursor partei_stimmen
        OPEN partei_stimmenCursor;
        SELECT FOUND_ROWS() INTO rowcount;
        
        REPEAT # iterate over partei_stimmen entreies
        
           FETCH partei_stimmenCursor INTO partei, stimmen;
	   
	   SET divisor = 0.5;
	   SET j = 0;
	   
	   # insert start tmp_oberverteilung entry
	   INSERT INTO tmp_oberverteilung VALUES (partei, 0, bundestagswahl);
	   
	   REPEAT # calculate tmp_oberverteilung_punkte by iterating over amount of seats
	   
	      INSERT INTO tmp_oberverteilung_punkte (partei_fk, punkte, wahljahr) VALUES (partei, FLOOR((stimmen / divisor)), bundestagswahl);
	   
              SET divisor = divisor + 1.0;	      
	      SET j = j + 1;	      
           
           UNTIL j = seats END REPEAT;
           
           SET i = i + 1;
           
        UNTIL i = rowcount END REPEAT;
        
        # reset counters
        SET j = 0;
        SET i = 0;
	
	# close cursor partei_stimmen
        CLOSE partei_stimmenCursor;    
		
        
        # calculate tmp_oberverteilung
	# open cursor oberverteilung_punkte
        OPEN oberverteilung_punkteCursor;
        
        REPEAT # iterate over partei_stimmen entreies
        
	   FETCH oberverteilung_punkteCursor INTO partei;
	   
	   UPDATE tmp_oberverteilung SET sitze = sitze + 1 WHERE partei_fk = partei AND wahljahr = bundestagswahl;
	   
	   SET j = j + 1;
	   
	UNTIL j = seats END REPEAT;  
	
	# close cursor oberverteilung_punkte
        CLOSE oberverteilung_punkteCursor; 
	 
    END$$

DELIMITER ;