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
prompt Desinstalacion de tests iniciada
prompt ===================================
prompt

prompt
prompt Borrando tests de triggers...
prompt -----------------------------------
prompt
drop package test_gb_personas;

prompt
prompt Borrando tests de paquetes...
prompt -----------------------------------
prompt
drop package test_k_aplicacion;
drop package test_k_archivo;
drop package test_k_auditoria;
drop package test_k_autenticacion;
drop package test_k_autorizacion;
drop package test_k_dato;
drop package test_k_dispositivo;
drop package test_k_error;
drop package test_k_mensajeria;
drop package test_k_operacion;
drop package test_k_reporte;
drop package test_k_servicio;
drop package test_k_sesion;
drop package test_k_sistema;
drop package test_k_trabajo;
drop package test_k_usuario;
drop package test_k_util;

prompt
prompt Borrando tests de types...
prompt -----------------------------------
prompt
drop package test_y_dato;
drop package test_y_respuesta;

prompt
prompt Vaciando papelera de reciclaje...
prompt -----------------------------------
prompt
purge recyclebin;

prompt
prompt ===================================
prompt Desinstalacion de tests finalizada
prompt ===================================
prompt

spool off
