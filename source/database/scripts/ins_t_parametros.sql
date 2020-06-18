prompt Importing table t_parametros...
set feedback off
set define off
insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('BASE_DATOS_PRODUCCION', 'Nombre de la Base de Datos del entorno de Producción', 'RISK');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('CANTIDAD_MAXIMA_SESIONES_USUARIO', 'Cantidad máxima permitida de sesiones activas por usuario', '2');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('CLAVE_VALIDACION_ACCESS_TOKEN', 'Clave de validación del Access Token', '9vVzzZbbUCcYE3cDnE+IVMrLF+8X8TPyK2cmC3Vu7M0=');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('LONGITUD_MINIMA_CLAVE_ACCESO', 'Longitud mínima permitida para clave de acceso', '8');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('LONGITUD_MINIMA_CLAVE_TRANSACCIONAL', 'Longitud mínima permitida para clave transaccional', '6');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('NOMBRE_ROL_DEFECTO', 'Nombre del Rol que se agrega por defecto a un usuario cuando se registra', 'USUARIO');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('REGEXP_VALIDAR_DIRECCION_CORREO', 'Expresión Regular para validación de direcciones de correo electrónico', '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('REGEXP_VALIDAR_NUMERO_TELEFONO', 'Expresión Regular para validación de números de teléfono', '^\+5959[6-9][1-9][0-9]{6}$');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('TIEMPO_EXPIRACION_ACCESS_TOKEN', 'Tiempo de expiración del Access Token en segundos', '300');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('TIEMPO_EXPIRACION_REFRESH_TOKEN', 'Tiempo de expiración del Refresh Token en horas', '5');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('URL_SERVICIOS_PRODUCCION', 'URL base de los Servicios Web del entorno de Producción', 'http://localhost:5000');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('PAGINACION_CANTIDAD_DEFECTO_POR_PAGINA', 'Cantidad por defecto de elementos por página en paginación de listas', '30');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('PAGINACION_CANTIDAD_MAXIMA_POR_PAGINA', 'Cantidad máxima permitida de elementos por página en paginación de listas', '100');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('DIRECCION_CORREO_PRUEBAS', 'Dirección de correo electrónico para pruebas', 'javier.meza.py@gmail.com');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('NUMERO_TELEFONO_PRUEBAS', 'Número de teléfono para pruebas', '+595991384113');

prompt Done.
