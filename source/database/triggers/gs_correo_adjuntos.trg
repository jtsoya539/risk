CREATE OR REPLACE TRIGGER gs_correo_adjuntos
  BEFORE INSERT ON t_correo_adjuntos
  FOR EACH ROW
BEGIN
  IF :new.id_correo_adjunto IS NULL THEN
    :new.id_correo_adjunto := s_id_correo_adjunto.nextval;
  END IF;
END;
/

