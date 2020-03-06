CREATE OR REPLACE TRIGGER gb_sesiones
  BEFORE INSERT OR UPDATE OR DELETE ON t_sesiones
  FOR EACH ROW
BEGIN
  IF inserting OR
     (updating AND nvl(:new.estado, 'X') <> nvl(:old.estado, 'X')) THEN
    :new.fecha_estado := SYSDATE;
  END IF;
END;
/

