prompt Importing table t_reportes...
set feedback off
set define off

insert into t_reportes (ID_REPORTE, TIPO, CANTIDAD_EJECUCIONES, FECHA_ULTIMA_EJECUCION, CONSULTA_SQL)
values (20, 'H', null, null, null);

insert into t_reportes (ID_REPORTE, TIPO, CANTIDAD_EJECUCIONES, FECHA_ULTIMA_EJECUCION, CONSULTA_SQL)
values (36, 'C', null, null, 'SELECT dominio, codigo, significado, referencia, activo FROM t_significados ORDER BY dominio, codigo');

prompt Done.
