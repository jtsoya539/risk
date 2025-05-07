prompt Importing table t_flujos...
set feedback off
set define off

insert into t_flujos (ID_FLUJO, NOMBRE, ACTIVO, DETALLE, VARIABLES_DEFECTO)
values (1, 'Demo de Solicitud de Servicio Interno', 'S', 'Flujo de aprobación demo para solicitudes internas', null);

prompt Done.
