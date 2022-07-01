PL/SQL Developer Test script 3.0
17
DECLARE
  l_plantilla CLOB;
  l_vars      k_cadena.t_assoc_array;
BEGIN
  -- Arrange
  l_plantilla := 'Hola ##NOMBRE## ##apellido##!';
  l_vars('nombre') := 'Juan';
  l_vars('apellido') := 'Pérez';
  -- Act
  l_plantilla := k_cadena.f_procesar_plantilla(l_plantilla, l_vars, '##');
  -- Assert
  IF l_plantilla = 'Hola Juan Pérez!' THEN
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
