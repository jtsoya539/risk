prompt Importing table t_roles...
set feedback off
set define off
insert into t_roles (ID_ROL, NOMBRE, ACTIVO, DETALLE)
values (1, 'ADMINISTRADOR', 'S', 'Rol con permisos para administradores del sistema');

insert into t_roles (ID_ROL, NOMBRE, ACTIVO, DETALLE)
values (2, 'USUARIO', 'S', 'Rol con permisos para usuarios del sistema');

insert into t_roles (ID_ROL, NOMBRE, ACTIVO, DETALLE)
values (3, 'MENSAJERIA', 'S', 'Rol para envío de mensajes a los usuarios a través de Correo electrónico (E-mail), Mensaje de texto (SMS) y Notificación push');

insert into t_roles (ID_ROL, NOMBRE, ACTIVO, DETALLE)
values (4, 'USUARIO_NUEVO', 'S', 'Rol con permisos para usuarios nuevos del sistema');

prompt Done.
