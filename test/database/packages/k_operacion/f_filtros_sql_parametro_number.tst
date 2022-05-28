PL/SQL Developer Test script 3.0
22
DECLARE
  l_filtros_sql CLOB;
  l_parametros  y_parametros;
  l_parametro   y_parametro;
BEGIN
  -- Arrange
  l_parametros       := NEW y_parametros();
  l_parametro        := NEW y_parametro();
  l_parametro.nombre := 'campo';
  l_parametro.valor  := anydata.convertnumber(1234);
  l_parametros.extend;
  l_parametros(l_parametros.count) := l_parametro;
  -- Act
  l_filtros_sql := k_operacion.f_filtros_sql(l_parametros);
  -- Assert
  IF l_filtros_sql LIKE
     '%to_char(campo, ''TM'', ''NLS_NUMERIC_CHARACTERS = ''''.,'''''') = ''1234''%' THEN
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
