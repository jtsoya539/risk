CREATE OR REPLACE PACKAGE k_autenticacion IS

  /**
  Agrupa operaciones relacionadas con la autenticacion de usuarios
  
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

  c_clave_acceso        CONSTANT CHAR(1) := 'A';
  c_clave_transaccional CONSTANT CHAR(1) := 'T';

  c_access_token  CONSTANT CHAR(1) := 'A';
  c_refresh_token CONSTANT CHAR(1) := 'R';

  FUNCTION f_id_aplicacion(i_clave_aplicacion IN VARCHAR2,
                           i_activo           IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2;

  FUNCTION f_tiempo_expiracion_token(i_id_aplicacion IN VARCHAR2,
                                     i_tipo_token    IN VARCHAR2)
    RETURN NUMBER;

  PROCEDURE p_validar_clave(i_usuario    IN VARCHAR2,
                            i_clave      IN VARCHAR2,
                            i_tipo_clave IN CHAR DEFAULT 'A');

  PROCEDURE p_registrar_usuario(i_usuario          IN VARCHAR2,
                                i_clave            IN VARCHAR2,
                                i_nombre           IN VARCHAR2,
                                i_apellido         IN VARCHAR2,
                                i_direccion_correo IN VARCHAR2,
                                i_numero_telefono  IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_registrar_clave(i_usuario    IN VARCHAR2,
                              i_clave      IN VARCHAR2,
                              i_tipo_clave IN CHAR DEFAULT 'A');

  PROCEDURE p_cambiar_clave(i_usuario       IN VARCHAR2,
                            i_clave_antigua IN VARCHAR2,
                            i_clave_nueva   IN VARCHAR2,
                            i_tipo_clave    IN CHAR DEFAULT 'A');

  FUNCTION f_validar_credenciales(i_usuario    IN VARCHAR2,
                                  i_clave      IN VARCHAR2,
                                  i_tipo_clave IN CHAR DEFAULT 'A')
    RETURN BOOLEAN;

  PROCEDURE p_validar_credenciales(i_usuario    IN VARCHAR2,
                                   i_clave      IN VARCHAR2,
                                   i_tipo_clave IN CHAR DEFAULT 'A');

  FUNCTION f_generar_clave_aplicacion RETURN VARCHAR2;

  FUNCTION f_validar_clave_aplicacion(i_clave_aplicacion IN VARCHAR2)
    RETURN BOOLEAN;

  PROCEDURE p_validar_clave_aplicacion(i_clave_aplicacion IN VARCHAR2);

  FUNCTION f_iniciar_sesion(i_clave_aplicacion  IN VARCHAR2,
                            i_usuario           IN VARCHAR2,
                            i_access_token      IN VARCHAR2,
                            i_refresh_token     IN VARCHAR2,
                            i_token_dispositivo IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION f_refrescar_sesion(i_clave_aplicacion      IN VARCHAR2,
                              i_access_token_antiguo  IN VARCHAR2,
                              i_refresh_token_antiguo IN VARCHAR2,
                              i_access_token_nuevo    IN VARCHAR2,
                              i_refresh_token_nuevo   IN VARCHAR2)
    RETURN NUMBER;

  PROCEDURE p_cambiar_estado_sesion(i_access_token IN VARCHAR2,
                                    i_estado       IN VARCHAR2);

  FUNCTION f_sesion_activa(i_access_token IN VARCHAR2) RETURN BOOLEAN;

  PROCEDURE p_sesion_activa(i_access_token IN VARCHAR2);

  PROCEDURE p_editar_usuario(i_usuario_antiguo  IN VARCHAR2,
                             i_usuario_nuevo    IN VARCHAR2,
                             i_nombre           IN VARCHAR2,
                             i_apellido         IN VARCHAR2,
                             i_direccion_correo IN VARCHAR2,
                             i_numero_telefono  IN VARCHAR2 DEFAULT NULL);

END;
/
CREATE OR REPLACE PACKAGE BODY k_autenticacion IS

  c_algoritmo      CONSTANT PLS_INTEGER := dbms_crypto.hmac_sh1;
  c_iteraciones    CONSTANT PLS_INTEGER := 4096;
  c_longitud_bytes CONSTANT PLS_INTEGER := 32;

  c_cantidad_intentos_permitidos CONSTANT PLS_INTEGER := 3;

  -- Excepciones
  ex_credenciales_invalidas EXCEPTION;
  ex_tokens_invalidos       EXCEPTION;
  ex_usuario_inexistente    EXCEPTION;
  ex_sesion_inexistente     EXCEPTION;

  -- https://mikepargeter.wordpress.com/2012/11/26/pbkdf2-in-oracle
  -- https://www.ietf.org/rfc/rfc6070.txt
  FUNCTION pbkdf2(p_password   IN VARCHAR2,
                  p_salt       IN VARCHAR2,
                  p_count      IN INTEGER,
                  p_key_length IN INTEGER) RETURN VARCHAR2 IS
    l_block_count INTEGER;
    l_last        RAW(32767);
    l_xorsum      RAW(32767);
    l_result      RAW(32767);
  BEGIN
    -- SHA-1   ==> 20 bytes
    -- SHA-256 ==> 32 bytes
    l_block_count := ceil(p_key_length / 20);
    FOR i IN 1 .. l_block_count LOOP
      l_last   := utl_raw.concat(utl_raw.cast_to_raw(p_salt),
                                 utl_raw.cast_from_binary_integer(i,
                                                                  utl_raw.big_endian));
      l_xorsum := NULL;
      FOR j IN 1 .. p_count LOOP
        l_last := dbms_crypto.mac(l_last,
                                  c_algoritmo,
                                  utl_raw.cast_to_raw(p_password));
        IF l_xorsum IS NULL THEN
          l_xorsum := l_last;
        ELSE
          l_xorsum := utl_raw.bit_xor(l_xorsum, l_last);
        END IF;
      END LOOP;
      l_result := utl_raw.concat(l_result, l_xorsum);
    END LOOP;
    RETURN rawtohex(utl_raw.substr(l_result, 1, p_key_length));
  END;

  FUNCTION lf_id_usuario(i_alias IN VARCHAR2) RETURN NUMBER IS
    l_id_usuario t_usuarios.id_usuario%TYPE;
  BEGIN
    BEGIN
      SELECT id_usuario
        INTO l_id_usuario
        FROM t_usuarios
       WHERE alias = i_alias;
    EXCEPTION
      WHEN no_data_found THEN
        l_id_usuario := NULL;
      WHEN OTHERS THEN
        l_id_usuario := NULL;
    END;
    RETURN l_id_usuario;
  END;

  FUNCTION lf_id_sesion(i_access_token IN VARCHAR2) RETURN NUMBER IS
    l_id_sesion t_sesiones.id_sesion%TYPE;
  BEGIN
    BEGIN
      SELECT id_sesion
        INTO l_id_sesion
        FROM t_sesiones
       WHERE access_token = i_access_token;
    EXCEPTION
      WHEN no_data_found THEN
        l_id_sesion := NULL;
      WHEN OTHERS THEN
        l_id_sesion := NULL;
    END;
    RETURN l_id_sesion;
  END;

  PROCEDURE lp_registrar_intento_fallido(i_id_usuario IN NUMBER,
                                         i_tipo       IN CHAR) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE t_usuario_claves
       SET cantidad_intentos_fallidos = CASE
                                          WHEN nvl(cantidad_intentos_fallidos,
                                                   0) >=
                                               c_cantidad_intentos_permitidos THEN
                                           cantidad_intentos_fallidos
                                          ELSE
                                           nvl(cantidad_intentos_fallidos, 0) + 1
                                        END,
           estado = CASE
                      WHEN nvl(cantidad_intentos_fallidos, 0) >=
                           c_cantidad_intentos_permitidos THEN
                       'B'
                      ELSE
                       estado
                    END
     WHERE id_usuario = i_id_usuario
       AND tipo = i_tipo;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  PROCEDURE lp_registrar_autenticacion(i_id_usuario IN NUMBER,
                                       i_tipo       IN CHAR) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE t_usuario_claves
       SET cantidad_intentos_fallidos = 0,
           fecha_ultima_autenticacion = SYSDATE,
           estado = CASE
                      WHEN nvl(estado, 'N') = 'N' THEN
                       'A'
                      ELSE
                       estado
                    END
     WHERE id_usuario = i_id_usuario
       AND tipo = i_tipo;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  FUNCTION lf_fecha_expiracion_access_token(i_access_token IN VARCHAR2)
    RETURN DATE IS
    l_exp          NUMBER;
    l_payload_json json_object_t;
  BEGIN
    l_payload_json := json_object_t.parse(utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(k_util.f_valor_posicion(i_access_token,
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

  FUNCTION lf_fecha_expiracion_refresh_token(i_id_aplicacion IN VARCHAR2)
    RETURN DATE IS
  BEGIN
    RETURN SYSDATE +(f_tiempo_expiracion_token(i_id_aplicacion,
                                               c_refresh_token) / 24);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  FUNCTION f_id_aplicacion(i_clave_aplicacion IN VARCHAR2,
                           i_activo           IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2 IS
    l_id_aplicacion t_aplicaciones.id_aplicacion%TYPE;
  BEGIN
    BEGIN
      SELECT id_aplicacion
        INTO l_id_aplicacion
        FROM t_aplicaciones
       WHERE clave = i_clave_aplicacion
         AND activo = nvl(i_activo, activo);
    EXCEPTION
      WHEN no_data_found THEN
        l_id_aplicacion := NULL;
      WHEN OTHERS THEN
        l_id_aplicacion := NULL;
    END;
    RETURN l_id_aplicacion;
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

  PROCEDURE p_validar_clave(i_usuario    IN VARCHAR2,
                            i_clave      IN VARCHAR2,
                            i_tipo_clave IN CHAR DEFAULT 'A') IS
    l_lon_minima       NUMBER(6) := to_number(k_util.f_valor_parametro('LONGITUD_MINIMA_CLAVE_' ||
                                                                       k_util.f_significado_codigo('TIPO_CLAVE',
                                                                                                   i_tipo_clave)));
    l_lon_clave        NUMBER(6) := length(i_clave);
    l_can_letras       NUMBER(6) := 0;
    l_can_letras_may   NUMBER(6) := 0;
    l_can_letras_min   NUMBER(6) := 0;
    l_can_numeros      NUMBER(6) := 0;
    l_can_otros        NUMBER(6) := 0;
    l_can_repeticiones NUMBER(6) := 0;
    l_caracter         VARCHAR2(1);
  BEGIN
    -- Valida la longitud de la clave
    IF l_lon_clave < l_lon_minima THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos ' ||
                              to_char(l_lon_minima) || ' caracteres');
    END IF;
  
    FOR i IN 1 .. l_lon_clave LOOP
      l_caracter := substr(i_clave, i, 1);
    
      -- Cuenta la cantidad de mayusculas, minusculas, numeros y caracteres especiales
      IF l_caracter BETWEEN 'A' AND 'Z' THEN
        l_can_letras_may := l_can_letras_may + 1;
      ELSIF l_caracter BETWEEN 'a' AND 'z' THEN
        l_can_letras_min := l_can_letras_min + 1;
      ELSIF l_caracter BETWEEN '0' AND '9' THEN
        l_can_numeros := l_can_numeros + 1;
      ELSE
        l_can_otros := l_can_otros + 1;
      END IF;
    
      -- Valida la cantidad de repeticiones de un mismo caracter
      l_can_repeticiones := 0;
      FOR j IN i .. l_lon_clave LOOP
        IF l_caracter = substr(i_clave, j, 1) THEN
          l_can_repeticiones := l_can_repeticiones + 1;
        END IF;
      END LOOP;
      IF l_can_repeticiones > 2 THEN
        raise_application_error(-20000,
                                'La clave no puede contener más de 2 caracteres iguales');
      END IF;
    END LOOP;
  
    l_can_letras := l_can_letras_min + l_can_letras_may;
  
    -- Valida que la clave no sea igual al usuario
    IF i_clave = i_usuario THEN
      raise_application_error(-20000,
                              'La clave no puede ser igual al usuario');
    END IF;
    -- Valida que la clave no contenga el usuario
    IF instr(upper(i_clave), upper(i_usuario)) > 0 THEN
      raise_application_error(-20000,
                              'La clave no debe contener el usuario');
    END IF;
  
    -- Valida la cantidad de letras
    IF l_can_letras < 3 THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos 3 letras del abecedario');
    END IF;
    -- Valida la cantidad de letras mayusculas
    IF l_can_letras_may = 0 THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos 1 letra mayúscula');
    END IF;
    -- Valida la cantidad de letras minusculas
    IF l_can_letras_min = 0 THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos 1 letra minúscula');
    END IF;
    -- Valida la cantidad de numeros
    IF l_can_numeros = 0 THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos 1 número');
    END IF;
    -- Valida la cantidad de caracteres especiales
    IF l_can_otros = 0 THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos 1 caracter especial');
    END IF;
    -- Valida caracteres no permitidos
    IF instr(i_clave, '&') > 0 THEN
      raise_application_error(-20000,
                              'La clave no puede contener el caracter "&"');
    END IF;
  END;

  PROCEDURE p_registrar_usuario(i_usuario          IN VARCHAR2,
                                i_clave            IN VARCHAR2,
                                i_nombre           IN VARCHAR2,
                                i_apellido         IN VARCHAR2,
                                i_direccion_correo IN VARCHAR2,
                                i_numero_telefono  IN VARCHAR2 DEFAULT NULL) IS
    l_id_persona t_personas.id_persona%TYPE;
    l_id_usuario t_usuarios.id_usuario%TYPE;
  BEGIN
    -- Valida clave
    p_validar_clave(i_usuario, i_clave, c_clave_acceso);
  
    -- Inserta persona
    INSERT INTO t_personas
      (nombre,
       apellido,
       nombre_completo,
       tipo_persona,
       tipo_documento,
       numero_documento,
       id_pais,
       fecha_nacimiento)
    VALUES
      (i_nombre,
       i_apellido,
       i_nombre || ' ' || i_apellido,
       'F',
       NULL,
       NULL,
       NULL,
       NULL)
    RETURNING id_persona INTO l_id_persona;
  
    -- Inserta usuario
    INSERT INTO t_usuarios
      (alias, id_persona, estado, direccion_correo, numero_telefono)
    VALUES
      (i_usuario, l_id_persona, 'A', i_direccion_correo, i_numero_telefono)
    RETURNING id_usuario INTO l_id_usuario;
  
    INSERT INTO t_rol_usuarios
      (id_rol, id_usuario)
      SELECT id_rol, l_id_usuario
        FROM t_roles
       WHERE nombre = k_util.f_valor_parametro('NOMBRE_ROL_DEFECTO');
  
    p_registrar_clave(i_usuario, i_clave, c_clave_acceso);
  EXCEPTION
    WHEN dup_val_on_index THEN
      raise_application_error(-20000, 'Usuario ya existe');
  END;

  PROCEDURE p_registrar_clave(i_usuario    IN VARCHAR2,
                              i_clave      IN VARCHAR2,
                              i_tipo_clave IN CHAR DEFAULT 'A') IS
    l_id_usuario t_usuarios.id_usuario%TYPE;
    l_hash       t_usuario_claves.hash%TYPE;
    l_salt       t_usuario_claves.salt%TYPE;
  BEGIN
    -- Valida clave
    p_validar_clave(i_usuario, i_clave, i_tipo_clave);
  
    -- Busca usuario
    l_id_usuario := lf_id_usuario(i_usuario);
  
    IF l_id_usuario IS NULL THEN
      RAISE ex_usuario_inexistente;
    END IF;
  
    -- Genera salt
    l_salt := rawtohex(dbms_crypto.randombytes(c_longitud_bytes));
    -- Genera hash
    l_hash := pbkdf2(i_clave, l_salt, c_iteraciones, c_longitud_bytes);
  
    -- Inserta clave de usuario
    INSERT INTO t_usuario_claves
      (id_usuario,
       tipo,
       estado,
       HASH,
       salt,
       algoritmo,
       iteraciones,
       cantidad_intentos_fallidos,
       fecha_ultima_autenticacion)
    VALUES
      (l_id_usuario,
       i_tipo_clave,
       'N',
       l_hash,
       l_salt,
       c_algoritmo,
       c_iteraciones,
       0,
       NULL);
  EXCEPTION
    WHEN ex_usuario_inexistente THEN
      raise_application_error(-20000, 'Usuario inexistente');
    WHEN dup_val_on_index THEN
      raise_application_error(-20000,
                              'Usuario ya tiene una clave registrada');
  END;

  PROCEDURE p_cambiar_clave(i_usuario       IN VARCHAR2,
                            i_clave_antigua IN VARCHAR2,
                            i_clave_nueva   IN VARCHAR2,
                            i_tipo_clave    IN CHAR DEFAULT 'A') IS
    l_id_usuario t_usuarios.id_usuario%TYPE;
    l_hash       t_usuario_claves.hash%TYPE;
    l_salt       t_usuario_claves.salt%TYPE;
  BEGIN
    -- Valida clave
    p_validar_clave(i_usuario, i_clave_nueva, i_tipo_clave);
  
    -- Busca usuario
    l_id_usuario := lf_id_usuario(i_usuario);
  
    IF l_id_usuario IS NULL THEN
      RAISE ex_usuario_inexistente;
    END IF;
  
    IF NOT f_validar_credenciales(i_usuario, i_clave_antigua, i_tipo_clave) THEN
      RAISE ex_credenciales_invalidas;
    END IF;
  
    -- Genera salt
    l_salt := rawtohex(dbms_crypto.randombytes(c_longitud_bytes));
    -- Genera hash
    l_hash := pbkdf2(i_clave_nueva, l_salt, c_iteraciones, c_longitud_bytes);
  
    -- Actualiza clave de usuario
    UPDATE t_usuario_claves
       SET HASH                       = l_hash,
           salt                       = l_salt,
           algoritmo                  = c_algoritmo,
           iteraciones                = c_iteraciones,
           estado                     = 'N',
           cantidad_intentos_fallidos = 0,
           fecha_ultima_autenticacion = NULL
     WHERE id_usuario = l_id_usuario
       AND tipo = i_tipo_clave
       AND estado IN ('N', 'A');
    /*IF SQL%NOTFOUND THEN
      RAISE ex_credenciales_invalidas;
    END IF;*/
  EXCEPTION
    WHEN ex_usuario_inexistente THEN
      raise_application_error(-20000, 'Credenciales invalidas');
    WHEN ex_credenciales_invalidas THEN
      raise_application_error(-20000, 'Credenciales invalidas');
    WHEN OTHERS THEN
      lp_registrar_intento_fallido(l_id_usuario, i_tipo_clave);
      raise_application_error(-20000, 'Credenciales invalidas');
  END;

  FUNCTION f_validar_credenciales(i_usuario    IN VARCHAR2,
                                  i_clave      IN VARCHAR2,
                                  i_tipo_clave IN CHAR DEFAULT 'A')
    RETURN BOOLEAN IS
    l_id_usuario  t_usuarios.id_usuario%TYPE;
    l_hash        t_usuario_claves.hash%TYPE;
    l_salt        t_usuario_claves.salt%TYPE;
    l_iteraciones t_usuario_claves.iteraciones%TYPE;
  BEGIN
    -- Busca usuario
    l_id_usuario := lf_id_usuario(i_usuario);
  
    IF l_id_usuario IS NULL THEN
      RAISE ex_usuario_inexistente;
    END IF;
  
    BEGIN
      SELECT c.hash, c.salt, c.iteraciones
        INTO l_hash, l_salt, l_iteraciones
        FROM t_usuario_claves c
       WHERE c.id_usuario = l_id_usuario
         AND c.tipo = i_tipo_clave
         AND c.estado IN ('N', 'A');
    EXCEPTION
      WHEN OTHERS THEN
        RAISE ex_credenciales_invalidas;
    END;
  
    IF l_hash <> pbkdf2(i_clave,
                        l_salt,
                        l_iteraciones,
                        utl_raw.length(hextoraw(l_hash))) THEN
      RAISE ex_credenciales_invalidas;
    END IF;
  
    lp_registrar_autenticacion(l_id_usuario, i_tipo_clave);
    RETURN TRUE;
  EXCEPTION
    WHEN ex_usuario_inexistente THEN
      RETURN FALSE;
    WHEN ex_credenciales_invalidas THEN
      lp_registrar_intento_fallido(l_id_usuario, i_tipo_clave);
      RETURN FALSE;
    WHEN OTHERS THEN
      lp_registrar_intento_fallido(l_id_usuario, i_tipo_clave);
      RETURN FALSE;
  END;

  PROCEDURE p_validar_credenciales(i_usuario    IN VARCHAR2,
                                   i_clave      IN VARCHAR2,
                                   i_tipo_clave IN CHAR DEFAULT 'A') IS
  BEGIN
    IF NOT f_validar_credenciales(i_usuario, i_clave, i_tipo_clave) THEN
      raise_application_error(-20000, 'Credenciales invalidas');
    END IF;
  END;

  FUNCTION f_generar_clave_aplicacion RETURN VARCHAR2 IS
  BEGIN
    RETURN utl_raw.cast_to_varchar2(utl_encode.base64_encode(dbms_crypto.randombytes(number_bytes => 32)));
  END;

  FUNCTION f_validar_clave_aplicacion(i_clave_aplicacion IN VARCHAR2)
    RETURN BOOLEAN IS
  BEGIN
    IF f_id_aplicacion(i_clave_aplicacion, 'S') IS NULL THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;

  PROCEDURE p_validar_clave_aplicacion(i_clave_aplicacion IN VARCHAR2) IS
  BEGIN
    IF NOT f_validar_clave_aplicacion(i_clave_aplicacion) THEN
      raise_application_error(-20000, 'Aplicacion inexistente o inactiva');
    END IF;
  END;

  FUNCTION f_iniciar_sesion(i_clave_aplicacion  IN VARCHAR2,
                            i_usuario           IN VARCHAR2,
                            i_access_token      IN VARCHAR2,
                            i_refresh_token     IN VARCHAR2,
                            i_token_dispositivo IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    l_id_sesion                      t_sesiones.id_sesion%TYPE;
    l_id_usuario                     t_usuarios.id_usuario%TYPE;
    l_id_aplicacion                  t_aplicaciones.id_aplicacion%TYPE;
    l_tipo_aplicacion                t_aplicaciones.tipo%TYPE;
    l_id_dispositivo                 t_dispositivos.id_dispositivo%TYPE;
    l_cantidad                       NUMBER(3);
    l_fecha_expiracion_access_token  DATE;
    l_fecha_expiracion_refresh_token DATE;
  BEGIN
    -- Busca aplicacion
    l_id_aplicacion := f_id_aplicacion(i_clave_aplicacion, 'S');
  
    IF l_id_aplicacion IS NULL THEN
      raise_application_error(-20000, 'Aplicacion inexistente o inactiva');
    END IF;
  
    -- Busca usuario
    l_id_usuario := lf_id_usuario(i_usuario);
  
    IF l_id_usuario IS NULL THEN
      RAISE ex_usuario_inexistente;
    END IF;
  
    -- Busca dispositivo
    l_id_dispositivo := k_dispositivo.f_id_dispositivo(i_token_dispositivo);
  
    -- Obtiene tipo de aplicacion
    BEGIN
      SELECT tipo
        INTO l_tipo_aplicacion
        FROM t_aplicaciones
       WHERE id_aplicacion = l_id_aplicacion;
    EXCEPTION
      WHEN OTHERS THEN
        l_tipo_aplicacion := NULL;
    END;
  
    IF l_tipo_aplicacion <> 'S' THEN
      -- Si es de tipo S-SERVICIO no valida cantidad de sesiones activas
    
      -- Obtiene cantidad de sesiones activas del usuario
      SELECT COUNT(id_sesion)
        INTO l_cantidad
        FROM t_sesiones
       WHERE estado = 'A'
         AND id_usuario = l_id_usuario;
    
      IF l_cantidad >=
         to_number(k_util.f_valor_parametro('CANTIDAD_MAXIMA_SESIONES_USUARIO')) THEN
        raise_application_error(-20000,
                                'Usuario ha alcanzado la cantidad máxima de sesiones activas');
      END IF;
    
    END IF;
  
    -- Obtiene la fecha de expiracion del Access Token y Refresh Token
    l_fecha_expiracion_access_token  := lf_fecha_expiracion_access_token(i_access_token);
    l_fecha_expiracion_refresh_token := lf_fecha_expiracion_refresh_token(l_id_aplicacion);
  
    -- Inserta sesion
    INSERT INTO t_sesiones
      (id_usuario,
       id_aplicacion,
       estado,
       fecha_autenticacion,
       access_token,
       fecha_expiracion_access_token,
       refresh_token,
       fecha_expiracion_refresh_token,
       direccion_ip,
       host,
       terminal,
       id_dispositivo)
    VALUES
      (l_id_usuario,
       l_id_aplicacion,
       'A',
       SYSDATE,
       i_access_token,
       l_fecha_expiracion_access_token,
       i_refresh_token,
       l_fecha_expiracion_refresh_token,
       k_util.f_direccion_ip,
       k_util.f_host,
       k_util.f_terminal,
       l_id_dispositivo)
    RETURNING id_sesion INTO l_id_sesion;
  
    RETURN l_id_sesion;
  EXCEPTION
    WHEN ex_usuario_inexistente THEN
      raise_application_error(-20000, 'Usuario inexistente');
  END;

  FUNCTION f_refrescar_sesion(i_clave_aplicacion      IN VARCHAR2,
                              i_access_token_antiguo  IN VARCHAR2,
                              i_refresh_token_antiguo IN VARCHAR2,
                              i_access_token_nuevo    IN VARCHAR2,
                              i_refresh_token_nuevo   IN VARCHAR2)
    RETURN NUMBER IS
    l_id_aplicacion                  t_aplicaciones.id_aplicacion%TYPE;
    l_id_sesion                      t_sesiones.id_sesion%TYPE;
    l_fecha_expiracion_access_token  DATE;
    l_fecha_expiracion_refresh_token DATE;
  BEGIN
    -- Busca aplicacion
    l_id_aplicacion := f_id_aplicacion(i_clave_aplicacion, 'S');
  
    IF l_id_aplicacion IS NULL THEN
      raise_application_error(-20000, 'Aplicacion inexistente o inactiva');
    END IF;
  
    -- Busca sesion
    l_id_sesion := lf_id_sesion(i_access_token_antiguo);
  
    IF l_id_sesion IS NULL THEN
      RAISE ex_tokens_invalidos;
    END IF;
  
    -- Obtiene la fecha de expiracion del Access Token y Refresh Token
    l_fecha_expiracion_access_token  := lf_fecha_expiracion_access_token(i_access_token_nuevo);
    l_fecha_expiracion_refresh_token := lf_fecha_expiracion_refresh_token(l_id_aplicacion);
  
    -- Actualiza sesion
    UPDATE t_sesiones
       SET access_token                   = i_access_token_nuevo,
           refresh_token                  = i_refresh_token_nuevo,
           fecha_expiracion_access_token  = l_fecha_expiracion_access_token,
           fecha_expiracion_refresh_token = l_fecha_expiracion_refresh_token,
           estado                         = 'A',
           fecha_estado                   = SYSDATE
     WHERE id_sesion = l_id_sesion
       AND access_token = i_access_token_antiguo
       AND refresh_token = i_refresh_token_antiguo
       AND estado IN ('A', 'X')
       AND fecha_expiracion_refresh_token >= SYSDATE;
    IF SQL%NOTFOUND THEN
      RAISE ex_tokens_invalidos;
    END IF;
  
    RETURN l_id_sesion;
  EXCEPTION
    WHEN ex_tokens_invalidos THEN
      raise_application_error(-20000, 'Tokens invalidos');
  END;

  PROCEDURE p_cambiar_estado_sesion(i_access_token IN VARCHAR2,
                                    i_estado       IN VARCHAR2) IS
    l_id_sesion t_sesiones.id_sesion%TYPE;
  BEGIN
    -- Busca sesion
    l_id_sesion := lf_id_sesion(i_access_token);
  
    IF l_id_sesion IS NULL THEN
      RAISE ex_sesion_inexistente;
    END IF;
  
    -- Actualiza sesion
    UPDATE t_sesiones
       SET estado = i_estado
     WHERE id_sesion = l_id_sesion
       AND estado <> i_estado;
  
    -- Elimina sesion
    /*DELETE t_sesiones WHERE id_sesion = l_id_sesion;*/
  EXCEPTION
    WHEN ex_sesion_inexistente THEN
      /*raise_application_error(-20000, 'Sesion inexistente');*/
      NULL;
  END;

  FUNCTION f_sesion_activa(i_access_token IN VARCHAR2) RETURN BOOLEAN IS
    l_id_sesion t_sesiones.id_sesion%TYPE;
  BEGIN
    SELECT id_sesion
      INTO l_id_sesion
      FROM t_sesiones
     WHERE estado = 'A'
       AND access_token = i_access_token;
    RETURN TRUE;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN FALSE;
  END;

  PROCEDURE p_sesion_activa(i_access_token IN VARCHAR2) IS
  BEGIN
    IF NOT f_sesion_activa(i_access_token) THEN
      raise_application_error(-20000, 'Sesion finalizada o expirada');
    END IF;
  END;

  PROCEDURE p_editar_usuario(i_usuario_antiguo  IN VARCHAR2,
                             i_usuario_nuevo    IN VARCHAR2,
                             i_nombre           IN VARCHAR2,
                             i_apellido         IN VARCHAR2,
                             i_direccion_correo IN VARCHAR2,
                             i_numero_telefono  IN VARCHAR2 DEFAULT NULL) IS
    l_id_persona t_personas.id_persona%TYPE;
  BEGIN
    -- Actualiza usuario
    UPDATE t_usuarios
       SET alias            = nvl(i_usuario_nuevo, alias),
           direccion_correo = nvl(i_direccion_correo, direccion_correo),
           numero_telefono  = nvl(i_numero_telefono, numero_telefono)
     WHERE alias = i_usuario_antiguo
    RETURNING id_persona INTO l_id_persona;
  
    IF SQL%NOTFOUND THEN
      raise_application_error(-20000, 'Usuario inexistente');
    END IF;
  
    -- Actualiza persona
    UPDATE t_personas
       SET nombre          = nvl(i_nombre, nombre),
           apellido        = nvl(i_apellido, apellido),
           nombre_completo = nvl(i_nombre || ' ' || i_apellido,
                                 nombre_completo)
     WHERE id_persona = l_id_persona;
  
    IF SQL%NOTFOUND THEN
      raise_application_error(-20000, 'Persona inexistente');
    END IF;
  END;

END;
/
