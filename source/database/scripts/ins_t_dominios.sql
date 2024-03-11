prompt Importing table t_dominios...
set feedback off
set define off
insert into t_dominios (ID_DOMINIO, NOMBRE, DETALLE, ACTIVO, ID_MODULO)
values ('GEN', 'GENERAL', 'Dominio General', 'S', 'RISK');

insert into t_dominios (ID_DOMINIO, NOMBRE, DETALLE, ACTIVO, ID_MODULO)
values ('AUT', 'AUTENTICACIÓN', 'Dominio de Autenticación y Autorización de Usuarios', 'S', 'RISK');

insert into t_dominios (ID_DOMINIO, NOMBRE, DETALLE, ACTIVO, ID_MODULO)
values ('API', 'OPERACIONES', 'Dominio de Operaciones (Servicios Web, Reportes, Trabajos) y sus Parámetros', 'S', 'RISK');

insert into t_dominios (ID_DOMINIO, NOMBRE, DETALLE, ACTIVO, ID_MODULO)
values ('GLO', 'GLOBAL', 'Dominio Global', 'S', 'RISK');

prompt Done.
