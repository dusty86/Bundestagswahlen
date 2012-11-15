/*Table structure for table `erststimme` */

DROP TABLE IF EXISTS `erststimme`;

CREATE TABLE `erststimme` (
  `nr` int(11) NOT NULL AUTO_INCREMENT,
  `gueltig` tinyint(1) NOT NULL,
  `kandidat_fk` int(11) NOT NULL,
  `wahlkreis_nr_fk` int(11) NOT NULL,
  `wahlkreis_bundestagswahl_fk` int(11) NOT NULL,
  PRIMARY KEY (`nr`),
  KEY `erst_wahlb_fk` (`wahlkreis_nr_fk`),
  KEY `erst_kand_fk` (`kandidat_fk`),
  KEY `erst_wahl_fk` (`wahlkreis_nr_fk`,`wahlkreis_bundestagswahl_fk`),
  CONSTRAINT `erst_kand_fk` FOREIGN KEY (`kandidat_fk`) REFERENCES `kandidat` (`nr`),
  CONSTRAINT `erst_wahl_fk` FOREIGN KEY (`wahlkreis_nr_fk`, `wahlkreis_bundestagswahl_fk`) REFERENCES `wahlkreis` (`nr`, `bundestagswahl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `zweitstimme` */

DROP TABLE IF EXISTS `zweitstimme`;

CREATE TABLE `zweitstimme` (
  `nr` int(11) NOT NULL AUTO_INCREMENT,
  `gueltig` tinyint(1) NOT NULL,
  `landesliste_nr_fk` int(11) NOT NULL,
  `landesliste_bundestagswahl_fk` int(11) NOT NULL,
  `wahlkreis_nr_fk` int(11) NOT NULL,
  `wahlkreis_bundestagswahl_fk` int(11) NOT NULL,
  PRIMARY KEY (`nr`),
  KEY `zweit_land_fk` (`landesliste_nr_fk`),
  KEY `zweit_landes_fk` (`landesliste_nr_fk`,`landesliste_bundestagswahl_fk`),
  KEY `zweit_wahl_fk` (`wahlkreis_nr_fk`,`wahlkreis_bundestagswahl_fk`),
  CONSTRAINT `zweit_landes_fk` FOREIGN KEY (`landesliste_nr_fk`, `landesliste_bundestagswahl_fk`) REFERENCES `landesliste` (`nr`, `bundestagswahl`),
  CONSTRAINT `zweit_wahl_fk` FOREIGN KEY (`wahlkreis_nr_fk`, `wahlkreis_bundestagswahl_fk`) REFERENCES `wahlkreis` (`nr`, `bundestagswahl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;