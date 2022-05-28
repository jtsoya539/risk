PL/SQL Developer Test script 3.0
13
DECLARE
  l_tipo_error VARCHAR2(3);
BEGIN
  -- Arrange
  -- Act
  l_tipo_error := k_error.f_tipo_excepcion(20000);
  -- Assert
  IF l_tipo_error = k_error.c_user_defined_error THEN
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
