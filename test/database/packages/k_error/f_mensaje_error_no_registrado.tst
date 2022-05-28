PL/SQL Developer Test script 3.0
13
DECLARE
  l_mensaje_error VARCHAR2(4000);
BEGIN
  -- Arrange
  -- Act
  l_mensaje_error := k_error.f_mensaje_error('errorquenoexiste');
  -- Assert
  IF l_mensaje_error = 'Error no registrado [errorquenoexiste]' THEN
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
