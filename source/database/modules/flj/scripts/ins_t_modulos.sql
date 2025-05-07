prompt Importing table t_modulos...
set feedback off
set define off

insert into t_modulos (ID_MODULO, NOMBRE, DETALLE, ACTIVO, FECHA_ACTUAL, VERSION_ACTUAL)
values ('FLJ', 'FLUJOS', 'Módulo para la gestión del motor de flujos', 'S', to_date('04-05-2025', 'dd-mm-yyyy'), '1.0.0');

prompt Done.
