PL/SQL Developer Test script 3.0
20
DECLARE
  l_resultado CLOB;
  l_respuesta y_respuesta;
BEGIN
  -- Arrange
  -- Act
  l_resultado := k_servicio.f_procesar_servicio(i_nombre     => 'VERSION_SISTEMA',
                                                i_dominio    => 'GEN',
                                                i_parametros => '{}',
                                                i_contexto   => '{}');
  -- Assert
  k_sistema.p_inicializar_cola;
  k_sistema.p_encolar('Y_DATO');
  l_respuesta := treat(y_respuesta.parse_json(l_resultado) AS y_respuesta);
  IF l_respuesta.codigo = k_operacion.c_ok THEN
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
