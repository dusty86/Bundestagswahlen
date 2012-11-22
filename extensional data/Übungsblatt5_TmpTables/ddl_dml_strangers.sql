# strange direktkandidaten

CREATE TABLE tmp_direktkandidaten_strange AS
SELECT t.* 
  FROM tmp_direktkandidaten t
 WHERE t.partei_fk = 'OHNE PARTEI' # direktkandidaten ohne partei
    OR NOT EXISTS (SELECT l.*
                     FROM landesliste l
                    WHERE l.partei_fk = t.partei_fk
                      AND l.bundesland_fk = t.bundesland_fk
                      AND l.bundestagswahl = t.wahljahr) # direktkandidaten aus bundesland, wo dessen partei keine landesliste hat
	 OR ( ((SELECT be.prozent
              FROM tmp_bunderg be
             WHERE be.partei_fk = t.partei_fk
               AND be.wahljahr = t.wahljahr) < 5) AND
          ((SELECT count(*)
              FROM tmp_direktkandidaten td
             WHERE td.partei_fk = t.partei_fk
               AND td.wahljahr = t.wahljahr) < 3)); 
    		# direktkandidaten aus einer Partei, die gesperrt ist (unter 5% in tmp_bunderg, weniger als 3 direktmandate)
    		
ALTER TABLE `bundestagswahlen`.`tmp_direktkandidaten_strange`   
    ADD PRIMARY KEY (`wahlkreis_nr`, `wahljahr`);
