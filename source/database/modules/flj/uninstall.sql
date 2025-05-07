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
prompt #            jtsoya539            #
prompt ###################################

prompt
prompt ===================================
prompt Uninstallation started
prompt ===================================
prompt

prompt
prompt Droping packages...
prompt -----------------------------------
prompt
drop package k_flujo;
drop package k_flujo_util;

prompt
prompt Droping views...
prompt -----------------------------------
prompt
drop view v_estado_flujo;
drop view v_historial_instancia;
drop view v_proximos_pasos;
drop view v_usuarios_responsables_paso;
drop view v_roles_responsables_en_progreso;
drop view v_historial_aprobaciones;
drop view v_roles_responsables_paso;
drop view v_pasos_en_progreso;
drop view v_flujo_aprobador;

prompt
prompt Droping tables...
prompt -----------------------------------
prompt
drop table t_flujo_instancia_historial cascade constraints;
drop table t_flujo_instancia_aprobaciones cascade constraints;
drop table t_flujo_instancia_pasos cascade constraints;
drop table t_flujo_instancias cascade constraints;
drop table t_flujo_transiciones cascade constraints;
drop table t_flujo_pasos cascade constraints;
drop table t_flujos cascade constraints;

prompt
prompt Purging recycle bin...
prompt -----------------------------------
prompt
purge recyclebin;

prompt
prompt Running scripts...
prompt -----------------------------------
prompt
--@@../../packages/k_modulo.pck
@@../../compile_schema.sql
@@scripts/del_t_parametros.sql
@@scripts/del_t_significados.sql
@@scripts/del_t_significado_dominios.sql
@@scripts/del_t_dominios.sql
@@scripts/del_t_modulos.sql
commit;
/

prompt
prompt ===================================
prompt Uninstallation completed
prompt ===================================
prompt

spool off
