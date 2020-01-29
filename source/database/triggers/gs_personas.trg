CREATE OR REPLACE TRIGGER gs_personas
  BEFORE INSERT ON t_personas
  FOR EACH ROW
BEGIN
  SELECT s_id_persona.nextval INTO :new.id_persona FROM dual;
END;
/

