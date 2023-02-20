prompt Importing table t_aplicaciones...
set feedback off
set define off

insert into t_aplicaciones (ID_APLICACION, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL, TIEMPO_EXPIRACION_ACCESS_TOKEN, TIEMPO_EXPIRACION_REFRESH_TOKEN, PLATAFORMA_NOTIFICACION)
values ('MSJ', 'RISK MSJ', 'S', 'S', 'Hkru7cXdu6FdIqhA9Q4XJqTgW/pW651rDjlSyLczKwI=', 'Servicio para envío de mensajes a los usuarios a través de Correo electrónico (E-mail), Mensaje de texto (SMS) y Notificación push', '0.1.0', 86400, 10000, null);

prompt Done.
