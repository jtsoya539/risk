set define on
set serveroutput on size unlimited

accept v_user     char default 'risk' prompt 'Ingrese usuario (por defecto ''risk''):'
accept v_password char default 'risk' prompt 'Ingrese clave (por defecto ''risk''):' hide

--
BEGIN
  dbms_output.put_line('usuario: &v_user');
  dbms_output.put_line('clave: &v_password');
END;
/
/*
CREATE USER &V_USER
IDENTIFIED BY &V_PASSWORD;
 
GRANT CONNECT TO &V_USER;

GRANT CREATE TABLE TO &V_USER;

GRANT CREATE VIEW TO &V_USER;

GRANT CREATE TYPE TO &V_USER;

GRANT CREATE PROCEDURE TO &V_USER;

GRANT CREATE SEQUENCE TO &V_USER;

-- set tablespace quota for the user
ALTER USER &V_USER QUOTA 100M ON USERS;
*/
--

set serveroutput off
set define off
