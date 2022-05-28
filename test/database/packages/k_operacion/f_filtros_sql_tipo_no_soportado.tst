PL/SQL Developer Test script 3.0
27
DECLARE
  l_filtros_sql  CLOB;
  l_parametros   y_parametros;
  l_parametro    y_parametro;
  l_error_number NUMBER;
BEGIN
  -- Arrange
  l_parametros       := NEW y_parametros();
  l_parametro        := NEW y_parametro();
  l_parametro.nombre := 'campo';
  l_parametro.valor  := anydata.convertclob('hola');
  l_parametros.extend;
  l_parametros(l_parametros.count) := l_parametro;
  -- Act
  BEGIN
    l_filtros_sql := k_operacion.f_filtros_sql(l_parametros);
  EXCEPTION
    WHEN OTHERS THEN
      l_error_number := utl_call_stack.error_number(1);
  END;
  -- Assert
  IF l_error_number = 20000 THEN
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
