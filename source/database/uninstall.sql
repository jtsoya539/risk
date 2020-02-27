spool uninstall.log

set feedback off
set define off

prompt ###################################
prompt #   _____   _____   _____  _  __  #
prompt #  |  __ \ |_   _| / ____|| |/ /  #
prompt #  | |__) |  | |  | (___  | ' /   #
prompt #  |  _  /   | |   \___ \ |  <    #
prompt #  | | \ \  _| |_  ____) || . \   #
prompt #  |_|  \_\|_____||_____/ |_|\_\  #
prompt #                                 #
prompt #          Proyecto RISK          #
prompt #            jtsoya539            #
prompt ###################################

prompt
prompt ===================================
prompt Desinstalacion iniciada
prompt ===================================
prompt

prompt
prompt Borrando paquetes...
prompt -----------------------------------
prompt
drop package k_mensajeria;
drop package k_servicio;
drop package k_error;
drop package k_autenticacion;
drop package k_auditoria;
drop package k_util;
drop package k_html;
drop package k_sistema;

prompt
prompt Borrando types...
prompt -----------------------------------
prompt
drop type y_respuesta force;
drop type y_parametros force;
drop type y_parametro force;
drop type y_dato force;

prompt
prompt Borrando tablas...
prompt -----------------------------------
prompt
drop table t_mensajes cascade constraints;
drop table t_correo_adjuntos cascade constraints;
drop table t_correos cascade constraints;
drop table t_usuario_claves cascade constraints;
drop table t_sesiones cascade constraints;
drop table t_servicio_parametros cascade constraints;
drop table t_servicios cascade constraints;
drop table t_rol_usuarios cascade constraints;
drop table t_rol_permisos cascade constraints;
drop table t_permisos cascade constraints;
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
prompt Borrando secuencias...
prompt -----------------------------------
prompt
drop sequence s_id_ciudad;
drop sequence s_id_pais;
drop sequence s_id_persona;
drop sequence s_id_rol;
drop sequence s_id_servicio;
drop sequence s_id_sesion;
drop sequence s_id_usuario;
drop sequence s_id_correo;
drop sequence s_id_correo_adjunto;
drop sequence s_id_mensaje;

prompt
prompt Borrando logs...
prompt -----------------------------------
prompt
exec plog.purge;

prompt
prompt Vaciando papelera de reciclaje...
prompt -----------------------------------
prompt
purge recyclebin;

prompt
prompt ===================================
prompt Desinstalacion finalizada
prompt ===================================
prompt

spool off
