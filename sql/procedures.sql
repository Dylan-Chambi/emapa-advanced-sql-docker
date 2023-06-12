USE emapa_productos;

DELIMITER //


-- TODO: Reutilizar y automatizar el registro de movimientos entre almacenes
DROP PROCEDURE IF EXISTS mover_productos_entre_almacenes //
CREATE PROCEDURE mover_productos_entre_almacenes(
    IN producto_id BIGINT UNSIGNED,
    IN almacen_origen_id INT UNSIGNED,
    IN almacen_destino_id INT UNSIGNED,
    IN fecha_movimiento DATE,
    IN cantidad_movimiento INT UNSIGNED
)
    BEGIN
    DECLARE existe_producto_origen INT;
    DECLARE existe_producto_destino INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            RESIGNAL;
        END;

        IF almacen_origen_id = almacen_destino_id THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El almacen origen y el almacen destino no pueden ser el mismo';
        END IF;
                
        SET existe_producto_origen = (SELECT COUNT(*) FROM almacen_producto WHERE almacen_producto.almacen_id = almacen_origen_id AND almacen_producto.producto_id = producto_id);
        SET existe_producto_destino = (SELECT COUNT(*) FROM almacen_producto WHERE almacen_producto.almacen_id = almacen_destino_id AND almacen_producto.producto_id = producto_id);

        IF existe_producto_origen = 0 THEN
            START TRANSACTION;
            INSERT INTO almacen_producto (producto_id, almacen_id, cantidad_producto) VALUES (producto_id, almacen_origen_id, 0);
            COMMIT;
        END IF;

        START TRANSACTION;
        IF existe_producto_destino = 0 THEN
            INSERT INTO almacen_producto (producto_id, almacen_id, cantidad_producto) VALUES (producto_id, almacen_destino_id, 0);
        END IF;

        INSERT INTO movimiento_producto (producto_id, almacen_origen_id, almacen_destino_id, fecha_movimiento, cantidad_movimiento) VALUES (producto_id, almacen_origen_id, almacen_destino_id, fecha_movimiento, cantidad_movimiento);
        COMMIT;
END //


-- TODO: Agregar producos, junto con su respectivo almacen
DROP PROCEDURE IF EXISTS agregar_producto_con_almacen //
CREATE PROCEDURE agregar_producto_con_almacen(
    IN nombre_producto VARCHAR(100),
    IN proveedor_id INT UNSIGNED,
    IN codigo_barras BIGINT UNSIGNED,
    IN precio_nacional DECIMAL(10, 2),
    IN marca_id INT UNSIGNED,
    IN categoria_id INT UNSIGNED,
    IN estado_producto ENUM('HABILITADO', 'DESHABILITADO'),
    IN almacen_id INT UNSIGNED
)
BEGIN
    DECLARE producto_id BIGINT UNSIGNED;
    DECLARE almacen_existente INT UNSIGNED;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO producto (nombre_producto, proveedor_id, codigo_barras, precio_nacional, marca_id, categoria_id, estado_producto, cantidad_stock_total, cantidad_vendida_total)
    VALUES (nombre_producto, proveedor_id, codigo_barras, precio_nacional, marca_id, categoria_id, estado_producto, 0, 0);

    SET producto_id = LAST_INSERT_ID();

    INSERT INTO almacen_producto (producto_id, almacen_id, cantidad_producto) VALUES (producto_id, almacen_id, 0);
    COMMIT;
END //


-- TODO: Automatizacion del registro de una compra de productos
DROP PROCEDURE IF EXISTS crear_compra //
CREATE PROCEDURE crear_compra(
    IN compra_info JSON
)
BEGIN
    DECLARE compra_id INT UNSIGNED;
    DECLARE producto_id BIGINT UNSIGNED;
    DECLARE fecha_vencimiento DATE;
    DECLARE cantidad_producto MEDIUMINT UNSIGNED;
    DECLARE precio_unitario DECIMAL(10, 2);
    DECLARE producto_existente INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO compra (fecha_compra, proveedor_id, total_compra) VALUES (
        JSON_UNQUOTE(JSON_EXTRACT(compra_info, '$.fecha_compra')),
        JSON_UNQUOTE(JSON_EXTRACT(compra_info, '$.proveedor_id')),
        0
    );

    SET compra_id = LAST_INSERT_ID();

    SET @productos = JSON_EXTRACT(compra_info, '$.productos');
    SET @num_productos = JSON_LENGTH(@productos);
    SET @i = 0;

    WHILE @i < @num_productos DO
        SET @producto = JSON_EXTRACT(@productos, CONCAT('$[', @i, ']'));
        SET producto_id = JSON_UNQUOTE(JSON_EXTRACT(@producto, '$.producto_id'));
        SET cantidad_producto = JSON_UNQUOTE(JSON_EXTRACT(@producto, '$.cantidad_producto'));
        SET precio_unitario = JSON_UNQUOTE(JSON_EXTRACT(@producto, '$.precio_unitario'));
        SET fecha_vencimiento = JSON_UNQUOTE(JSON_EXTRACT(@producto, '$.fecha_vencimiento'));
        
        INSERT INTO lote_compra (compra_id, producto_id, fecha_vencimiento_lote, cantidad_producto, precio_unitario) VALUES (
            compra_id,
            producto_id,
            fecha_vencimiento,
            cantidad_producto,
            precio_unitario
        );

        SET @i = @i + 1;
    END WHILE;

    COMMIT;
END //


-- TODO: Automatizacion del registro de una venta de productos
DROP PROCEDURE IF EXISTS crear_venta //
CREATE PROCEDURE crear_venta(
    IN venta_info JSON
)
BEGIN
    DECLARE factura_id INT UNSIGNED;
    DECLARE venta_id INT UNSIGNED;
    DECLARE producto_id BIGINT UNSIGNED;
    DECLARe nro_autorizacion INT UNSIGNED;
    DECLARE cliente_nit_ci BIGINT UNSIGNED;
    DECLARE nit_empresa BIGINT UNSIGNED;
    DECLARE fecha_emision DATE;
    DECLARE nombre_o_razon_social VARCHAR(255);
    DECLARE detalle VARCHAR(255);
    DECLARE codigo_control VARCHAR(255);
    DECLARE codigo_qr BLOB;
    DECLARE fecha_limite_emision DATE;
    DECLARE cantidad_producto INT UNSIGNED;
    DECLARE precio_unitario DECIMAL(10, 2);
    DECLARE producto_existente INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET nro_autorizacion = JSON_UNQUOTE(JSON_EXTRACT(venta_info, '$.nro_autorizacion'));
    SET cliente_nit_ci = JSON_UNQUOTE(JSON_EXTRACT(venta_info, '$.cliente_nit_ci'));
    SET nit_empresa = JSON_UNQUOTE(JSON_EXTRACT(venta_info, '$.nit_empresa'));
    SET fecha_emision = JSON_UNQUOTE(JSON_EXTRACT(venta_info, '$.fecha_emision'));
    SET nombre_o_razon_social = JSON_UNQUOTE(JSON_EXTRACT(venta_info, '$.nombre_o_razon_social'));
    SET detalle = JSON_UNQUOTE(JSON_EXTRACT(venta_info, '$.detalle'));
    SET codigo_control = JSON_UNQUOTE(JSON_EXTRACT(venta_info, '$.codigo_control'));
    SET codigo_qr = JSON_UNQUOTE(JSON_EXTRACT(venta_info, '$.codigo_qr'));
    SET fecha_limite_emision = JSON_UNQUOTE(JSON_EXTRACT(venta_info, '$.fecha_limite_emision'));

    START TRANSACTION;
    INSERT INTO factura (nro_autorizacion, cliente_nit_ci, nit_empresa, fecha_emision, nombre_o_razon_social, detalle, codigo_control, codigo_qr, fecha_limite_emision, estado, subtotal, importe_total) VALUES (
        nro_autorizacion,
        cliente_nit_ci,
        nit_empresa,
        fecha_emision,
        nombre_o_razon_social,
        detalle,
        codigo_control,
        codigo_qr,
        fecha_limite_emision,
        'ACTIVA',
        0,
        0
    );

    SET factura_id = LAST_INSERT_ID();


    INSERT INTO venta (fecha_venta, cliente_nit_ci, estado_venta, factura_nro, total_venta) VALUES (
        JSON_UNQUOTE(JSON_EXTRACT(venta_info, '$.fecha_venta')),
        JSON_UNQUOTE(JSON_EXTRACT(venta_info, '$.cliente_nit_ci')),
        'PAGADA',
        factura_id,
        0
    );


    SET venta_id = LAST_INSERT_ID();

    SET @productos = JSON_EXTRACT(venta_info, '$.productos');
    SET @num_productos = JSON_LENGTH(@productos);
    SET @i = 0;

    WHILE @i < @num_productos DO
        SET @producto = JSON_EXTRACT(@productos, CONCAT('$[', @i, ']'));
        SET producto_id = JSON_UNQUOTE(JSON_EXTRACT(@producto, '$.producto_id'));
        SET cantidad_producto = JSON_UNQUOTE(JSON_EXTRACT(@producto, '$.cantidad_producto'));
        SET precio_unitario = JSON_UNQUOTE(JSON_EXTRACT(@producto, '$.precio_unitario'));

        INSERT INTO lote_venta (venta_id, producto_id, cantidad_producto, precio_unitario) VALUES (venta_id, producto_id, cantidad_producto, precio_unitario);
        SET @i = @i + 1;
    END WHILE;

    COMMIT;
END //

-- TODO: Registro de producto con sus respectivo proveedor (con su direccion), marca, categoria
DROP PROCEDURE IF EXISTS registrar_nuevo_producto_marca_proveedor //
CREATE PROCEDURE registrar_nuevo_producto_marca_proveedor(
    IN nuevo_producto_info JSON
)
BEGIN
    DECLARE codigo_barras_producto BIGINT UNSIGNED;
    DECLARE precio_unitario DECIMAL(10, 2);
    DECLARE categoria_producto VARCHAR(255);
    DECLARE nombre_producto VARCHAR(255);
    DECLARE nombre_categoria VARCHAR(255);
    DECLARE nombre_marca VARCHAR(255);
    DECLARE nombre_empresa VARCHAR(255);
    DECLARE nombre_proveedor VARCHAR(255);
    DECLARE telefono_proveedor BIGINT UNSIGNED;
    DECLARE encargado_proveedor VARCHAR(255);
    DECLARE calle_o_avenida_proveedor VARCHAR(255);
    DECLARE nro_domicilio_proveedor BIGINT UNSIGNED;
    DECLARE zona_proveedor VARCHAR(255);
    DECLARE departamento_proveedor VARCHAR(255);
    DECLARE almacen_id INT UNSIGNED;

    DECLARE categoria_id INT UNSIGNED;
    DECLARE marca_id INT UNSIGNED;
    DECLARE empresa_id INT UNSIGNED;
    DECLARe direccion_id INT UNSIGNED;
    DECLARE proveedor_id INT UNSIGNED;


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET codigo_barras_producto = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.codigo_barras_producto'));
    SET precio_unitario = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.precio_unitario'));
    SET nombre_producto = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.nombre_producto'));
    SET nombre_categoria = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.nombre_categoria'));
    SET nombre_marca = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.nombre_marca'));
    SET nombre_empresa = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.nombre_empresa'));
    SET nombre_proveedor = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.nombre_proveedor'));
    SET telefono_proveedor = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.telefono_proveedor'));
    SET encargado_proveedor = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.encargado_proveedor'));
    SET calle_o_avenida_proveedor = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.calle_o_avenida_proveedor'));
    SET nro_domicilio_proveedor = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.nro_domicilio_proveedor'));
    SET zona_proveedor = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.zona_proveedor'));
    SET departamento_proveedor = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.departamento_proveedor'));
    SET almacen_id = JSON_UNQUOTE(JSON_EXTRACT(nuevo_producto_info, '$.almacen_id'));
    
    START TRANSACTION;

    INSERT INTO categoria (nombre_categoria) VALUES (nombre_categoria);
    SET categoria_id = LAST_INSERT_ID();
    
    INSERT INTO empresa (nombre_empresa) VALUES (nombre_empresa);
    SET empresa_id = LAST_INSERT_ID();

    INSERT INTO marca (nombre_marca, empresa_id) VALUES (nombre_marca, empresa_id);
    SET marca_id = LAST_INSERT_ID();

    INSERT INTO direccion (calle_o_avenida_direccion, nro_domicilio_direccion, zona_direccion, departamento_direccion) VALUES (calle_o_avenida_proveedor, nro_domicilio_proveedor, zona_proveedor, departamento_proveedor);
    SET direccion_id = LAST_INSERT_ID();

    INSERT INTO proveedor (nombre_proveedor, empresa_id, telefono_proveedor, encargado_proveedor, direccion_proveedor_id) VALUES (nombre_proveedor, empresa_id, telefono_proveedor, encargado_proveedor, direccion_id);
    SET proveedor_id = LAST_INSERT_ID();

    CALL agregar_producto_con_almacen(nombre_producto, proveedor_id, codigo_barras_producto, precio_unitario, marca_id, categoria_id, 'HABILITADO', almacen_id);

    COMMIT;
END //


DELIMITER ;

