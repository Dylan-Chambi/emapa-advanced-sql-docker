USE emapa_productos;

CREATE INDEX idx_nombre_producto ON producto (nombre_producto);

CREATE INDEX idx_codigo_barras ON producto (codigo_barras);

CREATE INDEX idx_nombre_proveedor ON proveedor (nombre_proveedor);

CREATE INDEX idx_cliente_fecha_venta ON factura (cliente_nit_ci, fecha_emision);

CREATE INDEX idx_apellido_p_nombre ON cliente (apellido_paterno, nombre_cliente);