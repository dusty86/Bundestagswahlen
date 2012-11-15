select kandidat_fk, sum(gueltig), wahlkreis_nr_fk, wahlkreis_bundestagswahl_fk from erststimme
group by kandidat_fk, wahlkreis_nr_fk, wahlkreis_bundestagswahl_fk;