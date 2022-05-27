PL/SQL Developer Test script 3.0
12
DECLARE
  l_fecha_actual t_modulos.fecha_actual%TYPE;
BEGIN
  SELECT fecha_actual
    INTO l_fecha_actual
    FROM t_modulos
   WHERE id_modulo = 'RISK';
  k_sistema.p_inicializar_parametros;
  IF k_sistema.f_fecha = l_fecha_actual THEN
    dbms_output.put_line('OK');
  END IF;
END;
0
0
