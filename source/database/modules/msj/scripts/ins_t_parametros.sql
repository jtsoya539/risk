prompt Importing table t_parametros...
set feedback off
set define off

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('DIRECCION_CORREO_PRUEBAS', 'Dirección de correo electrónico para pruebas', 'demouser@risk.com', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('DIRECCION_CORREO_REMITENTE', 'Dirección de correo del remitente para mensajería', null, 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('ENVIO_CORREOS_ACTIVO', 'Indica si está activo el envío de correos electrónicos (E-mail) (S/N)', 'N', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('ENVIO_MENSAJES_ACTIVO', 'Indica si está activo el envío de mensajes de texto (SMS) (S/N)', 'N', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('ENVIO_NOTIFICACIONES_ACTIVO', 'Indica si está activo el envío de notificaciones push (S/N)', 'N', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('NUMERO_TELEFONO_PRUEBAS', 'Número de teléfono para pruebas', '+595991000000', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('NUMERO_TELEFONO_REMITENTE', 'Número de teléfono del remitente para mensajería', null, 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('REGEXP_VALIDAR_DIRECCION_CORREO', 'Expresión Regular para validación de direcciones de correo electrónico', '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('REGEXP_VALIDAR_NUMERO_TELEFONO', 'Expresión Regular para validación de números de teléfono', '^\+5959[6-9][1-9][0-9]{6}$', 'MSJ');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR, ID_DOMINIO)
values ('SUSCRIPCION_PRUEBAS', 'Tag o expresión destino para pruebas de notificaciones push', 'test', 'MSJ');

prompt Done.
