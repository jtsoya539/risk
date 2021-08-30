prompt Importing table t_monedas...
set feedback off
set define off
insert into t_monedas (ID_MONEDA, DESCRIPCION, ACTIVO, FORMATO, SIMBOLO, ID_PAIS, CODIGO_ISO)
values ('ARP', 'PESO ARGENTINO', 'S', '999G999G999G999G999D00', null, 12, 'ARS');

insert into t_monedas (ID_MONEDA, DESCRIPCION, ACTIVO, FORMATO, SIMBOLO, ID_PAIS, CODIGO_ISO)
values ('EUR', 'EURO', 'S', '999G999G999G999G999D00', null, null, 'EUR');

insert into t_monedas (ID_MONEDA, DESCRIPCION, ACTIVO, FORMATO, SIMBOLO, ID_PAIS, CODIGO_ISO)
values ('GS', 'GUARANÍ', 'S', '999G999G999G999G999', null, 177, 'PYG');

insert into t_monedas (ID_MONEDA, DESCRIPCION, ACTIVO, FORMATO, SIMBOLO, ID_PAIS, CODIGO_ISO)
values ('RS', 'REAL BRASILEÑO', 'S', '999G999G999G999G999D00', null, 31, 'BRL');

insert into t_monedas (ID_MONEDA, DESCRIPCION, ACTIVO, FORMATO, SIMBOLO, ID_PAIS, CODIGO_ISO)
values ('USD', 'DÓLAR ESTADOUNIDENSE', 'S', '999G999G999G999G999D00', '$', 65, 'USD');

prompt Done.
