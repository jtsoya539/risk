PL/SQL Developer Test script 3.0
13
DECLARE
  l_terminal VARCHAR2(500);
BEGIN
  -- Arrange
  -- Act
  l_terminal := k_util.f_terminal;
  -- Assert
  IF l_terminal = sys_context('USERENV', 'TERMINAL') THEN
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
