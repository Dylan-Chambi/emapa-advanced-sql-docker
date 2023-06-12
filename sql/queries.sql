USE emapa_productos;

-- TODO: Reporte de ventas por nombre de producto
EXPLAIN SELECT
    v.fecha_venta,
    lv.cantidad_producto,
    lv.precio_unitario,
    lv.total_lote_compra,
    c.nombre_cliente
FROM venta v
    INNER JOIN lote_venta lv ON v.id_venta = lv.venta_id
    INNER JOIN producto p ON lv.producto_id = p.id_producto
    INNER JOIN cliente c ON v.cliente_nit_ci = c.nit_ci
WHERE
    p.nombre_producto = 'Kris Mayonesa Pomo 380ml';


-- TODO: Reporte de ventas por codigo de producto
EXPLAIN SELECT
    v.fecha_venta,
    lv.cantidad_producto,
    lv.precio_unitario,
    lv.total_lote_compra,
    c.nombre_cliente
FROM venta v
    INNER JOIN lote_venta lv ON v.id_venta = lv.venta_id
    INNER JOIN producto p ON lv.producto_id = p.id_producto
    INNER JOIN cliente c ON v.cliente_nit_ci = c.nit_ci
WHERE
    p.codigo_barras = 3456789012;


-- TODO: Reporte de compras por proveedor
EXPLAIN SELECT
    c.fecha_compra,
    c.total_compra,
    p.nombre_producto
FROM compra c
    INNER JOIN lote_compra lc ON c.id_compra = lc.compra_id
    INNER JOIN producto p ON lc.producto_id = p.id_producto
    INNER JOIN proveedor pr ON c.proveedor_id = pr.id_proveedor
WHERE
    pr.nombre_proveedor = 'Grupo Venado';


-- TODO: Reporte de ventas por CI/NIT de clientey fecha de emision
EXPLAIN SELECT
    f.fecha_emision,
    f.importe_total,
    p.nombre_producto
FROM factura f
    INNER JOIN venta v ON f.nro_factura = v.factura_nro
    INNER JOIN lote_venta lt ON v.id_venta = lt.venta_id
    INNER JOIN producto p ON lt.producto_id = p.id_producto
WHERE
    f.cliente_nit_ci = 6963367
    AND f.fecha_emision > '2022-01-01';


-- TODO: Consutla de ventas apellido paterno y nombre de cliente
EXPLAIN SELECT
    f.fecha_emision,
    f.importe_total,
    p.nombre_producto
FROM factura f
    INNER JOIN venta v ON f.nro_factura = v.factura_nro
    INNER JOIN lote_venta lt ON v.id_venta = lt.venta_id
    INNER JOIN producto p ON lt.producto_id = p.id_producto
    INNER JOIN cliente c ON f.cliente_nit_ci = c.nit_ci
WHERE
    c.apellido_paterno = 'Chambi'
    AND c.nombre_cliente = 'Dylan';





INSERT INTO lote_venta (venta_id, producto_id, cantidad_producto) VALUES (5, 1, 1000);

INSERT INTO lote_venta (venta_id, producto_id, cantidad_producto) VALUES (5, 2, 1);


INSERT INTO lote_venta (venta_id, producto_id, cantidad_producto) VALUES (5, 1, 1);


INSERT INTO lote_compra (compra_id, producto_id, fecha_vencimiento_lote, cantidad_producto, precio_unitario) VALUES (3, 4, '2021-12-12', 1000, 1);

INSERT INTO movimiento_producto (producto_id, almacen_origen_id, almacen_destino_id, fecha_movimiento, cantidad_movimiento) VALUES (1, 2, 1, '2021-12-12', 1);
