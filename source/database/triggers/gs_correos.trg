CREATE OR REPLACE TRIGGER gs_correos
  BEFORE INSERT ON t_correos
  FOR EACH ROW
BEGIN
  IF :new.id_correo IS NULL THEN
    :new.id_correo := s_id_correo.nextval;
  END IF;
END;
/

