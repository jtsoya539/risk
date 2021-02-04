CREATE OR REPLACE PACKAGE test_k_usuario IS

  --%suite(Tests unitarios del paquete k_usuario)
  --%tags(package)

  --%context(Tests unitarios de 2)
  --%name(2)

  --%test()
  PROCEDURE test;
  --%endcontext

END;
/
CREATE OR REPLACE PACKAGE BODY test_k_usuario IS

  PROCEDURE test IS
  BEGIN
    NULL;
  END;

END;
/
