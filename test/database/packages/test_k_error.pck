CREATE OR REPLACE PACKAGE test_k_error IS

  --%suite(Tests unitarios del paquete k_error)
  --%tags(package)

  --%context(Tests unitarios de f_tipo_excepcion)
  --%name(f_tipo_excepcion)

  --%test()
  PROCEDURE f_tipo_excepcion_ude_negativo;
  --%test()
  PROCEDURE f_tipo_excepcion_ude_positivo;
  --%test()
  PROCEDURE f_tipo_excepcion_ope;
  --%endcontext

  --%context(Tests unitarios de f_mensaje_excepcion)
  --%name(f_mensaje_excepcion)

  --%test()
  PROCEDURE f_mensaje_excepcion_ude;
  --%test()
  PROCEDURE f_mensaje_excepcion_ope;
  --%test()
  PROCEDURE f_mensaje_excepcion_ope_sin_plsql;
  --%endcontext

  --%context(Tests unitarios de f_mensaje_error)
  --%name(f_mensaje_error)

  --%test()
  PROCEDURE f_mensaje_error_default_wrap_char;
  --%test()
  PROCEDURE f_mensaje_error_custom_wrap_char;
  --%test()
  PROCEDURE f_mensaje_error_no_registrado;
  --%endcontext

END;
/
CREATE OR REPLACE PACKAGE BODY test_k_error IS

  PROCEDURE f_tipo_excepcion_ude_negativo IS
  BEGIN
    ut.expect(k_error.f_tipo_excepcion(-20000)).to_equal(k_error.c_user_defined_error);
  END;

  PROCEDURE f_tipo_excepcion_ude_positivo IS
  BEGIN
    ut.expect(k_error.f_tipo_excepcion(20000)).to_equal(k_error.c_user_defined_error);
  END;

  PROCEDURE f_tipo_excepcion_ope IS
  BEGIN
    ut.expect(k_error.f_tipo_excepcion(-1)).to_equal(k_error.c_oracle_predefined_error);
  END;

  PROCEDURE f_mensaje_excepcion_ude IS
    l_mensaje_excepcion VARCHAR2(4000);
  BEGIN
    BEGIN
      raise_application_error(-20000, 'Este es un mensaje de error');
    EXCEPTION
      WHEN OTHERS THEN
        l_mensaje_excepcion := k_error.f_mensaje_excepcion(SQLERRM);
    END;
    ut.expect(l_mensaje_excepcion).to_equal('Este es un mensaje de error');
  END;

  PROCEDURE f_mensaje_excepcion_ope IS
    l_mensaje_excepcion VARCHAR2(4000);
    l_error_msg         VARCHAR2(4000);
  BEGIN
    BEGIN
      RAISE no_data_found;
    EXCEPTION
      WHEN OTHERS THEN
        l_error_msg         := utl_call_stack.error_msg(1);
        l_mensaje_excepcion := k_error.f_mensaje_excepcion(SQLERRM);
    END;
    ut.expect(l_mensaje_excepcion).to_equal(l_error_msg);
  END;

  PROCEDURE f_mensaje_excepcion_ope_sin_plsql IS
    l_mensaje_excepcion VARCHAR2(4000);
    l_error_msg         VARCHAR2(4000);
  BEGIN
    BEGIN
      RAISE program_error;
    EXCEPTION
      WHEN OTHERS THEN
        l_error_msg         := utl_call_stack.error_msg(1);
        l_mensaje_excepcion := k_error.f_mensaje_excepcion(SQLERRM);
    END;
    ut.expect(l_mensaje_excepcion).to_equal(REPLACE(l_error_msg,
                                                    'PL/SQL: '));
  END;

  PROCEDURE f_mensaje_error_default_wrap_char IS
    l_mensaje_error VARCHAR2(4000);
  BEGIN
    INSERT INTO t_errores
      (id_error, mensaje)
    VALUES
      ('mierror', '@1@-@2@-@3@-@4@-@5@');
  
    l_mensaje_error := k_error.f_mensaje_error('mierror',
                                               'uno',
                                               'dos',
                                               'tres',
                                               'cuatro',
                                               'cinco');
    ut.expect(l_mensaje_error).to_equal('uno-dos-tres-cuatro-cinco');
  END;

  PROCEDURE f_mensaje_error_custom_wrap_char IS
    l_mensaje_error VARCHAR2(4000);
  BEGIN
    INSERT INTO t_errores
      (id_error, mensaje)
    VALUES
      ('mierror', '#1#-#2#-#3#-#4#-#5#');
  
    l_mensaje_error := k_error.f_mensaje_error('mierror',
                                               'uno',
                                               'dos',
                                               'tres',
                                               'cuatro',
                                               'cinco',
                                               '#');
    ut.expect(l_mensaje_error).to_equal('uno-dos-tres-cuatro-cinco');
  END;

  PROCEDURE f_mensaje_error_no_registrado IS
  BEGIN
    ut.expect(k_error.f_mensaje_error('errorquenoexiste')).to_equal('Error no registrado [errorquenoexiste]');
  END;

END;
/
