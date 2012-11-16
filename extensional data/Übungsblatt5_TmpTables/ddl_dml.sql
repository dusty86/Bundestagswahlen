# zählt erstimmen pro kandidat pro wahlkreis pro wahljahr
CREATE TABLE tmp_wkerg AS
SELECT k.nr kandidat_nr, k.nachname, k.vorname, k.partei_fk, w.nr wahlkreis_nr, w.name wahlkreis_name, w.bundestagswahl wahljahr, w.bundesland_fk, COUNT(*) stimmen
  FROM kandidat k JOIN erststimme e ON k.nr = e.kandidat_fk
                  JOIN wahlkreis w ON e.wahlkreis_nr_fk = w.nr AND w.bundestagswahl = e.wahlkreis_bundestagswahl_fk
 GROUP BY k.nr , k.nachname, k.vorname, k.partei_fk, w.nr, w.name, w.bundestagswahl, w.bundesland_fk;
  
# ermittelt die durch erststimmen gewählten direktkandidaten pro wahlkreis pro wahljahr  
CREATE TABLE tmp_direktkandidaten AS 
SELECT erg1.kandidat_nr, erg1.nachname, erg1.vorname, erg1.partei_fk, erg1.wahlkreis_nr, erg1.wahlkreis_name, erg1.wahljahr, erg1.bundesland_fk, erg1.stimmen
  FROM tmp_wkerg erg1
 WHERE erg1.stimmen = (SELECT MAX(erg2.stimmen)
                         FROM tmp_wkerg erg2
                        WHERE erg2.wahlkreis_nr = erg1.wahlkreis_nr
                          AND erg2.wahljahr = erg1.wahljahr);
						  

ALTER TABLE `bundestagswahlen`.`tmp_wkerg`   
  DROP PRIMARY KEY,
  ADD PRIMARY KEY (`kandidat_nr`, `wahljahr`);
						  
ALTER TABLE `bundestagswahlen`.`tmp_direktkandidaten`   
  DROP PRIMARY KEY,
  ADD PRIMARY KEY (`wahlkreis_nr`, `wahljahr`);