CREATE TABLE tmp_unterverteilung(
partei_fk VARCHAR(200) REFERENCES partei,
bundesland_fk VARCHAR(2) REFERENCES bundesland,
sitze INTEGER, 
wahljahr INTEGER REFERENCES `bundestagswahl`,
PRIMARY KEY (partei_fk, bundesland_fk, wahljahr));