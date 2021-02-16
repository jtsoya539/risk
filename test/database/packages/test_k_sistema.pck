CREATE OR REPLACE PACKAGE test_k_sistema IS

  --%suite(Tests unitarios del paquete k_sistema)
  --%tags(package)

  --%context(Tests unitarios de f_fecha)
  --%name(f_fecha)

  --%test()
  PROCEDURE f_fecha_por_defecto;
  --%endcontext

  --%context(Tests unitarios de f_usuario)
  --%name(f_usuario)

  --%test()
  PROCEDURE f_usuario_por_defecto;
  --%endcontext

END;
/
CREATE OR REPLACE PACKAGE BODY test_k_sistema IS

  PROCEDURE f_fecha_por_defecto IS
    l_fecha_actual t_sistemas.fecha_actual%TYPE;
  BEGIN
    SELECT fecha_actual
      INTO l_fecha_actual
      FROM t_sistemas
     WHERE id_sistema = 'RISK';
    k_sistema.p_inicializar_parametros;
    ut.expect(k_sistema.f_fecha).to_equal(l_fecha_actual);
  END;

  PROCEDURE f_usuario_por_defecto IS
  BEGIN
    k_sistema.p_inicializar_parametros;
    ut.expect(k_sistema.f_usuario).to_equal(USER);
  END;

END;
/
