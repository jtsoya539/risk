PL/SQL Developer Test script 3.0
19
DECLARE
  l_id_operacion t_operaciones.id_operacion%TYPE;
BEGIN
  -- Arrange
  INSERT INTO t_operaciones
    (tipo, nombre, dominio, activo, version_actual, nivel_log)
  VALUES
    ('S', 'OPERACION_DE_PRUEBA', 'GEN', 'S', '0.1.0', 0)
  RETURNING id_operacion INTO l_id_operacion;
  k_sistema.p_inicializar_parametros;
  -- Act
  k_operacion.p_reservar_id_log(l_id_operacion);
  -- Assert
  IF k_sistema.f_valor_parametro_number(k_operacion.c_id_log) IS NULL THEN
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
