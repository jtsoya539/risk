prompt Importing table t_usuarios...
set feedback off
set define off
insert into t_usuarios (ID_USUARIO, ALIAS, ID_PERSONA, ESTADO, DIRECCION_CORREO, NUMERO_TELEFONO)
values (1, 'demouser', 1, 'A', 'demouser@risk.com', null);

insert into t_usuarios (ID_USUARIO, ALIAS, ID_PERSONA, ESTADO, DIRECCION_CORREO, NUMERO_TELEFONO)
values (2, 'msjuser', null, 'A', null, null);

insert into t_usuarios (ID_USUARIO, ALIAS, ID_PERSONA, ESTADO, DIRECCION_CORREO, NUMERO_TELEFONO)
values (3, 'admin', null, 'A', 'admin@risk.com', null);

prompt Done.
