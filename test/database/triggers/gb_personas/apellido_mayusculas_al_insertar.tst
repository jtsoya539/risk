PL/SQL Developer Test script 3.0
19
DECLARE
  l_id_persona t_personas.id_persona%TYPE;
  l_apellido   t_personas.apellido%TYPE;
BEGIN
  -- Arrange
  SELECT MAX(id_persona) + 1 INTO l_id_persona FROM t_personas;
  -- Act
  INSERT INTO t_personas
    (id_persona, apellido)
  VALUES
    (l_id_persona, 'Doe')
  RETURNING apellido INTO l_apellido;
  -- Assert
  IF l_apellido = 'DOE' THEN
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
