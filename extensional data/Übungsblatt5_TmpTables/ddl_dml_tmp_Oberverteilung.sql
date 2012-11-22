CREATE TABLE tmp_oberverteilung(
partei_fk VARCHAR(200) REFERENCES partei,
sitze INTEGER,
wahljahr INTEGER REFERENCES `bundestagswahl`,
PRIMARY KEY (partei_fk, wahljahr));