CREATE OR REPLACE TRIGGER gs_paises
  BEFORE INSERT ON t_paises
  FOR EACH ROW
BEGIN
  IF :new.id_pais IS NULL THEN
    :new.id_pais := s_id_pais.nextval;
  END IF;
END;
/

