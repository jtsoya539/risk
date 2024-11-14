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
prompt Tests execution started
prompt ===================================
prompt

prompt
prompt Running types tests...
prompt -----------------------------------
prompt
RunTestSet C:\repo\risk\test\database\types\y_respuesta\y_respuesta.ts

prompt
prompt Running packages tests...
prompt -----------------------------------
prompt
RunTestSet C:\repo\risk\test\database\packages\k_cadena\k_cadena.ts
RunTestSet C:\repo\risk\test\database\packages\k_dato\k_dato.ts
RunTestSet C:\repo\risk\test\database\packages\k_error\k_error.ts
RunTestSet C:\repo\risk\test\database\packages\k_html\k_html.ts
RunTestSet C:\repo\risk\test\database\packages\k_operacion\k_operacion.ts
RunTestSet C:\repo\risk\test\database\packages\k_servicio\k_servicio.ts
RunTestSet C:\repo\risk\test\database\packages\k_sistema\k_sistema.ts
RunTestSet C:\repo\risk\test\database\packages\k_util\k_util.ts

prompt
prompt Running triggers tests...
prompt -----------------------------------
prompt
RunTestSet C:\repo\risk\test\database\triggers\gb_personas\gb_personas.ts

rollback;
/

prompt
prompt ===================================
prompt Tests execution completed
prompt ===================================
prompt
