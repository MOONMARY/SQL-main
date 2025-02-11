-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema EnrollmentDB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `EnrollmentDB` ;

-- -----------------------------------------------------
-- Schema EnrollmentDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `EnrollmentDB` DEFAULT CHARACTER SET utf8mb4 ;
USE `EnrollmentDB` ;

-- -----------------------------------------------------
-- Table `EnrollmentDB`.`Students`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EnrollmentDB`.`Students` ;

CREATE TABLE IF NOT EXISTS `EnrollmentDB`.`Students` (
  `id` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `birth_date` DATE NOT NULL,
  `address` VARCHAR(200) NULL,
  `phone` VARCHAR(20) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EnrollmentDB`.`Teachesrs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EnrollmentDB`.`Teachesrs` ;

CREATE TABLE IF NOT EXISTS `EnrollmentDB`.`Teachesrs` (
  `id` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `department` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EnrollmentDB`.`Subjects`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EnrollmentDB`.`Subjects` ;

CREATE TABLE IF NOT EXISTS `EnrollmentDB`.`Subjects` (
  `id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `teacher_id` INT NOT NULL,
  `credits` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Subjects_Teachesrs1_idx` (`teacher_id` ASC) VISIBLE,
  CONSTRAINT `fk_Subjects_Teachesrs1`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `EnrollmentDB`.`Teachesrs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EnrollmentDB`.`Enrollments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `EnrollmentDB`.`Enrollments` ;

CREATE TABLE IF NOT EXISTS `EnrollmentDB`.`Enrollments` (
  `id` INT NOT NULL,
  `student_id` INT NOT NULL,
  `subject_id` INT NOT NULL,
  `enrollment_date` DATE NOT NULL,
  `grade` CHAR(2) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Enrollments_Students_idx` (`student_id` ASC) VISIBLE,
  INDEX `fk_Enrollments_Subjects1_idx` (`subject_id` ASC) VISIBLE,
  CONSTRAINT `fk_Enrollments_Students`
    FOREIGN KEY (`student_id`)
    REFERENCES `EnrollmentDB`.`Students` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Enrollments_Subjects1`
    FOREIGN KEY (`subject_id`)
    REFERENCES `EnrollmentDB`.`Subjects` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
