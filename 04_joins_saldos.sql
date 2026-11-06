-- =====================================================================
-- Archivo 04: cruce de tablas (JOIN, LEFT JOIN) y saldos pendientes
-- =====================================================================

USE Cuentas_por_cobrar;

-- Facturas con la razón social del cliente
SELECT f.id_factura, c.razon_social, f.fecha_emision, f.importe
FROM facturas f
JOIN clientes c ON c.id_cliente = f.id_cliente
ORDER BY f.id_factura;

-- Ranking de clientes por facturación
SELECT c.razon_social, SUM(f.importe) AS total_facturado
FROM facturas f
JOIN clientes c ON c.id_cliente = f.id_cliente
GROUP BY c.razon_social
ORDER BY total_facturado DESC;

-- ¿Cuál es el saldo pendiente de cada factura?
-- LEFT JOIN: incluye las facturas sin ningún cobro (impagas).
-- COALESCE: si no hay cobros, la suma es NULL y se reemplaza por 0.
SELECT f.id_factura,
       c.razon_social,
       f.fecha_vencimiento,
       f.importe,
       COALESCE(SUM(co.importe), 0)            AS cobrado,
       f.importe - COALESCE(SUM(co.importe), 0) AS saldo
FROM facturas f
JOIN clientes c     ON c.id_cliente  = f.id_cliente
LEFT JOIN cobros co ON co.id_factura = f.id_factura
GROUP BY f.id_factura, c.razon_social, f.fecha_vencimiento, f.importe
HAVING saldo > 0
ORDER BY saldo DESC;
