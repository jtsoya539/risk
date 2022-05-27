PL/SQL Developer Test script 3.0
22
DECLARE
  l_valor t_parametros.valor%TYPE;
BEGIN
  -- Arrange
  INSERT INTO t_parametros
    (id_parametro, valor)
  VALUES
    ('PARAMETRO_CON_VALOR', 'VALOR1');
  -- Act
  k_util.p_actualizar_valor_parametro('PARAMETRO_CON_VALOR', 'VALOR2');
  -- Assert
  SELECT a.valor
    INTO l_valor
    FROM t_parametros a
   WHERE a.id_parametro = 'PARAMETRO_CON_VALOR';

  IF l_valor = 'VALOR2' THEN
    dbms_output.put_line('OK');
  END IF;

  ROLLBACK;
END;
0
0
