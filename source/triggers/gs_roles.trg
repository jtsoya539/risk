CREATE OR REPLACE TRIGGER gs_roles
  BEFORE INSERT ON t_roles
  FOR EACH ROW
BEGIN
  SELECT s_id_rol.nextval INTO :new.id_rol FROM dual;
END;
/

