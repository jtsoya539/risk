CREATE OR REPLACE TRIGGER gs_ciudades
  BEFORE INSERT ON t_ciudades
  FOR EACH ROW
BEGIN
  SELECT s_id_ciudad.nextval INTO :new.id_ciudad FROM dual;
END;
/

