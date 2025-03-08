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

set define on

--accept v_user     char default 'risk_code' prompt 'Enter user (default ''risk_code''):'
--accept v_password char default 'risk' prompt 'Enter password (default ''risk''):' hide
DEFINE v_user = '&1'
DEFINE v_password = '&2'

-- Create user
CREATE USER &v_user IDENTIFIED BY &v_password;
-- Grant system privileges
GRANT CREATE SESSION TO &v_user;
--
GRANT CREATE DATABASE LINK TO &v_user;
GRANT CREATE JOB TO &v_user;
GRANT CREATE MATERIALIZED VIEW TO &v_user;
GRANT CREATE PROCEDURE TO &v_user;
GRANT CREATE SEQUENCE TO &v_user;
GRANT CREATE SYNONYM TO &v_user;
GRANT CREATE TABLE TO &v_user;
GRANT CREATE TRIGGER TO &v_user;
GRANT CREATE TYPE TO &v_user;
GRANT CREATE VIEW TO &v_user;
GRANT UNLIMITED TABLESPACE TO &v_user;

set define off
