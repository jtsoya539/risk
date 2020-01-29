spool install.log

set feedback off
set define off

prompt
prompt Installing sequences...
prompt ===========================
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
prompt ===========================
prompt
@@tables/t_aplicaciones.tab
@@tables/t_ciudades.tab
@@tables/t_errores.tab
@@tables/t_paises.tab
@@tables/t_parametros.tab
@@tables/t_personas.tab
@@tables/t_roles.tab
@@tables/t_rol_parametros.tab
@@tables/t_rol_usuarios.tab
@@tables/t_servicios.tab
@@tables/t_sesiones.tab
@@tables/t_significados.tab
@@tables/t_sistemas.tab
@@tables/t_usuarios.tab
@@tables/t_usuario_claves.tab

prompt
prompt Installing triggers...
prompt ===========================
prompt
@@triggers/ga_aplicaciones.trg
@@triggers/ga_ciudades.trg
@@triggers/ga_paises.trg
@@triggers/ga_personas.trg
@@triggers/ga_roles.trg
@@triggers/ga_rol_usuarios.trg
@@triggers/ga_servicios.trg
@@triggers/ga_significados.trg
@@triggers/ga_usuarios.trg
@@triggers/gs_ciudades.trg
@@triggers/gs_paises.trg
@@triggers/gs_personas.trg
@@triggers/gs_roles.trg
@@triggers/gs_servicios.trg
@@triggers/gs_sesiones.trg
@@triggers/gs_usuarios.trg

prompt
prompt Installing types...
prompt ===========================
prompt
@@types/y_respuesta.typ

prompt
prompt Installing packages...
prompt ===========================
prompt
@@packages/k_auditoria.pck
@@packages/k_autenticacion.pck
@@packages/k_error.pck
@@packages/k_servicio.pck
@@packages/k_sistema.pck
@@packages/k_util.pck

spool off