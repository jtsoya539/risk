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
prompt Tests installation started
prompt ===================================
prompt

prompt
prompt Creating types tests...
prompt -----------------------------------
prompt
@@types/test_y_dato.pck
@@types/test_y_respuesta.pck

prompt
prompt Creating packages tests...
prompt -----------------------------------
prompt
@@packages/test_k_aplicacion.pck
@@packages/test_k_archivo.pck
@@packages/test_k_auditoria.pck
@@packages/test_k_autenticacion.pck
@@packages/test_k_autorizacion.pck
@@packages/test_k_cadena.pck
@@packages/test_k_clave.pck
@@packages/test_k_dato.pck
@@packages/test_k_dispositivo.pck
@@packages/test_k_dominio.pck
@@packages/test_k_error.pck
@@packages/test_k_html.pck
@@packages/test_k_mensajeria.pck
@@packages/test_k_modulo.pck
@@packages/test_k_operacion.pck
@@packages/test_k_reporte.pck
@@packages/test_k_servicio.pck
@@packages/test_k_sesion.pck
@@packages/test_k_significado.pck
@@packages/test_k_sistema.pck
@@packages/test_k_trabajo.pck
@@packages/test_k_usuario.pck
@@packages/test_k_util.pck

prompt
prompt Creating triggers tests...
prompt -----------------------------------
prompt
@@triggers/test_gb_personas.pck

prompt
prompt ===================================
prompt Tests installation completed
prompt ===================================
prompt

spool off
