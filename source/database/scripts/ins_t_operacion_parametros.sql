prompt Importing table t_operacion_parametros...
set feedback off
set define off

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (1, 'USUARIO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (1, 'CLAVE', '0.1.0', 2, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (1, 'TIPO_CLAVE', '0.1.0', 3, 'S', 'S', null, null, 'N', 'A', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (2, 'USUARIO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (2, 'ACCESS_TOKEN', '0.1.0', 2, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (2, 'REFRESH_TOKEN', '0.1.0', 3, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (2, 'TOKEN_DISPOSITIVO', '0.1.0', 4, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (2, 'ORIGEN', '0.1.0', 5, 'S', 'S', null, 1, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (2, 'DATO_EXTERNO', '0.1.0', 6, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (3, 'ACCESS_TOKEN', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (3, 'ESTADO', '0.1.0', 2, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (4, 'USUARIO', '0.1.0', 1, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (4, 'CLAVE', '0.1.0', 2, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (4, 'NOMBRE', '0.1.0', 3, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (4, 'APELLIDO', '0.1.0', 4, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (4, 'DIRECCION_CORREO', '0.1.0', 5, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (4, 'NUMERO_TELEFONO', '0.1.0', 6, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (4, 'ORIGEN', '0.1.0', 7, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (4, 'ID_EXTERNO', '0.1.0', 8, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (5, 'USUARIO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (5, 'CLAVE', '0.1.0', 2, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (5, 'TIPO_CLAVE', '0.1.0', 3, 'S', 'S', null, null, 'N', 'A', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (6, 'USUARIO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (6, 'CLAVE_ANTIGUA', '0.1.0', 2, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (6, 'CLAVE_NUEVA', '0.1.0', 3, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (6, 'TIPO_CLAVE', '0.1.0', 4, 'S', 'S', null, null, 'N', 'A', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (7, 'ACCESS_TOKEN', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (8, 'PARAMETRO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (9, 'DOMINIO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (9, 'CODIGO', '0.1.0', 2, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (10, 'USUARIO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (11, 'ACCESS_TOKEN_ANTIGUO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (11, 'REFRESH_TOKEN_ANTIGUO', '0.1.0', 2, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (11, 'ACCESS_TOKEN_NUEVO', '0.1.0', 3, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (11, 'REFRESH_TOKEN_NUEVO', '0.1.0', 4, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (11, 'ORIGEN', '0.1.0', 5, 'S', 'S', null, 1, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (11, 'DATO_EXTERNO', '0.1.0', 6, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (12, 'CLAVE_APLICACION', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (14, 'DISPOSITIVO', '0.1.0', 1, 'S', 'O', 'Y_DISPOSITIVO', null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (15, 'TOKEN_DISPOSITIVO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (15, 'LATITUD', '0.1.0', 2, 'S', 'N', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (15, 'LONGITUD', '0.1.0', 3, 'S', 'N', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (16, 'ID_PAIS', '0.1.0', 1, 'S', 'N', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (17, 'TIPO_TOKEN', '0.1.0', 1, 'S', 'S', null, null, 'N', 'A', null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (18, 'TABLA', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (18, 'CAMPO', '0.1.0', 2, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (18, 'REFERENCIA', '0.1.0', 3, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (18, 'VERSION', '0.1.0', 4, 'S', 'N', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (19, 'TABLA', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (19, 'CAMPO', '0.1.0', 2, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (19, 'REFERENCIA', '0.1.0', 3, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (19, 'ARCHIVO', '0.1.0', 4, 'S', 'O', 'Y_ARCHIVO', null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (21, 'TOKEN_DISPOSITIVO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (22, 'USUARIO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (22, 'ESTADO', '0.1.0', 2, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (23, 'TIPO_MENSAJERIA', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (23, 'DESTINO', '0.1.0', 2, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (24, 'SECRET', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (24, 'OTP', '0.1.0', 2, 'S', 'N', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (25, 'ID_DEPARTAMENTO', '0.1.0', 1, 'S', 'N', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (25, 'ID_PAIS', '0.1.0', 2, 'S', 'N', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (26, 'ID_CIUDAD', '0.1.0', 1, 'S', 'N', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (26, 'ID_PAIS', '0.1.0', 2, 'S', 'N', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (26, 'ID_DEPARTAMENTO', '0.1.0', 3, 'S', 'N', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (27, 'ID_BARRIO', '0.1.0', 1, 'S', 'N', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (27, 'ID_PAIS', '0.1.0', 2, 'S', 'N', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (27, 'ID_DEPARTAMENTO', '0.1.0', 3, 'S', 'N', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (27, 'ID_CIUDAD', '0.1.0', 4, 'S', 'N', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (28, 'REFERENCIA', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (29, 'DOMINIO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (33, 'TIPO_MENSAJERIA', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (33, 'ID_MENSAJERIA', '0.1.0', 2, 'S', 'N', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (33, 'ESTADO', '0.1.0', 3, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (33, 'RESPUESTA_ENVIO', '0.1.0', 4, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (34, 'TIPO_MENSAJERIA', '0.1.0', 1, 'S', 'S', null, 1, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (34, 'ESTADO', '0.1.0', 2, 'S', 'S', null, 1, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (36, 'DOMINIO', '0.1.0', 2, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (42, 'USUARIO_ANTIGUO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (42, 'USUARIO_NUEVO', '0.1.0', 2, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (42, 'NOMBRE', '0.1.0', 3, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (42, 'APELLIDO', '0.1.0', 4, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (42, 'DIRECCION_CORREO', '0.1.0', 5, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (42, 'NUMERO_TELEFONO', '0.1.0', 6, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (50, 'SERVICIO', '0.1.0', 1, 'S', 'S', null, null, 'S', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (51, 'ID_ERROR', '0.1.0', 1, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (59, 'ID_APLICACION', '0.1.0', 1, 'S', 'S', null, 5, 'N', null, 'Identificador de la aplicación', null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (59, 'CLAVE', '0.1.0', 2, 'S', 'S', null, 50, 'N', null, 'Clave de la aplicación', null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (1000, 'PAGINA_PARAMETROS', '0.1.0', 100, 'S', 'O', 'Y_PAGINA_PARAMETROS', null, 'N', '{}', null, 'Parámetros para paginación de elementos', null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (1000, 'FORMATO', '0.1.0', 101, 'S', 'S', null, 4, 'N', 'PDF', null, 'Formato de salida de reporte', null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (1001, 'DIRECCION_IP', '0.1.0', 1, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (1001, 'CLAVE_APLICACION', '0.1.0', 2, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (1001, 'ACCESS_TOKEN', '0.1.0', 3, 'S', 'S', null, null, 'N', null, null, null, null);

insert into t_operacion_parametros (ID_OPERACION, NOMBRE, VERSION, ORDEN, ACTIVO, TIPO_DATO, FORMATO, LONGITUD_MAXIMA, OBLIGATORIO, VALOR_DEFECTO, ETIQUETA, DETALLE, VALORES_POSIBLES)
values (1001, 'USUARIO', '0.1.0', 4, 'S', 'S', null, null, 'N', null, null, null, null);

prompt Done.
