ALTER TABLE `bundestagswahlen`.`zweitstimme` DROP FOREIGN KEY `zweit_landes_fk`;

ALTER TABLE `bundestagswahlen`.`zweitstimme`   
  DROP INDEX `zweit_landes_fk`;
  
ALTER TABLE `bundestagswahlen`.`zweitstimme`   
  DROP COLUMN `landesliste_bundestagswahl_fk`;

ALTER TABLE `bundestagswahlen`.`zweitstimme` ADD CONSTRAINT `zweit_landes_fk` FOREIGN KEY (`landesliste_nr_fk`) REFERENCES `bundestagswahlen`.`landesliste`(`nr`);

ALTER TABLE `bundestagswahlen`.`kandidat` DROP FOREIGN KEY `kand_land_fk`;

ALTER TABLE `bundestagswahlen`.`kandidat`   
  DROP INDEX `kand_land_fk`,
  ADD  INDEX `kand_land_fk` (`landesliste_nr_fk`);

ALTER TABLE `bundestagswahlen`.`kandidat`   
  DROP COLUMN `landesliste_bundestagswahl_fk`;

ALTER TABLE `bundestagswahlen`.`kandidat` ADD CONSTRAINT `kand_land_fk` FOREIGN KEY (`landesliste_nr_fk`) REFERENCES `bundestagswahlen`.`landesliste`(`nr`);

ALTER TABLE `bundestagswahlen`.`landesliste`   
  CHANGE `notizen` `position` INT(11) NULL, 
  DROP PRIMARY KEY,
  ADD PRIMARY KEY (`nr`);
