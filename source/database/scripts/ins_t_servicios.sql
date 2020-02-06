prompt Importing table t_servicios...
set feedback off
set define off
insert into t_servicios (ID_SERVICIO, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL)
values (1, 'F_VALIDAR_CREDENCIALES', 'R', 'S', null, null, null);

insert into t_servicios (ID_SERVICIO, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL)
values (2, 'F_INICIAR_SESION', 'R', 'S', null, null, null);

insert into t_servicios (ID_SERVICIO, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL)
values (3, 'F_FINALIZAR_SESION', 'R', 'S', null, null, null);

prompt Done.
