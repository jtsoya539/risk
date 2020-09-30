prompt Importing table t_operaciones...
set feedback off
set define off
insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (0, 'P', 'CONTEXTO', null, 'S', null, null, 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (1, 'S', 'VALIDAR_CREDENCIALES', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (2, 'S', 'INICIAR_SESION', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (3, 'S', 'CAMBIAR_ESTADO_SESION', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (4, 'S', 'REGISTRAR_USUARIO', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (5, 'S', 'REGISTRAR_CLAVE', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (6, 'S', 'CAMBIAR_CLAVE', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (7, 'S', 'VALIDAR_SESION', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (8, 'S', 'VALOR_PARAMETRO', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (9, 'S', 'SIGNIFICADO_CODIGO', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (10, 'S', 'DATOS_USUARIO', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (11, 'S', 'REFRESCAR_SESION', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (12, 'S', 'VALIDAR_CLAVE_APLICACION', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (13, 'S', 'VERSION_SISTEMA', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (14, 'S', 'REGISTRAR_DISPOSITIVO', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (15, 'S', 'REGISTRAR_UBICACION', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (16, 'S', 'LISTAR_PAISES', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (17, 'S', 'TIEMPO_EXPIRACION_TOKEN', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (18, 'S', 'RECUPERAR_ARCHIVO', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (19, 'S', 'GUARDAR_ARCHIVO', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (20, 'R', 'VERSION_SISTEMA', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (21, 'S', 'DATOS_DISPOSITIVO', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (22, 'S', 'CAMBIAR_ESTADO_USUARIO', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (23, 'S', 'GENERAR_OTP', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (24, 'S', 'VALIDAR_OTP', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (25, 'S', 'LISTAR_DEPARTAMENTOS', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (26, 'S', 'LISTAR_CIUDADES', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (27, 'S', 'LISTAR_BARRIOS', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (28, 'S', 'RECUPERAR_TEXTO', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (29, 'S', 'LISTAR_SIGNIFICADOS', 'GEN', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (30, 'S', 'LISTAR_MENSAJES_PENDIENTES', 'MSJ', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (31, 'S', 'LISTAR_CORREOS_PENDIENTES', 'MSJ', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (32, 'S', 'LISTAR_NOTIFICACIONES_PENDIENTES', 'MSJ', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (33, 'S', 'CAMBIAR_ESTADO_MENSAJERIA', 'MSJ', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (42, 'S', 'EDITAR_USUARIO', 'AUT', 'S', null, '0.1.0', 'N');

insert into t_operaciones (ID_OPERACION, TIPO, NOMBRE, DOMINIO, ACTIVO, DETALLE, VERSION_ACTUAL, LOG_ACTIVO)
values (50, 'S', 'VERSION_SERVICIO', 'GEN', 'S', null, '0.1.0', 'N');

prompt Done.
