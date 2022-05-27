PL/SQL Developer Test script 3.0
17
DECLARE
  l_valor t_parametros.valor%TYPE;
BEGIN
  -- Arrange
  INSERT INTO t_parametros
    (id_parametro, valor)
  VALUES
    ('PARAMETRO_CON_VALOR', 'VALOR');
  -- Act
  l_valor := k_util.f_valor_parametro('PARAMETRO_CON_VALOR');
  -- Assert
  IF l_valor = 'VALOR' THEN
    dbms_output.put_line('OK');
  END IF;

  ROLLBACK;
END;
0
0
