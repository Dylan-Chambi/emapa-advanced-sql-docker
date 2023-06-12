CREATE DATABASE IF NOT EXISTS emapa_productos;

USE emapa_productos;

CREATE TABLE IF NOT EXISTS categoria (
    id_categoria INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    nombre_categoria VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_categoria)
);

CREATE TABLE IF NOT EXISTS empresa (
    id_empresa INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    nombre_empresa VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_empresa)
);

CREATE TABLE IF NOT EXISTS direccion (
    id_direccion INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    calle_o_avenida_direccion VARCHAR(255) NOT NULL,
    nro_domicilio_direccion INT UNSIGNED NOT NULL,
    zona_direccion VARCHAR(50) NOT NULL,
    departamento_direccion VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_direccion)
);

CREATE TABLE IF NOT EXISTS sucursal(
    id_sucursal INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    direccion_sucursal_id INT UNSIGNED NOT NULL,
    nombre_sucursal VARCHAR(100) NOT NULL,
    telefono_sucursal VARCHAR(20) NOT NULL,
    correo_sucursal VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_sucursal),
    FOREIGN KEY (direccion_sucursal_id) REFERENCES direccion (id_direccion)
);

CREATE TABLE IF NOT EXISTS almacen (
    id_almacen INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    nombre_almacen VARCHAR(100) NOT NULL,
    nro_piso_almacen INT UNSIGNED NOT NULL,
    nro_cuarto_almacen INT UNSIGNED NOT NULL,
    sucursal_almacen INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_almacen),
    FOREIGN KEY (sucursal_almacen) REFERENCES sucursal (id_sucursal)
);

CREATE TABLE IF NOT EXISTS cliente (
    nit_ci BIGINT UNSIGNED NOT NULL UNIQUE,
    nombre_cliente VARCHAR(50) NOT NULL,
    segundo_nombre VARCHAR(50),
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50) NOT NULL,
    correo_cliente VARCHAR(30) NOT NULL,
    telefono_cliente VARCHAR(20) NOT NULL,
    extension_ci VARCHAR(5) NOT NULL,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    PRIMARY KEY (nit_ci)
);

CREATE TABLE IF NOT EXISTS cliente_shadow (
    id_shadow INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    nit_ci BIGINT UNSIGNED,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    accion VARCHAR(50),
    PRIMARY KEY (id_shadow)
);

CREATE TABLE IF NOT EXISTS marca (
    id_marca INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    nombre_marca VARCHAR(100) NOT NULL,
    empresa_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_marca),
    FOREIGN KEY (empresa_id) REFERENCES empresa (id_empresa)
);

CREATE TABLE IF NOT EXISTS proveedor (
    id_proveedor INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    nombre_proveedor VARCHAR(100) NOT NULL,
    empresa_id INT UNSIGNED NOT NULL,
    telefono_proveedor VARCHAR(20),
    encargado_proveedor VARCHAR(50),
    direccion_proveedor_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_proveedor),
    FOREIGN KEY (empresa_id) REFERENCES empresa (id_empresa),
    FOREIGN KEY (direccion_proveedor_id) REFERENCES direccion (id_direccion)
);

CREATE TABLE IF NOT EXISTS factura (
    nro_factura BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    nro_autorizacion INT UNSIGNED NOT NULL,
    nit_empresa BIGINT UNSIGNED NOT NULL,
    fecha_emision DATE NOT NULL,
    nombre_o_razon_social VARCHAR(255) NOT NULL,
    cliente_nit_ci BIGINT UNSIGNED NOT NULL,
    detalle VARCHAR(255),
    subtotal DECIMAL(10, 2) NOT NULL,
    importe_total DECIMAL(10, 2) NOT NULL,
    codigo_control VARCHAR(255) NOT NULL,
    codigo_qr BLOB,
    fecha_limite_emision DATE NOT NULL,
    estado ENUM('ACTIVA', 'ANULADA', 'PENDIENTE') NOT NULL,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    PRIMARY KEY (nro_factura),
    FOREIGN KEY (cliente_nit_ci) references cliente (nit_ci)
) AUTO_INCREMENT = 10000000;

CREATE TABLE IF NOT EXISTS factura_shadow (
    id_shadow INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    nro_factura BIGINT UNSIGNED,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    accion VARCHAR(50),
    PRIMARY KEY (id_shadow)
);

CREATE TABLE IF NOT EXISTS producto (
    id_producto BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    nombre_producto VARCHAR(100) NOT NULL,
    proveedor_id INT UNSIGNED NOT NULL,
    codigo_barras BIGINT UNSIGNED,
    precio_nacional DECIMAL(10, 2) NOT NULL,
    marca_id INT UNSIGNED NOT NULL,
    categoria_id INT UNSIGNED NOT NULL,
    estado_producto ENUM('HABILITADO', 'DESHABILITADO'),
    cantidad_stock_total INT UNSIGNED NOT NULL,
    cantidad_vendida_total INT UNSIGNED NOT NULL,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    PRIMARY KEY (id_producto),
    FOREIGN KEY (proveedor_id) REFERENCES proveedor (id_proveedor),
    FOREIGN KEY (marca_id) REFERENCES marca (id_marca),
    FOREIGN KEY (categoria_id) REFERENCES categoria (id_categoria)
);

CREATE TABLE IF NOT EXISTS producto_shadow (
    id_shadow INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    id_producto BIGINT UNSIGNED,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    accion VARCHAR(50),
    PRIMARY KEY (id_shadow)
);

CREATE TABLE IF NOT EXISTS almacen_producto (
    producto_id BIGINT UNSIGNED NOT NULL,
    almacen_id INT UNSIGNED NOT NULL,
    cantidad_producto INT UNSIGNED NOT NULL,
    PRIMARY KEY (producto_id, almacen_id),
    FOREIGN KEY (producto_id) REFERENCES producto (id_producto),
    FOREIGN KEY (almacen_id) REFERENCES almacen (id_almacen)
);

CREATE TABLE IF NOT EXISTS compra (
    id_compra INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    fecha_compra DATE NOT NULL,
    proveedor_id INT UNSIGNED NOT NULL,
    total_compra DECIMAL(10, 2) NOT NULL,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    PRIMARY KEY (id_compra),
    FOREIGN KEY (proveedor_id) REFERENCES proveedor (id_proveedor)
);

CREATE TABLE IF NOT EXISTS compra_shadow (
    id_shadow INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    id_compra INT UNSIGNED,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    accion VARCHAR(50),
    PRIMARY KEY (id_shadow)
);

CREATE TABLE IF NOT EXISTS lote_compra (
    compra_id INT UNSIGNED NOT NULL,
    producto_id BIGINT UNSIGNED NOT NULL,
    fecha_vencimiento_lote DATE NOT NULL,
    cantidad_producto MEDIUMINT UNSIGNED NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    total_lote_compra DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (compra_id, producto_id),
    FOREIGN KEY (compra_id) REFERENCES compra (id_compra),
    FOREIGN KEY (producto_id) REFERENCES producto (id_producto)
);

CREATE TABLE IF NOT EXISTS venta (
    id_venta INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    fecha_venta DATE NOT NULL,
    cliente_nit_ci BIGINT UNSIGNED NOT NULL,
    estado_venta ENUM('INMEDIATA', 'PENDIENTE', 'PAGADA') NOT NULL,
    factura_nro BIGINT UNSIGNED NOT NULL UNIQUE,
    total_venta DECIMAL(10, 2) NOT NULL,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    PRIMARY KEY (id_venta),
    FOREIGN KEY (cliente_nit_ci) references cliente (nit_ci),
    FOREIGN KEY (factura_nro) references factura (nro_factura)
);

CREATE TABLE IF NOT EXISTS venta_shadow (
    id_shadow INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    id_venta INT UNSIGNED,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    accion VARCHAR(50),
    PRIMARY KEY (id_shadow)
);

CREATE TABLE IF NOT EXISTS lote_venta (
    venta_id INT UNSIGNED NOT NULL,
    producto_id BIGINT UNSIGNED NOT NULL,
    cantidad_producto MEDIUMINT UNSIGNED NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    total_lote_compra DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (venta_id, producto_id),
    FOREIGN KEY (venta_id) REFERENCES venta (id_venta),
    FOREIGN KEY (producto_id) REFERENCES producto (id_producto)
);

CREATE TABLE IF NOT EXISTS movimiento_producto (
    id_movimiento INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    producto_id BIGINT UNSIGNED NOT NULL,
    almacen_origen_id INT UNSIGNED NOT NULL,
    almacen_destino_id INT UNSIGNED NOT NULL,
    fecha_movimiento DATE NOT NULL,
    cantidad_movimiento INT UNSIGNED NOT NULL,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    PRIMARY KEY (id_movimiento),
    FOREIGN KEY (producto_id) REFERENCES producto (id_producto),
    FOREIGN KEY (almacen_origen_id) REFERENCES almacen (id_almacen),
    FOREIGN KEY (almacen_destino_id) REFERENCES almacen (id_almacen)
);

CREATE TABLE IF NOT EXISTS movimiento_producto_shadow (
    id_shadow INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    id_movimiento INT UNSIGNED,
    mod_usuario VARCHAR(50),
    mod_fecha DATETIME,
    accion VARCHAR(50),
    PRIMARY KEY (id_shadow)
);
