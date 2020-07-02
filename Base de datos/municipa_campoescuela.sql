-- phpMyAdmin SQL Dump
-- version 4.9.4
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 01-07-2020 a las 21:04:53
-- Versión del servidor: 5.7.29-cll-lve
-- Versión de PHP: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `municipa_campoescuela`
create database municipa_campoescuela;
use municipa_campoescuela;
--

DELIMITER $$
--
-- Procedimientos
--
CREATE PROCEDURE `editar_insumo` (IN `idinsumos` INT, IN `cantida` INT, IN `fecha` DATE)  begin
set @ent= 0;
  INSERT INTO kardexinsumo(
 entrada,
 salida,
 fechaS,
 idinsumo
 ) values(
 @ent,
 cantida,
 fecha,
 idinsumos
 );
 update insumos set
 cantidad = cantidad - cantida
 where id_insumo = idinsumos;
 END$$

CREATE  PROCEDURE `editar_producto` (IN `producto` VARCHAR(25), IN `precio` DOUBLE, IN `unidad` INT, IN `idusuario` INT, IN `idcategorias` INT, IN `idproducto` INT, IN `cantida` DOUBLE, IN `cantida1` DOUBLE)  begin
Declare exit handler for sqlexception
 BEGIN
  SELECT "ERROR"
  ROLLBACK;
  END;
  declare exit handler for sqlwarning
  begin
  Select "advertencia"
  ROLLBACK;
  END;
  START TRANSACTION;
  set @cant = (select entrada from kardex where id_producto1=idproducto);
update producto set
     producto=producto,
     precio_venta=precio,
     id_unidad=unidad,
     id_usuario=idusuario,
     idcategorias=idcategorias
     where id_producto=idproducto;
 update kardex set
   stock =cantida+cantida1
   where id_producto1=idproducto;
     update kardex set
   entrada=@cant+cantida
   where id_producto1=idproducto;
 commit;
END$$

CREATE  PROCEDURE `editar_valoresinsumo` (IN `idinsumos` INT, IN `cant` INT, IN `prec` DOUBLE, IN `descr` VARCHAR(100), IN `fec` DATE, IN `idcate` INT(11), IN `idunid` INT(11), IN `sumar` INT)  begin
update kardexinsumo set
   entrada = cant + sumar
   where idinsumo = idinsumos;
update insumos set
     cantidad = cant + sumar,
     precio = prec,
     descripcion = descr,
     fecha = fec,
     idcategoria = idcate,
     iduni = idunid
     where id_insumo = idinsumos;
END$$

CREATE  PROCEDURE `getproductos` ()  BEGIN
   select p.id_producto, p.producto,p.precio_venta,u.nombre as unidad,c.categoria,k.stock from producto p
  inner join kardex k on p.id_producto=k.id_producto1
  inner join categorias c on c.id_categoria=p.idcategorias
  inner join unidad u on u.idunidad=p.id_unidad;
END$$

CREATE  PROCEDURE `getventas` ()  BEGIN
select v.idventas,v.fechaventa, concat(u.nombres,' ', u.apellidos) as usuario , v.numero_venta, v.total_pagar ,v.estado from ventas v
inner join usuarios u on v.id_usuario= u.id_usuario order by v.fechaventa DESC;
END$$

CREATE PROCEDURE `get_producto_por_id` (IN `idproducto` INT)  BEGIN
  select p.id_producto, p.producto,p.precio_venta,u.nombre as unidad,c.categoria,c.id_categoria,k.stock, u.idunidad from producto p
  inner join kardex k on p.id_producto=k.id_producto1
  inner join categorias c on c.id_categoria=p.idcategorias
  inner join unidad u on u.idunidad=p.id_unidad
   where p.id_producto=idproducto;
END$$

CREATE  PROCEDURE `registar_producto` (IN `nombreprodu` VARCHAR(50), IN `precio` DOUBLE, IN `medida` INT, IN `idcategoria` INT, IN `ingreso` DOUBLE, IN `id_usuario` INT)  BEGIN
    INSERT INTO producto(
        producto,
        precio_venta,
        id_unidad,
        id_usuario,
        idcategorias
    )
VALUES(
    nombreprodu,
    precio,
    medida,
    id_usuario,
    idcategoria
);
SET
    @id =(
SELECT
    LAST_INSERT_ID()); IF ingreso = NULL THEN
SET
    @ing = 0;
INSERT INTO kardex(
    entrada,
    salida,
    stock,
    id_producto1
)
VALUES(@ing, @ing,@ing, @id); ELSE
SET
    @salid = 0;
INSERT INTO kardex(
    entrada,
    salida,
    stock,
    id_producto1
)
VALUES(
    ingreso,
    @salid,
    ingreso,
    @id
);
END IF;
END$$

CREATE  PROCEDURE `registrar_detalleventas` (IN `idproducto` INT(11), IN `cantidad` DOUBLE, IN `precio_venta` DOUBLE, IN `idventas` INT(11))  begin
  INSERT INTO detalleventas(
  id_producto,
  cantidad,
  precio_venta,
  id_ventas)
  values(idproducto,
  cantidad,
  precio_venta,
  idventas);
    END$$

CREATE  PROCEDURE `registrar_insumo` (IN `cantida` INT, IN `precios` DOUBLE, IN `descrip` VARCHAR(100), IN `fecha` DATE, IN `idcategoria` INT, IN `iduni` INT)  BEGIN
 INSERT INTO insumos(
 cantidad,
 precio,
 descripcion,
 fecha,
 idcategoria,
 iduni
 ) values(
 cantida,
 precios,
 descrip,
 fecha,
 idcategoria,
 iduni
 );
 set @id= (select LAST_INSERT_ID());
 set @sal= 0;
 insert into kardexinsumo(
 entrada,
 salida,
 fechaS,
 idinsumo)values(
 cantida,
 @sal,
 fecha,
 @id
 );
END$$

CREATE  PROCEDURE `registrar_venta` (IN `fecha` DATE, IN `total_pagar` DOUBLE, IN `estado` ENUM('1','0'), IN `numero_venta` VARCHAR(10), IN `id_usuario` INT(11))  begin
  INSERT INTO ventas(
  fechaventa,
  total_pagar,
  estado,
  numero_venta,
  id_usuario)
  values(
  fecha,
  total_pagar,
  estado,
  numero_venta,
  id_usuario);
    set @id= (select LAST_INSERT_ID());
    select @id;
  END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `capacitaciones`
--

CREATE TABLE `capacitaciones` (
  `id_capacitacion` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `nombreGrupo` varchar(45) NOT NULL,
  `cargo` varchar(45) NOT NULL,
  `encargado` varchar(45) NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `descripcion` varchar(75) NOT NULL,
  `id_usuarioscate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuentas`
--

CREATE TABLE `cuentas` (
  `id_cuenta` int(11) NOT NULL,
  `id_partida` int(11) NOT NULL,
  `nombrecuenta` varchar(50) NOT NULL,
  `objetivo` varchar(150) NOT NULL,
  `estrategia` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallecapacitados`
--

CREATE TABLE `detallecapacitados` (
  `id_detallecapacitados` int(11) NOT NULL,
  `nombres` varchar(45) NOT NULL,
  `apellidos` varchar(45) NOT NULL,
  `dui` varchar(45) DEFAULT NULL,
  `id_capacitacion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallepedidos`
--

CREATE TABLE `detallepedidos` (
  `id_detallepedido` int(11) NOT NULL,
  `nombreInsumo` varchar(45) NOT NULL,
  `cantidad` int(4) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `id_uni` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalleventas`
--

CREATE TABLE `detalleventas` (
  `id_detalle` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` decimal(6,2) NOT NULL,
  `precio_venta` decimal(6,2) NOT NULL,
  `id_ventas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Disparadores `detalleventas`
--
DELIMITER $$
CREATE TRIGGER `detalleventas_AFTER_INSERT` AFTER INSERT ON `detalleventas` FOR EACH ROW BEGIN

update kardex set stock= stock-new.cantidad
where kardex.id_producto1= new.id_producto;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `detalleventas_BEFORE_INSERT` BEFORE INSERT ON `detalleventas` FOR EACH ROW BEGIN
update kardex set salida=salida+new.cantidad
where kardex.id_producto1=new.id_producto;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `donaciones`
--

CREATE TABLE `donaciones` (
  `id_donacion` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `donante` varchar(45) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `cantidad` int(4) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entrada`
--

CREATE TABLE `entrada` (
  `id_entrada` int(11) NOT NULL,
  `id_cuenta` int(11) NOT NULL,
  `ActGeneral` varchar(100) DEFAULT NULL,
  `ActEspecifica` varchar(100) DEFAULT NULL,
  `Responsable` varchar(50) DEFAULT NULL,
  `Academico` varchar(50) DEFAULT NULL,
  `Tecnico` varchar(50) DEFAULT NULL,
  `Financiero` decimal(30,2) DEFAULT NULL,
  `Infraestructura` varchar(150) DEFAULT NULL,
  `Logro` varchar(200) DEFAULT NULL,
  `Inicio` varchar(15) DEFAULT NULL,
  `Fin` varchar(15) DEFAULT NULL,
  `Orden` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gastos`
--

CREATE TABLE `gastos` (
  `id_gasto` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `incidentes`
--

CREATE TABLE `incidentes` (
  `id_incidente` int(11) NOT NULL,
  `titulo` varchar(50) NOT NULL,
  `descripcion` varchar(250) NOT NULL,
  `fecha` date NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `insumos`
--

CREATE TABLE `insumos` (
  `id_insumo` int(11) NOT NULL,
  `cantidad` int(4) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `fecha` date NOT NULL,
  `idcategoria` int(11) NOT NULL,
  `iduni` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `kardex`
--

CREATE TABLE `kardex` (
  `idkardex` int(11) NOT NULL,
  `entrada` decimal(6,2) NOT NULL,
  `salida` decimal(6,2) DEFAULT NULL,
  `stock` decimal(6,2) NOT NULL,
  `id_producto1` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `kardexinsumo`
--

CREATE TABLE `kardexinsumo` (
  `id_kardexinsumo` int(11) NOT NULL,
  `entrada` int(4) NOT NULL,
  `salida` int(4) DEFAULT NULL,
  `fechaS` date NOT NULL,
  `idinsumo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulo`
--

CREATE TABLE `modulo` (
  `idmodulo` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `modulo`
--

INSERT INTO `modulo` (`idmodulo`, `nombre`) VALUES
(1, 'USUARIOS'),
(2, 'INCIDENTES'),
(3, 'PARTIDAS'),
(4, 'PERDIDAS'),
(5, 'DONACIONES'),
(6, 'GASTOS'),
(7, 'CAPACITACIONES'),
(8, 'CATEGORIA'),
(9, 'PRODUCTO'),
(10, 'PEDIDOS'),
(11, 'VENTA'),
(12, 'INFORME FINANCIERO'),
(13, 'REPORTES DE VENTAS'),
(14, 'RESPALDO'),
(15, 'UNIDAD'),
(16, 'PERMISO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partidas`
--

CREATE TABLE `partidas` (
  `id_partida` int(11) NOT NULL,
  `nombrepartida` varchar(50) NOT NULL,
  `responsable` varchar(50) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `anio` int(4) NOT NULL,
  `estado` enum('0','1') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id_pedido` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perdidas`
--

CREATE TABLE `perdidas` (
  `id_perdida` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `cantidad` int(4) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `precioProduc` decimal(10,2) NOT NULL,
  `fecha` date NOT NULL,
  `unidadDelProduc` varchar(45) DEFAULT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Disparadores `perdidas`
--
DELIMITER $$
CREATE TRIGGER `perdidas_AFTER_DELETE` AFTER DELETE ON `perdidas` FOR EACH ROW BEGIN
update kardex set stock = stock + old.cantidad 
    where kardex.id_producto1 = old.idproducto;
update kardex set entrada = entrada + old.cantidad
    where kardex.id_producto1 = old.idproducto;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `perdidas_AFTER_INSERT` AFTER INSERT ON `perdidas` FOR EACH ROW BEGIN
	update kardex set stock = stock - new.cantidad
    where kardex.id_producto1 = new.idproducto;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `perdidas_BEFORE_INSERT` BEFORE INSERT ON `perdidas` FOR EACH ROW BEGIN
	update kardex set salida = salida + new.cantidad
    where kardex.id_producto1 = new.idproducto;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perfil`
--

CREATE TABLE `perfil` (
  `idperfil` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `codperfil` varchar(45) NOT NULL,
  `estados` enum('0','1') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `perfil`
--

INSERT INTO `perfil` (`idperfil`, `nombre`, `codperfil`, `estados`) VALUES
(1, 'Administrador', 'dmP4Ei', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perfil_modulo`
--

CREATE TABLE `perfil_modulo` (
  `idperfil_modulo` int(11) NOT NULL,
  `id_modulo` int(11) NOT NULL,
  `idperfiles` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `perfil_modulo`
--

INSERT INTO `perfil_modulo` (`idperfil_modulo`, `id_modulo`, `idperfiles`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 1),
(10, 10, 1),
(11, 11, 1),
(12, 12, 1),
(13, 13, 1),
(14, 14, 1),
(15, 15, 1),
(16, 16, 1);


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `id_producto` int(11) NOT NULL,
  `producto` varchar(60) NOT NULL,
  `precio_venta` decimal(6,2) NOT NULL,
  `id_unidad` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `idcategorias` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `idrol` int(11) NOT NULL,
  `rol` varchar(45) NOT NULL,
  `codigo` varchar(45) NOT NULL,
  `descripcion` varchar(45) NOT NULL,
  `idmodulos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`idrol`, `rol`, `codigo`, `descripcion`, `idmodulos`) VALUES
(1, 'REGISTRAR', 'RECATE', 'acciones para registar en categoria', 8),
(2, 'EDITAR', 'EDCATE', 'accion para editar categoria', 8),
(3, 'ELIMINAR', 'ELCATE', 'accion para eliminar una categoria', 8),
(4, 'REGISRAR', 'REPROD', 'accion para registrar producto', 9),
(5, 'REGISTRAR', 'REUSUA', 'jdhfjhdjfhjdhfjdhf', 1),
(6, 'EDITAR', 'EDUSUA', 'DSDSD', 1),
(7, 'ELIMINAR', 'ELUSUA', 'FDFDFDF', 1),
(8, 'REGISTRAR', 'REINCI', 'DFDFDF', 2),
(9, 'ELIMINAR', 'ELINCI', 'SFDFDF', 2),
(10, 'REGISTRAR', 'REPART', 'DDSDSD', 3),
(11, 'EDITAR', 'EDPART', 'GHGHGHGH', 3),
(12, 'ELIMINAR', 'ELPART', 'HGHGHGH', 3),
(13, 'REGISTRAR', 'REPERD', 'HGHGHGH', 4),
(14, 'EDITAR', 'EDPERD', 'GHGHGH', 4),
(15, 'ELIMINAR', 'ELPERD', 'DSDSD', 4),
(16, 'REGISTRAR', 'REDONA', 'DSDSDSD', 5),
(17, 'EDITAR', 'EDDONA', 'DSDSDSD', 5),
(18, 'ELIMINAR', 'ELDONA', 'FDFDF', 5),
(19, 'REGISTRAR', 'REGAST', 'DSDSDSD', 6),
(20, 'EDITAR', 'EDGAST', 'DSDSDSD', 6),
(21, 'ELIMINAR', 'ELGAST', 'DSDSDSD', 6),
(22, 'REGISTRAR', 'RECAPA', 'SDSDSDSDSD', 7),
(23, 'EDITAR', 'EDCAPA', 'FDFDF', 7),
(24, 'ELIMINAR', 'ELCAPA', 'DSDSDS', 7),
(25, 'EDITAR', 'EDPROD', 'FDFDF', 9),
(26, 'ELIMINAR', 'ELPROD', 'DFDFDF', 9),
(27, 'REGISTRAR', 'REPEDI', 'REGISTAR PERDIDA', 10),
(28, 'EDITAR', 'EDPEDI', 'PEDIDOS', 10),
(29, 'ELIMINAR', 'ELPEDI', 'ELIMINAR PEDIDO', 10),
(30, 'REGISTRAR', 'REVENT', 'registra venta', 11),
(31, 'EDITAR', 'EDVENT', 'permite editar venta', 11),
(32, 'ELIMINAR', 'ELVENT', 'anula una venta', 11),
(33, 'REGISTRAR', 'REUNID', 'registrar unidad', 15),
(34, 'EDITAR', 'EDUNID', 'edita la unidad', 15),
(35, 'ELIMINAR', 'ELUNID', 'elimina unidad', 15),
(36, 'REGISTRAR', 'REPERM', 'agrega permiso', 16),
(37, 'EDITAR', 'EDPERM', 'edita los permiso', 16),
(38, 'ELIMINAR', 'ELPERM', 'eliminar permiso', 16),
(39, 'CONSULTAR', 'COGAST', 'consulta de gasto', 6),
(40, 'CONSULTAR', 'CODONA', 'comsulta de donaciones', 5),
(41, 'CONSULTAR', 'COINFO', 'consulta de informes', 12),
(42, 'CONSULTAR', 'COREPO', 'consulta de ventas', 13),
(43, 'EDITAR', 'EDINCI', 'edita la informacion ', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles_usuario`
--

CREATE TABLE `roles_usuario` (
  `idroles_usuario` int(11) NOT NULL,
  `idroles` int(11) NOT NULL,
  `id_usuarios` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--

--
-- Estructura de tabla para la tabla `unidad`
--

CREATE TABLE `unidad` (
  `idunidad` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `idusuariouni` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `apellidos` varchar(50) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `password` varchar(75) NOT NULL,
  `password2` varchar(75) NOT NULL,
  `fecha_ingreso` date NOT NULL,
  `estado` enum('0','1') NOT NULL,
  `usuario_imagen` varchar(50) NOT NULL,
  `idperfiles` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `idventas` int(11) NOT NULL,
  `fechaventa` date NOT NULL,
  `total_pagar` decimal(6,2) NOT NULL,
  `estado` enum('0','1') NOT NULL,
  `numero_venta` varchar(15) NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `capacitaciones`
--
ALTER TABLE `capacitaciones`
  ADD PRIMARY KEY (`id_capacitacion`),
  ADD KEY `idusuarios_idx4` (`id_usuario`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`),
  ADD KEY `id_usuarios_idx` (`id_usuarioscate`);

--
-- Indices de la tabla `cuentas`
--
ALTER TABLE `cuentas`
  ADD PRIMARY KEY (`id_cuenta`),
  ADD KEY `idpartida_idx` (`id_partida`);

--
-- Indices de la tabla `detallecapacitados`
--
ALTER TABLE `detallecapacitados`
  ADD PRIMARY KEY (`id_detallecapacitados`),
  ADD KEY `idcapacitaciones_idx` (`id_capacitacion`);

--
-- Indices de la tabla `detallepedidos`
--
ALTER TABLE `detallepedidos`
  ADD PRIMARY KEY (`id_detallepedido`),
  ADD KEY `idpedidos_idx` (`id_pedido`),
  ADD KEY `id_uni_idx` (`id_uni`);

--
-- Indices de la tabla `detalleventas`
--
ALTER TABLE `detalleventas`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `id_producto3_idx` (`id_producto`),
  ADD KEY `id_ventas_idx` (`id_ventas`);

--
-- Indices de la tabla `donaciones`
--
ALTER TABLE `donaciones`
  ADD PRIMARY KEY (`id_donacion`),
  ADD KEY `idusuarios_idx5` (`id_usuario`);

--
-- Indices de la tabla `entrada`
--
ALTER TABLE `entrada`
  ADD PRIMARY KEY (`id_entrada`),
  ADD KEY `id_cuenta_idx` (`id_cuenta`);

--
-- Indices de la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD PRIMARY KEY (`id_gasto`),
  ADD KEY `idusuarios_idx2` (`id_usuario`);

--
-- Indices de la tabla `incidentes`
--
ALTER TABLE `incidentes`
  ADD PRIMARY KEY (`id_incidente`),
  ADD KEY `idusuarios_idx8` (`id_usuario`);

--
-- Indices de la tabla `insumos`
--
ALTER TABLE `insumos`
  ADD PRIMARY KEY (`id_insumo`),
  ADD KEY `idcategoria_idx` (`idcategoria`),
  ADD KEY `iduni_idx` (`iduni`);

--
-- Indices de la tabla `kardex`
--
ALTER TABLE `kardex`
  ADD PRIMARY KEY (`idkardex`),
  ADD KEY `id_producto1_idx` (`id_producto1`);

--
-- Indices de la tabla `kardexinsumo`
--
ALTER TABLE `kardexinsumo`
  ADD PRIMARY KEY (`id_kardexinsumo`),
  ADD KEY `idinsumo_idx` (`idinsumo`);

--
-- Indices de la tabla `modulo`
--
ALTER TABLE `modulo`
  ADD PRIMARY KEY (`idmodulo`);

--
-- Indices de la tabla `partidas`
--
ALTER TABLE `partidas`
  ADD PRIMARY KEY (`id_partida`),
  ADD KEY `idusuarios_idx9` (`id_usuario`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `idusuarios_idx1` (`id_usuario`);

--
-- Indices de la tabla `perdidas`
--
ALTER TABLE `perdidas`
  ADD PRIMARY KEY (`id_perdida`),
  ADD KEY `idusuarios_idx3` (`id_usuario`),
  ADD KEY `idproducto_idx` (`idproducto`);

--
-- Indices de la tabla `perfil`
--
ALTER TABLE `perfil`
  ADD PRIMARY KEY (`idperfil`);

--
-- Indices de la tabla `perfil_modulo`
--
ALTER TABLE `perfil_modulo`
  ADD PRIMARY KEY (`idperfil_modulo`),
  ADD KEY `idmodulos_idx` (`id_modulo`),
  ADD KEY `idperfiles_idx` (`idperfiles`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `idusuarios_idx6` (`id_usuario`),
  ADD KEY `idcategorias_idx` (`idcategorias`),
  ADD KEY `idunidad_idx` (`id_unidad`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`idrol`),
  ADD KEY `id_modulos_idx` (`idmodulos`);

--
-- Indices de la tabla `roles_usuario`
--
ALTER TABLE `roles_usuario`
  ADD PRIMARY KEY (`idroles_usuario`),
  ADD KEY `id_usuarios_idx` (`id_usuarios`),
  ADD KEY `idroles_idx` (`idroles`);

--
-- Indices de la tabla `unidad`
--
ALTER TABLE `unidad`
  ADD PRIMARY KEY (`idunidad`),
  ADD KEY `id_usuario_idx` (`idusuariouni`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `id_perfiles_idx` (`idperfiles`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`idventas`),
  ADD KEY `idusuarios_idx7` (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `capacitaciones`
--
ALTER TABLE `capacitaciones`
  MODIFY `id_capacitacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cuentas`
--
ALTER TABLE `cuentas`
  MODIFY `id_cuenta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detallecapacitados`
--
ALTER TABLE `detallecapacitados`
  MODIFY `id_detallecapacitados` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detallepedidos`
--
ALTER TABLE `detallepedidos`
  MODIFY `id_detallepedido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalleventas`
--
ALTER TABLE `detalleventas`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `donaciones`
--
ALTER TABLE `donaciones`
  MODIFY `id_donacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `entrada`
--
ALTER TABLE `entrada`
  MODIFY `id_entrada` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `gastos`
--
ALTER TABLE `gastos`
  MODIFY `id_gasto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `incidentes`
--
ALTER TABLE `incidentes`
  MODIFY `id_incidente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `insumos`
--
ALTER TABLE `insumos`
  MODIFY `id_insumo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `kardex`
--
ALTER TABLE `kardex`
  MODIFY `idkardex` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `kardexinsumo`
--
ALTER TABLE `kardexinsumo`
  MODIFY `id_kardexinsumo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `modulo`
--
ALTER TABLE `modulo`
  MODIFY `idmodulo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `partidas`
--
ALTER TABLE `partidas`
  MODIFY `id_partida` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `perdidas`
--
ALTER TABLE `perdidas`
  MODIFY `id_perdida` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `perfil`
--
ALTER TABLE `perfil`
  MODIFY `idperfil` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `perfil_modulo`
--
ALTER TABLE `perfil_modulo`
  MODIFY `idperfil_modulo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT de la tabla `roles_usuario`
--
ALTER TABLE `roles_usuario`
  MODIFY `idroles_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=299;

--
-- AUTO_INCREMENT de la tabla `unidad`
--
ALTER TABLE `unidad`
  MODIFY `idunidad` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `idventas` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `capacitaciones`
--
ALTER TABLE `capacitaciones`
  ADD CONSTRAINT `idusuarios4` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD CONSTRAINT `id_usuarioscate` FOREIGN KEY (`id_usuarioscate`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `cuentas`
--
ALTER TABLE `cuentas`
  ADD CONSTRAINT `idpartida` FOREIGN KEY (`id_partida`) REFERENCES `partidas` (`id_partida`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detallecapacitados`
--
ALTER TABLE `detallecapacitados`
  ADD CONSTRAINT `id_capacitacion` FOREIGN KEY (`id_capacitacion`) REFERENCES `capacitaciones` (`id_capacitacion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detallepedidos`
--
ALTER TABLE `detallepedidos`
  ADD CONSTRAINT `id_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_uni` FOREIGN KEY (`id_uni`) REFERENCES `unidad` (`idunidad`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalleventas`
--
ALTER TABLE `detalleventas`
  ADD CONSTRAINT `id_producto3` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `id_ventas` FOREIGN KEY (`id_ventas`) REFERENCES `ventas` (`idventas`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `donaciones`
--
ALTER TABLE `donaciones`
  ADD CONSTRAINT `idusuarios5` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `entrada`
--
ALTER TABLE `entrada`
  ADD CONSTRAINT `id_cuenta` FOREIGN KEY (`id_cuenta`) REFERENCES `cuentas` (`id_cuenta`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD CONSTRAINT `idusuarios2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `incidentes`
--
ALTER TABLE `incidentes`
  ADD CONSTRAINT `idusuarios8` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `insumos`
--
ALTER TABLE `insumos`
  ADD CONSTRAINT `idcategoria` FOREIGN KEY (`idcategoria`) REFERENCES `categorias` (`id_categoria`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `iduni` FOREIGN KEY (`iduni`) REFERENCES `unidad` (`idunidad`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `kardex`
--
ALTER TABLE `kardex`
  ADD CONSTRAINT `id_producto1` FOREIGN KEY (`id_producto1`) REFERENCES `producto` (`id_producto`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Filtros para la tabla `kardexinsumo`
--
ALTER TABLE `kardexinsumo`
  ADD CONSTRAINT `idinsumo` FOREIGN KEY (`idinsumo`) REFERENCES `insumos` (`id_insumo`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `partidas`
--
ALTER TABLE `partidas`
  ADD CONSTRAINT `idusuarios9` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `idusuarios1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `perdidas`
--
ALTER TABLE `perdidas`
  ADD CONSTRAINT `idproducto` FOREIGN KEY (`idproducto`) REFERENCES `producto` (`id_producto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `idusuarios3` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `perfil_modulo`
--
ALTER TABLE `perfil_modulo`
  ADD CONSTRAINT `idmodulos` FOREIGN KEY (`id_modulo`) REFERENCES `modulo` (`idmodulo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `idperfiles` FOREIGN KEY (`idperfiles`) REFERENCES `perfil` (`idperfil`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `idcategorias` FOREIGN KEY (`idcategorias`) REFERENCES `categorias` (`id_categoria`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `idunidad` FOREIGN KEY (`id_unidad`) REFERENCES `unidad` (`idunidad`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `idusuarios6` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `rol`
--
ALTER TABLE `rol`
  ADD CONSTRAINT `id_modulos` FOREIGN KEY (`idmodulos`) REFERENCES `modulo` (`idmodulo`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `roles_usuario`
--
ALTER TABLE `roles_usuario`
  ADD CONSTRAINT `id_usuarios` FOREIGN KEY (`id_usuarios`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `idroles` FOREIGN KEY (`idroles`) REFERENCES `rol` (`idrol`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `unidad`
--
ALTER TABLE `unidad`
  ADD CONSTRAINT `id_usuario` FOREIGN KEY (`idusuariouni`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `id_perfiles` FOREIGN KEY (`idperfiles`) REFERENCES `perfil` (`idperfil`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `idusuarios7` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
