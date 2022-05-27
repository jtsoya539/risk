PL/SQL Developer Test script 3.0
8
BEGIN
  -- Call the function
  :RESULT := k_util.f_host;

  IF :RESULT = sys_context('USERENV', 'HOST') THEN
    dbms_output.put_line('OK');
  END IF;
END;
1
result
1
ATLAS\NTB1636
5
0
