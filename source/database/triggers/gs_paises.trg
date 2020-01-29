CREATE OR REPLACE TRIGGER gs_paises
  BEFORE INSERT ON t_paises
  FOR EACH ROW
BEGIN
  SELECT s_id_pais.nextval INTO :new.id_pais FROM dual;
END;
/

