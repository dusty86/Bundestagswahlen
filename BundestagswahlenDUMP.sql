/*
SQLyog Community v10.3 
MySQL - 5.5.15 : Database - bundestagswahlen
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`bundestagswahlen` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `bundestagswahlen`;

/*Table structure for table `bundesland` */

DROP TABLE IF EXISTS `bundesland`;

CREATE TABLE `bundesland` (
  `akronym` varchar(2) NOT NULL,
  `name` varchar(100) NOT NULL,
  `bevoelkerung` int(11) NOT NULL,
  PRIMARY KEY (`akronym`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bundesland` */

insert  into `bundesland`(`akronym`,`name`,`bevoelkerung`) values ('BB','Brandenburg',2503000),('BE','Berlin',3461000),('BW','Baden-Württemberg',10754000),('BY','Bayern',12539000),('HB','Bremen',661000),('HE','Hessen',6067000),('HH','Hamburg',1786000),('MV','Mecklenburg-Vorpommern',1642000),('NI','Niedersachsen',7918000),('NW','Nordrhein-Westfalen',17845000),('RP','Rheinland-Pfalz',4004000),('SH','Schleswig-Holstein',2834000),('SL','Saarland',1018000),('SN','Sachsen',4149000),('ST','Sachsen-Anhalt',2335000),('TH','Thüringen',2235000);

/*Table structure for table `bundestag` */

DROP TABLE IF EXISTS `bundestag`;

CREATE TABLE `bundestag` (
  `legislatur` int(11) NOT NULL,
  `notizen` varchar(200) DEFAULT NULL,
  `bundestagswahl_fk` int(11) NOT NULL,
  PRIMARY KEY (`legislatur`),
  KEY `bundt_bundw` (`bundestagswahl_fk`),
  CONSTRAINT `bundt_bundw` FOREIGN KEY (`bundestagswahl_fk`) REFERENCES `bundestagswahl` (`jahr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bundestag` */

/*Table structure for table `bundestagswahl` */

DROP TABLE IF EXISTS `bundestagswahl`;

CREATE TABLE `bundestagswahl` (
  `jahr` int(11) NOT NULL,
  PRIMARY KEY (`jahr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `bundestagswahl` */

/*Table structure for table `erststimme` */

DROP TABLE IF EXISTS `erststimme`;

CREATE TABLE `erststimme` (
  `nr` int(11) NOT NULL AUTO_INCREMENT,
  `gueltig` bit(1) NOT NULL,
  `kandidat_fk` int(11) NOT NULL,
  `wahlbezirk_fk` int(11) NOT NULL,
  PRIMARY KEY (`nr`),
  KEY `erst_wahlb_fk` (`wahlbezirk_fk`),
  KEY `erst_kand_fk` (`kandidat_fk`),
  CONSTRAINT `erst_kand_fk` FOREIGN KEY (`kandidat_fk`) REFERENCES `kandidat` (`nr`),
  CONSTRAINT `erst_wahlb_fk` FOREIGN KEY (`wahlbezirk_fk`) REFERENCES `wahlbezirk` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `erststimme` */

/*Table structure for table `kandidat` */

DROP TABLE IF EXISTS `kandidat`;

CREATE TABLE `kandidat` (
  `nr` int(11) NOT NULL AUTO_INCREMENT,
  `vorname` varchar(200) NOT NULL,
  `nachname` varchar(200) NOT NULL,
  `geburtsdatum` date NOT NULL,
  `listenrang` int(11) DEFAULT NULL,
  `typ` varchar(200) DEFAULT NULL,
  `partei_fk` int(11) DEFAULT NULL,
  `wahlbezirk_fk` int(11) DEFAULT NULL,
  `landesliste_fk` int(11) DEFAULT NULL,
  PRIMARY KEY (`nr`),
  KEY `kand_part_fk` (`partei_fk`),
  KEY `kand_land_fk` (`landesliste_fk`),
  KEY `kand_wahlb_fk` (`wahlbezirk_fk`),
  CONSTRAINT `kand_land_fk` FOREIGN KEY (`landesliste_fk`) REFERENCES `landesliste` (`nr`),
  CONSTRAINT `kand_part_fk` FOREIGN KEY (`partei_fk`) REFERENCES `partei` (`nr`),
  CONSTRAINT `kand_wahlb_fk` FOREIGN KEY (`wahlbezirk_fk`) REFERENCES `wahlbezirk` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `kandidat` */

/*Table structure for table `landesliste` */

DROP TABLE IF EXISTS `landesliste`;

CREATE TABLE `landesliste` (
  `nr` int(11) NOT NULL,
  `notizen` varchar(200) DEFAULT NULL,
  `partei_fk` int(11) NOT NULL,
  `bundesland_fk` varchar(2) NOT NULL,
  PRIMARY KEY (`nr`),
  KEY `land_part_fk` (`partei_fk`),
  KEY `land_bl_fk` (`bundesland_fk`),
  CONSTRAINT `land_bl_fk` FOREIGN KEY (`bundesland_fk`) REFERENCES `bundesland` (`akronym`),
  CONSTRAINT `land_part_fk` FOREIGN KEY (`partei_fk`) REFERENCES `partei` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `landesliste` */

/*Table structure for table `mandat` */

DROP TABLE IF EXISTS `mandat`;

CREATE TABLE `mandat` (
  `nr` int(11) NOT NULL AUTO_INCREMENT,
  `typ` varchar(20) NOT NULL,
  `notizen` varchar(200) DEFAULT NULL,
  `bundestag_fk` int(11) NOT NULL,
  `kandidat_fk` int(11) NOT NULL,
  PRIMARY KEY (`nr`),
  KEY `mand_kand_fk` (`kandidat_fk`),
  KEY `mand_bund_fk` (`bundestag_fk`),
  CONSTRAINT `mand_bund_fk` FOREIGN KEY (`bundestag_fk`) REFERENCES `bundestag` (`legislatur`),
  CONSTRAINT `mand_kand_fk` FOREIGN KEY (`kandidat_fk`) REFERENCES `kandidat` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `mandat` */

/*Table structure for table `partei` */

DROP TABLE IF EXISTS `partei`;

CREATE TABLE `partei` (
  `nr` int(11) NOT NULL AUTO_INCREMENT,
  `akronym` varchar(200) NOT NULL,
  `name` varchar(200) NOT NULL,
  `gruendungsjahr` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`nr`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;

/*Data for the table `partei` */

insert  into `partei`(`nr`,`akronym`,`name`,`gruendungsjahr`) values (1,'SPD','Sozialdemokratische Partei Deutschlands','1875'),(2,'CDU','Christlich Demokratische Union Deutschlands','1945'),(3,'CSU','Christlich-Soziale Union in Bayern','1945'),(4,'DIE LINKE','Die Linke','2007'),(5,'FDP','Freie Demokratische Partei','1948'),(6,'GRÜNE','Bündnis 90/Die Grünen','1980'),(7,'PIRATEN','Piratenpartei Deutschland','2006'),(8,'Die PARTEI','Partei für Arbeit, Rechtsstaat, Tierschutz, Elitenförderung und basisdemokratische Initiative','2004'),(9,'ÖDP','Ökologisch-Demokratische Partei','1982'),(10,'REP','Die Republikaner','1983'),(11,'NPD','Nationaldemokratische Partei Deutschlands','1964'),(12,'FREIE WÄHLER','Freie Wähler','2009'),(13,'DKP','Deutsche Kommunistische Partei','1968'),(14,'BP','Bayernpartei','1946'),(15,'SSW','Südschleswigscher Wählerverband','1948'),(16,'PBC','Partei Bibeltreuer Christen','1989'),(17,'MLPD','Marxistisch-Leninistische Partei Deutschlands','1982'),(18,'RRP','Rentnerinnen- und Rentner-Partei','2007'),(19,'BüSo','Bürgerrechtsbewegung Solidarität','1992'),(20,'DIE FREIHEIT','Bürgerrechtspartei für mehr Freiheit und Demokratie – Die Freiheit','2010'),(21,'DSU','Deutsche Soziale Union','1990'),(22,'Die Tierschutzpartei','Partei Mensch Umwelt Tierschutz','1993'),(23,'pdv','Partei der Vernunft','2009'),(24,'pro NRW','Bürgerbewegung pro NRW','2007'),(25,'DIE FRAUEN','Feministische Partei Die Frauen','1995'),(26,'Die Violetten','Die Violetten – für spirituelle Politik','2001'),(27,'ZENTRUM','Deutsche Zentrumspartei','1870'),(28,'FAMILIE','Familien-Partei Deutschlands','1981'),(29,'AUF','AUF – Partei für Arbeit, Umwelt und Familie','2008'),(30,'Volksabstimmung','Ab jetzt…Bündnis für Deutschland','n.a.'),(31,'CM','CHRISTLICHE MITTE - Für ein Deutschland nach GOTTES Geboten','1988'),(32,'BIG','Bündnis für Innovation und Gerechtigkeit','2010'),(33,'HUMANWIRTSCHAFT','Humanwirtschaftspartei','1950'),(34,'RENTNER','Rentner Partei Deutschland','2002'),(35,'B','Bergpartei, die „ÜberPartei“','2011'),(36,'BGD','Bund für Gesamtdeutschland Ostdeutsche, Mittel- und Westdeutsche Wählergemeinschaft Die neue deutsche Mitte','1991'),(37,'FU','Freie Union','2009'),(38,'PSG','Partei für Soziale Gleichheit, Sektion der Vierten Internationale','1997'),(39,'FWD','Freie Wähler Deutschland','2009'),(40,'KPD','Kommunistische Partei Deutschlands','1990'),(41,'pro Deutschland','Bürgerbewegung pro Deutschland','2005'),(42,'GRAUE','Die Grauen – Generationspartei','2008'),(43,'SVP','Sächsische Volkspartei','2006'),(44,'FP Deutschlands','Freiheitliche Partei Deutschlands','n.a.'),(45,'RSB','Revolutionär Sozialistischer Bund/Vierte Internationale','1994'),(46,'AUFBRUCH','Aufbruch für Bürgerrechte, Freiheit und Gesundheit','1998'),(47,'ddp','Deutsche Demokratische Partei','2004'),(48,'Soziale Mitte','Soziale Mitte','2009'),(49,'Westfalen','Die Westfalen','2009'),(50,'SG-NRW','Soziale Gerechtigkeit – Nordrhein-Westfalen','n.a.'),(51,'UAP','Unabhängige Arbeiter-Partei','1962'),(52,'DP','Deutsche Partei','1993'),(53,'LD','Liberale Demokraten – die Sozialliberalen','1982'),(54,'IPD','Interim Partei Deutschland DAS REICHT!','n.a.'),(55,'Freie Sachsen','Freie Sachsen - Allianz unabhängiger Wähler','2007'),(56,'Die Friesen','Die Friesen','2007'),(57,'APPD','Anarchistische Pogo-Partei Deutschlands','1991'),(58,'UNABHÄNGIGE','Unabhängige Kandidaten für Direkte Demokratie & bürgernahe Lösungen','2002'),(59,'AB','Alternatives Bündnis für soziale Gerechtigkeit','n.a.'),(60,'APD','Arbeiter-Arbeiterinnen Partei Deutschland','2006'),(61,'SPV','Sarazzistische Partei – für Volksentscheide SPV Atom-Stuttgart21','2010'),(62,'Deutsche Konservative','Deutsche Konservative Partei','2009'),(63,'FW in Thüringen','Freie Wähler in Thüringen','2004'),(64,'DIREKTE DEMOKRATIE','Initiative Direkte Demokratie','2012'),(65,'MUD','Maritime Union Deutschland','2011');

/*Table structure for table `wahlbezirk` */

DROP TABLE IF EXISTS `wahlbezirk`;

CREATE TABLE `wahlbezirk` (
  `nr` int(11) NOT NULL,
  `wahlberechtigte` int(11) NOT NULL,
  `abgegebeneWahlscheine` int(11) DEFAULT '0',
  `eingeworfeneStimmzettel` int(11) DEFAULT '0',
  `erschieneneWaehler` int(11) DEFAULT '0',
  `wahlkreis_fk` int(11) NOT NULL,
  PRIMARY KEY (`nr`),
  KEY `wahlb_wahlk_fk` (`wahlkreis_fk`),
  CONSTRAINT `wahlb_wahlk_fk` FOREIGN KEY (`wahlkreis_fk`) REFERENCES `wahlkreis` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wahlbezirk` */

/*Table structure for table `wahlkreis` */

DROP TABLE IF EXISTS `wahlkreis`;

CREATE TABLE `wahlkreis` (
  `nr` int(11) NOT NULL,
  `notizen` varchar(200) DEFAULT NULL,
  `bundesland_fk` varchar(2) NOT NULL,
  PRIMARY KEY (`nr`),
  KEY `wahlk_bl_fk` (`bundesland_fk`),
  CONSTRAINT `wahlk_bl_fk` FOREIGN KEY (`bundesland_fk`) REFERENCES `bundesland` (`akronym`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `wahlkreis` */

/*Table structure for table `zweitstimme` */

DROP TABLE IF EXISTS `zweitstimme`;

CREATE TABLE `zweitstimme` (
  `nr` int(11) NOT NULL AUTO_INCREMENT,
  `gueltig` bit(1) NOT NULL,
  `wahlbezirk_fk` int(11) NOT NULL,
  `landesliste_fk` int(11) NOT NULL,
  PRIMARY KEY (`nr`),
  KEY `zweit_land_fk` (`landesliste_fk`),
  KEY `zweit_wahlb_fk` (`wahlbezirk_fk`),
  CONSTRAINT `zweit_land_fk` FOREIGN KEY (`landesliste_fk`) REFERENCES `landesliste` (`nr`),
  CONSTRAINT `zweit_wahlb_fk` FOREIGN KEY (`wahlbezirk_fk`) REFERENCES `wahlbezirk` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `zweitstimme` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
