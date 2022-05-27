PL/SQL Developer Test script 3.0
8
BEGIN
  -- Call the function
  :RESULT := k_util.f_base_datos;

  IF :RESULT = sys_context('USERENV', 'DB_NAME') THEN
    dbms_output.put_line('OK');
  END IF;
END;
1
result
1
digital
5
0
