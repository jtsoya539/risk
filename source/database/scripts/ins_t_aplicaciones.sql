prompt Importing table t_aplicaciones...
set feedback off
set define off
insert into t_aplicaciones (ID_APLICACION, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL, TIEMPO_EXPIRACION_ACCESS_TOKEN, TIEMPO_EXPIRACION_REFRESH_TOKEN, TEMPLATE_NOTIFICACION, PLATAFORMA_NOTIFICACION)
values ('WIN', 'WINDOWS', 'D', 'S', 'u0jVxK7vw3b4O1/pnJnFD5CzoY4lyvRfwC/yUfXscFk=', 'Aplicación para la plataforma Windows', '0.1', 900, 5, null, 'wns');

insert into t_aplicaciones (ID_APLICACION, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL, TIEMPO_EXPIRACION_ACCESS_TOKEN, TIEMPO_EXPIRACION_REFRESH_TOKEN, TEMPLATE_NOTIFICACION, PLATAFORMA_NOTIFICACION)
values ('AND', 'ANDROID', 'M', 'S', 'azVd94zazPu/+q5ZHqoL1v6wccamHV3oWoALYWQK0Z8=', 'Aplicación móvil para la plataforma Android', '0.1', 900, 5, '{"notification":{"title":"$(titulo)","body":"$(contenido)"}}', 'fcm');

insert into t_aplicaciones (ID_APLICACION, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL, TIEMPO_EXPIRACION_ACCESS_TOKEN, TIEMPO_EXPIRACION_REFRESH_TOKEN, TEMPLATE_NOTIFICACION, PLATAFORMA_NOTIFICACION)
values ('IOS', 'IOS', 'M', 'S', '7C+o70uaWg7q4INnuzryHorFzbjNQOCWjrYZzWDQmLA=', 'Aplicación móvil para la plataforma iOS', '0.1', 900, 5, '{"aps":{"alert":"$(contenido)"}}', 'apns');

insert into t_aplicaciones (ID_APLICACION, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL, TIEMPO_EXPIRACION_ACCESS_TOKEN, TIEMPO_EXPIRACION_REFRESH_TOKEN, TEMPLATE_NOTIFICACION, PLATAFORMA_NOTIFICACION)
values ('MAIL', 'RISK MAIL', 'S', 'S', 'Hkru7cXdu6FdIqhA9Q4XJqTgW/pW651rDjlSyLczKwI=', 'Servicio para envío de mensajes a los usuarios a través de Correo electrónico (E-mail)', '0.1', 86400, 10000, null, null);

insert into t_aplicaciones (ID_APLICACION, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL, TIEMPO_EXPIRACION_ACCESS_TOKEN, TIEMPO_EXPIRACION_REFRESH_TOKEN, TEMPLATE_NOTIFICACION, PLATAFORMA_NOTIFICACION)
values ('PUSH', 'RISK PUSH', 'S', 'S', 'bQvry6WjGfCSg3R3K3zOogGl9XVhISEmqu9aZyMIK/0=', 'Servicio para envío de mensajes a los usuarios a través de Notificaciones push', '0.1', 86400, 10000, null, null);

insert into t_aplicaciones (ID_APLICACION, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL, TIEMPO_EXPIRACION_ACCESS_TOKEN, TIEMPO_EXPIRACION_REFRESH_TOKEN, TEMPLATE_NOTIFICACION, PLATAFORMA_NOTIFICACION)
values ('SMS', 'RISK SMS', 'S', 'S', 'Va1eggcdH9F27TTuLFMzU6s4mt568v439ZOD+8dw9ig=', 'Servicio para envío de mensajes a los usuarios a través de Mensaje de texto (SMS)', '0.1', 86400, 10000, null, null);

insert into t_aplicaciones (ID_APLICACION, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL, TIEMPO_EXPIRACION_ACCESS_TOKEN, TIEMPO_EXPIRACION_REFRESH_TOKEN, TEMPLATE_NOTIFICACION, PLATAFORMA_NOTIFICACION)
values ('TEST', 'RISK TEST', 'W', 'S', 'KM1gROAnPUAZykrHcOOJRAC1jkcnyBVLRWXcRD3pjvQ=', 'Cliente HTTP para pruebas de Servicios Web', '0.1', 3600, 5, null, null);

prompt Done.
