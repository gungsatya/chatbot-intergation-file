/*
SQLyog Ultimate v11.33 (64 bit)
MySQL - 10.1.16-MariaDB : Database - telegram_msg_2
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`telegram_msg_2` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `telegram_msg_2`;

/*Table structure for table `in` */

DROP TABLE IF EXISTS `in`;

CREATE TABLE `in` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `update_id` bigint(20) DEFAULT NULL,
  `chat_id` bigint(20) DEFAULT NULL,
  `chat_text` text,
  `attachment` enum('false','true') DEFAULT 'false',
  `file_id` varchar(50) DEFAULT NULL,
  `file_name` varchar(50) DEFAULT NULL,
  `mime_type` text,
  `downloaded` enum('false','true') DEFAULT 'false',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `in` */

/*Table structure for table `out` */

DROP TABLE IF EXISTS `out`;

CREATE TABLE `out` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) DEFAULT NULL,
  `chat_text` text,
  `sttus` enum('ready','sent') DEFAULT 'ready',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `out` */

/* Trigger structure for table `in` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `msg_handler` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `msg_handler` AFTER INSERT ON `in` FOR EACH ROW BEGIN
	declare v_count int;
	IF(new.chat_text = "/count") THEN
		SET v_count := 0;
		SELECT COUNT(id) INTO v_count FROM `in` WHERE attachment='true';
		INSERT INTO `out`(chat_id,chat_text) VALUES(new.chat_id,CONCAT("You have ", CONVERT(v_count, CHAR)," attachment message(s) in database"));
	END IF;
		
    END */$$


DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
