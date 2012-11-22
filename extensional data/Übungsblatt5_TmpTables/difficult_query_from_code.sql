# select parties that are used for oberverteilung calculation
SELECT t1.partei_fk, t1.stimmen, t1.prozent 
FROM tmp_bunderg t1
WHERE (prozent >=5 OR (
SELECT count(*) 
FROM tmp_direktkandidaten t2
WHERE t1.partei_fk = t2.partei_fk
AND t1.wahljahr = t2.wahljahr) >= 3)
AND t1.wahljahr = 2009;


# get the list candidates
SELECT k.nr, k.nachname, k.vorname, k.geburtsjahr, k.listenrang, k.partei_fk, k.landesliste_nr_fk, k.wahlkreis_nr_fk 
FROM kandidat k JOIN landesliste l ON l.nr = k.`landesliste_nr_fk`
WHERE k.partei_fk = 'CDU' 
AND l.`bundestagswahl` = 2009
AND l.`bundesland_fk` = 'SH'
AND k.`nr` NOT IN (
SELECT t.`kandidat_nr` FROM `tmp_direktkandidaten` t)
ORDER BY k.listenrang
LIMIT 5


# get rid of CSU/CDU MESS
UPDATE `tmp_unterverteilung`
SET partei_fk = 'CSU'
WHERE partei_fk ='CSU/CDU' AND
bundesland_fk = 'BY';

UPDATE `tmp_unterverteilung`
SET partei_fk = 'CDU'
WHERE partei_fk ='CSU/CDU' AND
bundesland_fk <> 'BY';


# get seats after filling
SELECT k.partei_fk, count(*) FROM kandidat k JOIN mandat m ON k.`nr`=m.`kandidat_fk`
GROUP BY k.`partei_fk`;