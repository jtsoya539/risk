CREATE OR REPLACE TRIGGER gs_personas
  BEFORE INSERT ON t_personas
  FOR EACH ROW
BEGIN
  IF :new.id_persona IS NULL THEN
    :new.id_persona := s_id_persona.nextval;
  END IF;
END;
/

