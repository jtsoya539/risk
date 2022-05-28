PL/SQL Developer Test script 3.0
18
DECLARE
  l_mensaje_excepcion VARCHAR2(4000);
BEGIN
  -- Arrange
  -- Act
  BEGIN
    raise_application_error(-20000, 'Este es un mensaje de error');
  EXCEPTION
    WHEN OTHERS THEN
      l_mensaje_excepcion := k_error.f_mensaje_excepcion(SQLERRM);
  END;
  -- Assert
  IF l_mensaje_excepcion = 'Este es un mensaje de error' THEN
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
