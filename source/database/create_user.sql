set define on

accept v_user     char default 'risk' prompt 'Ingrese usuario (por defecto ''risk''):'
accept v_password char default 'risk' prompt 'Ingrese clave (por defecto ''risk''):' hide

-- Create user
CREATE USER &v_user IDENTIFIED BY &v_password;
-- Grant system privileges
GRANT CREATE SESSION, ALTER SESSION, CREATE DATABASE LINK, CREATE MATERIALIZED VIEW, CREATE PROCEDURE, CREATE PUBLIC SYNONYM, CREATE ROLE, CREATE SEQUENCE, CREATE SYNONYM, CREATE TABLE, CREATE TRIGGER, CREATE TYPE, CREATE VIEW, UNLIMITED TABLESPACE TO &v_user;
GRANT DEBUG CONNECT SESSION TO &v_user;
-- Grant object privileges
GRANT SELECT  ON sys.v_$session  TO &v_user;
GRANT SELECT  ON sys.v_$sesstat  TO &v_user;
GRANT SELECT  ON sys.v_$statname TO &v_user;
GRANT EXECUTE ON sys.dbms_crypto TO &v_user;

set define off
