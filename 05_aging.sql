-- =====================================================================
-- Archivo 05: antigüedad de saldos (aging)
-- Fecha de corte fija: 2026-11-04, para que los resultados sean
-- reproducibles. (Con CURDATE() cambiarían todos los días.)
-- =====================================================================

USE Cuentas_por_cobrar;

-- Días de atraso de cada factura con saldo pendiente
-- (valores negativos = todavía no vencida)
SELECT f.id_factura,
       c.razon_social,
       f.fecha_vencimiento,
       f.importe - COALESCE(SUM(co.importe), 0)    AS saldo,
       DATEDIFF('2026-11-04', f.fecha_vencimiento) AS dias_vencido
FROM facturas f
JOIN clientes c     ON c.id_cliente  = f.id_cliente
LEFT JOIN cobros co ON co.id_factura = f.id_factura
GROUP BY f.id_factura, c.razon_social, f.fecha_vencimiento, f.importe
HAVING saldo > 0
ORDER BY dias_vencido DESC;

-- Detalle por factura con su tramo de antigüedad
-- WITH: calcula una tabla temporal "saldos" que se usa como tabla común.
-- CASE: asigna el tramo según los días de atraso (como un SI anidado).
WITH saldos AS (
    SELECT f.id_factura,
           c.razon_social,
           f.importe - COALESCE(SUM(co.importe), 0)    AS saldo,
           DATEDIFF('2026-11-04', f.fecha_vencimiento) AS dias_vencido
    FROM facturas f
    JOIN clientes c     ON c.id_cliente  = f.id_cliente
    LEFT JOIN cobros co ON co.id_factura = f.id_factura
    GROUP BY f.id_factura, c.razon_social, f.fecha_vencimiento, f.importe
)
SELECT id_factura, razon_social, saldo, dias_vencido,
       CASE
           WHEN dias_vencido <= 0  THEN '0. No vencido'
           WHEN dias_vencido <= 30 THEN '1. 1 a 30 días'
           WHEN dias_vencido <= 60 THEN '2. 31 a 60 días'
           WHEN dias_vencido <= 90 THEN '3. 61 a 90 días'
           ELSE                         '4. Más de 90 días'
       END AS tramo
FROM saldos
WHERE saldo > 0
ORDER BY dias_vencido DESC;

-- Cuadro resumen: saldo total por tramo de antigüedad
WITH saldos AS (
    SELECT f.id_factura,
           f.importe - COALESCE(SUM(co.importe), 0)    AS saldo,
           DATEDIFF('2026-11-04', f.fecha_vencimiento) AS dias_vencido
    FROM facturas f
    LEFT JOIN cobros co ON co.id_factura = f.id_factura
    GROUP BY f.id_factura, f.importe, f.fecha_vencimiento
)
SELECT CASE
           WHEN dias_vencido <= 0  THEN '0. No vencido'
           WHEN dias_vencido <= 30 THEN '1. 1 a 30 días'
           WHEN dias_vencido <= 60 THEN '2. 31 a 60 días'
           WHEN dias_vencido <= 90 THEN '3. 61 a 90 días'
           ELSE                         '4. Más de 90 días'
       END        AS tramo,
       COUNT(*)   AS facturas,
       SUM(saldo) AS saldo_total
FROM saldos
WHERE saldo > 0
GROUP BY tramo
ORDER BY tramo;

-- Aging por cliente (una columna por tramo, estilo tabla dinámica)
WITH saldos AS (
    SELECT c.razon_social,
           f.importe - COALESCE(SUM(co.importe), 0)    AS saldo,
           DATEDIFF('2026-11-04', f.fecha_vencimiento) AS dias_vencido
    FROM facturas f
    JOIN clientes c     ON c.id_cliente  = f.id_cliente
    LEFT JOIN cobros co ON co.id_factura = f.id_factura
    GROUP BY f.id_factura, c.razon_social, f.importe, f.fecha_vencimiento
)
SELECT razon_social,
       SUM(CASE WHEN dias_vencido <= 0              THEN saldo ELSE 0 END) AS no_vencido,
       SUM(CASE WHEN dias_vencido BETWEEN 1  AND 30 THEN saldo ELSE 0 END) AS vencido_1_30,
       SUM(CASE WHEN dias_vencido BETWEEN 31 AND 60 THEN saldo ELSE 0 END) AS vencido_31_60,
       SUM(CASE WHEN dias_vencido BETWEEN 61 AND 90 THEN saldo ELSE 0 END) AS vencido_61_90,
       SUM(CASE WHEN dias_vencido > 90              THEN saldo ELSE 0 END) AS vencido_mas_90,
       SUM(saldo)                                                          AS total
FROM saldos
WHERE saldo > 0
GROUP BY razon_social
ORDER BY total DESC;
