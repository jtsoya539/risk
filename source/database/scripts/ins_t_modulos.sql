prompt Importing table t_modulos...
set feedback off
set define off

insert into t_modulos (ID_MODULO, NOMBRE, DETALLE, ACTIVO, FECHA_ACTUAL, VERSION_ACTUAL)
values ('RISK', 'RISK', 'M�dulo principal con manejo de Operaciones (Servicios Web, Reportes, Trabajos) y sus Par�metros, Autenticaci�n y Autorizaci�n de Usuarios, Par�metros, Significados, Archivos, Datos Adicionales, entre otros', 'S', to_date('09-06-2022', 'dd-mm-yyyy'), '1.4.0');

prompt Done.
