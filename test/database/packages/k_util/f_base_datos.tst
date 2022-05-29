PL/SQL Developer Test script 3.0
13
DECLARE
  l_base_datos VARCHAR2(500);
BEGIN
  -- Arrange
  -- Act
  l_base_datos := k_util.f_base_datos;
  -- Assert
  IF l_base_datos = sys_context('USERENV', 'DB_NAME') THEN
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
