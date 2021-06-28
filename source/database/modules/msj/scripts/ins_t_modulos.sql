prompt Importing table t_modulos...
set feedback off
set define off

insert into t_modulos (ID_MODULO, NOMBRE, DETALLE, ACTIVO, FECHA_ACTUAL, VERSION_ACTUAL)
values ('MSJ', 'MENSAJERÍA', 'Módulo para envío de mensajes a los usuarios a través de Correo electrónico (E-mail), Mensaje de texto (SMS) y Notificación push', 'S', to_date('10-05-2021', 'dd-mm-yyyy'), '0.9.0');

prompt Done.
