CREATE OR REPLACE PACKAGE k_sesion IS

  /**
  Agrupa operaciones relacionadas con las sesiones
  
  %author jtsoya539 27/3/2020 16:16:59
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

  -- Tipos de token
  c_access_token  CONSTANT CHAR(1) := 'A';
  c_refresh_token CONSTANT CHAR(1) := 'R';

  -- Excepciones
  ex_sesion_inexistente EXCEPTION;

  FUNCTION f_id_sesion(i_access_token IN VARCHAR2,
                       i_estado       IN VARCHAR2 DEFAULT NULL) RETURN NUMBER;

  FUNCTION f_validar_sesion(i_access_token IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION f_datos_sesion(i_id_sesion IN NUMBER) RETURN y_sesion;

  FUNCTION f_dispositivo_sesion(i_id_sesion IN NUMBER) RETURN VARCHAR2;

  FUNCTION f_tiempo_expiracion_token(i_id_aplicacion IN VARCHAR2,
                                     i_tipo_token    IN VARCHAR2)
    RETURN NUMBER;

  FUNCTION f_fecha_expiracion_access_token(i_access_token IN VARCHAR2)
    RETURN DATE;

  FUNCTION f_fecha_expiracion_refresh_token(i_id_aplicacion IN VARCHAR2)
    RETURN DATE;

  PROCEDURE p_validar_sesion(i_access_token IN VARCHAR2);

  PROCEDURE p_cambiar_estado(i_access_token IN VARCHAR2,
                             i_estado       IN VARCHAR2);

  PROCEDURE p_expirar_sesiones(i_id_usuario IN NUMBER);

END;
/
CREATE OR REPLACE PACKAGE BODY k_sesion IS

  FUNCTION f_id_sesion(i_access_token IN VARCHAR2,
                       i_estado       IN VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
    l_id_sesion t_sesiones.id_sesion%TYPE;
  BEGIN
    BEGIN
      SELECT id_sesion
        INTO l_id_sesion
        FROM t_sesiones
       WHERE access_token = i_access_token
         AND estado = nvl(i_estado, estado);
    EXCEPTION
      WHEN no_data_found THEN
        l_id_sesion := NULL;
      WHEN OTHERS THEN
        l_id_sesion := NULL;
    END;
    RETURN l_id_sesion;
  END;

  FUNCTION f_validar_sesion(i_access_token IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF f_id_sesion(i_access_token, 'A') IS NULL THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;

  FUNCTION f_datos_sesion(i_id_sesion IN NUMBER) RETURN y_sesion IS
    l_sesion y_sesion;
  BEGIN
    -- Inicializa respuesta
    l_sesion := NEW y_sesion();
  
    -- Buscando datos de la sesion
    BEGIN
      SELECT id_sesion,
             estado,
             access_token,
             refresh_token,
             f_tiempo_expiracion_token(id_aplicacion, c_access_token),
             f_tiempo_expiracion_token(id_aplicacion, c_refresh_token)
        INTO l_sesion.id_sesion,
             l_sesion.estado,
             l_sesion.access_token,
             l_sesion.refresh_token,
             l_sesion.tiempo_expiracion_access_token,
             l_sesion.tiempo_expiracion_refresh_token
        FROM t_sesiones
       WHERE id_sesion = i_id_sesion;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000, 'Sesión inexistente');
      WHEN OTHERS THEN
        raise_application_error(-20000,
                                'Error al buscar datos de la sesión');
    END;
  
    RETURN l_sesion;
  END;

  FUNCTION f_dispositivo_sesion(i_id_sesion IN NUMBER) RETURN VARCHAR2 IS
    l_id_dispositivo t_sesiones.id_dispositivo%TYPE;
  BEGIN
    -- Buscando datos de la sesion
    BEGIN
      SELECT id_dispositivo
        INTO l_id_dispositivo
        FROM t_sesiones
       WHERE id_sesion = i_id_sesion;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000, 'Sesión inexistente');
      WHEN OTHERS THEN
        raise_application_error(-20000,
                                'Error al buscar datos de la sesión');
    END;
  
    RETURN l_id_dispositivo;
  END;

  FUNCTION f_tiempo_expiracion_token(i_id_aplicacion IN VARCHAR2,
                                     i_tipo_token    IN VARCHAR2)
    RETURN NUMBER IS
    l_tiempo_expiracion_token t_aplicaciones.tiempo_expiracion_access_token%TYPE;
  BEGIN
    -- Busca el tiempo de expiración configurado para la aplicación
    BEGIN
      SELECT CASE i_tipo_token
               WHEN c_refresh_token THEN -- Refresh Token
                tiempo_expiracion_refresh_token
               WHEN c_access_token THEN -- Access Token
                tiempo_expiracion_access_token
               ELSE
                NULL
             END
        INTO l_tiempo_expiracion_token
        FROM t_aplicaciones
       WHERE id_aplicacion = i_id_aplicacion;
    EXCEPTION
      WHEN no_data_found THEN
        l_tiempo_expiracion_token := NULL;
      WHEN OTHERS THEN
        l_tiempo_expiracion_token := NULL;
    END;
  
    -- Si no encuentra, busca el tiempo de expiración configurado a nivel general
    IF l_tiempo_expiracion_token IS NULL THEN
      l_tiempo_expiracion_token := CASE i_tipo_token
                                     WHEN c_refresh_token THEN -- Refresh Token
                                      to_number(k_util.f_valor_parametro('TIEMPO_EXPIRACION_REFRESH_TOKEN'))
                                     WHEN c_access_token THEN -- Access Token
                                      to_number(k_util.f_valor_parametro('TIEMPO_EXPIRACION_ACCESS_TOKEN'))
                                     ELSE
                                      NULL
                                   END;
    END IF;
  
    RETURN l_tiempo_expiracion_token;
  END;

  FUNCTION f_fecha_expiracion_access_token(i_access_token IN VARCHAR2)
    RETURN DATE IS
    l_exp          NUMBER;
    l_payload_json json_object_t;
  BEGIN
    l_payload_json := json_object_t.parse(utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(k_cadena.f_valor_posicion(i_access_token,
                                                                                                                                          2,
                                                                                                                                          '.')))));
    l_exp          := l_payload_json.get_number('exp');
    RETURN to_date('19700101', 'YYYYMMDD') +((l_exp +
                                             ((to_number(substr(tz_offset(sessiontimezone),
                                                                 1,
                                                                 3)) + 0) * 3600)) /
                                             86400);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  FUNCTION f_fecha_expiracion_refresh_token(i_id_aplicacion IN VARCHAR2)
    RETURN DATE IS
  BEGIN
    RETURN SYSDATE +(f_tiempo_expiracion_token(i_id_aplicacion,
                                               c_refresh_token) / 24);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  PROCEDURE p_validar_sesion(i_access_token IN VARCHAR2) IS
  BEGIN
    IF NOT f_validar_sesion(i_access_token) THEN
      raise_application_error(-20000, 'Sesión finalizada o expirada');
    END IF;
  END;

  PROCEDURE p_cambiar_estado(i_access_token IN VARCHAR2,
                             i_estado       IN VARCHAR2) IS
    l_id_sesion      t_sesiones.id_sesion%TYPE;
    l_id_dispositivo t_sesiones.id_dispositivo%TYPE;
    l_id_usuario     t_usuarios.id_usuario%TYPE;
  BEGIN
    -- Busca sesion
    l_id_sesion      := f_id_sesion(i_access_token);
    l_id_dispositivo := f_dispositivo_sesion(l_id_sesion);
  
    IF l_id_sesion IS NULL THEN
      RAISE ex_sesion_inexistente;
    END IF;
  
    -- Actualiza sesion
    UPDATE t_sesiones
       SET estado = i_estado
     WHERE id_sesion = l_id_sesion
       AND estado <> i_estado
    RETURNING id_usuario INTO l_id_usuario;
  
    $if k_modulo.c_instalado_msj $then
    IF l_id_usuario IS NOT NULL AND i_estado IN ('X', 'I', 'F') THEN
      k_dispositivo.p_desuscribir_notificacion_usuario(l_id_dispositivo,
                                                       l_id_usuario);
    END IF;
    $end
  EXCEPTION
    WHEN ex_sesion_inexistente THEN
      /*raise_application_error(-20000, 'Sesion inexistente');*/
      NULL;
  END;

  PROCEDURE p_expirar_sesiones(i_id_usuario IN NUMBER) IS
  BEGIN
    UPDATE t_sesiones a
       SET a.estado = 'X' -- EXPIRADO
     WHERE a.estado = 'A' -- ACTIVO
       AND a.fecha_expiracion_access_token < SYSDATE
       AND a.id_usuario = nvl(i_id_usuario, a.id_usuario);
  END;

END;
/
