# zählt erstimmen pro kandidat pro wahlkreis pro wahljahr
CREATE TABLE tmp_wkerg AS
SELECT k.nr kandidat_nr, k.nachname, k.vorname, k.partei_fk, w.nr wahlkreis_nr, w.name wahlkreis_name, w.bundestagswahl wahljahr, w.bundesland_fk, COUNT(*) stimmen
  FROM kandidat k JOIN erststimme e ON k.nr = e.kandidat_fk
                  JOIN wahlkreis w ON e.wahlkreis_nr_fk = w.nr AND w.bundestagswahl = e.wahlkreis_bundestagswahl_fk
 GROUP BY k.nr , k.nachname, k.vorname, k.partei_fk, w.nr, w.name, w.bundestagswahl, w.bundesland_fk;
 
 ALTER TABLE `bundestagswahlen`.`tmp_wkerg`   
  DROP PRIMARY KEY,
  ADD PRIMARY KEY (`kandidat_nr`, `wahljahr`);
  
  
# ermittelt die durch erststimmen gewählten direktkandidaten pro wahlkreis pro wahljahr  
CREATE TABLE tmp_direktkandidaten AS 
SELECT erg1.kandidat_nr, erg1.nachname, erg1.vorname, erg1.partei_fk, erg1.wahlkreis_nr, erg1.wahlkreis_name, erg1.wahljahr, erg1.bundesland_fk, erg1.stimmen
  FROM tmp_wkerg erg1
 WHERE erg1.stimmen = (SELECT MAX(erg2.stimmen)
                         FROM tmp_wkerg erg2
                        WHERE erg2.wahlkreis_nr = erg1.wahlkreis_nr
                          AND erg2.wahljahr = erg1.wahljahr);
						  
 ALTER TABLE `bundestagswahlen`.`tmp_direktkandidaten`   
  DROP PRIMARY KEY,
  ADD PRIMARY KEY (`wahlkreis_nr`, `wahljahr`);
						  
						  
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
              AND td.wahljahr = t.wahljahr) < 3)); # direktkandidaten aus einer Partei, die gesperrt ist (unter 5% in tmp_bunderg, weniger als 3 direktmandate)
						  
ALTER TABLE `bundestagswahlen`.`tmp_direktkandidaten_strange`   
  DROP PRIMARY KEY,
  ADD PRIMARY KEY (`wahlkreis_nr`, `wahljahr`);