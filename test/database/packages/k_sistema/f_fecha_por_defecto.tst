PL/SQL Developer Test script 3.0
19
DECLARE
  l_fecha        t_modulos.fecha_actual%TYPE;
  l_fecha_actual t_modulos.fecha_actual%TYPE;
BEGIN
  -- Arrange
  k_sistema.p_inicializar_parametros;
  -- Act
  l_fecha := k_sistema.f_fecha;
  -- Assert
  SELECT fecha_actual
    INTO l_fecha_actual
    FROM t_modulos
   WHERE id_modulo = 'RISK';
  IF l_fecha = l_fecha_actual THEN
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
