CREATE OR REPLACE TRIGGER gs_mensajes
  BEFORE INSERT ON t_mensajes
  FOR EACH ROW
BEGIN
  SELECT s_id_mensaje.nextval INTO :new.id_mensaje FROM dual;
END;
/

