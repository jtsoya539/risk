CREATE OR REPLACE TRIGGER gb_flujo_instancia_pasos
  BEFORE INSERT OR UPDATE ON t_flujo_instancia_pasos
  FOR EACH ROW
DECLARE
  l_nombre_paso t_flujo_pasos.nombre%TYPE;
BEGIN
  -- Obtener el nombre del paso de la instancia
  BEGIN
    SELECT nombre
      INTO l_nombre_paso
      FROM t_flujo_pasos a
     WHERE a.id_paso = :new.id_paso;
  END;

  -- Validar roles responsables
  DECLARE
    l_rol_json_arr json_array_t;
    l_nombre_rol   t_roles.nombre%TYPE;
    l_cantidad     PLS_INTEGER;
  BEGIN
    IF :new.roles_responsables IS NULL THEN
      RETURN;
    END IF;
  
    -- Validar que es un array válido
    l_rol_json_arr := json_array_t.parse(:new.roles_responsables);
  
    FOR i IN 0 .. l_rol_json_arr.get_size - 1 LOOP
      l_nombre_rol := l_rol_json_arr.get_string(i);
    
      -- Verificar si existe el rol
      SELECT COUNT(*)
        INTO l_cantidad
        FROM t_roles a
       WHERE a.nombre = l_nombre_rol;
    
      IF l_cantidad = 0 THEN
        raise_application_error(-20001,
                                'Rol [' || l_nombre_rol ||
                                '] inválido como responsables para el siguiente paso [' ||
                                l_nombre_paso || ']');
      END IF;
    END LOOP;
  END;

  -- Validar usuarios responsables
  DECLARE
    l_usu_json_arr  json_array_t;
    l_alias_usuario t_usuarios.alias%TYPE;
    l_cantidad      PLS_INTEGER;
  BEGIN
    IF :new.usuarios_responsables IS NULL THEN
      RETURN;
    END IF;
  
    -- Validar que es un array válido
    l_usu_json_arr := json_array_t.parse(:new.usuarios_responsables);
  
    FOR i IN 0 .. l_usu_json_arr.get_size - 1 LOOP
      l_alias_usuario := l_usu_json_arr.get_string(i);
    
      -- Verificar si existe el usuario
      SELECT COUNT(*)
        INTO l_cantidad
        FROM t_usuarios a
       WHERE a.alias = l_alias_usuario
         AND a.estado = 'A'; --Activo
    
      IF l_cantidad = 0 THEN
        raise_application_error(-20001,
                                'Usuario [' || l_alias_usuario ||
                                '] inválido como responsables para el siguiente paso [' ||
                                l_nombre_paso || ']');
      END IF;
    END LOOP;
  END;

END;
/
