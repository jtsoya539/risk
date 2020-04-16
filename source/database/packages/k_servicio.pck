CREATE OR REPLACE PACKAGE k_servicio IS

  /**
  Agrupa operaciones relacionadas con los Servicios Web del sistema
  
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

  -- Errores
  c_error_inesperado CONSTANT VARCHAR2(10) := 'api9999';

  -- Excepciones
  ex_error_general            EXCEPTION;
  ex_error_parametro          EXCEPTION;
  ex_servicio_no_implementado EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_servicio_no_implementado, -6550);

  PROCEDURE p_respuesta_ok(io_respuesta IN OUT y_respuesta,
                           i_datos      IN y_objeto DEFAULT NULL);

  PROCEDURE p_respuesta_error(io_respuesta IN OUT y_respuesta,
                              i_codigo     IN VARCHAR2,
                              i_mensaje    IN VARCHAR2,
                              i_mensaje_bd IN VARCHAR2 DEFAULT NULL);

  FUNCTION f_objeto_parse_json(i_json IN CLOB) RETURN anydata;

  FUNCTION f_objeto_to_json(i_objeto IN anydata) RETURN CLOB;

  FUNCTION f_procesar_parametros(i_id_servicio IN NUMBER,
                                 i_parametros  IN CLOB) RETURN y_parametros;

  FUNCTION f_valor_parametro(i_parametros IN y_parametros,
                             i_nombre     IN VARCHAR2) RETURN anydata;

  FUNCTION f_procesar_servicio(i_id_servicio IN NUMBER,
                               i_parametros  IN CLOB) RETURN CLOB;

END;
/
CREATE OR REPLACE PACKAGE BODY k_servicio IS

  PROCEDURE lp_registrar_ejecucion(i_id_servicio IN NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE t_servicios
       SET cantidad_ejecuciones   = nvl(cantidad_ejecuciones, 0) + 1,
           fecha_ultima_ejecucion = SYSDATE
     WHERE id_servicio = i_id_servicio;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  PROCEDURE lp_registrar_log(i_id_servicio IN NUMBER,
                             i_parametros  IN CLOB,
                             i_respuesta   IN CLOB) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO t_servicio_logs
      (id_servicio, parametros, respuesta)
    VALUES
      (i_id_servicio, i_parametros, i_respuesta);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  FUNCTION lf_procesar_servicio(i_id_servicio IN NUMBER,
                                i_parametros  IN CLOB) RETURN y_respuesta IS
    l_rsp              y_respuesta;
    l_prms             y_parametros;
    l_nombre_servicio  t_servicios.nombre%TYPE;
    l_dominio_servicio t_servicios.dominio%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Buscando nombre y dominio del servicio';
    BEGIN
      SELECT upper(nombre), upper(dominio)
        INTO l_nombre_servicio, l_dominio_servicio
        FROM t_servicios
       WHERE activo = 'S'
         AND id_servicio = i_id_servicio;
    EXCEPTION
      WHEN no_data_found THEN
        p_respuesta_error(l_rsp,
                          'api0001',
                          'Servicio inexistente o inactivo');
        RAISE ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Procesando parametros del servicio';
    BEGIN
      l_prms := f_procesar_parametros(i_id_servicio, i_parametros);
    EXCEPTION
      WHEN OTHERS THEN
        p_respuesta_error(l_rsp,
                          'api0002',
                          CASE
                          k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                          k_error.c_user_defined_error THEN
                          utl_call_stack.error_msg(1) WHEN
                          k_error.c_oracle_predefined_error THEN
                          'Error al procesar parametros del servicio' END,
                          dbms_utility.format_error_stack);
        RAISE ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Procesando servicio';
    BEGIN
      EXECUTE IMMEDIATE 'BEGIN :1 := K_SERVICIO_' || l_dominio_servicio || '.' ||
                        l_nombre_servicio || '(:2); END;'
        USING OUT l_rsp, IN l_prms;
    EXCEPTION
      WHEN ex_servicio_no_implementado THEN
        p_respuesta_error(l_rsp,
                          'api0003',
                          'Servicio no implementado',
                          dbms_utility.format_error_stack);
        RAISE ex_error_general;
      WHEN OTHERS THEN
        p_respuesta_error(l_rsp,
                          'api0004',
                          CASE
                          k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                          k_error.c_user_defined_error THEN
                          utl_call_stack.error_msg(1) WHEN
                          k_error.c_oracle_predefined_error THEN
                          'Error al procesar servicio' END,
                          dbms_utility.format_error_stack);
        RAISE ex_error_general;
    END;
  
    IF l_rsp.codigo = '0' THEN
      COMMIT;
    ELSE
      RAISE ex_error_general;
    END IF;
  
    p_respuesta_ok(l_rsp, l_rsp.datos);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_parametro THEN
      RETURN l_rsp;
    WHEN ex_error_general THEN
      ROLLBACK;
      RETURN l_rsp;
    WHEN OTHERS THEN
      ROLLBACK;
      p_respuesta_error(l_rsp,
                        c_error_inesperado,
                        k_error.f_mensaje_error(c_error_inesperado),
                        dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  PROCEDURE p_respuesta_ok(io_respuesta IN OUT y_respuesta,
                           i_datos      IN y_objeto DEFAULT NULL) IS
  BEGIN
    io_respuesta.codigo     := '0';
    io_respuesta.mensaje    := 'OK';
    io_respuesta.mensaje_bd := NULL;
    io_respuesta.datos      := i_datos;
  END;

  PROCEDURE p_respuesta_error(io_respuesta IN OUT y_respuesta,
                              i_codigo     IN VARCHAR2,
                              i_mensaje    IN VARCHAR2,
                              i_mensaje_bd IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    IF i_codigo = '0' THEN
      io_respuesta.codigo  := c_error_inesperado;
      io_respuesta.mensaje := k_error.f_mensaje_error(io_respuesta.codigo);
    ELSE
      io_respuesta.codigo  := substr(i_codigo, 1, 10);
      io_respuesta.mensaje := substr(i_mensaje, 1, 4000);
    END IF;
    io_respuesta.mensaje_bd := substr(i_mensaje_bd, 1, 4000);
    io_respuesta.datos      := NULL;
  END;

  FUNCTION f_objeto_parse_json(i_json IN CLOB) RETURN anydata IS
    functionresult anydata;
  BEGIN
    RETURN functionresult;
  END;

  FUNCTION f_objeto_to_json(i_objeto IN anydata) RETURN CLOB IS
    l_json     CLOB;
    l_typeinfo anytype;
    l_typecode PLS_INTEGER;
  BEGIN
    IF i_objeto IS NOT NULL THEN
      l_typecode := i_objeto.gettype(l_typeinfo);
      IF l_typecode = dbms_types.typecode_object THEN
        EXECUTE IMMEDIATE 'DECLARE
  l_retorno PLS_INTEGER;
  l_anydata anydata := :1;
  l_object  ' || i_objeto.gettypename || ';
  l_clob    CLOB;
BEGIN
  l_retorno := l_anydata.getobject(obj => l_object);
  :2        := l_object.to_json();
END;'
          USING IN i_objeto, OUT l_json;
      END IF;
    END IF;
    RETURN l_json;
  END;

  FUNCTION f_procesar_parametros(i_id_servicio IN NUMBER,
                                 i_parametros  IN CLOB) RETURN y_parametros IS
    l_parametros   y_parametros;
    l_parametro    y_parametro;
    l_json_object  json_object_t;
    l_json_element json_element_t;
  
    CURSOR c_servicio_parametros IS
      SELECT id_servicio,
             lower(nombre) nombre,
             direccion,
             tipo_dato,
             formato,
             obligatorio,
             valor_defecto
        FROM t_servicio_parametros
       WHERE activo = 'S'
         AND id_servicio = i_id_servicio
       ORDER BY orden;
  BEGIN
    -- Inicializa respuesta
    l_parametros := NEW y_parametros();
  
    IF i_parametros IS NULL OR dbms_lob.getlength(i_parametros) = 0 THEN
      l_json_object := json_object_t.parse('{}');
    ELSE
      l_json_object := json_object_t.parse(i_parametros);
    END IF;
  
    FOR par IN c_servicio_parametros LOOP
      IF par.obligatorio = 'S' THEN
        IF NOT l_json_object.has(par.nombre) THEN
          raise_application_error(-20000,
                                  'Parametro ' || par.nombre ||
                                  ' obligatorio');
        ELSE
          l_json_element := l_json_object.get(par.nombre);
          IF l_json_element.is_null THEN
            raise_application_error(-20000,
                                    'Parametro ' || par.nombre ||
                                    ' debe tener valor');
          END IF;
        END IF;
      END IF;
    
      l_parametro        := NEW y_parametro();
      l_parametro.nombre := par.nombre;
    
      CASE par.tipo_dato
        WHEN 'S' THEN
          -- String
          l_parametro.valor := anydata.convertvarchar2(l_json_object.get_string(par.nombre));
          IF l_parametro.valor.accessvarchar2 IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertvarchar2(par.valor_defecto);
          END IF;
        WHEN 'N' THEN
          -- Number
          l_parametro.valor := anydata.convertnumber(l_json_object.get_number(par.nombre));
          IF l_parametro.valor.accessnumber IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertnumber(to_number(par.valor_defecto));
          END IF;
        WHEN 'B' THEN
          -- Boolean
          l_parametro.valor := anydata.convertnumber(sys.diutil.bool_to_int(l_json_object.get_boolean(par.nombre)));
          IF l_parametro.valor.accessnumber IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertnumber(to_number(par.valor_defecto));
          END IF;
        WHEN 'D' THEN
          -- Date
          l_parametro.valor := anydata.convertdate(l_json_object.get_date(par.nombre));
          IF l_parametro.valor.accessdate IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertdate(to_date(par.valor_defecto,
                                                             'YYYY-MM-DD'));
          END IF;
        WHEN 'O' THEN
          -- Object
          l_parametro.valor := anydata.convertobject(y_dato.parse_json('{}'));
        ELSE
          raise_application_error(-20000, 'Tipo de dato no soportado');
      END CASE;
    
      l_parametros.extend;
      l_parametros(l_parametros.count) := l_parametro;
    END LOOP;
    RETURN l_parametros;
  END;

  FUNCTION f_valor_parametro(i_parametros IN y_parametros,
                             i_nombre     IN VARCHAR2) RETURN anydata IS
    l_valor anydata;
    i       INTEGER;
  BEGIN
    i := i_parametros.first;
    WHILE i IS NOT NULL AND l_valor IS NULL LOOP
      IF lower(i_parametros(i).nombre) = lower(i_nombre) THEN
        l_valor := i_parametros(i).valor;
      END IF;
      i := i_parametros.next(i);
    END LOOP;
    RETURN l_valor;
  END;

  FUNCTION f_procesar_servicio(i_id_servicio IN NUMBER,
                               i_parametros  IN CLOB) RETURN CLOB IS
    l_rsp CLOB;
  BEGIN
    -- Registra ejecución
    lp_registrar_ejecucion(i_id_servicio);
    -- Procesa servicio
    l_rsp := lf_procesar_servicio(i_id_servicio, i_parametros).to_json;
    -- Registra log con datos de entrada y salida
    lp_registrar_log(i_id_servicio, i_parametros, l_rsp);
    RETURN l_rsp;
  END;

END;
/
