prompt Importing table t_aplicaciones...
set feedback off
set define off
insert into t_aplicaciones (ID_APLICACION, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL, TIEMPO_EXPIRACION_ACCESS_TOKEN, TIEMPO_EXPIRACION_REFRESH_TOKEN)
values ('TEST', 'RISK TEST', 'W', 'S', 'KM1gROAnPUAZykrHcOOJRAC1jkcnyBVLRWXcRD3pjvQ=', 'Cliente HTTP para pruebas de Servicios Web', '0.1', 3600, 5);

insert into t_aplicaciones (ID_APLICACION, NOMBRE, TIPO, ACTIVO, CLAVE, DETALLE, VERSION_ACTUAL, TIEMPO_EXPIRACION_ACCESS_TOKEN, TIEMPO_EXPIRACION_REFRESH_TOKEN)
values ('MSJ', 'RISK MENSAJERÍA', 'W', 'S', 'Va1eggcdH9F27TTuLFMzU6s4mt568v439ZOD+8dw9ig=', 'Servicio para envío de mensajes a los usuarios a través de Correo electrónico (E-mail) y Mensaje de texto (SMS)', '0.1', 86400, 10000);

prompt Done.
