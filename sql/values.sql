USE emapa_productos;

INSERT INTO categoria (id_categoria, nombre_categoria) VALUES
    (1, 'Frutas'),
    (2, 'Carnes'),
    (3, 'Lácteos'),
    (4, 'Panadería'),
    (5, 'Bebidas'),
    (6, 'Salsas y condimentos'),
    (7, 'Dulces y chocolates');

INSERT INTO empresa (id_empresa, nombre_empresa) VALUES
    (1, 'Delizia'),
    (2, 'Pil Andina S.A.'),
    (3, 'Nestlé'),
    (4, 'Industrias Venado S.A.'),
    (5, 'Arcor');

INSERT INTO direccion (id_direccion, calle_o_avenida_direccion, nro_domicilio_direccion, zona_direccion, departamento_direccion) VALUES
    (1, 'Av. Arce', 256, 'Miraflores', 'La Paz'),
    (2, 'Av. San Martin', 120, 'Equipetrol', 'Santa Cruz'),
    (3, 'Av. Blanco Galindo', 45, 'Quillacollo', 'Cochabamba'),
    (4, 'Av. Cumana', 2001, 'Zona Central', 'Sucre'),
    (5, 'Av. Civica', 373, 'Zona Central', 'Oruro'),
    (6, 'Av. Potosi', 100, 'Zona Central', 'Potosí'),
    (7, 'Av. Tarija', 100, 'Zona Central', 'Tarija'),
    (8, 'Av. Beni', 100, 'Zona Central', 'Beni'),
    (9, 'Av. Pando', 100, 'Zona Central', 'Pando');

INSERT INTO sucursal (id_sucursal, direccion_sucursal_id, nombre_sucursal, telefono_sucursal, correo_sucursal) VALUES
    (1, 1, 'Sucursal La Paz', '2222222', 'sucursal.lp@emapa.com'),
    (2, 2, 'Sucursal Santa Cruz', '3333333', 'sucursal.sc@emapa.com'),
    (3, 3, 'Sucursal Cochabamba', '4444444', 'sucursal.ch@emapa.com'),
    (4, 4, 'Sucursal Sucre', '5555555', 'sucursal.suc@emapa.com'),
    (5, 5, 'Sucursal Oruro', '6666666', 'sucursal.or@emapa.com'),
    (6, 6, 'Sucursal Potosí', '7777777', 'sucursal.po@emapa.com'),
    (7, 7, 'Sucursal Tarija', '8888888', 'sucursal.ta@emapa.com'),
    (8, 8, 'Sucursal Beni', '9999999', 'sucursal.be@emapa.com'),
    (9, 9, 'Sucursal Pando', '10101010', 'sucursal.pd@emapa.com');

INSERT INTO almacen (id_almacen, nombre_almacen, nro_piso_almacen, nro_cuarto_almacen, sucursal_almacen) VALUES
    (1, 'Almacén La Paz', 1, 1, 1),
    (2, 'Almacén Santa Cruz', 1, 1, 2),
    (3, 'Almacén Cochabamba', 1, 1, 3),
    (4, 'Almacén Sucre', 1, 1, 4),
    (5, 'Almacén Oruro', 1, 1, 5),
    (6, 'Almacén Potosí', 1, 1, 6),
    (7, 'Almacén Tarija', 1, 1, 7),
    (8, 'Almacén Beni', 1, 1, 8),
    (9, 'Almacén Pando', 1, 1, 9);

INSERT INTO cliente (nit_ci, nombre_cliente, segundo_nombre, apellido_paterno, apellido_materno, correo_cliente, telefono_cliente, extension_ci) VALUES
    (6963367, 'Dylan', 'Imanol', 'Chambi', 'Frontanilla', 'dylanchambifi@gmail.com', '65608561', 'LP'),
    (9546465, 'Juan', '', 'Pérez', 'García', 'juan.perez@gmail.com', '77658589', 'LP'),
    (4516514, 'María', '', 'López', 'González', 'maria.lopez@gmail.com', '70564564', 'SC'),
    (6975165, 'Pedro', '', 'Ramírez', 'Martínez', 'pedro.ramirez@gmail.com', '66854564', 'CB'),
    (4514645, 'Ana', '', 'Hernández', 'Vargas', 'ana.hernandez@gmail.com', '67745444', 'OR'),
    (4516466, 'Luis', '', 'Gutiérrez', 'Díaz', 'luis.gutierrez@gmail.com', '72545444', 'PT'),
    (4516467, 'Carlos', '', 'García', 'García', 'carlos.garcia@gmail.com', '72545444', 'PT');

INSERT INTO marca (id_marca, nombre_marca, empresa_id) VALUES
    (1, 'IceFruit', 1),
    (2, 'PilFrut', 2),
    (3, 'Nesquik', 3),
    (4, 'Kris', 4),
    (5, 'Rocklets', 5);

INSERT INTO proveedor (id_proveedor, nombre_proveedor, empresa_id, telefono_proveedor, encargado_proveedor, direccion_proveedor_id) VALUES
        (1, 'Grupo Venado', 4, '65608561', 'Juan', 1),
        (2, 'Andes Tropico', 2, '65608561', 'Juan', 2),
        (3, 'Francisco Susz Guggenheim Ltda', 3, '77658589', 'María', 3),
        (4, 'CRUZIMEX LTDA', 1, '65608561', 'Juan', 4),
        (5, 'EL ARRIERO', 5, '65608561', 'Juan', 5);

INSERT INTO factura (nro_factura, nro_autorizacion, nit_empresa, fecha_emision, nombre_o_razon_social, cliente_nit_ci, detalle, subtotal, importe_total, codigo_control, codigo_qr, fecha_limite_emision, estado) VALUES
    (10000001, 45645, 45146484, '2023-05-22', 'Empresa ABC', 6963367, 'Compra de alimentos', 45.20, 50.26, 'A4-GH-59-B2', NULL, '2023-06-30', 'ACTIVA'),
    (10000002, 45645, 45146484, '2023-06-22', 'Empresa CENIL', 9546465, 'Compra de alimentos', 102.20, 110.05, 'A4-GH-59-B2', NULL, '2023-07-30', 'ACTIVA'),
    (10000003, 45645, 45146484, '2023-04-02', 'N/A', 4516514, 'Compra de alimentos', 23.00, 25.00, 'A4-GH-59-B2', NULL, '2023-06-30', 'ACTIVA'),
    (10000004, 45645, 45146484, '2023-05-12', 'N/A', 6975165, 'Compra de alimentos', 23.00, 25.00, 'A4-GH-59-B2', NULL, '2023-06-30', 'ACTIVA'),
    (10000005, 45645, 45146484, '2023-07-01', 'N/A', 4514645, 'Compra de alimentos', 23.00, 25.00, 'A4-GH-59-B2', NULL, '2023-06-30', 'ACTIVA');


INSERT INTO producto (id_producto, nombre_producto, proveedor_id, codigo_barras, precio_nacional, marca_id, categoria_id, estado_producto, cantidad_stock_total, cantidad_vendida_total) VALUES
    (1, 'Kris Mayonesa Pomo 380ml', 1, 1234567890, 17.30, 4, 6, 'HABILITADO', 100, 0),
    (2, 'PILFRUT MANZANA 800ML', 2, 2345678901, 1.00, 2, 5, 'HABILITADO', 100, 0),
    (3, 'Nesquik Chocolate 400g', 3, 3456789012, 14.50, 3, 5, 'HABILITADO', 100, 0),
    (4, 'Ice Fruit Mango Botella 2L', 4, 4567890123, 10.50, 1, 5, 'HABILITADO', 100, 0),
    (5, 'Arcor Tableta Rocklets X 80Gr', 5, 5678901234, 5.50, 5, 5, 'HABILITADO', 100, 0);

INSERT INTO almacen_producto (producto_id, almacen_id, cantidad_producto) VALUES
    (1, 1, 100),
    (2, 2, 100),
    (3, 3, 100),
    (4, 4, 100),
    (5, 5, 100);

INSERT INTO compra (id_compra, fecha_compra, proveedor_id, total_compra) VALUES
    (1, '2023-05-20', 1, 742.50), -- x 45
    (2, '2023-05-21', 2, 96.00), -- x 120
    (3, '2023-05-22', 3, 417.00), -- x 30
    (4, '2023-05-23', 4, 411.60), -- x 42
    (5, '2023-05-24', 5, 495.00); -- x 50

INSERT INTO lote_compra (compra_id, producto_id, fecha_vencimiento_lote, cantidad_producto, precio_unitario, total_lote_compra) VALUES
    (1, 1, '2023-05-20', 45, 16.50, 742.50),
    (2, 2, '2023-05-21', 120, 0.80, 96.00),
    (3, 3, '2023-05-22', 30, 13.90, 417.00),
    (4, 4, '2023-05-23', 42, 9.80, 411.60),
    (5, 5, '2023-05-24', 50, 9.90, 495.00);


INSERT INTO venta (id_venta, fecha_venta, cliente_nit_ci, estado_venta, factura_nro, total_venta) VALUES
    (1, '2023-05-20', 6963367, 'INMEDIATA', 10000001, 55.00),
    (2, '2023-05-21', 6975165, 'INMEDIATA', 10000002, 90.00),
    (3, '2023-05-22', 4516466, 'PENDIENTE', 10000003, 35.00),
    (4, '2023-05-23', 4514645, 'PENDIENTE', 10000004, 18.00),
    (5, '2023-05-24', 6963367, 'PAGADA', 10000005, 28.00);

INSERT INTO lote_venta (venta_id, producto_id, cantidad_producto, precio_unitario, total_lote_compra) VALUES
    (1, 1, 2, 2.50, 5.00),
    (2, 2, 1, 5.00, 5.00),
    (3, 3, 4, 1.80, 7.20),
    (4, 4, 1, 2.00, 2.00),
    (5, 5, 3, 1.50, 4.50);

INSERT INTO movimiento_producto (id_movimiento, producto_id, almacen_origen_id, almacen_destino_id, fecha_movimiento, cantidad_movimiento) VALUES
    (1, 1, 1, 2, '2023-05-20', 2),
    (2, 2, 2, 1, '2023-05-21', 1),
    (3, 1, 3, 2, '2023-05-22', 4),
    (4, 3, 2, 3, '2023-05-23', 1),
    (5, 2, 3, 2, '2023-05-24', 3);