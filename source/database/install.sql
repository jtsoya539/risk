spool install.log

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
prompt Installing Risk Project
prompt ===========================
prompt

prompt
prompt Installing sequences...
prompt ---------------------------
prompt
@@sequences/s_id_ciudad.seq
@@sequences/s_id_pais.seq
@@sequences/s_id_persona.seq
@@sequences/s_id_rol.seq
@@sequences/s_id_servicio.seq
@@sequences/s_id_sesion.seq
@@sequences/s_id_usuario.seq

prompt
prompt Installing tables...
prompt ---------------------------
prompt
@@tables/t_sistemas.tab
@@tables/t_aplicaciones.tab
@@tables/t_errores.tab
@@tables/t_significados.tab
@@tables/t_paises.tab
@@tables/t_ciudades.tab
@@tables/t_personas.tab
@@tables/t_usuarios.tab
@@tables/t_roles.tab
@@tables/t_parametros.tab
@@tables/t_rol_parametros.tab
@@tables/t_rol_usuarios.tab
@@tables/t_servicios.tab
@@tables/t_sesiones.tab
@@tables/t_usuario_claves.tab

prompt
prompt Installing triggers...
prompt ---------------------------
prompt
@@triggers/gs_ciudades.trg
@@triggers/gs_paises.trg
@@triggers/gs_personas.trg
@@triggers/gs_roles.trg
@@triggers/gs_servicios.trg
@@triggers/gs_sesiones.trg
@@triggers/gs_usuarios.trg

prompt
prompt Installing types...
prompt ---------------------------
prompt
@@types/y_respuesta.typ

prompt
prompt Installing packages...
prompt ---------------------------
prompt
@@packages/k_sistema.pck
@@packages/k_util.pck
@@packages/k_auditoria.pck
@@packages/k_autenticacion.pck
@@packages/k_error.pck
@@packages/k_servicio.pck

prompt
prompt Running scripts...
prompt ---------------------------
prompt
@@install_audit.sql
@@scripts/ins_t_sistemas.sql
@@scripts/ins_t_significados.sql

spool off
