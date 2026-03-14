/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.5.26-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: glpi
-- ------------------------------------------------------
-- Server version	10.5.26-MariaDB-0+deb11u2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `glpi_tickets`
--

DROP TABLE IF EXISTS `glpi_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glpi_tickets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entities_id` int(10) unsigned NOT NULL DEFAULT 0,
  `name` varchar(255) DEFAULT NULL,
  `date` timestamp NULL DEFAULT NULL,
  `closedate` timestamp NULL DEFAULT NULL,
  `solvedate` timestamp NULL DEFAULT NULL,
  `date_mod` timestamp NULL DEFAULT NULL,
  `users_id_lastupdater` int(10) unsigned NOT NULL DEFAULT 0,
  `status` int(11) NOT NULL DEFAULT 1,
  `users_id_recipient` int(10) unsigned NOT NULL DEFAULT 0,
  `requesttypes_id` int(10) unsigned NOT NULL DEFAULT 0,
  `content` longtext DEFAULT NULL,
  `urgency` int(11) NOT NULL DEFAULT 1,
  `impact` int(11) NOT NULL DEFAULT 1,
  `priority` int(11) NOT NULL DEFAULT 1,
  `itilcategories_id` int(10) unsigned NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL DEFAULT 1,
  `global_validation` int(11) NOT NULL DEFAULT 1,
  `slas_id_ttr` int(10) unsigned NOT NULL DEFAULT 0,
  `slas_id_tto` int(10) unsigned NOT NULL DEFAULT 0,
  `slalevels_id_ttr` int(10) unsigned NOT NULL DEFAULT 0,
  `time_to_resolve` timestamp NULL DEFAULT NULL,
  `time_to_own` timestamp NULL DEFAULT NULL,
  `begin_waiting_date` timestamp NULL DEFAULT NULL,
  `sla_waiting_duration` int(11) NOT NULL DEFAULT 0,
  `ola_waiting_duration` int(11) NOT NULL DEFAULT 0,
  `olas_id_tto` int(10) unsigned NOT NULL DEFAULT 0,
  `olas_id_ttr` int(10) unsigned NOT NULL DEFAULT 0,
  `olalevels_id_ttr` int(10) unsigned NOT NULL DEFAULT 0,
  `ola_ttr_begin_date` timestamp NULL DEFAULT NULL,
  `internal_time_to_resolve` timestamp NULL DEFAULT NULL,
  `internal_time_to_own` timestamp NULL DEFAULT NULL,
  `waiting_duration` int(11) NOT NULL DEFAULT 0,
  `close_delay_stat` int(11) NOT NULL DEFAULT 0,
  `solve_delay_stat` int(11) NOT NULL DEFAULT 0,
  `takeintoaccount_delay_stat` int(11) NOT NULL DEFAULT 0,
  `actiontime` int(11) NOT NULL DEFAULT 0,
  `is_deleted` tinyint(4) NOT NULL DEFAULT 0,
  `locations_id` int(10) unsigned NOT NULL DEFAULT 0,
  `validation_percent` int(11) NOT NULL DEFAULT 0,
  `date_creation` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `date` (`date`),
  KEY `closedate` (`closedate`),
  KEY `status` (`status`),
  KEY `priority` (`priority`),
  KEY `request_type` (`requesttypes_id`),
  KEY `date_mod` (`date_mod`),
  KEY `entities_id` (`entities_id`),
  KEY `users_id_recipient` (`users_id_recipient`),
  KEY `solvedate` (`solvedate`),
  KEY `urgency` (`urgency`),
  KEY `impact` (`impact`),
  KEY `global_validation` (`global_validation`),
  KEY `slas_id_tto` (`slas_id_tto`),
  KEY `slas_id_ttr` (`slas_id_ttr`),
  KEY `time_to_resolve` (`time_to_resolve`),
  KEY `time_to_own` (`time_to_own`),
  KEY `olas_id_tto` (`olas_id_tto`),
  KEY `olas_id_ttr` (`olas_id_ttr`),
  KEY `slalevels_id_ttr` (`slalevels_id_ttr`),
  KEY `internal_time_to_resolve` (`internal_time_to_resolve`),
  KEY `internal_time_to_own` (`internal_time_to_own`),
  KEY `users_id_lastupdater` (`users_id_lastupdater`),
  KEY `type` (`type`),
  KEY `itilcategories_id` (`itilcategories_id`),
  KEY `is_deleted` (`is_deleted`),
  KEY `name` (`name`),
  KEY `locations_id` (`locations_id`),
  KEY `date_creation` (`date_creation`),
  KEY `ola_waiting_duration` (`ola_waiting_duration`),
  KEY `olalevels_id_ttr` (`olalevels_id_ttr`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glpi_tickets`
--

LOCK TABLES `glpi_tickets` WRITE;
/*!40000 ALTER TABLE `glpi_tickets` DISABLE KEYS */;
INSERT INTO `glpi_tickets` VALUES (1,0,'Raphaël demande à libérer le serveur ainsi que la base de donnée associée au logiciel Zephyr.','2025-01-23 10:00:00',NULL,NULL,'2025-01-24 18:17:45',16,4,16,2,'&#60;p&#62;Raphaël a supprimé les comptes d\'accès de ses collaborateurs. Il souhaite maintenant qu\'on libère le serveur et sa base de donnée.&#60;/p&#62;',2,2,2,0,2,1,0,0,0,NULL,NULL,'2025-01-24 18:17:45',0,0,0,0,0,NULL,NULL,NULL,0,0,0,99196,0,0,0,0,'2025-01-24 13:29:57'),
(2,0,'Charly n\'arrive pas à s\'identifier sur son poste.','2025-01-23 10:30:00',NULL,NULL,'2025-01-24 15:06:44',16,2,16,3,'&#60;p&#62;Charly n\'arrive pas à s\'identifier peut importe le poste, il a l\'erreur \"mot de passe invalide\".&#60;/p&#62;',4,3,4,0,1,1,0,0,0,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,0,0,0,98075,0,0,0,0,'2025-01-24 13:44:24'),
(3,0,'Édouard souhaite avoir accès au compte root du server pour déboguer.','2025-01-23 12:30:00',NULL,NULL,'2025-01-24 14:03:02',16,2,16,3,'&#60;p&#62;Édouard demande à avoir accès au compte root du serveur pour déboguer un problème d\'affichage sur certains navigateurs.&#60;/p&#62;',4,3,4,0,2,1,0,0,0,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,0,0,0,91982,0,0,0,0,'2025-01-24 14:03:02'),
(4,0,'Philippe souhaite recevoir un nouveau téléphone.','2025-01-23 12:45:00',NULL,NULL,'2025-01-24 14:10:15',16,2,16,4,'&#60;p&#62;Philippe souhaite avoir un nouveau téléphone, cependant les lots que nous avons reçu ont déjà été distribué.&#60;/p&#62;',2,2,2,0,2,1,0,0,0,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,0,0,0,91515,0,0,0,0,'2025-01-24 14:10:15'),
(5,0,'Demande de prise de contact avec le partenaire Ocito.','2025-01-23 14:00:00',NULL,'2025-01-24 18:17:21','2025-01-24 18:17:21',16,5,16,4,'&#60;p&#62;Il faut prendre contact avec le partenaire Ocito pour configurer la connexion VPN Ipsec entre nos infrastructures.&#60;/p&#62;',3,3,3,0,2,1,0,0,0,NULL,NULL,'2025-01-24 18:17:21',0,0,0,0,0,NULL,NULL,NULL,0,0,101841,89499,0,0,0,0,'2025-01-24 14:16:13'),
(6,0,'Un code d’alerte E458 remonte sur la climatisation numéro 3.','2025-01-23 14:30:00',NULL,NULL,'2025-01-24 14:19:39',16,2,16,4,'&#60;p&#62;La gestion de la climatisation est assurée par la société de maintenance \"Clim Service\".&#60;/p&#62;',4,4,4,0,1,1,0,0,0,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,0,0,0,85779,0,0,0,0,'2025-01-24 14:19:39'),
(7,0,'Besoin de disques 4 To et 8 To.','2025-01-23 15:10:00',NULL,'2025-01-24 18:17:32','2025-01-24 18:17:32',16,5,16,3,'&#60;p&#62;Commander 10 disques de 4To et 5 de 8To.&#60;/p&#62;',3,3,3,0,2,1,0,0,0,NULL,NULL,'2025-01-24 18:17:32',0,0,0,0,0,NULL,NULL,NULL,0,0,97652,83629,0,0,0,0,'2025-01-24 14:23:49'),
(8,0,'Guillaume souhaite installer Itunes sur son ordinateur.','2025-01-23 15:45:00',NULL,NULL,'2025-01-24 14:26:55',16,2,16,4,'&#60;p&#62;Guillaume souhaite installer Itunes sur son ordinateur.&#60;/p&#62;',2,2,2,0,2,1,0,0,0,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,0,0,0,81715,0,0,0,0,'2025-01-24 14:26:55'),
(9,0,'Suite à l\'ouverture d\'une pièce jointe Samuel ne peut plus utiliser son poste.','2025-01-23 16:30:00',NULL,NULL,'2025-01-24 14:33:15',16,2,16,3,'&#60;p&#62;Suite à l\'ouverture d\'une pièce jointe Samuel ne peut plus utiliser son poste.&#60;/p&#62;',5,5,6,0,1,1,0,0,0,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,0,0,0,79395,0,0,0,0,'2025-01-24 14:33:15'),
(10,0,'Steeve n\'a pas plus accès au logiciel Zephyr.','2025-01-23 11:00:00',NULL,'2025-01-24 18:16:47','2025-01-24 18:16:47',16,5,16,3,'&#60;p&#62;Steeve n\'a pas plus accès au logiciel Zephyr suite à la suppression des compte d\'accès par Raphaël.&#60;/p&#62;',4,3,4,0,2,1,0,0,0,NULL,NULL,'2025-01-24 18:16:47',0,0,0,0,0,NULL,NULL,NULL,0,0,112607,99619,0,0,0,0,'2025-01-24 14:40:19');
/*!40000 ALTER TABLE `glpi_tickets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-26 19:58:37
