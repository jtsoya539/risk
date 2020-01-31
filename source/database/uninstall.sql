spool uninstall.log

set feedback off
set define off

prompt ---------------------------------
prompt |  _____   _____   _____  _  __ |
prompt | |  __ \ |_   _| / ____|| |/ / |
prompt | | |__) |  | |  | (___  | ' /  |
prompt | |  _  /   | |   \___ \ |  <   |
prompt | | | \ \  _| |_  ____) || . \  |
prompt | |_|  \_\|_____||_____/ |_|\_\ |
prompt |                               |
prompt |    Risk Project for Oracle    |
prompt |         By @jtsoya539         |
prompt ---------------------------------

prompt
prompt ===========================
prompt Uninstalling Risk Project
prompt ===========================
prompt

prompt
prompt Uninstalling packages...
prompt ---------------------------
prompt
drop package k_servicio;
drop package k_error;
drop package k_autenticacion;
drop package k_auditoria;
drop package k_util;
drop package k_sistema;

prompt
prompt Uninstalling types...
prompt ---------------------------
prompt
drop type y_respuesta force;

prompt
prompt Uninstalling tables...
prompt ---------------------------
prompt
drop table t_usuario_claves cascade constraints;
drop table t_sesiones cascade constraints;
drop table t_servicios cascade constraints;
drop table t_rol_usuarios cascade constraints;
drop table t_rol_parametros cascade constraints;
drop table t_parametros cascade constraints;
drop table t_roles cascade constraints;
drop table t_usuarios cascade constraints;
drop table t_personas cascade constraints;
drop table t_ciudades cascade constraints;
drop table t_paises cascade constraints;
drop table t_significados cascade constraints;
drop table t_errores cascade constraints;
drop table t_aplicaciones cascade constraints;
drop table t_sistemas cascade constraints;

prompt
prompt Uninstalling sequences...
prompt ---------------------------
prompt
drop sequence s_id_ciudad;
drop sequence s_id_pais;
drop sequence s_id_persona;
drop sequence s_id_rol;
drop sequence s_id_servicio;
drop sequence s_id_sesion;
drop sequence s_id_usuario;

prompt
prompt Purging recyclebin...
prompt ---------------------------
prompt
purge recyclebin;

spool off