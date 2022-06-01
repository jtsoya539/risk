CREATE OR REPLACE VIEW v_monitoreo_datos AS
SELECT d.id_monitoreo_ejecucion, d.id_monitoreo, j.*
  FROM t_monitoreo_ejecuciones d,
       json_table(d.datos,
                  '$' columns(codigo path '$.codigo',
                          cantidad_elementos path
                          '$.datos.cantidad_elementos',
                          NESTED path '$.datos.elementos[*]'
                          columns(mitigado path '$.mitigado'))) j;
