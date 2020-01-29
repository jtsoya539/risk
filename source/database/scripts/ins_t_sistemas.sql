prompt Importing table T_SISTEMAS...
set feedback off
set define off
insert into T_SISTEMAS (ID_SISTEMA, NOMBRE, DETALLE, ACTIVO, FECHA_ACTUAL, VERSION_ACTUAL)
values ('RISK', 'RISK', null, 'S', to_date('21-03-2019', 'dd-mm-yyyy'), '0.1');

prompt Done.
