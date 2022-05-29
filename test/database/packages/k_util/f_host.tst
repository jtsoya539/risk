PL/SQL Developer Test script 3.0
13
DECLARE
  l_host VARCHAR2(500);
BEGIN
  -- Arrange
  -- Act
  l_host := k_util.f_host;
  -- Assert
  IF l_host = sys_context('USERENV', 'HOST') THEN
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
