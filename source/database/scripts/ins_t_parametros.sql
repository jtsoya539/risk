prompt Importing table t_parametros...
set feedback off
set define off
insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('METODO_VALIDACION_CREDENCIALES', 'M�todo de validaci�n de credenciales', 'RISK');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('ENVIO_CORREOS_ACTIVO', 'Indica si est� activo el env�o de correos electr�nicos (E-mail) (S/N)', 'N');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('ENVIO_MENSAJES_ACTIVO', 'Indica si est� activo el env�o de mensajes de texto (SMS) (S/N)', 'N');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('ENVIO_NOTIFICACIONES_ACTIVO', 'Indica si est� activo el env�o de notificaciones push (S/N)', 'N');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('CONFIRMACION_DIRECCION_CORREO', 'Indica si est� activa la confirmaci�n de correo electr�nico de usuarios (S/N)', 'S');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('ESTADOS_ACTIVOS_USUARIO', 'Estados de usuario v�lidos para inicio de sesi�n. Separadas por coma. Ej.: A,P', 'A');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('BASE_DATOS_PRODUCCION', 'Nombre de la Base de Datos del entorno de Producci�n', 'RISK');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('CANTIDAD_MAXIMA_SESIONES_USUARIO', 'Cantidad m�xima permitida de sesiones activas por usuario', '2');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('CLAVE_ENCRIPTACION_DESENCRIPTACION', 'Clave para encriptaci�n y desencriptaci�n. Generar con la funci�n k_autenticacion.f_randombytes_hex', '26B9257BF16323A5919FAA48ABB7C575A50996698A0576C0DE0EE312AF6D2D60');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('CLAVE_VALIDACION_ACCESS_TOKEN', 'Clave de validaci�n del Access Token. Generar con la funci�n k_autenticacion.f_randombytes_base64', '9vVzzZbbUCcYE3cDnE+IVMrLF+8X8TPyK2cmC3Vu7M0=');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('NOMBRE_ROL_DEFECTO', 'Nombre del Rol que se agrega por defecto a un usuario cuando se registra', 'USUARIO');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('REGEXP_VALIDAR_DIRECCION_CORREO', 'Expresi�n Regular para validaci�n de direcciones de correo electr�nico', '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('REGEXP_VALIDAR_NUMERO_TELEFONO', 'Expresi�n Regular para validaci�n de n�meros de tel�fono', '^\+5959[6-9][1-9][0-9]{6}$');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('TIEMPO_EXPIRACION_ACCESS_TOKEN', 'Tiempo de expiraci�n del Access Token en segundos', '300');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('TIEMPO_EXPIRACION_REFRESH_TOKEN', 'Tiempo de expiraci�n del Refresh Token en horas', '5');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('URL_SERVICIOS_PRODUCCION', 'URL base de los Servicios Web del entorno de Producci�n', 'https://localhost:5001');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('PAGINACION_CANTIDAD_DEFECTO_POR_PAGINA', 'Cantidad por defecto de elementos por p�gina en paginaci�n de listas', '30');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('PAGINACION_CANTIDAD_MAXIMA_POR_PAGINA', 'Cantidad m�xima permitida de elementos por p�gina en paginaci�n de listas', '100');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('DIRECCION_CORREO_PRUEBAS', 'Direcci�n de correo electr�nico para pruebas', 'demouser@risk.com');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('NUMERO_TELEFONO_PRUEBAS', 'N�mero de tel�fono para pruebas', '+595991000000');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('DIRECCION_CORREO_REMITENTE', 'Direcci�n de correo del remitente para mensajer�a', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('NUMERO_TELEFONO_REMITENTE', 'N�mero de tel�fono del remitente para mensajer�a', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('GOOGLE_IDENTIFICADOR_CLIENTE', 'Identificador del cliente de los Servicios Web de Google', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('GOOGLE_EMISOR_TOKEN', 'Emisor del token de Google', 'accounts.google.com');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('REPORTE_FORMATO_SALIDA_DEFECTO', 'Formato de salida por defecto para reportes', 'PDF');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('SUSCRIPCION_PRUEBAS', 'Tag o expresi�n destino para pruebas de notificaciones push', 'test');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('REGEXP_VALIDAR_ALIAS_USUARIO', 'Expresi�n Regular para validaci�n de alias de usuario', '^[A-Za-z0-9_]{1,50}$');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('TIEMPO_TOLERANCIA_VALIDAR_OTP', 'Tiempo de tolerancia para validaci�n de OTP en segundos', '120');

prompt Done.
