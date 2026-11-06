-- =====================================================================
-- PROYECTO: Análisis de cuentas por cobrar con SQL
-- Archivo 01: creación de la base de datos, tablas y carga de datos
-- Motor: MySQL 8
-- Datos: ficticios, creados para este proyecto
-- =====================================================================

-- Se elimina la base si ya existe, para poder ejecutar el script
-- completo desde cero sin errores. ¡Ojo: borra todos los datos!
DROP DATABASE IF EXISTS Cuentas_por_cobrar;
CREATE DATABASE Cuentas_por_cobrar;
USE Cuentas_por_cobrar;

-- ---------------------------------------------------------------------
-- TABLAS
-- Relación: un cliente tiene muchas facturas; una factura puede tener
-- varios cobros (pagos parciales) o ninguno (impaga).
-- ---------------------------------------------------------------------

-- Maestro de clientes
CREATE TABLE clientes (
    id_cliente     INT PRIMARY KEY,
    razon_social   VARCHAR(100),
    cuit           VARCHAR(13),
    provincia      VARCHAR(50),
    rubro          VARCHAR(50)
);

-- Facturas emitidas (condición de pago: 30 días)
CREATE TABLE facturas (
    id_factura        INT PRIMARY KEY,
    id_cliente        INT,
    fecha_emision     DATE,
    fecha_vencimiento DATE,
    importe           DECIMAL(12,2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Cobros recibidos, imputados a cada factura
CREATE TABLE cobros (
    id_cobro      INT PRIMARY KEY,
    id_factura    INT,
    fecha_cobro   DATE,
    importe       DECIMAL(12,2),
    medio_pago    VARCHAR(30),
    FOREIGN KEY (id_factura) REFERENCES facturas(id_factura)
);

-- ---------------------------------------------------------------------
-- CARGA DE DATOS
-- El orden importa: clientes -> facturas -> cobros
-- ---------------------------------------------------------------------

INSERT INTO clientes (id_cliente, razon_social, cuit, provincia, rubro) VALUES
(1, 'Distribuidora del Sur SA',  '30-71234567-1', 'Buenos Aires', 'Comercio'),
(2, 'Agro Pampa SRL',            '30-70987654-2', 'Córdoba',      'Agropecuario'),
(3, 'Constructora Andina SA',    '30-71555222-3', 'Mendoza',      'Construcción'),
(4, 'Farmacia Central SRL',      '30-70111333-4', 'Santa Fe',     'Salud'),
(5, 'Tecno Soluciones SAS',      '30-71888999-5', 'CABA',         'Tecnología'),
(6, 'Transportes Norte SA',      '30-70444666-6', 'Salta',        'Logística'),
(7, 'Panificadora Litoral SRL',  '30-71777000-7', 'Entre Ríos',   'Alimentos'),
(8, 'Estudio Gómez y Asoc.',     '30-70222555-8', 'CABA',         'Servicios');

INSERT INTO facturas (id_factura, id_cliente, fecha_emision, fecha_vencimiento, importe) VALUES
(1,  1, '2026-05-05', '2026-06-04',  850000.00),
(2,  2, '2026-05-12', '2026-06-11', 1200000.00),
(3,  3, '2026-05-20', '2026-06-19', 2350000.00),
(4,  4, '2026-06-03', '2026-07-03',  430000.00),
(5,  5, '2026-06-10', '2026-07-10',  975000.00),
(6,  1, '2026-06-18', '2026-07-18',  620000.00),
(7,  6, '2026-06-25', '2026-07-25', 1580000.00),
(8,  7, '2026-07-02', '2026-08-01',  310000.00),
(9,  2, '2026-07-09', '2026-08-08', 1450000.00),
(10, 8, '2026-07-15', '2026-08-14',  540000.00),
(11, 3, '2026-07-28', '2026-08-27', 3100000.00),
(12, 4, '2026-08-05', '2026-09-04',  385000.00),
(13, 5, '2026-08-14', '2026-09-13', 1120000.00),
(14, 1, '2026-08-21', '2026-09-20',  760000.00),
(15, 6, '2026-09-02', '2026-10-02', 1690000.00),
(16, 7, '2026-09-11', '2026-10-11',  295000.00),
(17, 2, '2026-09-22', '2026-10-22', 1830000.00),
(18, 8, '2026-10-01', '2026-10-31',  610000.00),
(19, 3, '2026-10-14', '2026-11-13', 2750000.00),
(20, 5, '2026-10-24', '2026-11-23',  890000.00);

INSERT INTO cobros (id_cobro, id_factura, fecha_cobro, importe, medio_pago) VALUES
(1,  1,  '2026-06-02',  850000.00, 'Transferencia'),
(2,  2,  '2026-06-15',  600000.00, 'Transferencia'),
(3,  2,  '2026-07-10',  600000.00, 'Cheque'),
(4,  3,  '2026-07-05', 1000000.00, 'Cheque'),
(5,  4,  '2026-07-01',  430000.00, 'Transferencia'),
(6,  5,  '2026-08-20',  975000.00, 'Transferencia'),
(7,  6,  '2026-07-16',  620000.00, 'Transferencia'),
(8,  7,  '2026-08-10',  800000.00, 'Cheque'),
(9,  8,  '2026-07-30',  310000.00, 'Efectivo'),
(10, 9,  '2026-08-05', 1450000.00, 'Transferencia'),
(11, 11, '2026-09-15', 1500000.00, 'Cheque'),
(12, 12, '2026-09-03',  385000.00, 'Transferencia'),
(13, 13, '2026-10-05', 1120000.00, 'Transferencia'),
(14, 15, '2026-10-20',  900000.00, 'Transferencia'),
(15, 16, '2026-10-09',  295000.00, 'Efectivo'),
(16, 19, '2026-11-02', 1000000.00, 'Transferencia');

-- Verificación: deben aparecer las 3 tablas
SHOW TABLES;
