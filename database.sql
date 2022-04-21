-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Jeu 26 Octobre 2017 à 13:53
-- Version du serveur :  5.7.19-0ubuntu0.16.04.1
-- Version de PHP :  7.0.22-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `simple-mvc`
--

-- --------------------------------------------------------

--
-- Structure de la table `item`
--

CREATE TABLE `item` (
  `id` int(11) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `item`
--

INSERT INTO `item` (`id`, `title`) VALUES
(1, 'Stuff'),
(2, 'Doodads'),

--
-- Index pour les tables exportées
--

--
-- Index pour la table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `item`
--
ALTER TABLE `item`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- ​
-- SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
-- SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
-- SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
-- ​
-- -----------------------------------------------------
-- Schema tissus_jaures
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema tissus_jaures
-- -----------------------------------------------------
-- CREATE SCHEMA IF NOT EXISTS `tissus_jaures` DEFAULT CHARACTER SET utf8 ;
-- USE `tissus_jaures` ;

-- -----------------------------------------------------
-- Table `tissus_jaures`.`cloth_categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cloth_categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `image` VARCHAR(100) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Content `tissus_jaures`.`cloth_categories`
-- -----------------------------------------------------
INSERT INTO `cloth_categories` (`id`, `name`, `image`) VALUES
(1, "Tissus d'ameublement", 'public/assets/images/tss1'),
(2, "Loisirs créatifs", 'public/assets/images/tss1'),
(3, "Mercerie", 'public/assets/images/tss1'),
(4, "Tissus couture", 'public/assets/images/tss1'),
(5, "Voilage", 'public/assets/images/tss1'),
(6, "Décoration", 'public/assets/images/tss1');

-- -----------------------------------------------------
-- Table `tissus_jaures`.`cloth`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cloth` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `price` FLOAT NOT NULL,
  `image` VARCHAR(100) NULL,
  `is_on_sale` TINYINT NULL,
  `is_new` TINYINT NULL,
  `cloth_categories_id` INT NOT NULL,
  PRIMARY KEY (`id`, `cloth_categories_id`),
  INDEX `fk_cloth_cloth_categories_idx` (`cloth_categories_id` ASC) VISIBLE,
  CONSTRAINT `fk_cloth_cloth_categories`
    FOREIGN KEY (`cloth_categories_id`)
    REFERENCES `tissus_jaures`.`cloth_categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Content `tissus_jaures`.`cloth`
-- -----------------------------------------------------
INSERT INTO `cloth` (`id`, `name`, `price`, `image`,`is_on_sale`, `is_new`, `cloth_categories_id`) VALUES
(1, "Tissu bleu", 5, 'public/assets/images/tss1', 0, 0, 1),
(2, "Tissu vert", 4, 'public/assets/images/tss1', 0, 0, 3),
(3, "Tissu jaune", 2.5, 'public/assets/images/tss1', 1, 0, 4),
(4, "Tissu rouge", 150, 'public/assets/images/tss1', 0, 1, 2),
(5, "Tissu violet", 1, 'public/assets/images/tss1', 1, 1, 1),
(6, "Tissu orange", 4.5, 'public/assets/images/tss1', 1, 0, 4);

-- -----------------------------------------------------
-- Table `tissus_jaures`.`machines`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `machines` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `price` FLOAT NOT NULL,
  `image` VARCHAR(100) NULL,
  `is_on_sale` TINYINT NULL,
  `is_new` TINYINT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -- -----------------------------------------------------
-- -- Content `tissus_jaures`.`machines`
-- -- -----------------------------------------------------
INSERT INTO `machines` (`id`, `name`, `price`, `image`,`is_on_sale`, `is_new`) VALUES
(1, "Machine Singer", 400, 'public/assets/images/mchn1', 0, 0),
(2, "Machine Singer", 300, 'public/assets/images/mchn1', 1, 1),
(3, "Machine Singer", 150.5, 'public/assets/images/mchn1', 1, 0),
(4, "Machine Singer", 10000, 'public/assets/images/mchn1', 0, 1);

-- -----------------------------------------------------
-- Table `tissus_jaures`.`tutorials`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tutorials` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `image` VARCHAR(100) NULL,
  `content` TEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tissus_jaures`.`lexicon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lexicon` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `definition` TEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tissus_jaures`.`tips`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tips` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `content` TEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- SET SQL_MODE=@OLD_SQL_MODE;
-- SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
-- SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;