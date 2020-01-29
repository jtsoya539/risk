CREATE OR REPLACE TRIGGER gs_sesiones
  BEFORE INSERT ON t_sesiones
  FOR EACH ROW
BEGIN
  SELECT s_id_sesion.nextval INTO :new.id_sesion FROM dual;
END;
/

