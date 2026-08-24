USE Ventas_Tech_DB;

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR (100) NOT NULL, 
    email VARCHAR (100) UNIQUE,
    ciudad VARCHAR (50),
    fecha_registro DATE NOT NULL
);

CREATE TABLE productos (
    id_producto INT PRIMARY KEY, 
    nombre_producto VARCHAR (100) NOT NULL,
    id_categoria INT,
    precio DECIMAL (10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo TINYINT DEFAULT 1,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
    );

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad  INT NOT NULL,
    precio_unitario DECIMAL (10,2) NOT NULL, 
    fecha_venta DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
    );

INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Componentes', 'Placas graficas, Placas madres y Memorias RAM');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

INSERT INTO clientes VALUES (1, 'Leon Apesteguia',   'Leon@gmail.com',   'Buenos Aires', '2024-01-05');
INSERT INTO clientes VALUES (2, 'Amadeo Lozano',   'Amadeo@gmail.com',  'Córdoba',      '2024-01-10');
INSERT INTO clientes VALUES (3, 'Keila Obert',     'Kei@gmail.com',     'Rosario',      '2024-02-01');
INSERT INTO clientes VALUES (4, 'Sofia Ledda',    'Sofia@gmail.com',   'Mendoza',      '2024-02-15');
INSERT INTO clientes VALUES (5, 'Bautista Rubio',  'Bautista@gmail.com',   'Tucumán',      '2024-03-01');

INSERT INTO productos VALUES (1, 'Laptop Pro 15',       1, 1200.00, 15, 1);
INSERT INTO productos VALUES (2, 'Nvidia GTX 1060 Ti',   2,   600.00, 80, 1);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"',      1,  450.00, 12, 1);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro',  3,  120.00, 35, 1);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB',     4,  130.00, 18, 1);
INSERT INTO productos VALUES (6, 'Memoria Ram 16gb',    2,   150.00, 40, 1);

INSERT INTO ventas VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas VALUES (2,  2, 2, 5,   600.00, '2024-03-06');
INSERT INTO ventas VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas VALUES (6,  2, 6, 4,   150.00, '2024-03-11');
INSERT INTO ventas VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8,  3, 2, 8,   600.00, '2024-03-13');
INSERT INTO ventas VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');

SELECT * FROM ventas;

SELECT 
     MONTH (fecha_venta) AS mes, 
     SUM(cantidad * precio_unitario) AS total_facturado, 
     COUNT (id_venta) AS cantidad_pedidos, 
     AVG (cantidad * precio_unitario) AS ticket_promedio 
FROM ventas
GROUP BY MONTH (fecha_venta) 
ORDER BY mes;

SELECT TOP 5
     id_producto, 
     SUM (cantidad) AS unidades_vendidas, 
     SUM (cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC

SELECT
     id_cliente,
     COUNT (*) AS cantidad_pedidos,
     SUM (cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT (*) > 1


DECLARE @promedio_general DECIMAL(10,2);

SELECT @promedio_general = AVG(total_mensual)
FROM (
    SELECT SUM(cantidad * precio_unitario) AS total_mensual
    FROM ventas
    GROUP BY MONTH(fecha_venta)
) AS totales_por_mes;

SELECT 
     MONTH (fecha_venta) AS mes, 
     SUM (cantidad * precio_unitario) AS total_facturado,
CASE 
    WHEN SUM(cantidad * precio_unitario) > @promedio_general THEN 'Por encima'
    ELSE 'Por debajo'
END AS comparacion_promedio
FROM ventas
GROUP BY MONTH (fecha_venta)
ORDER BY mes;

SELECT * FROM productos;

-- ══════════════════════════════════════════
-- Hallazgos del análisis
-- ══════════════════════════════════════════

-- 1. El producto líder en facturación fue "Nvidia GTX 1060 Ti" (id_producto 2),
--    con $7.800 facturados y 13 unidades vendidas, muy por encima del segundo
--    puesto ($3.600 facturados, solo 3 unidades vendidas).

-- 2. Los 5 clientes registrados realizaron exactamente 2 compras cada uno
--    (100% de recurrencia). Es un dato llamativo, aunque probablemente se
--    explique porque el análisis cubre solo el mes de marzo, un período corto.

-- 3. Todas las ventas caen dentro del mes de marzo. Esto es una limitación de
--    los datos actuales (dataset de prueba reducido), no una conclusión de
--    negocio real: para validar tendencias mensuales genuinas haría falta
--    cargar datos de varios meses.