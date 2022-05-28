PL/SQL Developer Test script 3.0
21
DECLARE
  l_id_operacion t_operaciones.id_operacion%TYPE;
  l_resultado    t_operaciones.id_operacion%TYPE;
BEGIN
  -- Arrange
  INSERT INTO t_operaciones
    (tipo, nombre, dominio, activo, version_actual, nivel_log)
  VALUES
    ('S', 'OPERACION_DE_PRUEBA', 'GEN', 'S', '0.1.0', 2)
  RETURNING id_operacion INTO l_id_operacion;
  -- Act
  l_resultado := k_operacion.f_id_operacion(i_tipo    => 'S',
                                            i_nombre  => 'OPERACION_DE_PRUEBA',
                                            i_dominio => 'GEN');
  -- Assert
  IF l_resultado = l_id_operacion THEN
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
