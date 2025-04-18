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

spool install_dependencies.log

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
prompt Installing dependencies...
prompt -----------------------------------
prompt
@@dependencies/as_crypto.sql
@@dependencies/as_pdf.pks
@@dependencies/as_pdf.pkb
@@dependencies/as_xlsx.pks
@@dependencies/as_xlsx.pkb
@@dependencies/as_zip.pks
@@dependencies/as_zip.pkb
@@dependencies/csv.sql
@@dependencies/oos_util_totp.pks
@@dependencies/oos_util_totp.pkb
@@dependencies/ZT_QR.pks
@@dependencies/ZT_QR.pkb
@@dependencies/ZT_WORD.pks
@@dependencies/ZT_WORD.pkb
@@dependencies/fn_gen_inserts.sql
@@dependencies/create_console_objects.sql
@@dependencies/om_tapigen_install.sql
@@dependencies/plex_install.sql

prompt
prompt ===================================
prompt Installation completed
prompt ===================================
prompt

spool off
