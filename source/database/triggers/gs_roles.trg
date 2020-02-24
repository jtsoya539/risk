CREATE OR REPLACE TRIGGER gs_roles
  BEFORE INSERT ON t_roles
  FOR EACH ROW
BEGIN
  IF :new.id_rol IS NULL THEN
    :new.id_rol := s_id_rol.nextval;
  END IF;
END;
/

