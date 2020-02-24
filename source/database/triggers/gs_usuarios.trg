CREATE OR REPLACE TRIGGER gs_usuarios
  BEFORE INSERT ON t_usuarios
  FOR EACH ROW
BEGIN
  IF :new.id_usuario IS NULL THEN
    :new.id_usuario := s_id_usuario.nextval;
  END IF;
END;
/

