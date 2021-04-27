CREATE OR REPLACE PACKAGE k_operacion IS

  /**
  Agrupa operaciones relacionadas con las Operaciones (Servicios Web, Reportes, Trabajos)
  
  %author jtsoya539 27/3/2020 16:42:26
  */

  /*
  --------------------------------- MIT License ---------------------------------
  Copyright (c) 2019 jtsoya539
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  -------------------------------------------------------------------------------
  */

  -- Tipos de Operaciones
  c_tipo_servicio   CONSTANT CHAR(1) := 'S';
  c_tipo_reporte    CONSTANT CHAR(1) := 'R';
  c_tipo_trabajo    CONSTANT CHAR(1) := 'T';
  c_tipo_parametros CONSTANT CHAR(1) := 'P';

  -- Códigos de respuesta
  c_ok                       CONSTANT VARCHAR2(10) := '0';
  c_servicio_no_implementado CONSTANT VARCHAR2(10) := 'ser0001';
  c_error_parametro          CONSTANT VARCHAR2(10) := 'ser0002';
  c_error_permiso            CONSTANT VARCHAR2(10) := 'ser0003';
  c_error_general            CONSTANT VARCHAR2(10) := 'ser0099';
  c_error_inesperado         CONSTANT VARCHAR2(10) := 'ser9999';

  -- Otras constantes
  c_id_log                   CONSTANT VARCHAR2(50) := 'ID_LOG';
  c_id_operacion_contexto    CONSTANT PLS_INTEGER := 0;
  c_id_ope_pagina_parametros CONSTANT PLS_INTEGER := 1000;

  -- Excepciones
  ex_servicio_no_implementado EXCEPTION;
  ex_error_parametro          EXCEPTION;
  ex_error_general            EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_servicio_no_implementado, -6550);

  PROCEDURE p_reservar_id_log(i_id_operacion IN NUMBER);

  PROCEDURE p_registrar_log(i_id_operacion     IN NUMBER,
                            i_parametros       IN CLOB,
                            i_codigo_respuesta IN VARCHAR2,
                            i_respuesta        IN CLOB,
                            i_contexto         IN CLOB DEFAULT NULL,
                            i_version          IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_respuesta_ok(io_respuesta IN OUT NOCOPY y_respuesta,
                           i_datos      IN y_objeto DEFAULT NULL);

  PROCEDURE p_respuesta_error(io_respuesta IN OUT NOCOPY y_respuesta,
                              i_codigo     IN VARCHAR2,
                              i_mensaje    IN VARCHAR2,
                              i_mensaje_bd IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_respuesta_excepcion(io_respuesta   IN OUT NOCOPY y_respuesta,
                                  i_error_number IN NUMBER,
                                  i_error_msg    IN VARCHAR2,
                                  i_error_stack  IN VARCHAR2);

  PROCEDURE p_validar_parametro(io_respuesta IN OUT NOCOPY y_respuesta,
                                i_expresion  IN BOOLEAN,
                                i_mensaje    IN VARCHAR2);

  FUNCTION f_id_operacion(i_tipo    IN VARCHAR2,
                          i_nombre  IN VARCHAR2,
                          i_dominio IN VARCHAR2) RETURN NUMBER;

  FUNCTION f_id_permiso(i_id_operacion IN NUMBER) RETURN VARCHAR2;

  FUNCTION f_procesar_parametros(i_id_operacion IN NUMBER,
                                 i_parametros   IN CLOB,
                                 i_version      IN VARCHAR2 DEFAULT NULL)
    RETURN y_parametros;

  FUNCTION f_filtros_sql(i_parametros IN y_parametros) RETURN CLOB;

  FUNCTION f_valor_parametro(i_parametros IN y_parametros,
                             i_nombre     IN VARCHAR2) RETURN anydata;

  FUNCTION f_valor_parametro_string(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_valor_parametro_number(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN NUMBER;

  FUNCTION f_valor_parametro_boolean(i_parametros IN y_parametros,
                                     i_nombre     IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION f_valor_parametro_date(i_parametros IN y_parametros,
                                  i_nombre     IN VARCHAR2) RETURN DATE;

  FUNCTION f_valor_parametro_object(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN y_objeto;

END;
/
CREATE OR REPLACE PACKAGE BODY k_operacion IS

  PROCEDURE p_reservar_id_log(i_id_operacion IN NUMBER) IS
    l_nivel_log t_operaciones.nivel_log%TYPE;
  BEGIN
    BEGIN
      SELECT nivel_log
        INTO l_nivel_log
        FROM t_operaciones
       WHERE id_operacion = i_id_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        l_nivel_log := 0;
    END;
  
    IF l_nivel_log > 0 THEN
      k_sistema.p_definir_parametro_number(c_id_log,
                                           s_id_operacion_log.nextval);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE p_registrar_log(i_id_operacion     IN NUMBER,
                            i_parametros       IN CLOB,
                            i_codigo_respuesta IN VARCHAR2,
                            i_respuesta        IN CLOB,
                            i_contexto         IN CLOB DEFAULT NULL,
                            i_version          IN VARCHAR2 DEFAULT NULL) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_nivel_log t_operaciones.nivel_log%TYPE;
  BEGIN
    BEGIN
      SELECT nivel_log
        INTO l_nivel_log
        FROM t_operaciones
       WHERE id_operacion = i_id_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        l_nivel_log := 0;
    END;
  
    IF (l_nivel_log > 1 AND i_codigo_respuesta = c_ok) OR
       (l_nivel_log > 0 AND i_codigo_respuesta <> c_ok) THEN
      INSERT INTO t_operacion_logs
        (id_operacion_log,
         id_operacion,
         contexto,
         version,
         parametros,
         respuesta)
      VALUES
        (k_sistema.f_valor_parametro_number(c_id_log),
         i_id_operacion,
         i_contexto,
         substr(i_version, 1, 100),
         i_parametros,
         i_respuesta);
    END IF;
  
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  PROCEDURE p_respuesta_ok(io_respuesta IN OUT NOCOPY y_respuesta,
                           i_datos      IN y_objeto DEFAULT NULL) IS
  BEGIN
    io_respuesta.codigo     := c_ok;
    io_respuesta.mensaje    := 'OK';
    io_respuesta.mensaje_bd := NULL;
    io_respuesta.lugar      := NULL;
    io_respuesta.datos      := i_datos;
  END;

  PROCEDURE p_respuesta_error(io_respuesta IN OUT NOCOPY y_respuesta,
                              i_codigo     IN VARCHAR2,
                              i_mensaje    IN VARCHAR2,
                              i_mensaje_bd IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    IF i_codigo = c_ok THEN
      io_respuesta.codigo := c_error_general;
    ELSE
      io_respuesta.codigo := substr(i_codigo, 1, 10);
    END IF;
    io_respuesta.mensaje    := substr(k_error.f_mensaje_excepcion(i_mensaje),
                                      1,
                                      4000);
    io_respuesta.mensaje_bd := substr(i_mensaje_bd, 1, 4000);
    io_respuesta.datos      := NULL;
  END;

  PROCEDURE p_respuesta_excepcion(io_respuesta   IN OUT NOCOPY y_respuesta,
                                  i_error_number IN NUMBER,
                                  i_error_msg    IN VARCHAR2,
                                  i_error_stack  IN VARCHAR2) IS
  BEGIN
    IF k_error.f_tipo_excepcion(i_error_number) =
       k_error.c_user_defined_error THEN
      p_respuesta_error(io_respuesta,
                        c_error_general,
                        i_error_msg,
                        i_error_stack);
    ELSIF k_error.f_tipo_excepcion(i_error_number) =
          k_error.c_oracle_predefined_error THEN
      p_respuesta_error(io_respuesta,
                        c_error_inesperado,
                        k_error.f_mensaje_error(c_error_inesperado,
                                                to_char(nvl(k_sistema.f_valor_parametro_number(k_operacion.c_id_log),
                                                            0))),
                        i_error_stack);
    END IF;
  END;

  PROCEDURE p_validar_parametro(io_respuesta IN OUT NOCOPY y_respuesta,
                                i_expresion  IN BOOLEAN,
                                i_mensaje    IN VARCHAR2) IS
  BEGIN
    IF NOT nvl(i_expresion, FALSE) THEN
      p_respuesta_error(io_respuesta,
                        c_error_parametro,
                        nvl(i_mensaje,
                            k_error.f_mensaje_error(c_error_parametro)));
      RAISE ex_error_parametro;
    END IF;
  END;

  FUNCTION f_id_operacion(i_tipo    IN VARCHAR2,
                          i_nombre  IN VARCHAR2,
                          i_dominio IN VARCHAR2) RETURN NUMBER IS
    l_id_operacion t_operaciones.id_operacion%TYPE;
  BEGIN
    BEGIN
      SELECT a.id_operacion
        INTO l_id_operacion
        FROM t_operaciones a
       WHERE a.tipo = i_tipo
         AND a.nombre = i_nombre
         AND a.dominio = i_dominio;
    EXCEPTION
      WHEN no_data_found THEN
        l_id_operacion := NULL;
      WHEN OTHERS THEN
        l_id_operacion := NULL;
    END;
    RETURN l_id_operacion;
  END;

  FUNCTION f_id_permiso(i_id_operacion IN NUMBER) RETURN VARCHAR2 IS
    l_id_permiso t_permisos.id_permiso%TYPE;
  BEGIN
    BEGIN
      SELECT p.id_permiso
        INTO l_id_permiso
        FROM t_permisos p, t_operaciones a
       WHERE upper(p.id_permiso) =
             upper(k_util.f_significado_codigo('TIPO_OPERACION', a.tipo) || ':' ||
                   a.dominio || ':' || a.nombre)
         AND a.id_operacion = i_id_operacion;
    EXCEPTION
      WHEN no_data_found THEN
        l_id_permiso := NULL;
      WHEN OTHERS THEN
        l_id_permiso := NULL;
    END;
    RETURN l_id_permiso;
  END;

  FUNCTION f_procesar_parametros(i_id_operacion IN NUMBER,
                                 i_parametros   IN CLOB,
                                 i_version      IN VARCHAR2 DEFAULT NULL)
    RETURN y_parametros IS
    l_parametros   y_parametros;
    l_parametro    y_parametro;
    l_json_object  json_object_t;
    l_json_element json_element_t;
  
    CURSOR cr_parametros IS
      SELECT op.id_operacion,
             lower(op.nombre) nombre,
             op.orden,
             op.activo,
             op.tipo_dato,
             op.formato,
             op.longitud_maxima,
             op.obligatorio,
             op.valor_defecto,
             op.etiqueta,
             op.detalle
        FROM t_operacion_parametros op, t_operaciones o
       WHERE o.id_operacion = op.id_operacion
         AND op.activo = 'S'
         AND op.id_operacion = i_id_operacion
         AND op.version = nvl(i_version, o.version_actual)
      UNION
      SELECT op.id_operacion,
             lower(op.nombre) nombre,
             op.orden,
             op.activo,
             op.tipo_dato,
             op.formato,
             op.longitud_maxima,
             op.obligatorio,
             op.valor_defecto,
             op.etiqueta,
             op.detalle
        FROM t_operacion_parametros op
       WHERE op.activo = 'S'
         AND op.id_operacion = c_id_ope_pagina_parametros
         AND EXISTS (SELECT 1
                FROM t_operaciones o
               WHERE o.tiene_paginacion = 'S'
                 AND o.id_operacion = i_id_operacion)
       ORDER BY orden;
  BEGIN
    -- Inicializa respuesta
    l_parametros := NEW y_parametros();
  
    IF i_parametros IS NULL OR dbms_lob.getlength(i_parametros) = 0 THEN
      l_json_object := json_object_t.parse('{}');
    ELSE
      l_json_object := json_object_t.parse(i_parametros);
    END IF;
  
    FOR par IN cr_parametros LOOP
      l_parametro        := NEW y_parametro();
      l_parametro.nombre := par.nombre;
    
      l_json_element := l_json_object.get(par.nombre);
    
      IF par.obligatorio = 'S' THEN
        IF NOT l_json_object.has(par.nombre) THEN
          raise_application_error(-20000,
                                  k_error.f_mensaje_error('ora0003',
                                                          nvl(par.etiqueta,
                                                              par.nombre)));
        ELSE
          IF l_json_element.is_null THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        END IF;
      END IF;
    
      CASE par.tipo_dato
      
        WHEN 'S' THEN
          -- String
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_string THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0005',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
          l_parametro.valor := anydata.convertvarchar2(l_json_object.get_string(par.nombre));
          IF l_parametro.valor.accessvarchar2 IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertvarchar2(par.valor_defecto);
          END IF;
          IF l_parametro.valor.accessvarchar2 IS NULL AND
             par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
          IF par.longitud_maxima IS NOT NULL AND
             nvl(length(l_parametro.valor.accessvarchar2), 0) >
             par.longitud_maxima THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0006',
                                                            nvl(par.etiqueta,
                                                                par.nombre),
                                                            to_char(par.longitud_maxima)));
          END IF;
        
        WHEN 'N' THEN
          -- Number
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_number THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0005',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
          l_parametro.valor := anydata.convertnumber(l_json_object.get_number(par.nombre));
          IF l_parametro.valor.accessnumber IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertnumber(to_number(par.valor_defecto));
          END IF;
          IF l_parametro.valor.accessnumber IS NULL AND
             par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
          IF par.longitud_maxima IS NOT NULL AND
             nvl(length(to_char(abs(trunc(l_parametro.valor.accessnumber)))),
                 0) > par.longitud_maxima THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0006',
                                                            nvl(par.etiqueta,
                                                                par.nombre),
                                                            to_char(par.longitud_maxima)));
          END IF;
        
        WHEN 'B' THEN
          -- Boolean
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_boolean THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0005',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
          l_parametro.valor := anydata.convertnumber(sys.diutil.bool_to_int(l_json_object.get_boolean(par.nombre)));
          IF l_parametro.valor.accessnumber IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertnumber(to_number(par.valor_defecto));
          END IF;
          IF l_parametro.valor.accessnumber IS NULL AND
             par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
        WHEN 'D' THEN
          -- Date
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_string /*l_json_element.is_date*/
           THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0005',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
          l_parametro.valor := anydata.convertdate(l_json_object.get_date(par.nombre));
          IF l_parametro.valor.accessdate IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertdate(to_date(par.valor_defecto,
                                                             par.formato));
          END IF;
          IF l_parametro.valor.accessdate IS NULL AND par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
        WHEN 'O' THEN
          -- Object
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_object THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0005',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
          IF l_json_element IS NOT NULL THEN
            l_parametro.valor := k_util.json_to_objeto(l_json_element.to_clob,
                                                       par.formato);
          END IF;
        
          IF l_parametro.valor IS NULL AND par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := k_util.json_to_objeto(par.valor_defecto,
                                                       par.formato);
          END IF;
          IF l_parametro.valor IS NULL AND par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
        ELSE
          raise_application_error(-20000,
                                  k_error.f_mensaje_error('ora0002',
                                                          'parámetro',
                                                          nvl(par.etiqueta,
                                                              par.nombre)));
        
      END CASE;
    
      l_parametros.extend;
      l_parametros(l_parametros.count) := l_parametro;
    END LOOP;
    RETURN l_parametros;
  END;

  FUNCTION f_filtros_sql(i_parametros IN y_parametros) RETURN CLOB IS
    l_filtros_sql CLOB;
    i             INTEGER;
    l_typeinfo    anytype;
    l_typecode    PLS_INTEGER;
    l_seen_one    BOOLEAN := FALSE;
  BEGIN
    IF i_parametros IS NOT NULL THEN
      i := i_parametros.first;
      WHILE i IS NOT NULL LOOP
      
        IF lower(i_parametros(i).nombre) NOT IN
           ('formato', 'pagina_parametros') THEN
          IF i_parametros(i).valor IS NOT NULL THEN
            l_typecode := i_parametros(i).valor.gettype(l_typeinfo);
          
            IF l_typecode = dbms_types.typecode_varchar2 THEN
              IF anydata.accessvarchar2(i_parametros(i).valor) IS NOT NULL THEN
                l_filtros_sql := l_filtros_sql || CASE l_seen_one
                                   WHEN TRUE THEN
                                    ' AND '
                                   ELSE
                                    ' WHERE '
                                 END || i_parametros(i).nombre || ' = ' ||
                                 dbms_assert.enquote_literal('''' ||
                                                             REPLACE(anydata.accessvarchar2(i_parametros(i)
                                                                                            .valor),
                                                                     '''',
                                                                     '''''') || '''');
                l_seen_one    := TRUE;
              END IF;
            ELSIF l_typecode = dbms_types.typecode_number THEN
              IF anydata.accessnumber(i_parametros(i).valor) IS NOT NULL THEN
                l_filtros_sql := l_filtros_sql || CASE l_seen_one
                                   WHEN TRUE THEN
                                    ' AND '
                                   ELSE
                                    ' WHERE '
                                 END || 'to_char(' || i_parametros(i)
                                .nombre ||
                                 ', ''TM'', ''NLS_NUMERIC_CHARACTERS = ''''.,'''''') = ' ||
                                 dbms_assert.enquote_literal('''' ||
                                                             to_char(anydata.accessnumber(i_parametros(i)
                                                                                          .valor),
                                                                     'TM',
                                                                     'NLS_NUMERIC_CHARACTERS = ''.,''') || '''');
                l_seen_one    := TRUE;
              END IF;
            ELSIF l_typecode = dbms_types.typecode_date THEN
              IF anydata.accessdate(i_parametros(i).valor) IS NOT NULL THEN
                l_filtros_sql := l_filtros_sql || CASE l_seen_one
                                   WHEN TRUE THEN
                                    ' AND '
                                   ELSE
                                    ' WHERE '
                                 END || 'to_char(' || i_parametros(i)
                                .nombre || ', ''YYYY-MM-DD'') = ' ||
                                 dbms_assert.enquote_literal('''' ||
                                                             to_char(anydata.accessdate(i_parametros(i)
                                                                                        .valor),
                                                                     'YYYY-MM-DD') || '''');
                l_seen_one    := TRUE;
              END IF;
            ELSE
              raise_application_error(-20000,
                                      k_error.f_mensaje_error('ora0002',
                                                              'filtro',
                                                              i_parametros(i)
                                                              .nombre));
            END IF;
          END IF;
        END IF;
      
        i := i_parametros.next(i);
      END LOOP;
    END IF;
  
    RETURN l_filtros_sql;
  EXCEPTION
    WHEN value_error THEN
      raise_application_error(-20000, k_error.f_mensaje_error('ora0001'));
  END;

  FUNCTION f_valor_parametro(i_parametros IN y_parametros,
                             i_nombre     IN VARCHAR2) RETURN anydata IS
    l_valor anydata;
    i       INTEGER;
  BEGIN
    IF i_parametros IS NOT NULL THEN
      -- Busca el parámetro en la lista
      i := i_parametros.first;
      WHILE i IS NOT NULL AND l_valor IS NULL LOOP
        IF lower(i_parametros(i).nombre) = lower(i_nombre) THEN
          l_valor := i_parametros(i).valor;
        END IF;
        i := i_parametros.next(i);
      END LOOP;
    END IF;
  
    -- Si el parámetro no se encuentra en la lista carga un valor nulo de tipo
    -- VARCHAR2 para evitar el error ORA-30625 al acceder al valor a través de
    -- AnyData.Access*
    IF l_valor IS NULL THEN
      l_valor := anydata.convertvarchar2(NULL);
    END IF;
  
    RETURN l_valor;
  END;

  FUNCTION f_valor_parametro_string(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN anydata.accessvarchar2(f_valor_parametro(i_parametros, i_nombre));
  END;

  FUNCTION f_valor_parametro_number(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN NUMBER IS
  BEGIN
    RETURN anydata.accessnumber(f_valor_parametro(i_parametros, i_nombre));
  END;

  FUNCTION f_valor_parametro_boolean(i_parametros IN y_parametros,
                                     i_nombre     IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN sys.diutil.int_to_bool(anydata.accessnumber(f_valor_parametro(i_parametros,
                                                                         i_nombre)));
  END;

  FUNCTION f_valor_parametro_date(i_parametros IN y_parametros,
                                  i_nombre     IN VARCHAR2) RETURN DATE IS
  BEGIN
    RETURN anydata.accessdate(f_valor_parametro(i_parametros, i_nombre));
  END;

  FUNCTION f_valor_parametro_object(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN y_objeto IS
    l_objeto   y_objeto;
    l_anydata  anydata;
    l_result   PLS_INTEGER;
    l_typeinfo anytype;
    l_typecode PLS_INTEGER;
  BEGIN
    l_anydata := f_valor_parametro(i_parametros, i_nombre);
  
    l_typecode := l_anydata.gettype(l_typeinfo);
    IF l_typecode = dbms_types.typecode_object THEN
      l_result := l_anydata.getobject(l_objeto);
    END IF;
  
    RETURN l_objeto;
  END;

END;
/
