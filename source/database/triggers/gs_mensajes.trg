CREATE OR REPLACE TRIGGER gs_mensajes
  BEFORE INSERT ON t_mensajes
  FOR EACH ROW
BEGIN
  IF :new.id_mensaje IS NULL THEN
    :new.id_mensaje := s_id_mensaje.nextval;
  END IF;
END;
/

