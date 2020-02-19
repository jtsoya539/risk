CREATE OR REPLACE PACKAGE k_servicio IS

  -- Agrupa operaciones relacionadas con los Servicios Web del sistema
  --
  -- %author jmeza 17/3/2019 15:23:21

  FUNCTION api_procesar_servicio(i_id_servicio IN NUMBER,
                                 i_parametros  IN CLOB) RETURN CLOB;

  FUNCTION aut_registrar_usuario(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION aut_registrar_clave(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION aut_cambiar_clave(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION aut_validar_credenciales(i_parametros IN y_parametros)
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

  -- Excepciones
  ex_api_error EXCEPTION;

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
  
    l_json_object := json_object_t.parse(i_parametros);
  
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
      io_respuesta.codigo  := '999';
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
  
    l_rsp.lugar := 'Buscando nombre del servicio';
    BEGIN
      SELECT upper(nombre), upper(dominio)
        INTO l_nombre_servicio, l_dominio_servicio
        FROM t_servicios
       WHERE activo = 'S'
         AND id_servicio = i_id_servicio;
    EXCEPTION
      WHEN no_data_found THEN
        lp_respuesta_error(l_rsp, '1', 'Servicio inexistente o inactivo');
        RAISE ex_api_error;
    END;
  
    l_rsp.lugar := 'Procesando parametros del servicio';
    BEGIN
      l_prms := lf_procesar_parametros(i_id_servicio, i_parametros);
    EXCEPTION
      WHEN OTHERS THEN
        lp_respuesta_error(l_rsp,
                           '2',
                           CASE k_error.f_tipo_excepcion(SQLCODE) WHEN
                           k_error.oracle_predefined_error THEN
                           'Error al procesar parametros del servicio' WHEN
                           k_error.user_defined_error THEN
                           k_error.f_mensaje_excepcion(SQLERRM, SQLCODE) END,
                           SQLERRM);
        RAISE ex_api_error;
    END;
  
    l_rsp.lugar := 'Procesando servicio';
    EXECUTE IMMEDIATE 'BEGIN :1 := K_SERVICIO.' || l_dominio_servicio || '_' ||
                      l_nombre_servicio || '(:2); END;'
      USING OUT l_rsp, IN l_prms;
  
    IF l_rsp.codigo <> '0' THEN
      RAISE ex_api_error;
    END IF;
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_api_error THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         '999',
                         k_error.f_mensaje_error('999'),
                         SQLERRM);
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

  FUNCTION aut_registrar_usuario(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    -- l_rsp.lugar := 'Validando parametros';
  
    l_rsp.lugar := 'Registrando usuario';
    k_autenticacion.p_registrar_usuario(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                  'usuario')),
                                        anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                  'clave')));
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_api_error THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         '999',
                         CASE k_error.f_tipo_excepcion(SQLCODE) WHEN
                         k_error.oracle_predefined_error THEN
                         k_error.f_mensaje_error('999') WHEN
                         k_error.user_defined_error THEN
                         k_error.f_mensaje_excepcion(SQLERRM, SQLCODE) END,
                         SQLERRM);
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
    WHEN ex_api_error THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         '999',
                         CASE k_error.f_tipo_excepcion(SQLCODE) WHEN
                         k_error.oracle_predefined_error THEN
                         k_error.f_mensaje_error('999') WHEN
                         k_error.user_defined_error THEN
                         k_error.f_mensaje_excepcion(SQLERRM, SQLCODE) END,
                         SQLERRM);
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
    WHEN ex_api_error THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         '999',
                         CASE k_error.f_tipo_excepcion(SQLCODE) WHEN
                         k_error.oracle_predefined_error THEN
                         k_error.f_mensaje_error('999') WHEN
                         k_error.user_defined_error THEN
                         k_error.f_mensaje_excepcion(SQLERRM, SQLCODE) END,
                         SQLERRM);
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
      lp_respuesta_error(l_rsp, '1', 'Debe ingresar usuario');
      RAISE ex_api_error;
    END IF;
  
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'clave')) IS NULL THEN
      lp_respuesta_error(l_rsp, '2', 'Debe ingresar clave');
      RAISE ex_api_error;
    END IF;
  
    l_rsp.lugar := 'Validando credenciales';
    IF NOT
        k_autenticacion.f_validar_credenciales(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                         'usuario')),
                                               anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                         'clave')),
                                               anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                         'tipo_clave'))) THEN
      lp_respuesta_error(l_rsp, '3', 'Credenciales invalidas');
      RAISE ex_api_error;
    END IF;
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_api_error THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         '999',
                         k_error.f_mensaje_error('999'),
                         SQLERRM);
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
      lp_respuesta_error(l_rsp, '1', 'Debe ingresar usuario');
      RAISE ex_api_error;
    END IF;
  
    IF anydata.accessvarchar2(lf_valor_parametro(i_parametros, 'token')) IS NULL THEN
      lp_respuesta_error(l_rsp, '2', 'Debe ingresar token');
      RAISE ex_api_error;
    END IF;
  
    l_rsp.lugar := 'Iniciando sesion';
    k_autenticacion.p_iniciar_sesion(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                               'usuario')),
                                     anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                               'token')));
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_api_error THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         '999',
                         CASE k_error.f_tipo_excepcion(SQLCODE) WHEN
                         k_error.oracle_predefined_error THEN
                         k_error.f_mensaje_error('999') WHEN
                         k_error.user_defined_error THEN
                         k_error.f_mensaje_excepcion(SQLERRM, SQLCODE) END,
                         SQLERRM);
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
      lp_respuesta_error(l_rsp, '1', 'Debe ingresar token');
      RAISE ex_api_error;
    END IF;
  
    l_rsp.lugar := 'Finalizando sesion';
    k_autenticacion.p_finalizar_sesion(anydata.accessvarchar2(lf_valor_parametro(i_parametros,
                                                                                 'token')));
  
    lp_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_api_error THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      lp_respuesta_error(l_rsp,
                         '999',
                         CASE k_error.f_tipo_excepcion(SQLCODE) WHEN
                         k_error.oracle_predefined_error THEN
                         k_error.f_mensaje_error('999') WHEN
                         k_error.user_defined_error THEN
                         k_error.f_mensaje_excepcion(SQLERRM, SQLCODE) END,
                         SQLERRM);
      RETURN l_rsp;
  END;

BEGIN
  -- Initialization
  NULL;
END;
/
