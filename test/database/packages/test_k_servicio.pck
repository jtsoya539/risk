CREATE OR REPLACE PACKAGE test_k_servicio IS

  --%suite(Tests unitarios del paquete k_servicio)
  --%tags(package)
  --%rollback(manual)

  --%context(Tests unitarios de f_procesar_servicio)
  --%name(f_procesar_servicio)

  --%test()
  PROCEDURE f_procesar_servicio_inexistente;
  --%test()
  PROCEDURE f_procesar_servicio_error_json_parametros;
  --%test()
  PROCEDURE f_procesar_servicio_error_json_contexto;
  --%test()
  PROCEDURE f_procesar_servicio_error_tipo_contexto;
  --%test()
  PROCEDURE f_procesar_servicio_version_sistema;
  --%endcontext

END;
/
CREATE OR REPLACE PACKAGE BODY test_k_servicio IS

  PROCEDURE f_procesar_servicio_inexistente IS
    l_resultado CLOB;
    l_respuesta y_respuesta;
  BEGIN
    -- Arrange
    -- Act
    l_resultado := k_servicio.f_procesar_servicio(i_nombre     => 'SERVICIO_QUE_NO_EXISTE',
                                                  i_dominio    => 'GEN',
                                                  i_parametros => '{}',
                                                  i_contexto   => '{}');
    -- Assert
    k_sistema.p_inicializar_parametros;
    k_sistema.p_definir_parametro_string(k_sistema.c_nombre_tipo, 'Y_DATO');
    l_respuesta := treat(y_respuesta.parse_json(l_resultado) AS y_respuesta);
    ut.expect(l_respuesta.codigo).to_equal(k_servicio.c_servicio_no_implementado);
  END;

  PROCEDURE f_procesar_servicio_error_json_parametros IS
    l_resultado CLOB;
    l_respuesta y_respuesta;
  BEGIN
    -- Arrange
    -- Act
    l_resultado := k_servicio.f_procesar_servicio(i_nombre     => 'VERSION_SISTEMA',
                                                  i_dominio    => 'GEN',
                                                  i_parametros => '{"dato":',
                                                  i_contexto   => '{}');
    -- Assert
    k_sistema.p_inicializar_parametros;
    k_sistema.p_definir_parametro_string(k_sistema.c_nombre_tipo, 'Y_DATO');
    l_respuesta := treat(y_respuesta.parse_json(l_resultado) AS y_respuesta);
    ut.expect(l_respuesta.codigo).to_equal(k_servicio.c_error_parametro);
  END;

  PROCEDURE f_procesar_servicio_error_json_contexto IS
    l_resultado CLOB;
    l_respuesta y_respuesta;
  BEGIN
    -- Arrange
    -- Act
    l_resultado := k_servicio.f_procesar_servicio(i_nombre     => 'VERSION_SISTEMA',
                                                  i_dominio    => 'GEN',
                                                  i_parametros => '{}',
                                                  i_contexto   => '{"dato":');
    -- Assert
    k_sistema.p_inicializar_parametros;
    k_sistema.p_definir_parametro_string(k_sistema.c_nombre_tipo, 'Y_DATO');
    l_respuesta := treat(y_respuesta.parse_json(l_resultado) AS y_respuesta);
    ut.expect(l_respuesta.codigo).to_equal(k_servicio.c_error_parametro);
  END;

  PROCEDURE f_procesar_servicio_error_tipo_contexto IS
    l_resultado CLOB;
    l_respuesta y_respuesta;
  BEGIN
    -- Arrange
    -- Act
    l_resultado := k_servicio.f_procesar_servicio(i_nombre     => 'VERSION_SISTEMA',
                                                  i_dominio    => 'GEN',
                                                  i_parametros => '{}',
                                                  i_contexto   => '{"usuario":1234}');
    -- Assert
    k_sistema.p_inicializar_parametros;
    k_sistema.p_definir_parametro_string(k_sistema.c_nombre_tipo, 'Y_DATO');
    l_respuesta := treat(y_respuesta.parse_json(l_resultado) AS y_respuesta);
    ut.expect(l_respuesta.codigo).to_equal(k_servicio.c_error_parametro);
  END;

  PROCEDURE f_procesar_servicio_version_sistema IS
    l_resultado CLOB;
    l_respuesta y_respuesta;
  BEGIN
    -- Arrange
    -- Act
    l_resultado := k_servicio.f_procesar_servicio(i_nombre     => 'VERSION_SISTEMA',
                                                  i_dominio    => 'GEN',
                                                  i_parametros => '{}',
                                                  i_contexto   => '{}');
    -- Assert
    k_sistema.p_inicializar_parametros;
    k_sistema.p_definir_parametro_string(k_sistema.c_nombre_tipo, 'Y_DATO');
    l_respuesta := treat(y_respuesta.parse_json(l_resultado) AS y_respuesta);
    ut.expect(l_respuesta.codigo).to_equal(k_servicio.c_ok);
  END;

END;
/
