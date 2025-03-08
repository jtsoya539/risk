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
DEFINE v_code_user = '&v_app_name._code'
DEFINE v_access_user = '&v_app_name._access'

-- Create users
@@create_data_user.sql &v_data_user &v_password
set define on
@@create_code_user.sql &v_code_user &v_password
set define on
@@create_access_user.sql &v_access_user &v_password
set define on

-- Install source
exec execute immediate 'ALTER SESSION SET CURRENT_SCHEMA=&v_code_user'
@@install.sql

set define off

spool off
