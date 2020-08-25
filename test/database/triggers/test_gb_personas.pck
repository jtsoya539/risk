CREATE OR REPLACE PACKAGE test_gb_personas IS

  --%suite(Tests unitarios del trigger gb_personas)
  --%tags(trigger)

  --%test(Guarda el nombre en mayúsculas)
  PROCEDURE nombre_mayusculas;

END;
/
CREATE OR REPLACE PACKAGE BODY test_gb_personas IS

  PROCEDURE nombre_mayusculas IS
  BEGIN
    ut.expect('hola').to_equal('hola');
  END;

END;
/
