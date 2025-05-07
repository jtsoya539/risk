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
prompt Creating tables...
prompt -----------------------------------
prompt
@@tables/t_flujos.tab
@@tables/t_flujo_pasos.tab
@@tables/t_flujo_transiciones.tab
@@tables/t_flujo_instancias.tab
@@tables/t_flujo_instancia_pasos.tab
@@tables/t_flujo_instancia_aprobaciones.tab
@@tables/t_flujo_instancia_historial.tab

prompt
prompt Creating views...
prompt -----------------------------------
prompt
@@views/v_flujo_aprobador.vw
@@views/v_pasos_en_progreso.vw
@@views/v_roles_responsables_paso.vw
@@views/v_historial_aprobaciones.vw
@@views/v_roles_responsables_en_progreso.vw
@@views/v_usuarios_responsables_paso.vw
@@views/v_proximos_pasos.vw
@@views/v_historial_instancia.vw
@@views/v_estado_flujo.vw

prompt
prompt Creating packages...
prompt -----------------------------------
prompt
@@packages/k_flujo_util.pck
@@packages/k_flujo.pck

prompt
prompt Creating triggers...
prompt -----------------------------------
prompt
@@triggers/gb_roles.trg
@@triggers/gb_flujo_instancia_pasos.trg

prompt
prompt Running scripts...
prompt -----------------------------------
prompt
--@@packages/k_modulo.pck
@@../../compile_schema.sql
@@scripts/ins_t_modulos.sql
@@scripts/ins_t_dominios.sql
@@scripts/ins_t_flujos.sql
@@scripts/ins_t_flujo_pasos.sql
@@scripts/ins_t_flujo_transiciones.sql
commit;
/

prompt
prompt ===================================
prompt Installation completed
prompt ===================================
prompt

spool off
