PL/SQL Developer Test script 3.0
23
DECLARE
  l_respuesta y_respuesta;
  l_error     y_error;
  l_resultado y_objeto;
BEGIN
  -- Arrange
  l_respuesta       := NEW y_respuesta();
  l_error           := NEW y_error();
  l_error.id_error  := '0001';
  l_error.mensaje   := 'Este es un mensaje';
  l_respuesta.datos := l_error;
  --
  k_sistema.p_inicializar_cola;
  k_sistema.p_encolar('Y_ERROR');
  -- Act
  l_resultado := y_respuesta.parse_json(l_respuesta.to_json);
  -- Assert
  IF l_resultado.to_json = l_respuesta.to_json THEN
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
