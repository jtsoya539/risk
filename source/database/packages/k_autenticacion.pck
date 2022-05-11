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

  -- Origenes de usuario
  c_origen_risk     CONSTANT CHAR(1) := 'R';
  c_origen_google   CONSTANT CHAR(1) := 'G';
  c_origen_facebook CONSTANT CHAR(1) := 'F';

  -- Métodos de validación de credenciales
  c_metodo_validacion_risk   CONSTANT VARCHAR2(10) := 'RISK';
  c_metodo_validacion_oracle CONSTANT VARCHAR2(10) := 'ORACLE';

  FUNCTION f_registrar_usuario(i_alias            IN VARCHAR2,
                               i_clave            IN VARCHAR2,
                               i_nombre           IN VARCHAR2,
                               i_apellido         IN VARCHAR2,
                               i_direccion_correo IN VARCHAR2,
                               i_numero_telefono  IN VARCHAR2 DEFAULT NULL,
                               i_origen           IN VARCHAR2 DEFAULT NULL,
                               i_id_externo       IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2;

  PROCEDURE p_editar_usuario(i_alias_antiguo    IN VARCHAR2,
                             i_alias_nuevo      IN VARCHAR2,
                             i_nombre           IN VARCHAR2,
                             i_apellido         IN VARCHAR2,
                             i_direccion_correo IN VARCHAR2,
                             i_numero_telefono  IN VARCHAR2 DEFAULT NULL);

  FUNCTION f_validar_credenciales_risk(i_id_usuario IN NUMBER,
                                       i_clave      IN VARCHAR2,
                                       i_tipo_clave IN CHAR DEFAULT 'A')
    RETURN BOOLEAN;

  FUNCTION f_validar_credenciales_oracle(i_usuario IN VARCHAR2,
                                         i_clave   IN VARCHAR2)
    RETURN BOOLEAN;

  FUNCTION f_validar_credenciales(i_usuario    IN VARCHAR2,
                                  i_clave      IN VARCHAR2,
                                  i_tipo_clave IN CHAR DEFAULT 'A',
                                  i_metodo     IN VARCHAR2 DEFAULT NULL)
    RETURN BOOLEAN;

  PROCEDURE p_validar_credenciales(i_usuario    IN VARCHAR2,
                                   i_clave      IN VARCHAR2,
                                   i_tipo_clave IN CHAR DEFAULT 'A',
                                   i_metodo     IN VARCHAR2 DEFAULT NULL);

  FUNCTION f_iniciar_sesion(i_id_aplicacion     IN VARCHAR2,
                            i_usuario           IN VARCHAR2,
                            i_access_token      IN VARCHAR2,
                            i_refresh_token     IN VARCHAR2,
                            i_token_dispositivo IN VARCHAR2 DEFAULT NULL,
                            i_origen            IN VARCHAR2 DEFAULT NULL,
                            i_dato_externo      IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION f_refrescar_sesion(i_id_aplicacion         IN VARCHAR2,
                              i_access_token_antiguo  IN VARCHAR2,
                              i_refresh_token_antiguo IN VARCHAR2,
                              i_access_token_nuevo    IN VARCHAR2,
                              i_refresh_token_nuevo   IN VARCHAR2,
                              i_origen                IN VARCHAR2 DEFAULT NULL,
                              i_dato_externo          IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION f_generar_url_activacion(i_alias IN VARCHAR2) RETURN VARCHAR2;

END;
/
CREATE OR REPLACE PACKAGE BODY k_autenticacion IS

  -- Excepciones
  ex_credenciales_invalidas EXCEPTION;
  ex_tokens_invalidos       EXCEPTION;

  FUNCTION f_registrar_usuario(i_alias            IN VARCHAR2,
                               i_clave            IN VARCHAR2,
                               i_nombre           IN VARCHAR2,
                               i_apellido         IN VARCHAR2,
                               i_direccion_correo IN VARCHAR2,
                               i_numero_telefono  IN VARCHAR2 DEFAULT NULL,
                               i_origen           IN VARCHAR2 DEFAULT NULL,
                               i_id_externo       IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2 IS
    l_id_persona          t_personas.id_persona%TYPE;
    l_id_usuario          t_usuarios.id_usuario%TYPE;
    l_alias               t_usuarios.alias%TYPE := i_alias;
    l_confirmacion_activa VARCHAR2(1);
    l_estado_usuario      t_usuarios.estado%TYPE;
    l_body                CLOB;
    l_origen              VARCHAR2(1) := nvl(i_origen, c_origen_risk);
  BEGIN
    -- Valida que no exista el usuario externo
    IF l_origen <> c_origen_risk THEN
      IF k_usuario.f_existe_usuario_externo(l_origen, i_id_externo) THEN
        RAISE k_usuario.ex_usuario_existente;
      END IF;
    
      l_alias := translate(l_alias,
                           'áéíóúàèìòùäëïöüñÁÉÍÓÚÝÄËÏÖÜÀÈÌÒÙÑ'' ',
                           'aeiouaeiouaeiounAEIOUYAEIOUAEIOUN__');
    
      SELECT l_alias ||
             to_char(MAX(to_number(nvl(regexp_substr(a.alias, '\d+'), '0'))) + 1) alias
        INTO l_alias
        FROM t_usuarios a
       WHERE (upper(a.alias) = upper(l_alias) OR
             regexp_like(a.alias, '(' || l_alias || ')\d+', 'i'));
    END IF;
  
    -- Valida políticas
    IF l_origen = c_origen_risk THEN
      k_clave.p_validar_politicas(l_alias, i_clave, k_clave.c_clave_acceso);
    END IF;
  
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
  
    l_confirmacion_activa := CASE l_origen
                               WHEN c_origen_risk THEN
                                nvl(k_util.f_valor_parametro('CONFIRMACION_DIRECCION_CORREO'),
                                    'N')
                               ELSE
                                'N'
                             END;
    l_estado_usuario      := CASE l_confirmacion_activa
                               WHEN 'S' THEN
                                'P' -- PENDIENTE DE ACTIVACIÓN
                               ELSE
                                'A' -- ACTIVO
                             END;
  
    -- Inserta usuario
    INSERT INTO t_usuarios
      (alias,
       id_persona,
       estado,
       direccion_correo,
       numero_telefono,
       origen,
       id_externo)
    VALUES
      (l_alias,
       l_id_persona,
       l_estado_usuario,
       i_direccion_correo,
       i_numero_telefono,
       l_origen,
       i_id_externo)
    RETURNING id_usuario INTO l_id_usuario;
  
    INSERT INTO t_rol_usuarios
      (id_rol, id_usuario)
      SELECT id_rol, l_id_usuario
        FROM t_roles
       WHERE nombre =
             nvl(k_significado.f_referencia_codigo('ESTADO_USUARIO',
                                                   l_estado_usuario),
                 k_util.f_valor_parametro('NOMBRE_ROL_DEFECTO'));
  
    -- Registra clave
    IF l_origen = c_origen_risk THEN
      k_clave.p_registrar_clave(l_alias, i_clave, k_clave.c_clave_acceso);
    END IF;
  
    -- Inserta o actualiza suscripción básica del usuario
    k_usuario.p_suscribir_notificacion(l_id_usuario,
                                       k_dispositivo.f_suscripcion_usuario(l_id_usuario));
  
    $if k_modulo.c_instalado_msj $then
    IF l_confirmacion_activa = 'S' THEN
      -- Envía correo de verificación
      l_body := k_mensajeria.f_correo_html('Para activar tu cuenta, por favor verifica tu dirección de correo.' ||
                                           utl_tcp.crlf ||
                                           'Tu cuenta no será creada hasta que tu dirección de correo sea confirmada.' ||
                                           utl_tcp.crlf ||
                                           'Confirma tu dirección de correo con el botón o con la siguiente URL:' ||
                                           utl_tcp.crlf ||
                                           f_generar_url_activacion(l_alias),
                                           'Confirmación de correo',
                                           'Confirmación de correo',
                                           NULL,
                                           'Confirmar',
                                           f_generar_url_activacion(l_alias));
    
      IF k_mensajeria.f_enviar_correo('Confirmación de correo',
                                      l_body,
                                      NULL,
                                      i_direccion_correo,
                                      NULL,
                                      NULL,
                                      NULL,
                                      NULL,
                                      k_mensajeria.c_prioridad_importante) <>
         k_mensajeria.c_ok THEN
        raise_application_error(-20000,
                                'Error al enviar correo de verificación');
      END IF;
    END IF;
    $end
  
    RETURN l_alias;
  EXCEPTION
    WHEN dup_val_on_index THEN
      raise_application_error(-20000, 'Usuario ya existe');
  END;

  PROCEDURE p_editar_usuario(i_alias_antiguo    IN VARCHAR2,
                             i_alias_nuevo      IN VARCHAR2,
                             i_nombre           IN VARCHAR2,
                             i_apellido         IN VARCHAR2,
                             i_direccion_correo IN VARCHAR2,
                             i_numero_telefono  IN VARCHAR2 DEFAULT NULL) IS
    l_id_persona t_personas.id_persona%TYPE;
  BEGIN
    -- Actualiza usuario
    UPDATE t_usuarios
       SET alias            = nvl(i_alias_nuevo, alias),
           direccion_correo = nvl(i_direccion_correo, direccion_correo),
           numero_telefono  = nvl(i_numero_telefono, numero_telefono)
     WHERE alias = i_alias_antiguo
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

  FUNCTION f_validar_credenciales_risk(i_id_usuario IN NUMBER,
                                       i_clave      IN VARCHAR2,
                                       i_tipo_clave IN CHAR DEFAULT 'A')
    RETURN BOOLEAN IS
  BEGIN
    RETURN k_clave.f_validar_clave(i_id_usuario, i_clave, i_tipo_clave);
  END;

  -- https://stackoverflow.com/a/33043760
  FUNCTION f_validar_credenciales_oracle(i_usuario IN VARCHAR2,
                                         i_clave   IN VARCHAR2)
    RETURN BOOLEAN IS
  BEGIN
    BEGIN
      EXECUTE IMMEDIATE 'DROP DATABASE LINK password_test_loopback';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    EXECUTE IMMEDIATE 'CREATE DATABASE LINK password_test_loopback CONNECT TO ' ||
                      i_usuario || ' IDENTIFIED BY ' || i_clave ||
                      ' USING ''' || k_util.f_base_datos || '''';
  
    EXECUTE IMMEDIATE 'SELECT * FROM dual@password_test_loopback';
  
    EXECUTE IMMEDIATE 'DROP DATABASE LINK password_test_loopback';
  
    RETURN TRUE;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;

  FUNCTION f_validar_credenciales(i_usuario    IN VARCHAR2,
                                  i_clave      IN VARCHAR2,
                                  i_tipo_clave IN CHAR DEFAULT 'A',
                                  i_metodo     IN VARCHAR2 DEFAULT NULL)
    RETURN BOOLEAN IS
    l_id_usuario t_usuarios.id_usuario%TYPE;
  BEGIN
    -- Busca usuario
    l_id_usuario := k_usuario.f_buscar_id(i_usuario);
  
    IF l_id_usuario IS NULL THEN
      RAISE k_usuario.ex_usuario_inexistente;
    END IF;
  
    CASE nvl(i_metodo,
         k_util.f_valor_parametro('METODO_VALIDACION_CREDENCIALES'))
      WHEN c_metodo_validacion_risk THEN
        IF NOT
            f_validar_credenciales_risk(l_id_usuario, i_clave, i_tipo_clave) THEN
          RAISE ex_credenciales_invalidas;
        END IF;
      WHEN c_metodo_validacion_oracle THEN
        IF NOT f_validar_credenciales_oracle(i_usuario, i_clave) THEN
          RAISE ex_credenciales_invalidas;
        END IF;
      ELSE
        RAISE ex_credenciales_invalidas;
    END CASE;
  
    k_clave.p_registrar_autenticacion(l_id_usuario, i_tipo_clave);
    RETURN TRUE;
  EXCEPTION
    WHEN k_usuario.ex_usuario_inexistente THEN
      RETURN FALSE;
    WHEN ex_credenciales_invalidas THEN
      k_clave.p_registrar_intento_fallido(l_id_usuario, i_tipo_clave);
      RETURN FALSE;
    WHEN OTHERS THEN
      k_clave.p_registrar_intento_fallido(l_id_usuario, i_tipo_clave);
      RETURN FALSE;
  END;

  PROCEDURE p_validar_credenciales(i_usuario    IN VARCHAR2,
                                   i_clave      IN VARCHAR2,
                                   i_tipo_clave IN CHAR DEFAULT 'A',
                                   i_metodo     IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    IF NOT
        f_validar_credenciales(i_usuario, i_clave, i_tipo_clave, i_metodo) THEN
      raise_application_error(-20000, 'Credenciales inválidas');
    END IF;
  END;

  FUNCTION f_iniciar_sesion(i_id_aplicacion     IN VARCHAR2,
                            i_usuario           IN VARCHAR2,
                            i_access_token      IN VARCHAR2,
                            i_refresh_token     IN VARCHAR2,
                            i_token_dispositivo IN VARCHAR2 DEFAULT NULL,
                            i_origen            IN VARCHAR2 DEFAULT NULL,
                            i_dato_externo      IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    l_id_sesion                      t_sesiones.id_sesion%TYPE;
    l_id_usuario                     t_usuarios.id_usuario%TYPE;
    l_estado_usuario                 t_usuarios.estado%TYPE;
    l_tipo_aplicacion                t_aplicaciones.tipo%TYPE;
    l_id_dispositivo                 t_dispositivos.id_dispositivo%TYPE;
    l_cantidad                       NUMBER(3);
    l_fecha_expiracion_access_token  DATE;
    l_fecha_expiracion_refresh_token DATE;
    --
    l_origen VARCHAR2(1) := nvl(i_origen, c_origen_risk);
  BEGIN
    -- Valida aplicacion
    IF i_id_aplicacion IS NULL THEN
      raise_application_error(-20000, 'Aplicación inexistente o inactiva');
    END IF;
  
    -- Busca usuario
    l_id_usuario := k_usuario.f_buscar_id(i_usuario);
  
    IF l_id_usuario IS NULL THEN
      RAISE k_usuario.ex_usuario_inexistente;
    END IF;
  
    -- Valida estado de usuario
    l_estado_usuario := k_usuario.f_estado(l_id_usuario);
    BEGIN
      SELECT TRIM(column_value) estado
        INTO l_estado_usuario
        FROM k_util.f_separar_cadenas(k_util.f_valor_parametro('ESTADOS_ACTIVOS_USUARIO'),
                                      ',')
       WHERE TRIM(column_value) = l_estado_usuario;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000,
                                'Usuario ' ||
                                k_util.f_formatear_titulo(k_significado.f_significado_codigo('ESTADO_USUARIO',
                                                                                             l_estado_usuario)));
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- Busca dispositivo
    l_id_dispositivo := coalesce(k_sistema.f_valor_parametro_number(k_sistema.c_id_dispositivo),
                                 k_dispositivo.f_id_dispositivo(i_token_dispositivo));
  
    -- Obtiene tipo de aplicacion
    BEGIN
      SELECT tipo
        INTO l_tipo_aplicacion
        FROM t_aplicaciones
       WHERE id_aplicacion = i_id_aplicacion;
    EXCEPTION
      WHEN OTHERS THEN
        l_tipo_aplicacion := NULL;
    END;
  
    -- Cambia estado de las sesiones expiradas
    k_sesion.p_expirar_sesiones(l_id_usuario);
  
    IF l_origen = c_origen_risk THEN
      -- Si el origen de la sesion es R-RISK
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
      l_fecha_expiracion_access_token := k_sesion.f_fecha_expiracion_access_token(i_access_token);
      IF i_refresh_token IS NOT NULL THEN
        l_fecha_expiracion_refresh_token := k_sesion.f_fecha_expiracion_refresh_token(i_id_aplicacion);
      END IF;
    END IF;
  
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
       id_dispositivo,
       origen,
       dato_externo)
    VALUES
      (l_id_usuario,
       i_id_aplicacion,
       'A',
       SYSDATE,
       i_access_token,
       l_fecha_expiracion_access_token,
       i_refresh_token,
       l_fecha_expiracion_refresh_token,
       k_sistema.f_valor_parametro_string(k_sistema.c_direccion_ip),
       k_util.f_host,
       k_util.f_terminal,
       l_id_dispositivo,
       l_origen,
       i_dato_externo)
    RETURNING id_sesion INTO l_id_sesion;
  
    IF l_id_dispositivo IS NOT NULL THEN
      -- Inserta o actualiza suscripciones del usuario en el dispositivo
      k_dispositivo.p_suscribir_notificacion_usuario(l_id_dispositivo,
                                                     l_id_usuario);
    END IF;
  
    RETURN l_id_sesion;
  EXCEPTION
    WHEN k_usuario.ex_usuario_inexistente THEN
      raise_application_error(-20000, 'Usuario inexistente');
  END;

  FUNCTION f_refrescar_sesion(i_id_aplicacion         IN VARCHAR2,
                              i_access_token_antiguo  IN VARCHAR2,
                              i_refresh_token_antiguo IN VARCHAR2,
                              i_access_token_nuevo    IN VARCHAR2,
                              i_refresh_token_nuevo   IN VARCHAR2,
                              i_origen                IN VARCHAR2 DEFAULT NULL,
                              i_dato_externo          IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    l_id_sesion                      t_sesiones.id_sesion%TYPE;
    l_fecha_expiracion_access_token  DATE;
    l_fecha_expiracion_refresh_token DATE;
    --
    l_origen VARCHAR2(1) := nvl(i_origen, c_origen_risk);
  BEGIN
    -- Valida aplicacion
    IF i_id_aplicacion IS NULL THEN
      raise_application_error(-20000, 'Aplicación inexistente o inactiva');
    END IF;
  
    -- Busca sesion
    l_id_sesion := k_sesion.f_id_sesion(i_access_token_antiguo);
  
    IF l_id_sesion IS NULL THEN
      RAISE ex_tokens_invalidos;
    END IF;
  
    IF l_origen = c_origen_risk THEN
      -- Obtiene la fecha de expiracion del Access Token y Refresh Token
      l_fecha_expiracion_access_token := k_sesion.f_fecha_expiracion_access_token(i_access_token_nuevo);
      IF i_refresh_token_nuevo IS NOT NULL THEN
        l_fecha_expiracion_refresh_token := k_sesion.f_fecha_expiracion_refresh_token(i_id_aplicacion);
      END IF;
    
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
    
    ELSE
    
      -- Actualiza sesion
      UPDATE t_sesiones
         SET access_token = i_access_token_nuevo,
             estado       = 'A',
             fecha_estado = SYSDATE,
             dato_externo = i_dato_externo
       WHERE id_sesion = l_id_sesion
         AND access_token = i_access_token_antiguo
         AND estado IN ('A', 'X')
         AND origen = l_origen;
      IF SQL%NOTFOUND THEN
        RAISE ex_tokens_invalidos;
      END IF;
    
    END IF;
  
    RETURN l_id_sesion;
  EXCEPTION
    WHEN ex_tokens_invalidos THEN
      raise_application_error(-20000, 'Tokens inválidos');
  END;

  FUNCTION f_generar_url_activacion(i_alias IN VARCHAR2) RETURN VARCHAR2 IS
    l_json_object json_object_t;
    l_key         VARCHAR2(1000);
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('usuario', i_alias);
    l_json_object.put('hash', k_util.f_hash(i_alias, as_crypto.hash_sh1));
  
    l_key := utl_url.escape(k_util.base64encode(k_util.clob_to_blob(l_json_object.to_clob)),
                            TRUE);
  
    RETURN k_util.f_valor_parametro('URL_SERVICIOS_PRODUCCION') || '/Aut/ActivarUsuario?key=' || l_key;
  END;

END;
/
