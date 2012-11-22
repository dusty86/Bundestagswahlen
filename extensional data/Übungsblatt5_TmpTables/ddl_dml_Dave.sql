# aggregiert die Zweitstimmen für jede Landesliste
CREATE TABLE tmp_listerg AS
SELECT landesliste_nr_fk, COUNT(*) AS stimmen, wahlkreis_bundestagswahl_fk AS wahljahr
FROM zweitstimme
WHERE gueltig = 1
GROUP BY landesliste_nr_fk;
  
ALTER TABLE `bundestagswahlen`.`tmp_listerg`   
  ADD PRIMARY KEY (`landesliste_nr_fk`, `wahljahr`);

# aggregiert die Zweitstimmen für jedes Bundesland (mit Prozent), baut auf tmp_landerg1 auf
DROP TABLE IF EXISTS tmp_landerg;
CREATE TABLE tmp_landerg AS
SELECT l.partei_fk, l.bundesland_fk, SUM(t.Stimmen) AS stimmen, 
CAST((SUM(t.Stimmen) * 100 / (SELECT SUM(t2.stimmen) FROM landesliste l2 JOIN tmp_listerg t2 ON l2.nr = t2.landesliste_nr_fk 
WHERE l.bundesland_fk = l2.bundesland_fk AND t2.wahljahr = t.wahljahr)) AS DECIMAL(4,2)) AS prozent,
t.wahljahr AS wahljahr
FROM landesliste l JOIN tmp_listerg t ON l.nr = t.landesliste_nr_fk
GROUP BY l.partei_fk, l.bundesland_fk, t.wahljahr;

ALTER TABLE `bundestagswahlen`.`tmp_landerg`   
  ADD PRIMARY KEY (`partei_fk`, `bundesland_fk`, `wahljahr`);

#aggregiert die Zweitstimme für ganz Deutschland (mit Prozent), baut auf tmp_landerg auf
DROP TABLE IF EXISTS tmp_bunderg;
CREATE TABLE tmp_bunderg AS
SELECT t1.partei_fk, SUM(t1.stimmen) AS stimmen, 
	CAST(SUM(t1.stimmen) * 100 / (
	SELECT SUM(t2.stimmen) 
		FROM tmp_landerg t2 
		WHERE t2.wahljahr=t1.wahljahr)
	AS DECIMAL(4,2)) AS prozent, t1.wahljahr
FROM tmp_landerg t1
GROUP BY t1.partei_fk, t1.wahljahr;

    
ALTER TABLE `bundestagswahlen`.`tmp_bunderg`   
  ADD PRIMARY KEY (`partei_fk`, `wahljahr`);