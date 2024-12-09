CREATE OR REPLACE PACKAGE test_k_clave IS

  --%suite(Tests unitarios del paquete k_clave)
  --%tags(package)

  --%context(Tests unitarios de 2)
  --%name(2)

  --%test()
  PROCEDURE test;
  --%endcontext

END;
/

CREATE OR REPLACE PACKAGE BODY test_k_clave IS

  PROCEDURE test IS
  BEGIN
    NULL;
  END;

END;
/

