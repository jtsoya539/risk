prompt Importing table t_errores...
set feedback off
set define off

insert into t_errores (ID_ERROR, MENSAJE, ID_DOMINIO)
values ('ora0001', 'Valor no permitido', 'API');

insert into t_errores (ID_ERROR, MENSAJE, ID_DOMINIO)
values ('ora0002', 'Tipo de dato de @1@ @2@ no soportado', 'API');

insert into t_errores (ID_ERROR, MENSAJE, ID_DOMINIO)
values ('ora0003', 'Par�metro @1@ obligatorio', 'API');

insert into t_errores (ID_ERROR, MENSAJE, ID_DOMINIO)
values ('ora0004', 'Par�metro @1@ debe tener valor', 'API');

insert into t_errores (ID_ERROR, MENSAJE, ID_DOMINIO)
values ('ora0005', 'Par�metro @1@ de tipo incorrecto', 'API');

insert into t_errores (ID_ERROR, MENSAJE, ID_DOMINIO)
values ('ora0006', 'Longitud del par�metro @1@ no debe ser superior a @2@', 'API');

insert into t_errores (ID_ERROR, MENSAJE, ID_DOMINIO)
values ('ora0007', 'Valor del par�metro @1@ no permitido', 'API');

insert into t_errores (ID_ERROR, MENSAJE, ID_DOMINIO)
values ('ser0002', 'Error al procesar par�metros del servicio', 'API');

insert into t_errores (ID_ERROR, MENSAJE, ID_DOMINIO)
values ('ser0003', 'Operaci�n no autorizada', 'API');

insert into t_errores (ID_ERROR, MENSAJE, ID_DOMINIO)
values ('ser9999', 'Error inesperado [@1@]', 'API');

prompt Done.
