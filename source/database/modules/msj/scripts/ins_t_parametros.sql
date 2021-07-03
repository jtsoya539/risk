prompt Importing table t_parametros...
set feedback off
set define off

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('DIRECCION_CORREO_PRUEBAS', 'Direcci�n de correo electr�nico para pruebas', 'demouser@risk.com', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('DIRECCION_CORREO_REMITENTE', 'Direcci�n de correo del remitente para mensajer�a', null, 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('ENVIO_CORREOS_ACTIVO', 'Indica si est� activo el env�o de correos electr�nicos (E-mail) (S/N)', 'N', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('ENVIO_MENSAJES_ACTIVO', 'Indica si est� activo el env�o de mensajes de texto (SMS) (S/N)', 'N', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('ENVIO_NOTIFICACIONES_ACTIVO', 'Indica si est� activo el env�o de notificaciones push (S/N)', 'N', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('NUMERO_TELEFONO_PRUEBAS', 'N�mero de tel�fono para pruebas', '+595991000000', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('NUMERO_TELEFONO_REMITENTE', 'N�mero de tel�fono del remitente para mensajer�a', null, 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('REGEXP_VALIDAR_DIRECCION_CORREO', 'Expresi�n Regular para validaci�n de direcciones de correo electr�nico', '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('REGEXP_VALIDAR_NUMERO_TELEFONO', 'Expresi�n Regular para validaci�n de n�meros de tel�fono', '^\+5959[6-9][1-9][0-9]{6}$', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('SUSCRIPCION_PRUEBAS', 'Tag o expresi�n destino para pruebas de notificaciones push', 'test', 'MSJ');

prompt Done.
