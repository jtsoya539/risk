prompt Importing table t_servicios...
set feedback off
set define off
insert into t_servicios (ID_SERVICIO, NOMBRE, TIPO, ACTIVO, DOMINIO, DETALLE, VERSION_ACTUAL, CANTIDAD_EJECUCIONES, FECHA_ULTIMA_EJECUCION)
values (1, 'VALIDAR_CREDENCIALES', 'R', 'S', 'AUT', null, null, null, null);

insert into t_servicios (ID_SERVICIO, NOMBRE, TIPO, ACTIVO, DOMINIO, DETALLE, VERSION_ACTUAL, CANTIDAD_EJECUCIONES, FECHA_ULTIMA_EJECUCION)
values (2, 'INICIAR_SESION', 'R', 'S', 'AUT', null, null, null, null);

insert into t_servicios (ID_SERVICIO, NOMBRE, TIPO, ACTIVO, DOMINIO, DETALLE, VERSION_ACTUAL, CANTIDAD_EJECUCIONES, FECHA_ULTIMA_EJECUCION)
values (3, 'FINALIZAR_SESION', 'R', 'S', 'AUT', null, null, null, null);

insert into t_servicios (ID_SERVICIO, NOMBRE, TIPO, ACTIVO, DOMINIO, DETALLE, VERSION_ACTUAL, CANTIDAD_EJECUCIONES, FECHA_ULTIMA_EJECUCION)
values (4, 'REGISTRAR_USUARIO', 'R', 'S', 'AUT', null, null, null, null);

insert into t_servicios (ID_SERVICIO, NOMBRE, TIPO, ACTIVO, DOMINIO, DETALLE, VERSION_ACTUAL, CANTIDAD_EJECUCIONES, FECHA_ULTIMA_EJECUCION)
values (5, 'REGISTRAR_CLAVE', 'R', 'S', 'AUT', null, null, null, null);

insert into t_servicios (ID_SERVICIO, NOMBRE, TIPO, ACTIVO, DOMINIO, DETALLE, VERSION_ACTUAL, CANTIDAD_EJECUCIONES, FECHA_ULTIMA_EJECUCION)
values (6, 'CAMBIAR_CLAVE', 'R', 'S', 'AUT', null, null, null, null);

prompt Done.
