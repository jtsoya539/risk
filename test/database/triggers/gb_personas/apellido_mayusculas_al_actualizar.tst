PL/SQL Developer Test script 3.0
23
DECLARE
  l_id_persona t_personas.id_persona%TYPE;
  l_apellido   t_personas.apellido%TYPE;
BEGIN
  -- Arrange
  SELECT MAX(id_persona) + 1 INTO l_id_persona FROM t_personas;
  INSERT INTO t_personas
    (id_persona, apellido)
  VALUES
    (l_id_persona, 'Apellido')
  RETURNING id_persona INTO l_id_persona;
  -- Act
  UPDATE t_personas
     SET apellido = 'Doe'
   WHERE id_persona = l_id_persona
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
