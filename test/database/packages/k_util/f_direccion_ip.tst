PL/SQL Developer Test script 3.0
8
BEGIN
  -- Call the function
  :RESULT := k_util.f_direccion_ip;

  IF :RESULT = sys_context('USERENV', 'IP_ADDRESS') THEN
    dbms_output.put_line('OK');
  END IF;
END;
1
result
1
192.168.11.145
5
0
