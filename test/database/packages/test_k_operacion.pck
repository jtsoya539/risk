CREATE OR REPLACE PACKAGE test_k_operacion IS

  --%suite(Tests unitarios del paquete k_operacion)
  --%tags(package)

  --%context(Tests unitarios de p_reservar_id_log)
  --%name(p_reservar_id_log)

  --%test()
  PROCEDURE p_reservar_id_log_activo;
  --%test()
  PROCEDURE p_reservar_id_log_inactivo;
  --%endcontext

  --%context(Tests unitarios de f_id_operacion)
  --%name(f_id_operacion)

  --%test()
  PROCEDURE f_id_operacion_existente;
  --%test()
  PROCEDURE f_id_operacion_inexistente;
  --%endcontext

  --%context(Tests unitarios de f_filtros_sql)
  --%name(f_filtros_sql)

  --%test()
  PROCEDURE f_filtros_sql_sin_parametros;
  --%test()
  PROCEDURE f_filtros_sql_parametros_ignorados;
  --%test()
  PROCEDURE f_filtros_sql_parametro_varchar2;
  --%test()
  PROCEDURE f_filtros_sql_parametro_date;
  --%test()
  PROCEDURE f_filtros_sql_parametro_number;
  --%test()
  --%throws(-20000)
  PROCEDURE f_filtros_sql_tipo_no_soportado;
  --%endcontext

END;
/
CREATE OR REPLACE PACKAGE BODY test_k_operacion IS

  PROCEDURE p_reservar_id_log_activo IS
    l_id_operacion t_operaciones.id_operacion%TYPE;
  BEGIN
    -- Arrange
    INSERT INTO t_operaciones
      (tipo, nombre, dominio, activo, log_activo)
    VALUES
      ('S', 'OPERACION_DE_PRUEBA', 'GEN', 'S', 'S')
    RETURNING id_operacion INTO l_id_operacion;
    k_sistema.p_inicializar_parametros;
    -- Act
    k_operacion.p_reservar_id_log(l_id_operacion);
    -- Assert
    ut.expect(k_sistema.f_valor_parametro_number(k_operacion.c_id_log)).to_be_not_null();
  END;

  PROCEDURE p_reservar_id_log_inactivo IS
    l_id_operacion t_operaciones.id_operacion%TYPE;
  BEGIN
    -- Arrange
    INSERT INTO t_operaciones
      (tipo, nombre, dominio, activo, log_activo)
    VALUES
      ('S', 'OPERACION_DE_PRUEBA', 'GEN', 'S', 'N')
    RETURNING id_operacion INTO l_id_operacion;
    k_sistema.p_inicializar_parametros;
    -- Act
    k_operacion.p_reservar_id_log(l_id_operacion);
    -- Assert
    ut.expect(k_sistema.f_valor_parametro_number(k_operacion.c_id_log)).to_be_null();
  END;

  PROCEDURE f_id_operacion_existente IS
    l_id_operacion t_operaciones.id_operacion%TYPE;
    l_resultado    t_operaciones.id_operacion%TYPE;
  BEGIN
    -- Arrange
    INSERT INTO t_operaciones
      (tipo, nombre, dominio, activo, log_activo)
    VALUES
      ('S', 'OPERACION_DE_PRUEBA', 'GEN', 'S', 'S')
    RETURNING id_operacion INTO l_id_operacion;
    -- Act
    l_resultado := k_operacion.f_id_operacion(i_tipo    => 'S',
                                              i_nombre  => 'OPERACION_DE_PRUEBA',
                                              i_dominio => 'GEN');
    -- Assert
    ut.expect(l_resultado).to_equal(l_id_operacion);
  END;

  PROCEDURE f_id_operacion_inexistente IS
    l_resultado t_operaciones.id_operacion%TYPE;
  BEGIN
    -- Arrange
    -- Act
    l_resultado := k_operacion.f_id_operacion(i_tipo    => 'S',
                                              i_nombre  => 'OPERACION_QUE_NO_EXISTE',
                                              i_dominio => 'GEN');
    -- Assert
    ut.expect(l_resultado).to_be_null();
  END;

  PROCEDURE f_filtros_sql_sin_parametros IS
    l_parametros y_parametros;
  BEGIN
    l_parametros := NEW y_parametros();
    ut.expect(k_operacion.f_filtros_sql(l_parametros)).to_(be_null());
  END;

  PROCEDURE f_filtros_sql_parametros_ignorados IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
  BEGIN
    l_parametros := NEW y_parametros();
  
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'formato';
    l_parametro.valor  := anydata.convertvarchar2('PDF');
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
  
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'PAGINA_PARAMETROS';
    l_parametro.valor  := anydata.convertobject(NEW y_pagina_parametros());
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
  
    ut.expect(k_operacion.f_filtros_sql(l_parametros)).to_(be_null());
  END;

  PROCEDURE f_filtros_sql_parametro_varchar2 IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
  BEGIN
    l_parametros       := NEW y_parametros();
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'campo';
    l_parametro.valor  := anydata.convertvarchar2('hola');
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
    ut.expect(k_operacion.f_filtros_sql(l_parametros)).to_be_like('%campo = ''hola''%');
  END;

  PROCEDURE f_filtros_sql_parametro_date IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
  BEGIN
    l_parametros       := NEW y_parametros();
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'campo';
    l_parametro.valor  := anydata.convertdate(SYSDATE);
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
    ut.expect(k_operacion.f_filtros_sql(l_parametros)).to_be_like('%to_char(campo, ''YYYY-MM-DD'') = ''%-%-%''%');
  END;

  PROCEDURE f_filtros_sql_parametro_number IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
  BEGIN
    l_parametros       := NEW y_parametros();
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'campo';
    l_parametro.valor  := anydata.convertnumber(1234);
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
    ut.expect(k_operacion.f_filtros_sql(l_parametros)).to_be_like('%to_char(campo, ''TM'', ''NLS_NUMERIC_CHARACTERS = ''''.,'''''') = ''1234''%');
  END;

  PROCEDURE f_filtros_sql_tipo_no_soportado IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
    l_resultado  CLOB;
  BEGIN
    l_parametros       := NEW y_parametros();
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'campo';
    l_parametro.valor  := anydata.convertclob('hola');
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
    l_resultado := k_operacion.f_filtros_sql(l_parametros);
  END;

END;
/
