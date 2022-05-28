PL/SQL Developer Test script 3.0
22
DECLARE
  l_mensaje_error VARCHAR2(4000);
BEGIN
  -- Arrange
  INSERT INTO t_errores
    (id_error, mensaje)
  VALUES
    ('mierror', '@1@-@2@-@3@-@4@-@5@');
  -- Act
  l_mensaje_error := k_error.f_mensaje_error('mierror',
                                             'uno',
                                             'dos',
                                             'tres',
                                             'cuatro',
                                             'cinco');
  -- Assert
  IF l_mensaje_error = 'uno-dos-tres-cuatro-cinco' THEN
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
