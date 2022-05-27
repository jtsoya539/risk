PL/SQL Developer Test script 3.0
8
BEGIN
  -- Call the function
  :RESULT := k_util.f_esquema_actual;

  IF :RESULT = sys_context('USERENV', 'CURRENT_SCHEMA') THEN
    dbms_output.put_line('OK');
  END IF;
END;
1
result
1
JMEZA
5
0
