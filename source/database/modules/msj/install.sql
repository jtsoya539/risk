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
prompt #            jtsoya539            #
prompt ###################################

prompt
prompt ===================================
prompt Installation started
prompt ===================================
prompt

prompt
prompt Creating sequences...
prompt -----------------------------------
prompt
@@sequences/s_id_correo.seq
@@sequences/s_id_correo_adjunto.seq
@@sequences/s_id_mensaje.seq
@@sequences/s_id_notificacion.seq

prompt
prompt Creating tables...
prompt -----------------------------------
prompt
@@tables/t_correos.tab
@@tables/t_correo_adjuntos.tab
@@tables/t_mensajes.tab
@@tables/t_notificaciones.tab
@@tables/t_notificacion_plantillas.tab
@@tables/t_dispositivo_suscripciones.tab
@@tables/t_usuario_suscripciones.tab

prompt
prompt Creating views...
prompt -----------------------------------
prompt

prompt
prompt Creating types...
prompt -----------------------------------
prompt
@@types/y_correo.typ
@@types/y_mensaje.typ
@@types/y_notificacion.typ

prompt
prompt Creating packages...
prompt -----------------------------------
prompt
@@packages/k_mensajeria.pck
@@packages/k_servicio_msj.pck

prompt
prompt Creating triggers...
prompt -----------------------------------
prompt
@@triggers/gs_correos.trg
@@triggers/gs_correo_adjuntos.trg
@@triggers/gs_mensajes.trg
@@triggers/gs_notificaciones.trg
@@triggers/gb_mensajes.trg

prompt
prompt Running scripts...
prompt -----------------------------------
prompt
@@packages/k_modulo.pck
@@../../compile_schema.sql
@@scripts/ins_t_modulos.sql
@@scripts/ins_t_dominios.sql
@@scripts/ins_t_significado_dominios.sql
@@scripts/ins_t_significados.sql
@@scripts/ins_t_parametros.sql
@@scripts/ins_t_notificacion_plantillas.sql
@@scripts/ins_t_aplicaciones.sql
@@scripts/ins_t_archivo_definiciones.sql
@@scripts/operations/install.sql
commit;
/

prompt
prompt ===================================
prompt Installation completed
prompt ===================================
prompt

spool off
