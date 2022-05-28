PL/SQL Developer Test script 3.0
20
DECLARE
  l_parametros y_parametros;
  l_parametro  y_parametro;
BEGIN
  -- Arrange
  l_parametros       := NEW y_parametros();
  l_parametro        := NEW y_parametro();
  l_parametro.nombre := 'parametro';
  l_parametro.valor  := anydata.convertvarchar2('hola');
  l_parametros.extend;
  l_parametros(l_parametros.count) := l_parametro;
  -- Act
  -- Assert
  IF anydata.accessvarchar2(k_operacion.f_valor_parametro(i_parametros => l_parametros,
                                                          i_nombre     => 'no_existe')) IS NULL THEN
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
