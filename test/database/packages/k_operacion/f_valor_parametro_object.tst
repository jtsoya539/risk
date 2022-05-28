PL/SQL Developer Test script 3.0
26
DECLARE
  l_parametros y_parametros;
  l_parametro  y_parametro;
  l_dato       y_dato;
  l_resultado  y_dato;
BEGIN
  -- Arrange
  l_parametros       := NEW y_parametros();
  l_parametro        := NEW y_parametro();
  l_dato             := NEW y_dato();
  l_dato.contenido   := 'hola';
  l_parametro.nombre := 'parametro';
  l_parametro.valor  := anydata.convertobject(l_dato);
  l_parametros.extend;
  l_parametros(l_parametros.count) := l_parametro;
  -- Act
  l_resultado := treat(k_operacion.f_valor_parametro_object(i_parametros => l_parametros,
                                                            i_nombre     => 'parametro') AS
                       y_dato);
  -- Assert
  IF l_resultado.contenido = l_dato.contenido THEN
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
