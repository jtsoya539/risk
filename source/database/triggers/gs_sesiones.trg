CREATE OR REPLACE TRIGGER gs_sesiones
  BEFORE INSERT ON t_sesiones
  FOR EACH ROW
BEGIN
  IF :new.id_sesion IS NULL THEN
    :new.id_sesion := s_id_sesion.nextval;
  END IF;
END;
/

