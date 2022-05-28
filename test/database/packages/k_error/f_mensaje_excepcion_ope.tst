PL/SQL Developer Test script 3.0
20
DECLARE
  l_mensaje_excepcion VARCHAR2(4000);
  l_error_msg         VARCHAR2(4000);
BEGIN
  -- Arrange
  -- Act
  BEGIN
    RAISE no_data_found;
  EXCEPTION
    WHEN OTHERS THEN
      l_error_msg         := utl_call_stack.error_msg(1);
      l_mensaje_excepcion := k_error.f_mensaje_excepcion(SQLERRM);
  END;
  -- Assert
  IF l_mensaje_excepcion = l_error_msg THEN
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
