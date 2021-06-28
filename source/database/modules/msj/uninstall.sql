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
drop package k_servicio_msj;
drop package k_mensajeria;

prompt
prompt Borrando types...
prompt -----------------------------------
prompt
drop type y_notificacion force;
drop type y_mensaje force;
drop type y_correo force;

prompt
prompt Borrando vistas...
prompt -----------------------------------
prompt

prompt
prompt Borrando tablas...
prompt -----------------------------------
prompt
drop table t_notificacion_plantillas cascade constraints;
drop table t_notificaciones cascade constraints;
drop table t_mensajes cascade constraints;
drop table t_correo_adjuntos cascade constraints;
drop table t_correos cascade constraints;

prompt
prompt Borrando secuencias...
prompt -----------------------------------
prompt
drop sequence s_id_correo;
drop sequence s_id_correo_adjunto;
drop sequence s_id_mensaje;
drop sequence s_id_notificacion;

prompt
prompt Desinstalando dependencias...
prompt -----------------------------------
prompt
@@uninstall_dependencies.sql

prompt
prompt Vaciando papelera de reciclaje...
prompt -----------------------------------
prompt
purge recyclebin;

prompt
prompt Ejecutando scripts...
prompt -----------------------------------
prompt
@@../../packages/k_modulo.pck
@@../../compile_schema.sql
@@scripts/del_t_modulos.sql
@@scripts/operations/uninstall.sql
commit;
/

prompt
prompt ===================================
prompt Desinstalacion finalizada
prompt ===================================
prompt

spool off
