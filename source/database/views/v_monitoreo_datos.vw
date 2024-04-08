CREATE OR REPLACE FORCE VIEW V_MONITOREO_DATOS AS
SELECT d.id_monitoreo_ejecucion,
       d.id_monitoreo,
       j.codigo,
       j.cantidad_elementos,
       j.mitigado
  FROM t_monitoreo_ejecuciones d,
       json_table(d.datos,
                  '$' columns(codigo path '$.codigo',
                          cantidad_elementos path
                          '$.datos.cantidad_elementos',
                          NESTED path '$.datos.elementos[*]'
                          columns(mitigado path '$.mitigado'))) j;

