CREATE OR REPLACE PACKAGE k_servicio IS

  -- Agrupa operaciones relacionadas con los Servicios Web del sistema
  --
  -- %author jmeza 17/3/2019 15:23:21

  TYPE y_parametros IS TABLE OF anydata NOT NULL INDEX BY VARCHAR2(100);

  FUNCTION lf_procesar_parametros(i_id_servicio IN NUMBER,
                                  i_parametros  IN CLOB) RETURN y_parametros;

  FUNCTION api_validar_credenciales(i_usuario IN VARCHAR2,
                                    i_clave   IN VARCHAR2) RETURN CLOB;

  FUNCTION api_iniciar_sesion(i_usuario IN VARCHAR2,
                              i_token   IN VARCHAR2) RETURN CLOB;

  FUNCTION api_finalizar_sesion(i_token IN VARCHAR2) RETURN CLOB;

  FUNCTION api_procesar_servicio(i_id_servicio IN NUMBER,
                                 i_parametros  IN CLOB) RETURN CLOB;

END;
/
CREATE OR REPLACE PACKAGE BODY k_servicio IS

  -- Excepciones
  ex_api_error EXCEPTION;

  FUNCTION lf_procesar_parametros(i_id_servicio IN NUMBER,
                                  i_parametros  IN CLOB) RETURN y_parametros IS
    l_parametros  y_parametros;
    l_json_object json_object_t;
    CURSOR c_servicio_parametros IS
      SELECT lower(nombre) nombre, tipo_dato
        FROM t_servicio_parametros
       WHERE id_servicio = i_id_servicio
         AND activo = 'S';
  BEGIN
    l_json_object := json_object_t.parse(i_parametros);
    FOR par IN c_servicio_parametros LOOP
      IF par.tipo_dato = 'S' THEN
        l_parametros(par.nombre) := anydata.convertvarchar2(l_json_object.get_string(par.nombre));
      END IF;
    END LOOP;
    RETURN l_parametros;
  END;

  FUNCTION lf_mensaje_error(i_id_error IN VARCHAR2) RETURN VARCHAR2 IS
    l_mensaje t_errores.mensaje%TYPE;
  BEGIN
    BEGIN
      SELECT mensaje
        INTO l_mensaje
        FROM t_errores
       WHERE id_error = i_id_error;
    EXCEPTION
      WHEN no_data_found THEN
        l_mensaje := 'Error no registrado';
    END;
    RETURN l_mensaje;
  END;

  PROCEDURE lp_respuesta_error(io_respuesta IN OUT y_respuesta,
                               i_codigo     IN VARCHAR2,
                               i_mensaje    IN VARCHAR2,
                               i_mensaje_bd IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    IF i_codigo = '0' THEN
      io_respuesta.codigo  := '999';
      io_respuesta.mensaje := lf_mensaje_error(io_respuesta.codigo);
    ELSE
      io_respuesta.codigo  := substr(i_codigo, 1, 10);
      io_respuesta.mensaje := substr(i_mensaje, 1, 2000);
    END IF;
    io_respuesta.mensaje_bd := substr(i_mensaje_bd, 1, 2000);
    io_respuesta.datos      := NULL;
  END;

  PROCEDURE lp_respuesta_ok(io_respuesta IN OUT y_respuesta,
                            i_datos      IN anydata DEFAULT NULL) IS
  BEGIN
    io_respuesta.codigo     := '0';
    io_respuesta.mensaje    := 'OK';
    io_respuesta.mensaje_bd := NULL;
    io_respuesta.datos      := nvl(i_datos,
                                   anydata.convertobject(NEW y_dato()));
  END;

  FUNCTION lf_validar_credenciales(i_usuario IN VARCHAR2,
                                   i_clave   IN VARCHAR2) RETURN y_respuesta IS
    resp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    resp := NEW y_respuesta();
  
    resp.lugar := 'Validando parametros';
    IF i_usuario IS NULL THEN
      lp_respuesta_error(resp, '1', 'Debe ingresar usuario');
      RAISE ex_api_error;
    END IF;
  
    IF i_clave IS NULL THEN
      lp_respuesta_error(resp, '2', 'Debe ingresar clave');
      RAISE ex_api_error;
    END IF;
  
    resp.lugar := 'Validando credenciales';
    IF NOT k_autenticacion.f_validar_credenciales(i_usuario, i_clave) THEN
      lp_respuesta_error(resp, '3', 'Credenciales invalidas');
      RAISE ex_api_error;
    END IF;
  
    lp_respuesta_ok(resp);
    RETURN resp;
  EXCEPTION
    WHEN ex_api_error THEN
      RETURN resp;
    WHEN OTHERS THEN
      lp_respuesta_error(resp, '999', lf_mensaje_error('999'), SQLERRM);
      RETURN resp;
  END;

  FUNCTION api_validar_credenciales(i_usuario IN VARCHAR2,
                                    i_clave   IN VARCHAR2) RETURN CLOB IS
    l_prms json_object_t;
    l_resp CLOB;
  BEGIN
    -- Log de entrada
    l_prms := json_object_t;
    l_prms.put('i_usuario', i_usuario);
    l_prms.put('i_clave', i_clave);
    plog.info(l_prms.to_clob);
    -- Proceso
    l_resp := lf_validar_credenciales(i_usuario, i_clave).to_json;
    -- Log de salida
    plog.info(l_resp);
    RETURN l_resp;
  END;

  FUNCTION lf_iniciar_sesion(i_usuario IN VARCHAR2,
                             i_token   IN VARCHAR2) RETURN y_respuesta IS
    resp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    resp := NEW y_respuesta();
  
    resp.lugar := 'Validando parametros';
    IF i_usuario IS NULL THEN
      lp_respuesta_error(resp, '1', 'Debe ingresar usuario');
      RAISE ex_api_error;
    END IF;
  
    IF i_token IS NULL THEN
      lp_respuesta_error(resp, '2', 'Debe ingresar token');
      RAISE ex_api_error;
    END IF;
  
    resp.lugar := 'Iniciando sesion';
    k_autenticacion.p_iniciar_sesion(i_usuario, i_token);
  
    lp_respuesta_ok(resp);
    RETURN resp;
  EXCEPTION
    WHEN ex_api_error THEN
      RETURN resp;
    WHEN OTHERS THEN
      IF k_error.f_tipo_error(SQLCODE) = k_error.user_defined_error THEN
        lp_respuesta_error(resp,
                           '998',
                           k_error.f_mensaje_error(SQLERRM, SQLCODE),
                           SQLERRM);
      ELSE
        lp_respuesta_error(resp, '999', lf_mensaje_error('999'), SQLERRM);
      END IF;
      RETURN resp;
  END;

  FUNCTION api_iniciar_sesion(i_usuario IN VARCHAR2,
                              i_token   IN VARCHAR2) RETURN CLOB IS
    l_prms json_object_t;
    l_resp CLOB;
  BEGIN
    -- Log de entrada
    l_prms := json_object_t;
    l_prms.put('i_usuario', i_usuario);
    l_prms.put('i_token', i_token);
    plog.info(l_prms.to_clob);
    -- Proceso
    l_resp := lf_iniciar_sesion(i_usuario, i_token).to_json;
    -- Log de salida
    plog.info(l_resp);
    RETURN l_resp;
  END;

  FUNCTION lf_finalizar_sesion(i_token IN VARCHAR2) RETURN y_respuesta IS
    resp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    resp := NEW y_respuesta();
  
    resp.lugar := 'Validando parametros';
    IF i_token IS NULL THEN
      lp_respuesta_error(resp, '1', 'Debe ingresar token');
      RAISE ex_api_error;
    END IF;
  
    resp.lugar := 'Finalizando sesion';
    k_autenticacion.p_finalizar_sesion(i_token);
  
    lp_respuesta_ok(resp);
    RETURN resp;
  EXCEPTION
    WHEN ex_api_error THEN
      RETURN resp;
    WHEN OTHERS THEN
      IF k_error.f_tipo_error(SQLCODE) = k_error.user_defined_error THEN
        lp_respuesta_error(resp,
                           '998',
                           k_error.f_mensaje_error(SQLERRM, SQLCODE),
                           SQLERRM);
      ELSE
        lp_respuesta_error(resp, '999', lf_mensaje_error('999'), SQLERRM);
      END IF;
      RETURN resp;
  END;

  FUNCTION api_finalizar_sesion(i_token IN VARCHAR2) RETURN CLOB IS
    l_prms json_object_t;
    l_resp CLOB;
  BEGIN
    -- Log de entrada
    l_prms := json_object_t;
    l_prms.put('i_token', i_token);
    plog.info(l_prms.to_clob);
    -- Proceso
    l_resp := lf_finalizar_sesion(i_token).to_json;
    -- Log de salida
    plog.info(l_resp);
    RETURN l_resp;
  END;

  FUNCTION api_procesar_servicio(i_id_servicio IN NUMBER,
                                 i_parametros  IN CLOB) RETURN CLOB IS
    l_resp CLOB;
  BEGIN
    -- Log de entrada
    plog.info(i_parametros);
    -- Proceso
    l_resp := 'Aca tiene que procesar el servicio';
    -- Log de salida
    plog.info(l_resp);
    RETURN l_resp;
  END;

BEGIN
  -- Initialization
  NULL;
END;
/
