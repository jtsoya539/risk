CREATE OR REPLACE TRIGGER gs_servicios
  BEFORE INSERT ON t_servicios
  FOR EACH ROW
BEGIN
  IF :new.id_servicio IS NULL THEN
    :new.id_servicio := s_id_servicio.nextval;
  END IF;
END;
/

