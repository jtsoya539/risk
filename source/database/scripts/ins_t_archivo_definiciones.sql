prompt Importing table t_archivo_definiciones...
set feedback off
set define off
insert into t_archivo_definiciones (TABLA, CAMPO, DESCRIPCION, TAMANO_MAXIMO, ORDEN, NOMBRE_REFERENCIA, EXTENSIONES_PERMITIDAS)
values ('T_USUARIOS', 'AVATAR', 'Avatar del usuario (imagen de perfil)', 10000000, 1, 'ALIAS', 'EXTENSION_IMAGEN');

prompt Done.