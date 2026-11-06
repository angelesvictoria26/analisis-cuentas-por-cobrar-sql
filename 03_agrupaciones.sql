-- =====================================================================
-- Archivo 03: totales y agrupaciones (COUNT, SUM, AVG, GROUP BY, HAVING)
-- =====================================================================

USE Cuentas_por_cobrar;

-- Resumen general de la facturación
SELECT COUNT(*)                AS cantidad_facturas,
       SUM(importe)            AS total_facturado,
       ROUND(AVG(importe), 2)  AS ticket_promedio
FROM facturas;

-- Control: total cobrado (facturado - cobrado = saldo pendiente)
SELECT SUM(importe) AS total_cobrado
FROM cobros;

-- ¿Cuánto se le facturó a cada cliente?
SELECT id_cliente, SUM(importe) AS total_facturado
FROM facturas
GROUP BY id_cliente
ORDER BY total_facturado DESC;

-- ¿Cómo evolucionó la facturación mes a mes?
SELECT DATE_FORMAT(fecha_emision, '%Y-%m') AS mes,
       SUM(importe) AS total
FROM facturas
GROUP BY mes
ORDER BY mes;

-- ¿Qué medios de pago superan los $2.000.000 cobrados?
-- (WHERE filtra filas antes de agrupar; HAVING filtra grupos después)
SELECT medio_pago, COUNT(*) AS cantidad, SUM(importe) AS total
FROM cobros
GROUP BY medio_pago
HAVING total > 2000000;
