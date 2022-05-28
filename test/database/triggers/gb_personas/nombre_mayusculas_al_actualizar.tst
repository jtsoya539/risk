PL/SQL Developer Test script 3.0
23
DECLARE
  l_id_persona t_personas.id_persona%TYPE;
  l_nombre     t_personas.nombre%TYPE;
BEGIN
  -- Arrange
  SELECT MAX(id_persona) + 1 INTO l_id_persona FROM t_personas;
  INSERT INTO t_personas
    (id_persona, nombre)
  VALUES
    (l_id_persona, 'Nombre')
  RETURNING id_persona INTO l_id_persona;
  -- Act
  UPDATE t_personas
     SET nombre = 'John'
   WHERE id_persona = l_id_persona
  RETURNING nombre INTO l_nombre;
  -- Assert
  IF l_nombre = 'JOHN' THEN
    :RESULT := 'OK';
  END IF;

  ROLLBACK;
END;
1
result
0
5
0
