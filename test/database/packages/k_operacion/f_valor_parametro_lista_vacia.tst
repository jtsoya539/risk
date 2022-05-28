PL/SQL Developer Test script 3.0
14
DECLARE
  l_parametros y_parametros;
BEGIN
  -- Arrange
  l_parametros := NEW y_parametros();
  -- Act
  -- Assert
  IF anydata.accessvarchar2(k_operacion.f_valor_parametro(i_parametros => l_parametros,
                                                          i_nombre     => 'parametro')) IS NULL THEN
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
