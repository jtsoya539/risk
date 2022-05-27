PL/SQL Developer Test script 3.0
6
BEGIN
  k_sistema.p_inicializar_parametros;
  IF k_sistema.f_usuario = USER THEN
    dbms_output.put_line('OK');
  END IF;
END;
0
0
