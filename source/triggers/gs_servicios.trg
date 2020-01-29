CREATE OR REPLACE TRIGGER gs_servicios
  BEFORE INSERT ON t_servicios
  FOR EACH ROW
BEGIN
  SELECT s_id_servicio.nextval INTO :new.id_servicio FROM dual;
END;
/

