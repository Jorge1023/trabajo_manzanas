-- Active: 1710199987950@@127.0.0.1@3306
-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-02-2024 a las 18:44:18
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
use unman;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `unman`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manzanas`
--

CREATE TABLE `manzanas` (
  `id_manzanas` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Direccion` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `manzanas`
--

INSERT INTO `manzanas` (`id_manzanas`, `Nombre`, `Direccion`) VALUES
(1, 'Bosa', 'Kra 103 10-25'),
(2, 'Chapinero', 'Kra 63 10-25'),
(3, 'Suba', 'Kra 114F 10-25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manzana_servicios`
--

CREATE TABLE `manzana_servicios` (
  `id_m` int(11) DEFAULT NULL,
  `id_s` int(11) DEFAULT NULL,
  `Fecha` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `manzana_servicios`
--

INSERT INTO `manzana_servicios` (`id_m`, `id_s`, `Fecha`) VALUES
(1, 8, NULL),
(1, 10, NULL),
(1, 11, NULL),
(2, 5, NULL),
(2, 6, NULL),
(2, 7, NULL),
(2, 8, NULL),
(2, 10, NULL),
(3, 7, NULL),
(3, 9, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios`
--

CREATE TABLE `servicios` (
  `id_servicios` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Tipo` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `servicios`
--

INSERT INTO `servicios` (`id_servicios`, `Nombre`, `Tipo`) VALUES
(5, 'Clases de Baile', 'Entretenimiento'),
(6, 'Cine', 'Entretenimiento'),
(7, 'Piscina', 'Deporte'),
(8, 'Gimnasio', 'Deporte'),
(9, 'Yoga', 'Deporte'),
(10, 'Cocina', 'Gastronomia'),
(11, 'Coser', 'Maquina');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes`
--

CREATE TABLE `solicitudes` (
  `id_solicitudes` int(11) NOT NULL,
  `Fecha` datetime NOT NULL,
  `Id1` int(10) NOT NULL,
  `CodigoS` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_user` int(2) NOT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `Tipo` varchar(30) DEFAULT NULL,
  `Documento` varchar(10) DEFAULT NULL,
  `id_manzanas` int(11) DEFAULT NULL,
  `Rol` set('Usuario','Administrador') DEFAULT 'Usuario',
  `Contraseña` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERTT INTO `usuario` (`id_user`, `Nombre`, `Tipo`, `Documento`, `id_manzanas`, `Rol`, `Contraseña`) VALUES
(7, 'jorgito', 'CC', '1234', 1, 'Administrador', '123'),
(16, 'jorge', 'CC', '1023', 3, 'Usuario', '101');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `manzanas`
--
ALTER TABLE `manzanas`
  ADD PRIMARY KEY (`id_manzanas`);

--
-- Indices de la tabla `manzana_servicios`
--
ALTER TABLE `manzana_servicios`
  ADD KEY `fk_id2` (`id_m`),
  ADD KEY `fk_id3` (`id_s`);

--
-- Indices de la tabla `servicios`
--
ALTER TABLE `servicios`
  ADD PRIMARY KEY (`id_servicios`);

--
-- Indices de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD PRIMARY KEY (`id_solicitudes`),
  ADD UNIQUE KEY `Fecha` (`Fecha`),
  ADD KEY `fk_idsolicitud` (`Id1`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `Documento` (`Documento`),
  ADD KEY `fk_id1` (`id_manzanas`) USING BTREE;

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `manzanas`
--
ALTER TABLE `manzanas`
  MODIFY `id_manzanas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `servicios`
--
ALTER TABLE `servicios`
  MODIFY `id_servicios` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `id_solicitudes` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_user` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `manzana_servicios`
--
ALTER TABLE `manzana_servicios`
  ADD CONSTRAINT `fk_id2` FOREIGN KEY (`id_m`) REFERENCES `manzanas` (`id_manzanas`),
  ADD CONSTRAINT `fk_id3` FOREIGN KEY (`id_s`) REFERENCES `servicios` (`id_servicios`);

--
-- Filtros para la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD CONSTRAINT `fk_idsolicitud` FOREIGN KEY (`Id1`) REFERENCES `usuario` (`id_user`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_id1` FOREIGN KEY (`id_manzanas`) REFERENCES `manzanas` (`id_manzanas`);
COMMIT;

SELECT solicitudes.`Fecha`, servicios.`Nombre` FROM solicitudes 
INNER JOIN usuario ON solicitudes.id_solicitudes = usuario.id_user 
INNER JOIN manzanas ON usuario.id_manzanas = manzanas.id_manzanas 
INNER JOIN manzana_servicios ON manzanas.id_manzanas = manzana_servicios.id_m 
INNER JOIN servicios ON manzana_servicios.id_s = servicios.id_servicios 
WHERE usuario.`Nombre`="jorge" AND solicitudes.`CodigoS` = servicios.id_servicios;

/* SELECT solicitudes.Fecha, servicios.Nombre FROM solicitudes INNER JOIN usuario ON solicitudes.id_solicitudes = usuario.id_user INNER JOIN manzanas ON usuario.id_manzanas = manzanas.id_manzanas INNER JOIN manzana_servicios ON manzanas.id_manzanas = manzana_servicios.id_m NNER JOIN servicios ON manzana_servicios.id_s = servicios.id_servicios WHERE usuario.Nombre=? AND solicitudes.CodigoS = servicios.id_servicios */

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */; 
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
