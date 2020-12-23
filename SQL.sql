USE `milewskio` ;

-- -----------------------------------------------------
-- Table `milewskio`.`Towar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `milewskio`.`Towar` (
  `id_Towaru` INT NOT NULL AUTO_INCREMENT,
  `Nazwa` VARCHAR(100) NULL,
  `Cena_Brutto` INT NULL,
  `Cena_Netto` INT NULL,
  `Producent` VARCHAR(45) NULL,
  `Rok_produkcji` YEAR(4) NULL,
  PRIMARY KEY (`id_Towaru`),
  UNIQUE INDEX `id_Towaru_UNIQUE` (`id_Towaru` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `milewskio`.`Pracownicy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `milewskio`.`Pracownicy` (
  `id_Pracownika` INT NOT NULL AUTO_INCREMENT,
  `Imie` VARCHAR(45) NULL,
  `Nazwisko` VARCHAR(60) NULL,
  `PESEL` CHAR(11) NOT NULL,
  `typ_umowy` VARCHAR(45) NULL,
  `Adres_Ulica` VARCHAR(70) NULL,
  `Adres_nr_domu` INT NULL,
  `Adres_nr_mieszkania` INT NULL,
  `Miasto` VARCHAR(45) NULL,
  `Kod_pocztowy` VARCHAR(6) NULL COMMENT 'Przykład: 00-000',
  `Wynagrodzenie` DECIMAL NULL,
  UNIQUE INDEX `nr_Pracownika_UNIQUE` (`id_Pracownika` ASC) VISIBLE,
  PRIMARY KEY (`id_Pracownika`),
  UNIQUE INDEX `PESEL_UNIQUE` (`PESEL` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `milewskio`.`Klienci`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `milewskio`.`Klienci` (
  `id_klienta` INT UNSIGNED NOT NULL,
  `Imie` VARCHAR(45) NULL,
  `Nazwisko` VARCHAR(60) NULL,
  `Miasto` VARCHAR(45) NULL,
  `Kod_pocztowy` VARCHAR(6) NULL COMMENT 'Np. 00-000',
  `Adres_Ulica` VARCHAR(70) NULL,
  `Adres_nr_domu` INT NULL,
  `Adres_nr_mieszkania` INT NULL,
  PRIMARY KEY (`id_klienta`),
  UNIQUE INDEX `nr_klienta_UNIQUE` (`id_klienta` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `milewskio`.`Typy_transakcji`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `milewskio`.`Typy_transakcji` (
  `id_Typy_transakcji` INT NOT NULL,
  `Typ_transakcji` VARCHAR(45) NULL,
  PRIMARY KEY (`id_Typy_transakcji`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `milewskio`.`Transakcje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `milewskio`.`Transakcje` (
  `id_Transakcji` INT NOT NULL AUTO_INCREMENT,
  `Typ_transakcji_id` INT NOT NULL,
  `Data` DATE NULL,
  `czy_Zrealizowano` TINYINT NULL,
  `id_Klienta` INT UNSIGNED NOT NULL,
  `id_Pracownika` INT NOT NULL,
  `Typ_platnosci` VARCHAR(45) NULL,
  PRIMARY KEY (`id_Transakcji`, `Typ_transakcji_id`, `id_Klienta`, `id_Pracownika`),
  UNIQUE INDEX `idTransakcji_UNIQUE` (`id_Transakcji` ASC) VISIBLE,
  INDEX `fk_Transakcje_Typy_transakcji1_idx` (`Typ_transakcji_id` ASC) VISIBLE,
  INDEX `fk_Transakcje_Klienci1_idx` (`id_Klienta` ASC) VISIBLE,
  INDEX `fk_Transakcje_Pracownicy1_idx` (`id_Pracownika` ASC) VISIBLE,
  CONSTRAINT `fk_Transakcje_Typy_transakcji1`
    FOREIGN KEY (`Typ_transakcji_id`)
    REFERENCES `milewskio`.`Typy_transakcji` (`id_Typy_transakcji`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transakcje_Klienci1`
    FOREIGN KEY (`id_Klienta`)
    REFERENCES `milewskio`.`Klienci` (`id_klienta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transakcje_Pracownicy1`
    FOREIGN KEY (`id_Pracownika`)
    REFERENCES `milewskio`.`Pracownicy` (`id_Pracownika`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `milewskio`.`Zamowienie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `milewskio`.`Zamowienie` (
  `id_Transakcji` INT NOT NULL,
  `id_Towaru` INT NOT NULL,
  PRIMARY KEY (`id_Transakcji`, `id_Towaru`),
  INDEX `fk_Transakcje_has_Towar_Towar1_idx` (`id_Towaru` ASC) VISIBLE,
  INDEX `fk_Transakcje_has_Towar_Transakcje_idx` (`id_Transakcji` ASC) VISIBLE,
  CONSTRAINT `fk_Transakcje_has_Towar_Transakcje`
    FOREIGN KEY (`id_Transakcji`)
    REFERENCES `milewskio`.`Transakcje` (`id_Transakcji`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transakcje_has_Towar_Towar1`
    FOREIGN KEY (`id_Towaru`)
    REFERENCES `milewskio`.`Towar` (`id_Towaru`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;





--- PROCEDURA ---

DELIMITER $$
CREATE DEFINER=`milewskio`@`localhost` PROCEDURE `Liczba_pracownikow`()
BEGIN
	SELECT COUNT(*) AS Liczba_pracownikow FROM Pracownicy;
END$$
DELIMITER ;


--- FUNKCJA ---

DELIMITER $$
CREATE DEFINER=`milewskio`@`localhost` FUNCTION `count_transakcje`() RETURNS int
BEGIN
    DECLARE ile INT;
    SELECT COUNT(*) INTO @ile FROM Transakcje where czy_Zrealizowano = "TAK";
    RETURN @ile;
END$$
DELIMITER ;

--- WYZWALACZ ---

DELIMITER $$
CREATE TRIGGER Null_trigger  
BEFORE INSERT ON 
Transakcje FOR EACH ROW BEGIN      
IF NEW.czy_Zrealizowano is null   
THEN     
SET NEW.czy_Zrealizowano = 'W trakcie';       
END IF;    
END
$$
DELIMITER ;




