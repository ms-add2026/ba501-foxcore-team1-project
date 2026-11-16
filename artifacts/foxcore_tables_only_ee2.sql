-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema foxcore_retail
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema foxcore_retail
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `foxcore_retail` ;
USE `foxcore_retail` ;

-- -----------------------------------------------------
-- Table `foxcore_retail`.`venue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `foxcore_retail`.`venue` ;

CREATE TABLE IF NOT EXISTS `foxcore_retail`.`venue` (
  `venue_id` INT NOT NULL AUTO_INCREMENT,
  `venue_name` VARCHAR(100) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `parking_instructions` VARCHAR(255) NULL,
  `description` VARCHAR(255) NULL,
  PRIMARY KEY (`venue_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `foxcore_retail`.`retail_event`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `foxcore_retail`.`retail_event` ;

CREATE TABLE IF NOT EXISTS `foxcore_retail`.`retail_event` (
  `event_id` INT NOT NULL AUTO_INCREMENT,
  `venue_id` INT NOT NULL,
  `event_type` VARCHAR(50) NOT NULL,
  `event_name` VARCHAR(100) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `description` VARCHAR(255) NULL,
  PRIMARY KEY (`event_id`),
  INDEX `venue_id_idx` (`venue_id` ASC) VISIBLE,
  CONSTRAINT `venue_id`
    FOREIGN KEY (`venue_id`)
    REFERENCES `foxcore_retail`.`venue` (`venue_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `foxcore_retail`.`booth`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `foxcore_retail`.`booth` ;

CREATE TABLE IF NOT EXISTS `foxcore_retail`.`booth` (
  `booth_id` INT NOT NULL AUTO_INCREMENT,
  `event_id` INT NOT NULL,
  `location_code` VARCHAR(30) NOT NULL,
  `description` VARCHAR(255) NULL,
  PRIMARY KEY (`booth_id`),
  INDEX `event_id_idx` (`event_id` ASC) VISIBLE,
  CONSTRAINT `event_id`
    FOREIGN KEY (`event_id`)
    REFERENCES `foxcore_retail`.`retail_event` (`event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `foxcore_retail`.`salesperson`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `foxcore_retail`.`salesperson` ;

CREATE TABLE IF NOT EXISTS `foxcore_retail`.`salesperson` (
  `salesperson_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `address` VARCHAR(255) NULL,
  `phone_number` VARCHAR(25) NULL,
  PRIMARY KEY (`salesperson_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `foxcore_retail`.`work_shift`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `foxcore_retail`.`work_shift` ;

CREATE TABLE IF NOT EXISTS `foxcore_retail`.`work_shift` (
  `shift_id` INT NOT NULL AUTO_INCREMENT,
  `booth_id` INT NOT NULL,
  `salesperson_id` INT NOT NULL,
  `start_datetime` DATETIME NOT NULL,
  `end_datetime` DATETIME NOT NULL,
  PRIMARY KEY (`shift_id`),
  INDEX `booth_id_idx` (`booth_id` ASC) VISIBLE,
  INDEX `salesperson_id_idx` (`salesperson_id` ASC) VISIBLE,
  CONSTRAINT `booth_id`
    FOREIGN KEY (`booth_id`)
    REFERENCES `foxcore_retail`.`booth` (`booth_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `salesperson_id`
    FOREIGN KEY (`salesperson_id`)
    REFERENCES `foxcore_retail`.`salesperson` (`salesperson_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `foxcore_retail`.`product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `foxcore_retail`.`product` ;

CREATE TABLE IF NOT EXISTS `foxcore_retail`.`product` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(255) NULL,
  `wholesale_cost` DECIMAL(10,2) NOT NULL,
  `minimum_selling_price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`product_id`),
  UNIQUE INDEX `product_name_UNIQUE` (`product_name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `foxcore_retail`.`sale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `foxcore_retail`.`sale` ;

CREATE TABLE IF NOT EXISTS `foxcore_retail`.`sale` (
  `sale_id` INT NOT NULL AUTO_INCREMENT,
  `shift_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `sale_datetime` DATETIME NOT NULL,
  `quantity` INT NOT NULL,
  `final_unit_price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`sale_id`),
  INDEX `shift_id_idx` (`shift_id` ASC) VISIBLE,
  INDEX `product_id_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `shift_id`
    FOREIGN KEY (`shift_id`)
    REFERENCES `foxcore_retail`.`work_shift` (`shift_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `foxcore_retail`.`product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
