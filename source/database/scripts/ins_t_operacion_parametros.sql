prompt Importing table t_operacion_parametros...
set feedback off
set define off
insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (0, 'DIRECCION_IP', 1, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (0, 'CLAVE_APLICACION', 2, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (0, 'ACCESS_TOKEN', 3, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (0, 'USUARIO', 4, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (1, 'USUARIO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (1, 'CLAVE', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (1, 'TIPO_CLAVE', 3, 'S', 'S', null, null, 'N', 'A', null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (2, 'USUARIO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (2, 'ACCESS_TOKEN', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (2, 'REFRESH_TOKEN', 3, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (2, 'TOKEN_DISPOSITIVO', 4, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (3, 'ACCESS_TOKEN', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (3, 'ESTADO', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (4, 'USUARIO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (4, 'CLAVE', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (4, 'NOMBRE', 3, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (4, 'APELLIDO', 4, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (4, 'DIRECCION_CORREO', 5, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (4, 'NUMERO_TELEFONO', 6, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (5, 'USUARIO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (5, 'CLAVE', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (5, 'TIPO_CLAVE', 3, 'S', 'S', null, null, 'N', 'A', null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (6, 'USUARIO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (6, 'CLAVE_ANTIGUA', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (6, 'CLAVE_NUEVA', 3, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (6, 'TIPO_CLAVE', 4, 'S', 'S', null, null, 'N', 'A', null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (7, 'ACCESS_TOKEN', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (8, 'PARAMETRO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (9, 'DOMINIO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (9, 'CODIGO', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (10, 'USUARIO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (11, 'ACCESS_TOKEN_ANTIGUO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (11, 'REFRESH_TOKEN_ANTIGUO', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (11, 'ACCESS_TOKEN_NUEVO', 3, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (11, 'REFRESH_TOKEN_NUEVO', 4, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (12, 'CLAVE_APLICACION', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (14, 'DISPOSITIVO', 1, 'S', 'O', 'Y_DISPOSITIVO', null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (15, 'TOKEN_DISPOSITIVO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (15, 'LATITUD', 2, 'S', 'N', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (15, 'LONGITUD', 3, 'S', 'N', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (16, 'ID_PAIS', 1, 'S', 'N', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (16, 'PAGINA_PARAMETROS', 10, 'S', 'O', 'Y_PAGINA_PARAMETROS', null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (17, 'TIPO_TOKEN', 1, 'S', 'S', null, null, 'N', 'A', null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (18, 'TABLA', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (18, 'CAMPO', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (18, 'REFERENCIA', 3, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (18, 'VERSION', 4, 'S', 'N', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (19, 'TABLA', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (19, 'CAMPO', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (19, 'REFERENCIA', 3, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (19, 'ARCHIVO', 4, 'S', 'O', 'Y_ARCHIVO', null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (20, 'FORMATO', 1, 'S', 'S', null, 4, 'S', 'PDF', null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (21, 'TOKEN_DISPOSITIVO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (22, 'USUARIO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (22, 'ESTADO', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (23, 'TIPO_MENSAJERIA', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (23, 'DESTINO', 2, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (24, 'SECRET', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (24, 'OTP', 2, 'S', 'N', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (25, 'ID_DEPARTAMENTO', 1, 'S', 'N', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (25, 'ID_PAIS', 2, 'S', 'N', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (25, 'PAGINA_PARAMETROS', 10, 'S', 'O', 'Y_PAGINA_PARAMETROS', null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (26, 'ID_CIUDAD', 1, 'S', 'N', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (26, 'ID_PAIS', 2, 'S', 'N', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (26, 'ID_DEPARTAMENTO', 3, 'S', 'N', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (26, 'PAGINA_PARAMETROS', 10, 'S', 'O', 'Y_PAGINA_PARAMETROS', null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (27, 'ID_BARRIO', 1, 'S', 'N', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (27, 'ID_PAIS', 2, 'S', 'N', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (27, 'ID_DEPARTAMENTO', 3, 'S', 'N', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (27, 'ID_CIUDAD', 4, 'S', 'N', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (27, 'PAGINA_PARAMETROS', 10, 'S', 'O', 'Y_PAGINA_PARAMETROS', null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (28, 'REFERENCIA', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (29, 'DOMINIO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (29, 'PAGINA_PARAMETROS', 10, 'S', 'O', 'Y_PAGINA_PARAMETROS', null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (30, 'PAGINA_PARAMETROS', 10, 'S', 'O', 'Y_PAGINA_PARAMETROS', null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (31, 'PAGINA_PARAMETROS', 10, 'S', 'O', 'Y_PAGINA_PARAMETROS', null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (32, 'PAGINA_PARAMETROS', 10, 'S', 'O', 'Y_PAGINA_PARAMETROS', null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (33, 'TIPO_MENSAJERIA', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (33, 'ID_MENSAJERIA', 2, 'S', 'N', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (33, 'ESTADO', 3, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (33, 'RESPUESTA_ENVIO', 4, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (34, 'TIPO_MENSAJERIA', 1, 'S', 'S', null, 1, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (34, 'ESTADO', 2, 'S', 'S', null, 1, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (36, 'FORMATO', 1, 'S', 'S', null, 4, 'S', 'PDF', null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (36, 'DOMINIO', 2, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (42, 'USUARIO_ANTIGUO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (42, 'USUARIO_NUEVO', 2, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (42, 'NOMBRE', 3, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (42, 'APELLIDO', 4, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (42, 'DIRECCION_CORREO', 5, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (42, 'NUMERO_TELEFONO', 6, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (50, 'SERVICIO', 1, 'S', 'S', null, null, 'S', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (51, 'ID_ERROR', 1, 'S', 'S', null, null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (51, 'PAGINA_PARAMETROS', 10, 'S', 'O', 'Y_PAGINA_PARAMETROS', null, 'N', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (59, 'ID_APLICACION', 1, 'S', 'S', null, 5, 'N', null, 'Identificador de la aplicación', null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (59, 'CLAVE', 2, 'S', 'S', null, 50, 'N', null, 'Clave de la aplicación', null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE)
values (59, 'PAGINA_PARAMETROS', 10, 'S', 'O', 'Y_PAGINA_PARAMETROS', null, 'N', null, null, null);

prompt Done.
