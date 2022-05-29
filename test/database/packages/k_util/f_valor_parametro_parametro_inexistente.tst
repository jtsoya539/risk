PL/SQL Developer Test script 3.0
13
DECLARE
  l_valor t_parametros.valor%TYPE;
BEGIN
  -- Arrange
  -- Act
  l_valor := k_util.f_valor_parametro('PARAMETRO_QUE_NO_EXISTE');
  -- Assert
  IF l_valor IS NULL THEN
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
