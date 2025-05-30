CREATE OR REPLACE PACKAGE test_k_util IS

  --%suite(Tests unitarios del paquete k_util)
  --%tags(package)

  --%context(Tests unitarios de f_valor_parametro)
  --%name(f_valor_parametro)

  --%test()
  PROCEDURE f_valor_parametro_parametro_con_valor;
  --%test()
  PROCEDURE f_valor_parametro_parametro_sin_valor;
  --%test()
  PROCEDURE f_valor_parametro_parametro_inexistente;
  --%endcontext

  --%context(Tests unitarios de p_actualizar_valor_parametro)
  --%name(p_actualizar_valor_parametro)

  --%test()
  PROCEDURE p_actualizar_valor_parametro_uso_basico;
  --%endcontext

  --%context(Tests unitarios de f_base_datos)
  --%name(f_base_datos)

  --%test()
  PROCEDURE f_base_datos;
  --%endcontext

  --%context(Tests unitarios de f_terminal)
  --%name(f_terminal)

  --%test()
  PROCEDURE f_terminal;
  --%endcontext

  --%context(Tests unitarios de f_host)
  --%name(f_host)

  --%test()
  PROCEDURE f_host;
  --%endcontext

  --%context(Tests unitarios de f_direccion_ip)
  --%name(f_direccion_ip)

  --%test()
  PROCEDURE f_direccion_ip;
  --%endcontext

  --%context(Tests unitarios de f_esquema_actual)
  --%name(f_esquema_actual)

  --%test()
  PROCEDURE f_esquema_actual;
  --%endcontext

END;
/
CREATE OR REPLACE PACKAGE BODY test_k_util IS

  PROCEDURE f_valor_parametro_parametro_con_valor IS
    l_valor t_parametros.valor%TYPE;
  BEGIN
    -- Arrange
    INSERT INTO t_parametros
      (id_parametro, valor)
    VALUES
      ('PARAMETRO_CON_VALOR', 'VALOR');
    -- Act
    l_valor := k_util.f_valor_parametro('PARAMETRO_CON_VALOR');
    -- Assert
    ut.expect(l_valor).to_equal('VALOR');
  END;

  PROCEDURE f_valor_parametro_parametro_sin_valor IS
    l_valor t_parametros.valor%TYPE;
  BEGIN
    -- Arrange
    INSERT INTO t_parametros
      (id_parametro, valor)
    VALUES
      ('PARAMETRO_SIN_VALOR', NULL);
    -- Act
    l_valor := k_util.f_valor_parametro('PARAMETRO_SIN_VALOR');
    -- Assert
    ut.expect(l_valor).to_(be_null());
  END;

  PROCEDURE f_valor_parametro_parametro_inexistente IS
    l_valor t_parametros.valor%TYPE;
  BEGIN
    -- Arrange
    -- Act
    l_valor := k_util.f_valor_parametro('PARAMETRO_QUE_NO_EXISTE');
    -- Assert
    ut.expect(l_valor).to_(be_null());
  END;

  PROCEDURE p_actualizar_valor_parametro_uso_basico IS
    l_valor t_parametros.valor%TYPE;
  BEGIN
    -- Arrange
    INSERT INTO t_parametros
      (id_parametro, valor)
    VALUES
      ('PARAMETRO_CON_VALOR', 'VALOR1');
    -- Act
    k_util.p_actualizar_valor_parametro('PARAMETRO_CON_VALOR', 'VALOR2');
    -- Assert
    SELECT a.valor
      INTO l_valor
      FROM t_parametros a
     WHERE a.id_parametro = 'PARAMETRO_CON_VALOR';
    ut.expect(l_valor).to_equal('VALOR2');
  END;

  PROCEDURE f_base_datos IS
  BEGIN
    ut.expect(k_util.f_base_datos).to_equal(sys_context('USERENV',
                                                        'DB_NAME'));
  END;

  PROCEDURE f_terminal IS
  BEGIN
    ut.expect(k_util.f_terminal).to_equal(sys_context('USERENV',
                                                      'TERMINAL'));
  END;

  PROCEDURE f_host IS
  BEGIN
    ut.expect(k_util.f_host).to_equal(sys_context('USERENV', 'HOST'));
  END;

  PROCEDURE f_direccion_ip IS
  BEGIN
    ut.expect(k_util.f_direccion_ip).to_equal(sys_context('USERENV',
                                                          'IP_ADDRESS'));
  END;

  PROCEDURE f_esquema_actual IS
  BEGIN
    ut.expect(k_util.f_esquema_actual).to_equal(sys_context('USERENV',
                                                            'CURRENT_SCHEMA'));
  END;

END;
/
