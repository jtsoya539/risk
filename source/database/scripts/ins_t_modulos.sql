prompt Importing table t_modulos...
set feedback off
set define off

insert into t_modulos (ID_MODULO, NOMBRE, DETALLE, ACTIVO, FECHA_ACTUAL, VERSION_ACTUAL)
values ('RISK', 'RISK', 'Módulo principal con manejo de Operaciones (Servicios Web, Reportes, Trabajos) y sus Parámetros, Autenticación y Autorización de Usuarios, Parámetros, Significados, Archivos, Datos Adicionales, entre otros', 'S', to_date('01-11-2021', 'dd-mm-yyyy'), '1.1.0');

prompt Done.
