-- =====================================================================
-- Archivo 02: consultas básicas (SELECT, WHERE, ORDER BY, LIMIT, BETWEEN)
-- =====================================================================

USE Cuentas_por_cobrar;

-- ¿Qué clientes tienen domicilio en CABA?
SELECT razon_social, rubro
FROM clientes
WHERE provincia = 'CABA';

-- ¿Qué facturas superan $1.000.000? (de mayor a menor)
SELECT id_factura, id_cliente, importe
FROM facturas
WHERE importe > 1000000
ORDER BY importe DESC;

-- ¿Cuáles son las 5 facturas de mayor importe?
SELECT id_factura, importe
FROM facturas
ORDER BY importe DESC
LIMIT 5;

-- ¿Qué facturas se emitieron en el tercer trimestre?
SELECT *
FROM facturas
WHERE fecha_emision BETWEEN '2026-07-01' AND '2026-09-30';

-- ¿Qué cobros se recibieron en cheque? (ordenados por fecha)
SELECT id_cobro, id_factura, fecha_cobro, importe
FROM cobros
WHERE medio_pago = 'Cheque'
ORDER BY fecha_cobro;
