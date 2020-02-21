CREATE OR REPLACE TRIGGER gs_correo_adjuntos
  BEFORE INSERT ON t_correo_adjuntos
  FOR EACH ROW
BEGIN
  SELECT s_id_correo_adjunto.nextval INTO :new.id_correo_adjunto FROM dual;
END;
/

