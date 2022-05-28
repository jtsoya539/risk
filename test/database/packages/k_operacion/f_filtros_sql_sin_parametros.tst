PL/SQL Developer Test script 3.0
15
DECLARE
  l_filtros_sql CLOB;
  l_parametros  y_parametros;
BEGIN
  -- Arrange
  l_parametros := NEW y_parametros();
  -- Act
  l_filtros_sql := k_operacion.f_filtros_sql(l_parametros);
  -- Assert
  IF l_filtros_sql IS NULL THEN
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
