CREATE OR REPLACE PACKAGE k_clave IS

  /**
  Agrupa operaciones relacionadas con claves de usuarios
  
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

  -- Tipos de clave
  c_clave_acceso        CONSTANT CHAR(1) := 'A';
  c_clave_transaccional CONSTANT CHAR(1) := 'T';

  FUNCTION f_randombytes_hex RETURN VARCHAR2;

  FUNCTION f_randombytes_base64 RETURN VARCHAR2;

  FUNCTION f_salt RETURN VARCHAR2;

  FUNCTION f_hash(i_clave IN VARCHAR2,
                  i_salt  IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_validar_clave(i_id_usuario IN NUMBER,
                           i_clave      IN VARCHAR2,
                           i_tipo_clave IN CHAR DEFAULT 'A') RETURN BOOLEAN;

  PROCEDURE p_registrar_intento_fallido(i_id_usuario IN NUMBER,
                                        i_tipo_clave IN CHAR DEFAULT 'A');

  PROCEDURE p_registrar_autenticacion(i_id_usuario IN NUMBER,
                                      i_tipo_clave IN CHAR DEFAULT 'A');

  PROCEDURE p_validar_politicas(i_alias      IN VARCHAR2,
                                i_clave      IN VARCHAR2,
                                i_tipo_clave IN CHAR DEFAULT 'A');

  PROCEDURE p_registrar_clave(i_alias      IN VARCHAR2,
                              i_clave      IN VARCHAR2,
                              i_tipo_clave IN CHAR DEFAULT 'A');

  PROCEDURE p_desbloquear_clave(i_alias      IN VARCHAR2,
                                i_tipo_clave IN CHAR DEFAULT 'A');

  PROCEDURE p_restablecer_clave(i_alias      IN VARCHAR2,
                                i_clave      IN VARCHAR2,
                                i_tipo_clave IN CHAR DEFAULT 'A');

  PROCEDURE p_cambiar_clave(i_alias         IN VARCHAR2,
                            i_clave_antigua IN VARCHAR2,
                            i_clave_nueva   IN VARCHAR2,
                            i_tipo_clave    IN CHAR DEFAULT 'A');

END;
/
CREATE OR REPLACE PACKAGE BODY k_clave IS

  c_algoritmo      CONSTANT PLS_INTEGER := as_crypto.hmac_sh1;
  c_iteraciones    CONSTANT PLS_INTEGER := 128; -- 4096
  c_longitud_bytes CONSTANT PLS_INTEGER := 32;

  -- Excepciones
  ex_credenciales_invalidas EXCEPTION;
  ex_tokens_invalidos       EXCEPTION;

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
        l_last := as_crypto.mac(l_last,
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

  FUNCTION f_randombytes_hex RETURN VARCHAR2 IS
  BEGIN
    RETURN rawtohex(as_crypto.randombytes(c_longitud_bytes));
  END;

  FUNCTION f_randombytes_base64 RETURN VARCHAR2 IS
  BEGIN
    RETURN utl_raw.cast_to_varchar2(utl_encode.base64_encode(as_crypto.randombytes(c_longitud_bytes)));
  END;

  FUNCTION f_salt RETURN VARCHAR2 IS
  BEGIN
    RETURN f_randombytes_hex;
  END;

  FUNCTION f_hash(i_clave IN VARCHAR2,
                  i_salt  IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN pbkdf2(i_clave, i_salt, c_iteraciones, c_longitud_bytes);
  END;

  FUNCTION f_validar_clave(i_id_usuario IN NUMBER,
                           i_clave      IN VARCHAR2,
                           i_tipo_clave IN CHAR DEFAULT 'A') RETURN BOOLEAN IS
    l_hash        t_usuario_claves.hash%TYPE;
    l_salt        t_usuario_claves.salt%TYPE;
    l_iteraciones t_usuario_claves.iteraciones%TYPE;
  BEGIN
    BEGIN
      SELECT c.hash, c.salt, c.iteraciones
        INTO l_hash, l_salt, l_iteraciones
        FROM t_usuario_claves c
       WHERE c.id_usuario = i_id_usuario
         AND c.tipo = i_tipo_clave
         AND orden = (SELECT MAX(uc2.orden)
                        FROM t_usuario_claves uc2
                       WHERE uc2.id_usuario = c.id_usuario
                         AND uc2.tipo = c.tipo)
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
  
    RETURN TRUE;
  EXCEPTION
    WHEN ex_credenciales_invalidas THEN
      RETURN FALSE;
    WHEN OTHERS THEN
      RETURN FALSE;
  END;

  PROCEDURE p_registrar_intento_fallido(i_id_usuario IN NUMBER,
                                        i_tipo_clave IN CHAR DEFAULT 'A') IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_cantidad_intentos_permitidos PLS_INTEGER;
  BEGIN
    l_cantidad_intentos_permitidos := to_number(k_util.f_valor_parametro('AUTENTICACION_CANTIDAD_INTENTOS_PERMITIDOS'));
    UPDATE t_usuario_claves a
       SET cantidad_intentos_fallidos = CASE
                                          WHEN nvl(cantidad_intentos_fallidos,
                                                   0) >=
                                               l_cantidad_intentos_permitidos THEN
                                           cantidad_intentos_fallidos
                                          ELSE
                                           nvl(cantidad_intentos_fallidos, 0) + 1
                                        END,
           estado = CASE
                      WHEN nvl(cantidad_intentos_fallidos, 0) >=
                           l_cantidad_intentos_permitidos THEN
                       'B'
                      ELSE
                       estado
                    END
     WHERE id_usuario = i_id_usuario
       AND tipo = i_tipo_clave
       AND orden = (SELECT MAX(uc2.orden)
                      FROM t_usuario_claves uc2
                     WHERE uc2.id_usuario = a.id_usuario
                       AND uc2.tipo = a.tipo);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  PROCEDURE p_registrar_autenticacion(i_id_usuario IN NUMBER,
                                      i_tipo_clave IN CHAR DEFAULT 'A') IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE t_usuario_claves a
       SET cantidad_intentos_fallidos = 0,
           fecha_ultima_autenticacion = SYSDATE,
           estado = CASE
                      WHEN nvl(estado, 'N') = 'N' THEN
                       'A'
                      ELSE
                       estado
                    END
     WHERE id_usuario = i_id_usuario
       AND tipo = i_tipo_clave
       AND orden = (SELECT MAX(uc2.orden)
                      FROM t_usuario_claves uc2
                     WHERE uc2.id_usuario = a.id_usuario
                       AND uc2.tipo = a.tipo);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  PROCEDURE p_validar_politicas(i_alias      IN VARCHAR2,
                                i_clave      IN VARCHAR2,
                                i_tipo_clave IN CHAR DEFAULT 'A') IS
    l_dominio               t_significados.dominio%TYPE;
    l_caracteres_prohibidos t_significados.significado%TYPE;
    l_lon_clave             NUMBER(6) := 0;
    l_can_letras            NUMBER(6) := 0;
    l_can_letras_may        NUMBER(6) := 0;
    l_can_letras_min        NUMBER(6) := 0;
    l_can_numeros           NUMBER(6) := 0;
    l_can_otros             NUMBER(6) := 0;
    l_can_repeticiones      NUMBER(6) := 0;
    l_caracter              VARCHAR2(1);
  BEGIN
    l_dominio   := 'POLITICA_VALIDACION_CLAVE_' ||
                   k_significado.f_significado_codigo('TIPO_CLAVE',
                                                      i_tipo_clave);
    l_lon_clave := length(i_clave);
  
    -- Valida la longitud de la clave
    IF l_lon_clave <
       to_number(k_significado.f_significado_codigo(l_dominio,
                                                    'LONGITUD_MINIMA')) THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos ' ||
                              k_significado.f_significado_codigo(l_dominio,
                                                                 'LONGITUD_MINIMA') ||
                              ' caracteres');
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
      IF l_can_repeticiones >
         to_number(k_significado.f_significado_codigo(l_dominio,
                                                      'CAN_MAX_CARACTERES_IGUALES')) THEN
        raise_application_error(-20000,
                                'La clave no puede contener más de ' ||
                                k_significado.f_significado_codigo(l_dominio,
                                                                   'CAN_MAX_CARACTERES_IGUALES') ||
                                ' caracteres iguales');
      END IF;
    END LOOP;
  
    l_can_letras := l_can_letras_min + l_can_letras_may;
  
    -- Valida que la clave no sea igual al usuario
    IF k_util.string_to_bool(k_significado.f_significado_codigo(l_dominio,
                                                                'VAL_ALIAS_IGUAL')) AND
       upper(i_clave) = upper(i_alias) THEN
      raise_application_error(-20000,
                              'La clave no puede ser igual al usuario');
    END IF;
    -- Valida que la clave no contenga el usuario
    IF k_util.string_to_bool(k_significado.f_significado_codigo(l_dominio,
                                                                'VAL_ALIAS_CONTENIDO')) AND
       instr(upper(i_clave), upper(i_alias)) > 0 THEN
      raise_application_error(-20000,
                              'La clave no debe contener el usuario');
    END IF;
  
    -- Valida la cantidad de letras
    IF l_can_letras <
       to_number(k_significado.f_significado_codigo(l_dominio,
                                                    'CAN_MIN_LETRAS_ABECEDARIO')) THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos ' ||
                              k_significado.f_significado_codigo(l_dominio,
                                                                 'CAN_MIN_LETRAS_ABECEDARIO') ||
                              ' letras del abecedario');
    END IF;
    -- Valida la cantidad de letras mayusculas
    IF l_can_letras_may <
       to_number(k_significado.f_significado_codigo(l_dominio,
                                                    'CAN_MIN_MAYUSCULAS')) THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos ' ||
                              k_significado.f_significado_codigo(l_dominio,
                                                                 'CAN_MIN_MAYUSCULAS') ||
                              ' letra mayúscula');
    END IF;
    -- Valida la cantidad de letras minusculas
    IF l_can_letras_min <
       to_number(k_significado.f_significado_codigo(l_dominio,
                                                    'CAN_MIN_MINUSCULAS')) THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos ' ||
                              k_significado.f_significado_codigo(l_dominio,
                                                                 'CAN_MIN_MINUSCULAS') ||
                              ' letra minúscula');
    END IF;
    -- Valida la cantidad de numeros
    IF l_can_numeros <
       to_number(k_significado.f_significado_codigo(l_dominio,
                                                    'CAN_MIN_NUMEROS')) THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos ' ||
                              k_significado.f_significado_codigo(l_dominio,
                                                                 'CAN_MIN_NUMEROS') ||
                              ' número');
    END IF;
    -- Valida la cantidad de caracteres especiales
    IF l_can_otros <
       to_number(k_significado.f_significado_codigo(l_dominio,
                                                    'CAN_MIN_CARACTERES_ESPECIALES')) THEN
      raise_application_error(-20000,
                              'La clave debe contener al menos ' ||
                              k_significado.f_significado_codigo(l_dominio,
                                                                 'CAN_MIN_CARACTERES_ESPECIALES') ||
                              ' caracter especial');
    END IF;
  
    -- Valida caracteres prohibidos
    l_caracteres_prohibidos := k_significado.f_significado_codigo(l_dominio,
                                                                  'CARACTERES_PROHIBIDOS');
    FOR i IN 1 .. length(l_caracteres_prohibidos) LOOP
      l_caracter := substr(l_caracteres_prohibidos, i, 1);
      IF instr(i_clave, l_caracter) > 0 THEN
        raise_application_error(-20000,
                                'La clave no puede contener el caracter "' ||
                                l_caracter || '"');
      END IF;
    END LOOP;
  END;

  PROCEDURE p_registrar_clave(i_alias      IN VARCHAR2,
                              i_clave      IN VARCHAR2,
                              i_tipo_clave IN CHAR DEFAULT 'A') IS
    l_id_usuario t_usuarios.id_usuario%TYPE;
    l_orden      t_usuario_claves.orden%TYPE;
    l_hash       t_usuario_claves.hash%TYPE;
    l_salt       t_usuario_claves.salt%TYPE;
  BEGIN
    -- Busca usuario
    l_id_usuario := k_usuario.f_id_usuario(i_alias);
  
    IF l_id_usuario IS NULL THEN
      RAISE k_usuario.ex_usuario_inexistente;
    END IF;
  
    -- Valida políticas
    p_validar_politicas(i_alias, i_clave, i_tipo_clave);
  
    -- Genera salt
    l_salt := f_salt;
    -- Genera hash
    l_hash := f_hash(i_clave, l_salt);
  
    SELECT nvl(MAX(c.orden), 0) + 1
      INTO l_orden
      FROM t_usuario_claves c
     WHERE c.id_usuario = l_id_usuario
       AND c.tipo = i_tipo_clave;
  
    -- Inserta clave de usuario
    INSERT INTO t_usuario_claves
      (id_usuario,
       tipo,
       orden,
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
       l_orden,
       'N',
       l_hash,
       l_salt,
       c_algoritmo,
       c_iteraciones,
       0,
       NULL);
  EXCEPTION
    WHEN k_usuario.ex_usuario_inexistente THEN
      raise_application_error(-20000, 'Usuario inexistente');
    WHEN dup_val_on_index THEN
      raise_application_error(-20000,
                              'Usuario ya tiene una clave registrada');
  END;

  PROCEDURE p_desbloquear_clave(i_alias      IN VARCHAR2,
                                i_tipo_clave IN CHAR DEFAULT 'A') IS
    l_id_usuario t_usuarios.id_usuario%TYPE;
  BEGIN
    -- Busca usuario
    l_id_usuario := k_usuario.f_id_usuario(i_alias);
  
    IF l_id_usuario IS NULL THEN
      RAISE k_usuario.ex_usuario_inexistente;
    END IF;
  
    -- Actualiza clave de usuario
    UPDATE t_usuario_claves a
       SET estado                     = 'N',
           cantidad_intentos_fallidos = 0,
           fecha_ultima_autenticacion = NULL
     WHERE id_usuario = l_id_usuario
       AND tipo = i_tipo_clave
       AND orden = (SELECT MAX(uc2.orden)
                      FROM t_usuario_claves uc2
                     WHERE uc2.id_usuario = a.id_usuario
                       AND uc2.tipo = a.tipo);
  
    IF SQL%NOTFOUND THEN
      raise_application_error(-20000, 'Usuario sin clave registrada');
    END IF;
  EXCEPTION
    WHEN k_usuario.ex_usuario_inexistente THEN
      raise_application_error(-20000, 'Usuario inexistente');
  END;

  PROCEDURE p_restablecer_clave(i_alias      IN VARCHAR2,
                                i_clave      IN VARCHAR2,
                                i_tipo_clave IN CHAR DEFAULT 'A') IS
    l_id_usuario t_usuarios.id_usuario%TYPE;
    l_hash       t_usuario_claves.hash%TYPE;
    l_salt       t_usuario_claves.salt%TYPE;
  BEGIN
    -- Busca usuario
    l_id_usuario := k_usuario.f_id_usuario(i_alias);
  
    IF l_id_usuario IS NULL THEN
      RAISE k_usuario.ex_usuario_inexistente;
    END IF;
  
    -- Valida políticas
    p_validar_politicas(i_alias, i_clave, i_tipo_clave);
  
    -- Genera salt
    l_salt := f_salt;
    -- Genera hash
    l_hash := f_hash(i_clave, l_salt);
  
    -- Actualiza clave de usuario
    UPDATE t_usuario_claves a
       SET HASH                       = l_hash,
           salt                       = l_salt,
           algoritmo                  = c_algoritmo,
           iteraciones                = c_iteraciones,
           estado                     = 'N',
           cantidad_intentos_fallidos = 0,
           fecha_ultima_autenticacion = NULL
     WHERE id_usuario = l_id_usuario
       AND tipo = i_tipo_clave
       AND orden = (SELECT MAX(uc2.orden)
                      FROM t_usuario_claves uc2
                     WHERE uc2.id_usuario = a.id_usuario
                       AND uc2.tipo = a.tipo);
  
    IF SQL%NOTFOUND THEN
      raise_application_error(-20000, 'Usuario sin clave registrada');
    END IF;
  EXCEPTION
    WHEN k_usuario.ex_usuario_inexistente THEN
      raise_application_error(-20000, 'Usuario inexistente');
  END;

  PROCEDURE p_cambiar_clave(i_alias         IN VARCHAR2,
                            i_clave_antigua IN VARCHAR2,
                            i_clave_nueva   IN VARCHAR2,
                            i_tipo_clave    IN CHAR DEFAULT 'A') IS
    l_id_usuario t_usuarios.id_usuario%TYPE;
    l_orden      t_usuario_claves.orden%TYPE;
    l_hash       t_usuario_claves.hash%TYPE;
    l_salt       t_usuario_claves.salt%TYPE;
  BEGIN
    -- Busca usuario
    l_id_usuario := k_usuario.f_id_usuario(i_alias);
  
    IF l_id_usuario IS NULL THEN
      RAISE k_usuario.ex_usuario_inexistente;
    END IF;
  
    IF NOT f_validar_clave(l_id_usuario, i_clave_antigua, i_tipo_clave) THEN
      RAISE ex_credenciales_invalidas;
    END IF;
  
    -- Valida políticas
    p_validar_politicas(i_alias, i_clave_nueva, i_tipo_clave);
  
    -- Genera salt
    l_salt := f_salt;
    -- Genera hash
    l_hash := f_hash(i_clave_nueva, l_salt);
  
    -- Actualiza clave de usuario antigua
    UPDATE t_usuario_claves a
       SET estado = 'I'
     WHERE id_usuario = l_id_usuario
       AND tipo = i_tipo_clave
       AND orden = (SELECT MAX(uc2.orden)
                      FROM t_usuario_claves uc2
                     WHERE uc2.id_usuario = a.id_usuario
                       AND uc2.tipo = a.tipo)
       AND estado IN ('N', 'A');
  
    IF SQL%NOTFOUND THEN
      raise_application_error(-20000, 'Usuario sin clave activa');
    END IF;
  
    SELECT nvl(MAX(c.orden), 0) + 1
      INTO l_orden
      FROM t_usuario_claves c
     WHERE c.id_usuario = l_id_usuario
       AND c.tipo = i_tipo_clave;
  
    -- Inserta clave de usuario nueva
    INSERT INTO t_usuario_claves
      (id_usuario,
       tipo,
       orden,
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
       l_orden,
       'N',
       l_hash,
       l_salt,
       c_algoritmo,
       c_iteraciones,
       0,
       NULL);
  EXCEPTION
    WHEN k_usuario.ex_usuario_inexistente THEN
      raise_application_error(-20000, 'Credenciales inválidas');
    WHEN ex_credenciales_invalidas THEN
      raise_application_error(-20000, 'Credenciales inválidas');
  END;

END;
/
