CREATE OR REPLACE PACKAGE test_y_dato IS

  --%suite(Tests unitarios del type y_dato)
  --%tags(type)

  --%test(Constructor del objeto sin parámetros)
  PROCEDURE y_dato_uso_basico;

END;
/
CREATE OR REPLACE PACKAGE BODY test_y_dato IS

  PROCEDURE y_dato_uso_basico IS
  BEGIN
    ut.expect('hola').to_equal('hola');
  END;

END;
/
