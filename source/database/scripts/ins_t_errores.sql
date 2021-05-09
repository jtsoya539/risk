prompt Importing table t_errores...
set feedback off
set define off

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0001', 'Valor no permitido');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0002', 'Tipo de dato de @1@ @2@ no soportado');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0003', 'Parámetro @1@ obligatorio');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0004', 'Parámetro @1@ debe tener valor');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0005', 'Parámetro @1@ de tipo incorrecto');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0006', 'Longitud del parámetro @1@ no debe ser superior a @2@');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0007', 'Valor del parámetro @1@ no permitido');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ser0002', 'Error al procesar parámetros del servicio');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ser0003', 'Operación no autorizada');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ser9999', 'Error inesperado [@1@]');

prompt Done.
