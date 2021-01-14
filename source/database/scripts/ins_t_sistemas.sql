prompt Importing table t_sistemas...
set feedback off
set define off

insert into t_sistemas (ID_SISTEMA, NOMBRE, DETALLE, ACTIVO, FECHA_ACTUAL, VERSION_ACTUAL)
values ('RISK', 'RISK', null, 'S', to_date('14-01-2021', 'dd-mm-yyyy'), '0.3.0');

prompt Done.
