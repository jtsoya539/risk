CREATE OR REPLACE PACKAGE test_k_operacion IS

  --%suite(Tests unitarios del paquete k_operacion)
  --%tags(package)

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
