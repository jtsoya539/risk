prompt Importing table t_errores...
set feedback off
set define off

insert into t_errores (ID_ERROR, MENSAJE)
values ('ser0002', 'Error al procesar parámetros del servicio');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ser0003', 'Operación no autorizada');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ser9999', 'Error inesperado');

prompt Done.
