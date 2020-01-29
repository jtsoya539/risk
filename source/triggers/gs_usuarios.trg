CREATE OR REPLACE TRIGGER gs_usuarios
  BEFORE INSERT ON t_usuarios
  FOR EACH ROW
BEGIN
  SELECT s_id_usuario.nextval INTO :new.id_usuario FROM dual;
END;
/

