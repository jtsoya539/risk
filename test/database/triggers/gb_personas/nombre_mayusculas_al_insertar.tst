PL/SQL Developer Test script 3.0
19
DECLARE
  l_id_persona t_personas.id_persona%TYPE;
  l_nombre     t_personas.nombre%TYPE;
BEGIN
  -- Arrange
  SELECT MAX(id_persona) + 1 INTO l_id_persona FROM t_personas;
  -- Act
  INSERT INTO t_personas
    (id_persona, nombre)
  VALUES
    (l_id_persona, 'John')
  RETURNING nombre INTO l_nombre;
  -- Assert
  IF l_nombre = 'JOHN' THEN
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
