CREATE OR REPLACE TRIGGER gs_ciudades
  BEFORE INSERT ON t_ciudades
  FOR EACH ROW
BEGIN
  IF :new.id_ciudad IS NULL THEN
    :new.id_ciudad := s_id_ciudad.nextval;
  END IF;
END;
/

