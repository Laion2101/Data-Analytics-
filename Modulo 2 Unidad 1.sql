CREATE DATABASE RetailPro;
USE RetailPro;
CREATE TABLE clientes (
id_cliente INT, -- numero entero, identifica a cada cliente de forma unica
nombre VARCHAR (100), -- texto corto; 100 caracteres que cubren nombres compuestos
perfil_bio VARCHAR (max), -- texto sin limite fijo, puede variar mucho en extension
fecha_registro DATE -- Solo se necesita el dia, no la hora
); 
CREATE TABLE productos (
id_producto INT, -- numero entero, identifica a cada producto de forma unica
descripcion VARCHAR (255), -- texto intermedio; 255 caracteres que cubren una breve descripcion del producto
precio DECIMAL (10,2), -- precio de los productos, con un maximo de 10 digitos y 2 decimales
esta_activo BIT -- dos opciones que representan si el producto está a la venta o no
);