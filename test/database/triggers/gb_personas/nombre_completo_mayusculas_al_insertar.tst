PL/SQL Developer Test script 3.0
19
DECLARE
  l_id_persona      t_personas.id_persona%TYPE;
  l_nombre_completo t_personas.nombre_completo%TYPE;
BEGIN
  -- Arrange
  SELECT MAX(id_persona) + 1 INTO l_id_persona FROM t_personas;
  -- Act
  INSERT INTO t_personas
    (id_persona, nombre_completo)
  VALUES
    (l_id_persona, 'John Doe')
  RETURNING nombre_completo INTO l_nombre_completo;
  -- Assert
  IF l_nombre_completo = 'JOHN DOE' THEN
    :RESULT := 'OK';
  END IF;

  ROLLBACK;
END;
1
result
1
OK
5
0
