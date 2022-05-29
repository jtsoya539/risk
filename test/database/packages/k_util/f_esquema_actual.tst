PL/SQL Developer Test script 3.0
13
DECLARE
  l_esquema_actual VARCHAR2(500);
BEGIN
  -- Arrange
  -- Act
  l_esquema_actual := k_util.f_esquema_actual;
  -- Assert
  IF l_esquema_actual = sys_context('USERENV', 'CURRENT_SCHEMA') THEN
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
