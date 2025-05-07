CREATE OR REPLACE TRIGGER gb_roles
  BEFORE DELETE OR UPDATE ON t_roles
  FOR EACH ROW
DECLARE
  l_en_uso NUMBER;
BEGIN
  SELECT COUNT(*)
    INTO l_en_uso
    FROM t_flujo_instancia_pasos s,
         json_table(s.roles_responsables,
                    '$[*]' columns(val VARCHAR2(100) path '$')) j
   WHERE ((j.val = :old.id_rol AND :old.id_rol IS NOT NULL AND
         :new.id_rol IS NULL) /*eliminado*/
         OR (j.val = :old.id_rol AND :old.id_rol IS NOT NULL AND
         nvl(:old.id_rol, 'X') <> nvl(:new.id_rol, 'X') /*modificado*/
         ))
     AND s.estado = k_flujo.c_estado_en_progreso;

  IF l_en_uso > 0 THEN
    raise_application_error(-20002,
                            'No se puede eliminar o modificar el rol [' ||
                            :old.id_rol ||
                            '] porque está en uso en instancias activas del motor de flujos.');
  END IF;
END;
/
