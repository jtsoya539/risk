PL/SQL Developer Test script 3.0
8
BEGIN
  -- Call the function
  :RESULT := k_util.f_terminal;

  IF :RESULT = sys_context('USERENV', 'TERMINAL') THEN
    dbms_output.put_line('OK');
  END IF;
END;
1
result
1
NTB1636
5
0
