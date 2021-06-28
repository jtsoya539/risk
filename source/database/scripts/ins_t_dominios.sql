prompt Importing table t_dominios...
set feedback off
set define off
insert into t_dominios (ID_DOMINIO, NOMBRE, DETALLE, ACTIVO, ID_MODULO)
values ('GEN', 'GENERAL', null, 'S', 'RISK');

insert into t_dominios (ID_DOMINIO, NOMBRE, DETALLE, ACTIVO, ID_MODULO)
values ('AUT', 'AUTENTICACIÓN', null, 'S', 'RISK');

insert into t_dominios (ID_DOMINIO, NOMBRE, DETALLE, ACTIVO, ID_MODULO)
values ('API', 'SERVICIO', null, 'S', 'RISK');

prompt Done.
