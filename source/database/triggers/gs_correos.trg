CREATE OR REPLACE TRIGGER gs_correos
  BEFORE INSERT ON t_correos
  FOR EACH ROW
BEGIN
  SELECT s_id_correo.nextval INTO :new.id_correo FROM dual;
END;
/

