/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.3-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: concesionarioKONRUEDAS
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB-1build1 from Ubuntu

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `CARRO`
--

DROP TABLE IF EXISTS `CARRO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CARRO` (
  `id_carro` int(11) NOT NULL AUTO_INCREMENT,
  `marca` varchar(50) NOT NULL,
  `modelo` varchar(50) NOT NULL,
  `color` varchar(30) DEFAULT NULL,
  `motor` varchar(50) DEFAULT NULL,
  `combustible` varchar(20) DEFAULT NULL,
  `traccion` varchar(20) DEFAULT NULL,
  `transmision` varchar(20) DEFAULT NULL,
  `anno` int(11) DEFAULT NULL,
  `tipo_carroceria` varchar(30) DEFAULT NULL,
  `hp` int(11) DEFAULT NULL,
  `puertas` int(11) DEFAULT NULL,
  `torque` int(11) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_carro`)
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CIUDAD`
--

DROP TABLE IF EXISTS `CIUDAD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CIUDAD` (
  `id_ciudad` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id_ciudad`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CLIENTE`
--

DROP TABLE IF EXISTS `CLIENTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENTE` (
  `id_cliente` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `fecha_de_nacimiento` date DEFAULT NULL,
  `cedula` varchar(20) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `historial_crediticio` text DEFAULT NULL,
  `capacidad_endeudamiento` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `cedula` (`cedula`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CONCESIONARIO`
--

DROP TABLE IF EXISTS `CONCESIONARIO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CONCESIONARIO` (
  `id_concesionario` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `id_ciudad` int(11) NOT NULL,
  PRIMARY KEY (`id_concesionario`),
  KEY `id_ciudad` (`id_ciudad`),
  CONSTRAINT `CONCESIONARIO_ibfk_1` FOREIGN KEY (`id_ciudad`) REFERENCES `CIUDAD` (`id_ciudad`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FACTURA`
--

DROP TABLE IF EXISTS `FACTURA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `FACTURA` (
  `id_factura` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_emision` date NOT NULL,
  `hora_emision` time NOT NULL,
  `metodo_pago` varchar(20) DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `iva` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `estado` varchar(15) DEFAULT 'PENDIENTE',
  `id_cliente` int(11) NOT NULL,
  `id_vendedor` int(11) NOT NULL,
  `id_carro` int(11) NOT NULL,
  PRIMARY KEY (`id_factura`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_vendedor` (`id_vendedor`),
  KEY `id_carro` (`id_carro`),
  CONSTRAINT `FACTURA_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `CLIENTE` (`id_cliente`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FACTURA_ibfk_2` FOREIGN KEY (`id_vendedor`) REFERENCES `VENDEDOR` (`id_vendedor`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FACTURA_ibfk_3` FOREIGN KEY (`id_carro`) REFERENCES `CARRO` (`id_carro`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3500 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `VENDEDOR`
--

DROP TABLE IF EXISTS `VENDEDOR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `VENDEDOR` (
  `id_vendedor` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `id_concesionario` int(11) NOT NULL,
  PRIMARY KEY (`id_vendedor`),
  UNIQUE KEY `correo` (`correo`),
  KEY `fk_vendedor_concesionario` (`id_concesionario`),
  CONSTRAINT `fk_vendedor_concesionario` FOREIGN KEY (`id_concesionario`) REFERENCES `CONCESIONARIO` (`id_concesionario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-11-20 22:26:18
