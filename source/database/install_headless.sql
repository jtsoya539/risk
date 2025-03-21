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

spool install_headless.log

set define on

--accept v_app_name char default 'risk' prompt 'Enter app name (default ''risk''):'
--accept v_password char default 'risk' prompt 'Enter password (default ''risk''):' hide
DEFINE v_app_name = '&1'
DEFINE v_password = '&2'

DEFINE v_data_user = '&v_app_name._data'
DEFINE v_util_user = '&v_app_name._util'
DEFINE v_code_user = '&v_app_name.'
DEFINE v_access_user = '&v_app_name._access'

-- Create users
@@create_data_user.sql &v_data_user &v_password
@@create_code_user.sql &v_util_user &v_password
@@create_code_user.sql &v_code_user &v_password
@@create_access_user.sql &v_access_user &v_password

-- Install dependencies
exec execute immediate 'ALTER SESSION SET CURRENT_SCHEMA=&v_util_user'
@@install_dependencies.sql
set define on
-- Grant object privileges to code user
GRANT EXECUTE ON &v_util_user..as_crypto TO &v_code_user;
GRANT EXECUTE ON &v_util_user..as_pdf TO &v_code_user;
GRANT EXECUTE ON &v_util_user..as_xlsx TO &v_code_user;
GRANT EXECUTE ON &v_util_user..as_zip TO &v_code_user;
GRANT EXECUTE ON &v_util_user..csv TO &v_code_user;
GRANT EXECUTE ON &v_util_user..oos_util_totp TO &v_code_user;
GRANT EXECUTE ON &v_util_user..zt_qr TO &v_code_user;
GRANT EXECUTE ON &v_util_user..zt_word TO &v_code_user;
GRANT EXECUTE ON &v_util_user..fn_gen_inserts TO &v_code_user;
GRANT EXECUTE ON &v_util_user..console TO &v_code_user;
GRANT SELECT ON &v_util_user..console_conf TO &v_code_user;
GRANT SELECT ON &v_util_user..console_logs TO &v_code_user;
GRANT EXECUTE ON &v_util_user..om_tapigen TO &v_code_user;
GRANT EXECUTE ON &v_util_user..plex TO &v_code_user;
CREATE OR REPLACE SYNONYM &v_code_user..as_crypto FOR &v_util_user..as_crypto;
CREATE OR REPLACE SYNONYM &v_code_user..as_pdf FOR &v_util_user..as_pdf;
CREATE OR REPLACE SYNONYM &v_code_user..as_xlsx FOR &v_util_user..as_xlsx;
CREATE OR REPLACE SYNONYM &v_code_user..as_zip FOR &v_util_user..as_zip;
CREATE OR REPLACE SYNONYM &v_code_user..csv FOR &v_util_user..csv;
CREATE OR REPLACE SYNONYM &v_code_user..oos_util_totp FOR &v_util_user..oos_util_totp;
CREATE OR REPLACE SYNONYM &v_code_user..zt_qr FOR &v_util_user..zt_qr;
CREATE OR REPLACE SYNONYM &v_code_user..zt_word FOR &v_util_user..zt_word;
CREATE OR REPLACE SYNONYM &v_code_user..fn_gen_inserts FOR &v_util_user..fn_gen_inserts;
CREATE OR REPLACE SYNONYM &v_code_user..console FOR &v_util_user..console;
CREATE OR REPLACE SYNONYM &v_code_user..console_conf FOR &v_util_user..console_conf;
CREATE OR REPLACE SYNONYM &v_code_user..console_logs FOR &v_util_user..console_logs;
CREATE OR REPLACE SYNONYM &v_code_user..om_tapigen FOR &v_util_user..om_tapigen;
CREATE OR REPLACE SYNONYM &v_code_user..plex FOR &v_util_user..plex;
--

-- Install source
exec execute immediate 'ALTER SESSION SET CURRENT_SCHEMA=&v_code_user'
@@install.sql
set define on
-- Grant object privileges to access user
GRANT EXECUTE ON &v_code_user..k_servicio TO &v_access_user;
GRANT EXECUTE ON &v_code_user..k_reporte TO &v_access_user;
CREATE OR REPLACE SYNONYM &v_access_user..k_servicio FOR &v_code_user..k_servicio;
CREATE OR REPLACE SYNONYM &v_access_user..k_reporte FOR &v_code_user..k_reporte;
--

spool off
