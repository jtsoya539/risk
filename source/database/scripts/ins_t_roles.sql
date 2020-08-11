prompt Importing table t_roles...
set feedback off
set define off
insert into t_roles (ID_ROL, NOMBRE, ACTIVO, DETALLE)
values (1, 'ADMINISTRADOR', 'S', null);

insert into t_roles (ID_ROL, NOMBRE, ACTIVO, DETALLE)
values (2, 'USUARIO', 'S', null);

insert into t_roles (ID_ROL, NOMBRE, ACTIVO, DETALLE)
values (3, 'MENSAJERIA', 'S', 'Rol para envío de mensajes a los usuarios a través de Correo electrónico (E-mail), Mensaje de texto (SMS) y Notificación push');

prompt Done.
