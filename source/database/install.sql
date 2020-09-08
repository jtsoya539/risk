/*
--------------------------------- MIT License ---------------------------------
Copyright (c) 2019 jtsoya539

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-------------------------------------------------------------------------------
*/

spool install.log

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
prompt Instalacion iniciada
prompt ===================================
prompt

prompt
prompt Instalando dependencias...
prompt -----------------------------------
prompt
@@install_dependencies.sql

prompt
prompt Creando secuencias...
prompt -----------------------------------
prompt
@@sequences/s_id_pais.seq
@@sequences/s_id_departamento.seq
@@sequences/s_id_ciudad.seq
@@sequences/s_id_barrio.seq
@@sequences/s_id_persona.seq
@@sequences/s_id_rol.seq
@@sequences/s_id_operacion.seq
@@sequences/s_id_servicio.seq
@@sequences/s_id_servicio_log.seq
@@sequences/s_id_trabajo.seq
@@sequences/s_id_sesion.seq
@@sequences/s_id_usuario.seq
@@sequences/s_id_dispositivo.seq
@@sequences/s_id_correo.seq
@@sequences/s_id_correo_adjunto.seq
@@sequences/s_id_mensaje.seq
@@sequences/s_id_notificacion.seq

prompt
prompt Creando tablas...
prompt -----------------------------------
prompt
@@tables/t_sistemas.tab
@@tables/t_aplicaciones.tab
@@tables/t_errores.tab
@@tables/t_significados.tab
@@tables/t_paises.tab
@@tables/t_departamentos.tab
@@tables/t_ciudades.tab
@@tables/t_barrios.tab
@@tables/t_personas.tab
@@tables/t_usuarios.tab
@@tables/t_roles.tab
@@tables/t_parametros.tab
@@tables/t_rol_parametros.tab
@@tables/t_permisos.tab
@@tables/t_rol_permisos.tab
@@tables/t_rol_usuarios.tab
@@tables/t_operaciones.tab
@@tables/t_operacion_parametros.tab
@@tables/t_servicios.tab
@@tables/t_servicio_logs.tab
@@tables/t_trabajos.tab
@@tables/t_dispositivos.tab
@@tables/t_dispositivo_suscripciones.tab
@@tables/t_dispositivo_ubicaciones.tab
@@tables/t_sesiones.tab
@@tables/t_usuario_claves.tab
@@tables/t_correos.tab
@@tables/t_correo_adjuntos.tab
@@tables/t_mensajes.tab
@@tables/t_notificaciones.tab
@@tables/t_dato_definiciones.tab
@@tables/t_datos.tab
@@tables/t_archivo_definiciones.tab
@@tables/t_archivos.tab

prompt
prompt Creando vistas...
prompt -----------------------------------
prompt

prompt
prompt Creando types...
prompt -----------------------------------
prompt
@@types/y_objeto.typ
@@types/y_objetos.typ
@@types/y_dato.typ
@@types/y_archivo.typ
@@types/y_parametro.typ
@@types/y_parametros.typ
@@types/y_respuesta.typ
@@types/y_rol.typ
@@types/y_usuario.typ
@@types/y_sesion.typ
@@types/y_dispositivo.typ
@@types/y_pagina.typ
@@types/y_pagina_parametros.typ
@@types/y_significado.typ
@@types/y_pais.typ
@@types/y_departamento.typ
@@types/y_ciudad.typ
@@types/y_barrio.typ
@@types/y_correo.typ
@@types/y_mensaje.typ
@@types/y_notificacion.typ

prompt
prompt Creando paquetes...
prompt -----------------------------------
prompt
@@packages/k_util.pck
@@packages/k_sistema.pck
@@packages/k_html.pck
@@packages/k_auditoria.pck
@@packages/k_aplicacion.pck
@@packages/k_usuario.pck
@@packages/k_dispositivo.pck
@@packages/k_sesion.pck
@@packages/k_autenticacion.pck
@@packages/k_error.pck
@@packages/k_dato.pck
@@packages/k_archivo.pck
@@packages/k_mensajeria.pck
@@packages/k_operacion.pck
@@packages/k_servicio.pck
@@packages/k_servicio_aut.pck
@@packages/k_servicio_gen.pck
@@packages/k_servicio_msj.pck
@@packages/k_planificador.pck
@@packages/k_reporte.pck
@@packages/k_reporte_gen.pck

prompt
prompt Creando triggers...
prompt -----------------------------------
prompt
@@triggers/gs_paises.trg
@@triggers/gs_departamentos.trg
@@triggers/gs_ciudades.trg
@@triggers/gs_barrios.trg
@@triggers/gs_personas.trg
@@triggers/gs_roles.trg
@@triggers/gs_operaciones.trg
@@triggers/gs_servicios.trg
@@triggers/gs_servicio_logs.trg
@@triggers/gs_trabajos.trg
@@triggers/gs_sesiones.trg
@@triggers/gs_usuarios.trg
@@triggers/gs_dispositivos.trg
@@triggers/gs_correos.trg
@@triggers/gs_correo_adjuntos.trg
@@triggers/gs_mensajes.trg
@@triggers/gs_notificaciones.trg
@@triggers/gb_usuarios.trg
@@triggers/gb_sesiones.trg
@@triggers/gb_personas.trg
@@triggers/gb_datos.trg
@@triggers/gb_archivos.trg
@@triggers/gb_mensajes.trg

prompt
prompt Ejecutando scripts...
prompt -----------------------------------
prompt
@@install_audit.sql
@@compile_schema.sql
@@scripts/ins_t_sistemas.sql
@@scripts/ins_t_aplicaciones.sql
@@scripts/ins_t_significados.sql
@@scripts/ins_t_errores.sql
@@scripts/ins_t_parametros.sql
@@scripts/ins_t_operaciones.sql
@@scripts/ins_t_operacion_parametros.sql
@@scripts/ins_t_servicios.sql
@@scripts/ins_t_roles.sql
@@scripts/ins_t_paises.sql
@@scripts/ins_t_departamentos.sql
@@scripts/ins_t_archivo_definiciones.sql
@@scripts/ins_t_personas.sql
@@scripts/ins_t_usuarios.sql
@@scripts/ins_t_usuario_claves.sql
@@scripts/ins_t_rol_usuarios.sql
commit;
/

prompt
prompt ===================================
prompt Instalacion finalizada
prompt ===================================
prompt

spool off
