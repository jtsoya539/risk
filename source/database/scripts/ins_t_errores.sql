prompt Importing table t_errores...
set feedback off
set define off

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0001', 'Valor no permitido');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0002', 'Tipo de dato de @1@ @2@ no soportado');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0003', 'Par�metro @1@ obligatorio');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0004', 'Par�metro @1@ debe tener valor');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0005', 'Par�metro @1@ de tipo incorrecto');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0006', 'Longitud del par�metro @1@ no debe ser superior a @2@');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ora0007', 'Valor del par�metro @1@ no permitido');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ser0002', 'Error al procesar par�metros del servicio');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ser0003', 'Operaci�n no autorizada');

insert into t_errores (ID_ERROR, MENSAJE)
values ('ser9999', 'Error inesperado [@1@]');

prompt Done.
