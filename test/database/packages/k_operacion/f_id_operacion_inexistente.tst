PL/SQL Developer Test script 3.0
15
DECLARE
  l_resultado t_operaciones.id_operacion%TYPE;
BEGIN
  -- Arrange
  -- Act
  l_resultado := k_operacion.f_id_operacion(i_tipo    => 'S',
                                            i_nombre  => 'OPERACION_QUE_NO_EXISTE',
                                            i_dominio => 'GEN');
  -- Assert
  IF l_resultado IS NULL THEN
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
