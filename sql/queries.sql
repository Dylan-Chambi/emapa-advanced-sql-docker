USE emapa_productos;

-- TODO: Reporte de ventas por nombre de producto
SELECT
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
SELECT
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
SELECT
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
SELECT
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
SELECT
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





CALL mover_productos_entre_almacenes(1, 1, 5, '2021-12-12', 1);

CALL agregar_producto_con_almacen('Producto 1', 1, 123456789, 100.00, 1, 1, 'HABILITADO', 1);

CALL crear_compra('{
  "fecha_compra": "2023-06-11",
  "proveedor_id": 1,
  "productos": [
    {
      "producto_id": 1,
      "cantidad_producto": 10,
      "precio_unitario": 9.99,
      "fecha_vencimiento": "2023-06-11"
    },
    {
      "producto_id": 2,
      "cantidad_producto": 5,
      "precio_unitario": 19.99,
      "fecha_vencimiento": "2023-06-11"
    }
  ]
}');


CALL crear_venta('{
  "nro_autorizacion": 123456789,
  "cliente_nit_ci": 123456789,
  "nit_empresa": 123456789,
  "fecha_emision": "2023-06-11",
  "nombre_o_razon_social": "Nombre o razon social",
  "detalle": "Detalle",
  "codigo_control": "Codigo control",
  "codigo_qr": "Codigo qr",
  "fecha_limite_emision": "2023-06-11",
  "fecha_venta": "2023-06-11",
  "cliente_nit_ci": 6963367,
  "productos": [
    {
      "producto_id": 1,
      "cantidad_producto": 10,
      "precio_unitario": 9.99
    },
    {
      "producto_id": 3,
      "cantidad_producto": 5,
      "precio_unitario": 19.99
    }
  ]
}');


CALL registrar_nuevo_producto_marca_proveedor('{
  "codigo_barras_producto": 123456789,
  "precio_unitario": 100.00,
  "nombre_producto": "Producto 1",
  "nombre_categoria": "Categoria 1",
  "nombre_marca": "Marca 1",
  "nombre_empresa": "Empresa 1",
  "nombre_proveedor": "Proveedor 1",
  "telefono_proveedor": 123456789,
  "encargado_proveedor": "Encargado 1",
  "calle_o_avenida_proveedor": "Calle 1",
  "nro_domicilio_proveedor": 123456789,
  "zona_proveedor": "Zona 1",
  "departamento_proveedor": "Departamento 1",
  "almacen_id": 1
}');