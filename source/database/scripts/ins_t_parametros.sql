prompt Importing table t_parametros...
set feedback off
set define off

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('METODO_VALIDACION_CREDENCIALES', 'M�todo de validaci�n de credenciales', 'RISK', 'AUT');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('CONFIRMACION_DIRECCION_CORREO', 'Indica si est� activa la confirmaci�n de correo electr�nico de usuarios (S/N)', 'S', 'AUT');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('ESTADOS_ACTIVOS_USUARIO', 'Estados de usuario v�lidos para inicio de sesi�n. Separadas por coma. Ej.: A,P', 'A', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('BASE_DATOS_PRODUCCION', 'Nombre de la Base de Datos del entorno de Producci�n', 'RISK', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('CANTIDAD_MAXIMA_SESIONES_USUARIO', 'Cantidad m�xima permitida de sesiones activas por usuario', '2', 'AUT');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('CLAVE_ENCRIPTACION_DESENCRIPTACION', 'Clave para encriptaci�n y desencriptaci�n. Generar con la funci�n k_autenticacion.f_randombytes_hex', '26B9257BF16323A5919FAA48ABB7C575A50996698A0576C0DE0EE312AF6D2D60', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('CLAVE_VALIDACION_ACCESS_TOKEN', 'Clave de validaci�n del Access Token. Generar con la funci�n k_autenticacion.f_randombytes_base64', '9vVzzZbbUCcYE3cDnE+IVMrLF+8X8TPyK2cmC3Vu7M0=', 'AUT');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('NOMBRE_ROL_DEFECTO', 'Nombre del Rol que se agrega por defecto a un usuario cuando se registra', 'USUARIO', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('TIEMPO_EXPIRACION_ACCESS_TOKEN', 'Tiempo de expiraci�n del Access Token en segundos', '300', 'AUT');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('TIEMPO_EXPIRACION_REFRESH_TOKEN', 'Tiempo de expiraci�n del Refresh Token en horas', '5', 'AUT');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('URL_SERVICIOS_PRODUCCION', 'URL base de los Servicios Web del entorno de Producci�n', 'https://localhost:5001', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('PAGINACION_CANTIDAD_DEFECTO_POR_PAGINA', 'Cantidad por defecto de elementos por p�gina en paginaci�n de listas', '30', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('PAGINACION_CANTIDAD_MAXIMA_POR_PAGINA', 'Cantidad m�xima permitida de elementos por p�gina en paginaci�n de listas', '100', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('GOOGLE_IDENTIFICADOR_CLIENTE', 'Identificador del cliente de los Servicios Web de Google', null, 'AUT');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('GOOGLE_EMISOR_TOKEN', 'Emisor del token de Google', 'accounts.google.com', 'AUT');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('REPORTE_FORMATO_SALIDA_DEFECTO', 'Formato de salida por defecto para reportes', 'PDF', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('REGEXP_VALIDAR_ALIAS_USUARIO', 'Expresi�n Regular para validaci�n de alias de usuario', '^[A-Za-z0-9_]{1,50}$', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('TIEMPO_TOLERANCIA_VALIDAR_OTP', 'Tiempo de tolerancia para validaci�n de OTP en segundos', '120', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('ZONA_HORARIA', 'Zona horaria del entorno de Producci�n', '-4:0', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('ID_IDIOMA_ISO', 'C�digo del Idioma por defecto seg�n est�ndar ISO 639-1', 'es', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('ID_PAIS_ISO', 'C�digo del Pa�s por defecto seg�n est�ndar ISO 3166-1 alpha-2', 'PY', null);

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('AUTENTICACION_CANTIDAD_INTENTOS_PERMITIDOS', 'Cantidad de intentos permitidos de autenticaci�n antes del bloqueo de clave', '3', 'AUT');

prompt Done.
