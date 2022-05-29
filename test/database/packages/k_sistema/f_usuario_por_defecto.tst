PL/SQL Developer Test script 3.0
14
DECLARE
  l_usuario t_usuarios.alias%TYPE;
BEGIN
  -- Arrange
  k_sistema.p_inicializar_parametros;
  -- Act
  l_usuario := k_sistema.f_usuario;
  -- Assert
  IF l_usuario = USER THEN
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
