USE emapa_productos;

DELIMITER //

-- TODO: Actualizar el los totales de precios de compra y venta cuando se inserte un lote
DROP TRIGGER IF EXISTS actualizar_precios_en_venta //
CREATE TRIGGER actualizar_precios_en_venta BEFORE INSERT ON lote_venta
FOR EACH ROW
BEGIN

    IF (NEW.total_lote_compra IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede establecer el total de lote de venta manualmente';
    END IF;
    IF (NEW.precio_unitario IS NULL) THEN
        SET NEW.precio_unitario = (SELECT precio_nacional FROM producto WHERE id_producto = NEW.producto_id);
    END IF;
    SET NEW.total_lote_compra = NEW.precio_unitario * NEW.cantidad_producto;

    UPDATE venta SET total_venta = total_venta + NEW.total_lote_compra WHERE id_venta = NEW.venta_id;
    UPDATE factura SET subtotal = subtotal + NEW.total_lote_compra WHERE nro_factura = (SELECT factura_nro FROM venta WHERE id_venta = NEW.venta_id);
    UPDATE factura SET importe_total = importe_total + NEW.total_lote_compra + (NEW.total_lote_compra * 0.13) WHERE nro_factura = (SELECT factura_nro FROM venta WHERE id_venta = NEW.venta_id);
END //


DROP TRIGGER IF EXISTS actualizar_precios_en_compra //
CREATE TRIGGER actualizar_precios_en_compra BEFORE INSERT ON lote_compra
FOR EACH ROW
BEGIN
    IF (NEW.total_lote_compra IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede establecer el total de lote de compra manualmente';
    END IF;
    SET NEW.total_lote_compra = NEW.precio_unitario * NEW.cantidad_producto;
    UPDATE compra SET total_compra = total_compra + NEW.total_lote_compra WHERE id_compra = NEW.compra_id;
END //



-- TODO: Actualizar el total de las cantidades de stock y vendidas de un producto cuando se inserte un lote

DROP TRIGGER IF EXISTS actualizar_cantidades_producto_venta //
CREATE TRIGGER actualizar_cantidades_producto_venta AFTER INSERT ON lote_venta
FOR EACH ROW
BEGIN
    UPDATE producto SET cantidad_vendida_total = cantidad_vendida_total + NEW.cantidad_producto WHERE producto.id_producto = NEW.producto_id;
END //

DROP TRIGGER IF EXISTS actualizar_cantidades_producto_compra //
CREATE TRIGGER actualizar_cantidades_producto_compra AFTER INSERT ON lote_compra
FOR EACH ROW
BEGIN
    UPDATE producto SET cantidad_stock_total = cantidad_stock_total + NEW.cantidad_producto WHERE producto.id_producto = NEW.producto_id;
END //


-- TODO: Validar que la cantidad de stock no se exceda en una venta
DROP TRIGGER IF EXISTS stock_no_excedido_venta //
CREATE TRIGGER stock_no_excedido_venta BEFORE INSERT ON lote_venta
FOR EACH ROW
BEGIN
    DECLARE cantidad_stock INT;
    DECLARE cantidad_venta INT;

    SET cantidad_stock = (SELECT producto.cantidad_stock_total - producto.cantidad_vendida_total FROM producto
    WHERE producto.id_producto = NEW.producto_id);

    SET cantidad_venta = NEW.cantidad_producto;

    IF cantidad_stock < cantidad_venta THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock en el inventario';
    END IF;
END //


-- TODO: Actualizar las cantiadades en almacenes cuando se haga un movimiento
DROP TRIGGER IF EXISTS actualizar_y_movimiento_stock_almacen //
CREATE TRIGGER actualizar_movimiento_stock_almacen AFTER INSERT ON movimiento_producto
FOR EACH ROW
BEGIN

    DECLARE cantidad_origen INT;

    SET cantidad_origen = (SELECT cantidad_producto FROM almacen_producto
    WHERE almacen_producto.almacen_id = NEW.almacen_origen_id AND almacen_producto.producto_id = NEW.producto_id);

    IF cantidad_origen < NEW.cantidad_movimiento THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock en el almacen origen';
    END IF;

    UPDATE almacen_producto SET cantidad_producto = cantidad_producto - NEW.cantidad_movimiento
    WHERE almacen_producto.almacen_id = NEW.almacen_origen_id AND almacen_producto.producto_id = NEW.producto_id;

    UPDATE almacen_producto SET cantidad_producto = cantidad_producto + NEW.cantidad_movimiento
    WHERE almacen_producto.almacen_id = NEW.almacen_destino_id AND almacen_producto.producto_id = NEW.producto_id;
END //


-- TODO: Validar que un producto no este desabilitado al momento de hacer una venta
DROP TRIGGER IF EXISTS validar_estado_producto_venta //
CREATE TRIGGER validar_estado_producto_venta BEFORE INSERT ON lote_venta
FOR EACH ROW
BEGIN
    DECLARE estado_producto ENUM('HABILITADO', 'DESHABILITADO');

    SET estado_producto = (SELECT producto.estado_producto FROM producto WHERE producto.id_producto = NEW.producto_id);
    

    IF estado_producto <> 'HABILITADO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede vender un producto deshabilitado';
    END IF;
    
END //

CREATE TRIGGER cliente_shadow_before_insert BEFORE INSERT ON cliente
FOR EACH ROW
BEGIN
    SET NEW.mod_usuario = CURRENT_USER();
    SET NEW.mod_fecha = NOW();
END //

CREATE TRIGGER cliente_shadow_after_insert AFTER INSERT ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO cliente_shadow (nit_ci, mod_usuario, mod_fecha, accion) VALUES (NEW.nit_ci, CURRENT_USER(), NOW(), 'INSERT');
END //

CREATE TRIGGER cliente_shadow_after_update AFTER UPDATE ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO cliente_shadow (nit_ci, mod_usuario, mod_fecha, accion) VALUES (NEW.nit_ci, CURRENT_USER(), NOW(), 'UPDATE');
END //


CREATE TRIGGER cliente_shadow_after_delete AFTER DELETE ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO cliente_shadow (nit_ci, mod_usuario, mod_fecha, accion) VALUES (OLD.nit_ci, CURRENT_USER(), NOW(), 'DELETE');
END //

CREATE TRIGGER factura_shadow_before_insert BEFORE INSERT ON factura
FOR EACH ROW
BEGIN
    SET NEW.mod_usuario = CURRENT_USER();
    SET NEW.mod_fecha = NOW();
END //

CREATE TRIGGER factura_shadow_after_insert AFTER INSERT ON factura
FOR EACH ROW
BEGIN
    INSERT INTO factura_shadow (nro_factura, mod_usuario, mod_fecha, accion) VALUES (NEW.nro_factura, CURRENT_USER(), NOW(), 'INSERT');
END //

CREATE TRIGGER factura_shadow_after_update AFTER UPDATE ON factura
FOR EACH ROW
BEGIN
    INSERT INTO factura_shadow (nro_factura, mod_usuario, mod_fecha, accion) VALUES (NEW.nro_factura, CURRENT_USER(), NOW(), 'UPDATE');
END //

CREATE TRIGGER factura_shadow_after_delete AFTER DELETE ON factura
FOR EACH ROW
BEGIN
    INSERT INTO factura_shadow (nro_factura, mod_usuario, mod_fecha, accion) VALUES (OLD.nro_factura, CURRENT_USER(), NOW(), 'DELETE');
END //

CREATE TRIGGER producto_shadow_before_insert BEFORE INSERT ON producto
FOR EACH ROW
BEGIN
    SET NEW.mod_usuario = CURRENT_USER();
    SET NEW.mod_fecha = NOW();
END //

CREATE TRIGGER producto_shadow_after_insert AFTER INSERT ON producto
FOR EACH ROW
BEGIN
    INSERT INTO producto_shadow (id_producto, mod_usuario, mod_fecha, accion) VALUES (NEW.id_producto, CURRENT_USER(), NOW(), 'INSERT');
END //

CREATE TRIGGER producto_shadow_after_update AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
    INSERT INTO producto_shadow (id_producto, mod_usuario, mod_fecha, accion) VALUES (NEW.id_producto, CURRENT_USER(), NOW(), 'UPDATE');
END //

CREATE TRIGGER producto_shadow_after_delete AFTER DELETE ON producto
FOR EACH ROW
BEGIN
    INSERT INTO producto_shadow (id_producto, mod_usuario, mod_fecha, accion) VALUES (OLD.id_producto, CURRENT_USER(), NOW(), 'DELETE');
END //

CREATE TRIGGER compra_shadow_before_insert BEFORE INSERT ON compra
FOR EACH ROW
BEGIN
    SET NEW.mod_usuario = CURRENT_USER();
    SET NEW.mod_fecha = NOW();
END //

CREATE TRIGGER compra_shadow_after_insert AFTER INSERT ON compra
FOR EACH ROW
BEGIN
    INSERT INTO compra_shadow (id_compra, mod_usuario, mod_fecha, accion) VALUES (NEW.id_compra, CURRENT_USER(), NOW(), 'INSERT');
END //

CREATE TRIGGER compra_shadow_after_update AFTER UPDATE ON compra
FOR EACH ROW
BEGIN
    INSERT INTO compra_shadow (id_compra, mod_usuario, mod_fecha, accion) VALUES (NEW.id_compra, CURRENT_USER(), NOW(), 'UPDATE');
END //

CREATE TRIGGER compra_shadow_after_delete AFTER DELETE ON compra
FOR EACH ROW
BEGIN
    INSERT INTO compra_shadow (id_compra, mod_usuario, mod_fecha, accion) VALUES (OLD.id_compra, CURRENT_USER(), NOW(), 'DELETE');
END //


CREATE TRIGGER venta_shadow_before_insert BEFORE INSERT ON venta
FOR EACH ROW
BEGIN
    SET NEW.mod_usuario = CURRENT_USER();
    SET NEW.mod_fecha = NOW();
END //

CREATE TRIGGER venta_shadow_after_insert AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    INSERT INTO venta_shadow (id_venta, mod_usuario, mod_fecha, accion) VALUES (NEW.id_venta, CURRENT_USER(), NOW(), 'INSERT');
END //

CREATE TRIGGER venta_shadow_after_update AFTER UPDATE ON venta
FOR EACH ROW
BEGIN
    INSERT INTO venta_shadow (id_venta, mod_usuario, mod_fecha, accion) VALUES (NEW.id_venta, CURRENT_USER(), NOW(), 'UPDATE');
END //

CREATE TRIGGER venta_shadow_after_delete AFTER DELETE ON venta
FOR EACH ROW
BEGIN
    INSERT INTO venta_shadow (id_venta, mod_usuario, mod_fecha, accion) VALUES (OLD.id_venta, CURRENT_USER(), NOW(), 'DELETE');
END //

CREATE TRIGGER movimiento_producto_shadow_before_insert BEFORE INSERT ON movimiento_producto
FOR EACH ROW
BEGIN
    SET NEW.mod_usuario = CURRENT_USER();
    SET NEW.mod_fecha = NOW();
END //

CREATE TRIGGER movimiento_producto_shadow_after_insert AFTER INSERT ON movimiento_producto
FOR EACH ROW
BEGIN
    INSERT INTO movimiento_producto_shadow (id_movimiento, mod_usuario, mod_fecha, accion) VALUES (NEW.id_movimiento, CURRENT_USER(), NOW(), 'INSERT');
END //

CREATE TRIGGER movimiento_producto_shadow_after_update AFTER UPDATE ON movimiento_producto
FOR EACH ROW
BEGIN
    INSERT INTO movimiento_producto_shadow (id_movimiento, mod_usuario, mod_fecha, accion) VALUES (NEW.id_movimiento, CURRENT_USER(), NOW(), 'UPDATE');
END //

CREATE TRIGGER movimiento_producto_shadow_after_delete AFTER DELETE ON movimiento_producto
FOR EACH ROW
BEGIN
    INSERT INTO movimiento_producto_shadow (id_movimiento, mod_usuario, mod_fecha, accion) VALUES (OLD.id_movimiento, CURRENT_USER(), NOW(), 'DELETE');
END //


DELIMITER ;