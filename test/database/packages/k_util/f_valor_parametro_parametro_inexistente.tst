PL/SQL Developer Test script 3.0
11
DECLARE
  l_valor t_parametros.valor%TYPE;
BEGIN
  -- Arrange
  -- Act
  l_valor := k_util.f_valor_parametro('PARAMETRO_QUE_NO_EXISTE');
  -- Assert
  IF l_valor IS NULL THEN
    dbms_output.put_line('OK');
  END IF;
END;
0
0
