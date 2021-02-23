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

  --%context(Tests unitarios de f_valor_parametro)
  --%name(f_valor_parametro)

  --%test()
  PROCEDURE f_valor_parametro_lista_null;
  --%test()
  PROCEDURE f_valor_parametro_lista_vacia;
  --%test() 
  PROCEDURE f_valor_parametro_nombre_con_diferente_case;
  --%test() 
  PROCEDURE f_valor_parametro_nombre_inexistente;
  --%test()
  PROCEDURE f_valor_parametro_string;
  --%test()
  PROCEDURE f_valor_parametro_number;
  --%test()
  PROCEDURE f_valor_parametro_boolean;
  --%test()
  PROCEDURE f_valor_parametro_date;
  --%test()
  PROCEDURE f_valor_parametro_object;
  --%endcontext

END;
/
CREATE OR REPLACE PACKAGE BODY test_k_operacion IS

  PROCEDURE p_reservar_id_log_activo IS
    l_id_operacion t_operaciones.id_operacion%TYPE;
  BEGIN
    -- Arrange
    INSERT INTO t_operaciones
      (tipo, nombre, dominio, activo, version_actual, log_activo)
    VALUES
      ('S', 'OPERACION_DE_PRUEBA', 'GEN', 'S', '0.1.0', 'S')
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
      (tipo, nombre, dominio, activo, version_actual, log_activo)
    VALUES
      ('S', 'OPERACION_DE_PRUEBA', 'GEN', 'S', '0.1.0', 'N')
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
      (tipo, nombre, dominio, activo, version_actual, log_activo)
    VALUES
      ('S', 'OPERACION_DE_PRUEBA', 'GEN', 'S', '0.1.0', 'S')
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

  PROCEDURE f_valor_parametro_lista_null IS
    l_parametros y_parametros;
  BEGIN
    -- Act
    -- Assert
    ut.expect(anydata.accessvarchar2(k_operacion.f_valor_parametro(i_parametros => l_parametros,
                                                                   i_nombre     => 'parametro'))).to_be_null();
  END;

  PROCEDURE f_valor_parametro_lista_vacia IS
    l_parametros y_parametros;
  BEGIN
    l_parametros := NEW y_parametros();
    -- Act
    -- Assert
    ut.expect(anydata.accessvarchar2(k_operacion.f_valor_parametro(i_parametros => l_parametros,
                                                                   i_nombre     => 'parametro'))).to_be_null();
  END;

  PROCEDURE f_valor_parametro_nombre_con_diferente_case IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
  BEGIN
    l_parametros       := NEW y_parametros();
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'parametro';
    l_parametro.valor  := anydata.convertvarchar2('hola');
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
    -- Act
    -- Assert
    ut.expect(anydata.accessvarchar2(k_operacion.f_valor_parametro(i_parametros => l_parametros,
                                                                   i_nombre     => 'PARAMETRO'))).to_equal('hola');
  END;

  PROCEDURE f_valor_parametro_nombre_inexistente IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
  BEGIN
    l_parametros       := NEW y_parametros();
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'parametro';
    l_parametro.valor  := anydata.convertvarchar2('hola');
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
    -- Act
    -- Assert
    ut.expect(anydata.accessvarchar2(k_operacion.f_valor_parametro(i_parametros => l_parametros,
                                                                   i_nombre     => 'no_existe'))).to_be_null();
  END;

  PROCEDURE f_valor_parametro_string IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
  BEGIN
    l_parametros       := NEW y_parametros();
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'parametro';
    l_parametro.valor  := anydata.convertvarchar2('hola');
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
    -- Act
    -- Assert
    ut.expect(k_operacion.f_valor_parametro_string(i_parametros => l_parametros,
                                                   i_nombre     => 'parametro')).to_equal('hola');
  END;

  PROCEDURE f_valor_parametro_number IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
  BEGIN
    l_parametros       := NEW y_parametros();
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'parametro';
    l_parametro.valor  := anydata.convertnumber(1234);
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
    -- Act
    -- Assert
    ut.expect(k_operacion.f_valor_parametro_number(i_parametros => l_parametros,
                                                   i_nombre     => 'parametro')).to_equal(1234);
  END;

  PROCEDURE f_valor_parametro_boolean IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
  BEGIN
    l_parametros       := NEW y_parametros();
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'parametro';
    l_parametro.valor  := anydata.convertnumber(sys.diutil.bool_to_int(TRUE));
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
    -- Act
    -- Assert
    ut.expect(k_operacion.f_valor_parametro_boolean(i_parametros => l_parametros,
                                                    i_nombre     => 'parametro')).to_equal(TRUE);
  END;

  PROCEDURE f_valor_parametro_date IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
  BEGIN
    l_parametros       := NEW y_parametros();
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := 'parametro';
    l_parametro.valor  := anydata.convertdate(trunc(SYSDATE));
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
    -- Act
    -- Assert
    ut.expect(k_operacion.f_valor_parametro_date(i_parametros => l_parametros,
                                                 i_nombre     => 'parametro')).to_equal(trunc(SYSDATE));
  END;

  PROCEDURE f_valor_parametro_object IS
    l_parametros y_parametros;
    l_parametro  y_parametro;
    l_dato       y_dato;
    l_resultado  y_dato;
  BEGIN
    l_parametros       := NEW y_parametros();
    l_parametro        := NEW y_parametro();
    l_dato             := NEW y_dato();
    l_dato.contenido   := 'hola';
    l_parametro.nombre := 'parametro';
    l_parametro.valor  := anydata.convertobject(l_dato);
    l_parametros.extend;
    l_parametros(l_parametros.count) := l_parametro;
    -- Act
    l_resultado := treat(k_operacion.f_valor_parametro_object(i_parametros => l_parametros,
                                                              i_nombre     => 'parametro') AS
                         y_dato);
    -- Assert
    ut.expect(l_resultado.contenido).to_equal(l_dato.contenido);
  END;

END;
/
