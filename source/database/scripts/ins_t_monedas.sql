prompt Importing table t_monedas...
set feedback off
set define off

insert into t_monedas (ID_MONEDA, DESCRIPCION, ACTIVO, FORMATO, SIMBOLO, ID_PAIS)
values ('EUR', 'EUROS', 'S', '999G999G999G999G999D00', '€', null);

insert into t_monedas (ID_MONEDA, DESCRIPCION, ACTIVO, FORMATO, SIMBOLO, ID_PAIS)
values ('GS', 'GUARANÍES', 'S', '999G999G999G999G999', 'G', 177);

insert into t_monedas (ID_MONEDA, DESCRIPCION, ACTIVO, FORMATO, SIMBOLO, ID_PAIS)
values ('USD', 'DÓLARES AMERICANOS', 'S', '999G999G999G999G999D00', '$', 65);

prompt Done.
