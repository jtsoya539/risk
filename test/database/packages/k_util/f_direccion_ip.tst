PL/SQL Developer Test script 3.0
13
DECLARE
  l_direccion_ip VARCHAR2(500);
BEGIN
  -- Arrange
  -- Act
  l_direccion_ip := k_util.f_direccion_ip;
  -- Assert
  IF l_direccion_ip = sys_context('USERENV', 'IP_ADDRESS') THEN
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
