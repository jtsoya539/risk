CREATE OR REPLACE PACKAGE k_servicio IS

  -- Agrupa operaciones relacionadas con los Servicios Web del sistema
  --
  -- %author jmeza 17/3/2019 15:23:21

  FUNCTION api_procesar_servicio(i_id_servicio IN NUMBER,
                                 i_parametros  IN CLOB) RETURN CLOB;

  FUNCTION gen_valor_parametro(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION gen_significado_codigo(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION aut_registrar_usuario(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION aut_registrar_clave(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION aut_cambiar_clave(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION aut_validar_credenciales(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION aut_validar_sesion(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION aut_iniciar_sesion(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION aut_finalizar_sesion(i_parametros IN y_parametros)
    RETURN y_respuesta;

END;
/
CREATE OR REPLACE PACKAGE BODY k_servicio IS

  -- Tipos de log
  c_log_entrada CONSTANT VARCHAR2(10) := 'ENTRADA';
  c_log_salida  CONSTANT VARCHAR2(10) := 'SALIDA';

  -- Errores
  c_error_inesperado CONSTANT VARCHAR2(10) := 'api9999';

  -- Excepciones
  ex_error_general            EXCEPTION;
  ex_error_parametro          EXCEPTION;
  ex_servicio_no_implementado EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_servicio_no_implementado, -6550);

  FUNCTION lf_procesar_parametros(i_id_servicio IN NUMBER,
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
            l_parametro.valor := anydata.convertnumber(par.valor_defecto);
          END IF;
        WHEN 'B' THEN
          -- Boolean
          l_parametro.valor := anydata.convertnumber(sys.diutil.bool_to_int(l_json_object.get_boolean(par.nombre)));
          IF l_parametro.valor.accessnumber IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertnumber(par.valor_defecto);
          END IF;
        WHEN 'D' THEN
          -- Date
          l_parametro.valor := anydata.convertdate(l_json_object.get_date(par.nombre));
          IF l_parametro.valor.accessdate IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertdate(par.valor_defecto);
          END IF;
        ELSE
          raise_application_error(-20000, 'Tipo de dato no soportado');
      END CASE;
    
      l_parametros.extend;
      l_parametros(l_parametros.count) := l_parametro;
    END LOOP;
    RETURN l_parametros;
  END;

  FUNCTION lf_valor_parametro(i_parametros IN y_parametros,
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

  PROCEDURE lp_registrar_log(i_id_servicio IN NUMBER,
                             i_tipo_log    IN VARCHAR2,
                             i_dato        IN CLOB) IS
  BEGIN
    plog.info(utl_lms.format_message('[%s][%s][%s]',
                                     to_char(i_id_servicio),
                                     i_tipo_log,
                                     dbms_lob.substr(i_dato)));
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

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

  PROCEDURE lp_respuesta_error(io_respuesta IN OUT y_respuesta,
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

  PROCEDURE lp_respuesta_ok(io_respuesta IN OUT y_respuesta,
                            i_datos      IN anydata DEFAULT NULL) IS
  BEGIN
    io_respuesta.codigo     := '0';
    io_respuesta.mensaje    := 'OK';
    io_respuesta.mensaje_bd := NULL;
    io_respuesta.datos      := i_datos;
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
        lp_respuesta_error(l_rsp,
                           'api0001',
                           'Servicio inexistente o inactivo');
        RAISE ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Procesando parametros del servicio';
    BEGIN
      l_prms := lf_procesar_parametros(i_id_servicio, i_parametros);
    EXCEPTION
      WHEN OTHERS THEN
        lp_respuesta_error(l_rsp,
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
      EXECUTE IMMEDIATE 'BEGIN :1 := K_SERVICIO.' || l_dominio_servicio || '_' ||
                        l_nombre_servicio || '(:2); END;'
        USING OUT l_rsp, IN l_prms;
    EXCEPTION
      WHEN ex_servicio_no_implementado THEN
        lp_respuesta_error(l_rsp,
                           'api0003',
                           'Servicio no implementado',
                           dbms_utility.format_error_stack);
        RAISE ex_error_general;
      WHEN OTHERS THEN
        lp_respuesta_error(l_rsp,
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
  
    lp_respuesta_ok(l_rsp, l_rsp.datos);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_parametro THEN
      RETURN l_rsp;
    WHEN ex_error_general THEN
      ROLLBACK;
      RETURN l_rsp;
    WHEN OTHERS THEN
      ROLLBACK;
      lp_respuesta_error(l_rsp,
                         c_error_inesperado,
                         k_error.f_mensaje_error(c_error_inesperado),
                         dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION api_procesar_servicio(i_id_servicio IN NUMBER,
                                 i_parametros  IN CLOB) RETURN CLOB IS
    l_rsp CLOB;
  BEGIN
    -- Log de entrada
    lp_registrar_log(i_id_servicio, c_log_entrada, i_parametros);
    -- Proceso
    lp_registrar_ejecucion(i_id_servicio);
    l_rsp := lf_procesar_servicio(i_id_servicio, i_parametros).to_json;
    -- Log de salida
    lp_registrar_log(i_id_servicio, c_log_salida, l_rsp);
    RETURN l_rsp;
  END;

  FUNCTION gen_valor_parametro(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp  y_respuesta;
    l_dato y_dato;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'parametro')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'gen0001', 'Debe ingresar parametro');
      RAISE ex_error_general;
    END IF;
  
    l_rsp.lugar := 'Obteniendo valor del parametro';
    l_dato.dato := k_util.f_valor_parametro(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                      'parametro')));
  
    IF l_dato.dato IS NULL THEN
      lp_respuesta_error(l_rsp, 'gen0002', 'Parametro inexistente');
      RAISE ex_error_general;
    END IF;
  
    lp_respuesta_ok(l_rsp, anydata.convertobject(l_dato));
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         c_error_inesperado,
                         k_error.f_mensaje_error(c_error_inesperado),
                         dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION gen_significado_codigo(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp  y_respuesta;
    l_dato y_dato;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'dominio')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'gen0001', 'Debe ingresar dominio');
      RAISE ex_error_general;
    END IF;
  
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'codigo')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'gen0002', 'Debe ingresar codigo');
      RAISE ex_error_general;
    END IF;
  
    l_rsp.lugar := 'Obteniendo significado';
    l_dato.dato := k_util.f_significado_codigo(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                         'dominio')),
                                               anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                         'codigo')));
  
    IF l_dato.dato IS NULL THEN
      lp_respuesta_error(l_rsp, 'gen0003', 'Significado inexistente');
      RAISE ex_error_general;
    END IF;
  
    lp_respuesta_ok(l_rsp, anydata.convertobject(l_dato));
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         c_error_inesperado,
                         k_error.f_mensaje_error(c_error_inesperado),
                         dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION aut_registrar_usuario(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'usuario')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'aut0001', 'Debe ingresar usuario');
      RAISE ex_error_general;
    END IF;
  
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'clave')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'aut0002', 'Debe ingresar clave');
      RAISE ex_error_general;
    END IF;
  
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'nombre')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'aut0003', 'Debe ingresar nombre');
      RAISE ex_error_general;
    END IF;
  
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'apellido')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'aut0004', 'Debe ingresar apellido');
      RAISE ex_error_general;
    END IF;
  
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                 'direccion_correo')) IS NULL THEN
      lp_respuesta_error(l_rsp,
                         'aut0005',
                         'Debe ingresar direccion de correo');
      RAISE ex_error_general;
    END IF;
  
    l_rsp.lugar := 'Registrando usuario';
    k_autenticacion.p_registrar_usuario(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                  'usuario')),
                                        anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                  'clave')),
                                        anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                  'nombre')),
                                        anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                  'apellido')),
                                        anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                  'direccion_correo')),
                                        anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                  'numero_telefono')));
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         c_error_inesperado,
                         CASE
                         k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                         k_error.c_user_defined_error THEN
                         utl_call_stack.error_msg(1) WHEN
                         k_error.c_oracle_predefined_error THEN
                         k_error.f_mensaje_error(c_error_inesperado) END,
                         dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION aut_registrar_clave(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    -- l_rsp.lugar := 'Validando parametros';
  
    l_rsp.lugar := 'Registrando clave';
    k_autenticacion.p_registrar_clave(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                'usuario')),
                                      anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                'clave')),
                                      anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                'tipo_clave')));
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         c_error_inesperado,
                         CASE
                         k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                         k_error.c_user_defined_error THEN
                         utl_call_stack.error_msg(1) WHEN
                         k_error.c_oracle_predefined_error THEN
                         k_error.f_mensaje_error(c_error_inesperado) END,
                         dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION aut_cambiar_clave(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    -- l_rsp.lugar := 'Validando parametros';
  
    l_rsp.lugar := 'Cambiando clave';
    k_autenticacion.p_cambiar_clave(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                              'usuario')),
                                    anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                              'clave_antigua')),
                                    anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                              'clave_nueva')),
                                    anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                              'tipo_clave')));
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         c_error_inesperado,
                         CASE
                         k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                         k_error.c_user_defined_error THEN
                         utl_call_stack.error_msg(1) WHEN
                         k_error.c_oracle_predefined_error THEN
                         k_error.f_mensaje_error(c_error_inesperado) END,
                         dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION aut_validar_credenciales(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'usuario')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'aut0001', 'Debe ingresar usuario');
      RAISE ex_error_general;
    END IF;
  
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'clave')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'aut0002', 'Debe ingresar clave');
      RAISE ex_error_general;
    END IF;
  
    l_rsp.lugar := 'Validando credenciales';
    IF NOT
        k_autenticacion.f_validar_credenciales(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                         'usuario')),
                                               anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                         'clave')),
                                               anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                         'tipo_clave'))) THEN
      lp_respuesta_error(l_rsp, 'aut0003', 'Credenciales invalidas');
      RAISE ex_error_general;
    END IF;
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         c_error_inesperado,
                         k_error.f_mensaje_error(c_error_inesperado),
                         dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION aut_validar_sesion(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'token')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'aut0001', 'Debe ingresar token');
      RAISE ex_error_general;
    END IF;
  
    l_rsp.lugar := 'Validando sesion';
    IF NOT
        k_autenticacion.f_sesion_activa(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                  'token'))) THEN
      lp_respuesta_error(l_rsp, 'aut0002', 'Sesion finalizada o expirada');
      RAISE ex_error_general;
    END IF;
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         c_error_inesperado,
                         k_error.f_mensaje_error(c_error_inesperado),
                         dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION aut_iniciar_sesion(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'usuario')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'aut0001', 'Debe ingresar usuario');
      RAISE ex_error_general;
    END IF;
  
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'token')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'aut0002', 'Debe ingresar token');
      RAISE ex_error_general;
    END IF;
  
    l_rsp.lugar := 'Iniciando sesion';
    k_autenticacion.p_iniciar_sesion(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                               'usuario')),
                                     anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                               'token')));
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         c_error_inesperado,
                         CASE
                         k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                         k_error.c_user_defined_error THEN
                         utl_call_stack.error_msg(1) WHEN
                         k_error.c_oracle_predefined_error THEN
                         k_error.f_mensaje_error(c_error_inesperado) END,
                         dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION aut_finalizar_sesion(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'token')) IS NULL THEN
      lp_respuesta_error(l_rsp, 'aut0001', 'Debe ingresar token');
      RAISE ex_error_general;
    END IF;
  
    l_rsp.lugar := 'Finalizando sesion';
    k_autenticacion.p_finalizar_sesion(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                 'token')));
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         c_error_inesperado,
                         CASE
                         k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                         k_error.c_user_defined_error THEN
                         utl_call_stack.error_msg(1) WHEN
                         k_error.c_oracle_predefined_error THEN
                         k_error.f_mensaje_error(c_error_inesperado) END,
                         dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

BEGIN
  -- Initialization
  NULL;
END;
/
