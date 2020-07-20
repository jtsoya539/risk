CREATE OR REPLACE PACKAGE k_mensajeria IS

  /**
  Agrupa operaciones relacionadas con el envío de mensajes a los usuarios
  
  El envío de mensajes se puede realizar a través de:
  <ul>
  <li>Correo electrónico (E-mail)</li>
  <li>Mensaje de texto (SMS)</li>
  </ul>
  
  %author jtsoya539 27/3/2020 16:38:22
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

  c_cantidad_intentos_permitidos CONSTANT PLS_INTEGER := 3;

  FUNCTION f_validar_direccion_correo(i_direccion_correo VARCHAR2)
    RETURN BOOLEAN;

  FUNCTION f_validar_numero_telefono(i_numero_telefono VARCHAR2)
    RETURN BOOLEAN;

  FUNCTION f_direccion_correo_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2;

  FUNCTION f_numero_telefono_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2;

  PROCEDURE p_enviar_correo(i_subject    IN VARCHAR2,
                            i_body       IN CLOB,
                            i_id_usuario IN NUMBER DEFAULT NULL,
                            i_to         IN VARCHAR2 DEFAULT NULL,
                            i_reply_to   IN VARCHAR2 DEFAULT NULL,
                            i_cc         IN VARCHAR2 DEFAULT NULL,
                            i_bcc        IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_enviar_mensaje(i_contenido       IN VARCHAR2,
                             i_id_usuario      IN NUMBER DEFAULT NULL,
                             i_numero_telefono IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_enviar_notificacion(i_titulo      IN VARCHAR2,
                                  i_contenido   IN VARCHAR2,
                                  i_id_usuario  IN NUMBER DEFAULT NULL,
                                  i_suscripcion IN VARCHAR2 DEFAULT NULL);

  FUNCTION f_enviar_correo(i_subject    IN VARCHAR2,
                           i_body       IN CLOB,
                           i_id_usuario IN NUMBER DEFAULT NULL,
                           i_to         IN VARCHAR2 DEFAULT NULL,
                           i_reply_to   IN VARCHAR2 DEFAULT NULL,
                           i_cc         IN VARCHAR2 DEFAULT NULL,
                           i_bcc        IN VARCHAR2 DEFAULT NULL)
    RETURN PLS_INTEGER;

  FUNCTION f_enviar_mensaje(i_contenido       IN VARCHAR2,
                            i_id_usuario      IN NUMBER DEFAULT NULL,
                            i_numero_telefono IN VARCHAR2 DEFAULT NULL)
    RETURN PLS_INTEGER;

  FUNCTION f_enviar_notificacion(i_titulo      IN VARCHAR2,
                                 i_contenido   IN VARCHAR2,
                                 i_id_usuario  IN NUMBER DEFAULT NULL,
                                 i_suscripcion IN VARCHAR2 DEFAULT NULL)
    RETURN PLS_INTEGER;

END;
/
CREATE OR REPLACE PACKAGE BODY k_mensajeria IS

  FUNCTION f_validar_direccion_correo(i_direccion_correo VARCHAR2)
    RETURN BOOLEAN IS
  BEGIN
    RETURN regexp_like(i_direccion_correo,
                       k_util.f_valor_parametro('REGEXP_VALIDAR_DIRECCION_CORREO'));
  END;

  FUNCTION f_validar_numero_telefono(i_numero_telefono VARCHAR2)
    RETURN BOOLEAN IS
  BEGIN
    RETURN regexp_like(i_numero_telefono,
                       k_util.f_valor_parametro('REGEXP_VALIDAR_NUMERO_TELEFONO'));
  END;

  FUNCTION f_direccion_correo_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2 IS
    l_direccion_correo t_usuarios.direccion_correo%TYPE;
  BEGIN
    BEGIN
      SELECT direccion_correo
        INTO l_direccion_correo
        FROM t_usuarios
       WHERE id_usuario = i_id_usuario;
    EXCEPTION
      WHEN no_data_found THEN
        l_direccion_correo := NULL;
    END;
    RETURN l_direccion_correo;
  END;

  FUNCTION f_numero_telefono_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2 IS
    l_numero_telefono t_usuarios.numero_telefono%TYPE;
  BEGIN
    BEGIN
      SELECT numero_telefono
        INTO l_numero_telefono
        FROM t_usuarios
       WHERE id_usuario = i_id_usuario;
    EXCEPTION
      WHEN no_data_found THEN
        l_numero_telefono := NULL;
    END;
    RETURN l_numero_telefono;
  END;

  PROCEDURE p_enviar_correo(i_subject    IN VARCHAR2,
                            i_body       IN CLOB,
                            i_id_usuario IN NUMBER DEFAULT NULL,
                            i_to         IN VARCHAR2 DEFAULT NULL,
                            i_reply_to   IN VARCHAR2 DEFAULT NULL,
                            i_cc         IN VARCHAR2 DEFAULT NULL,
                            i_bcc        IN VARCHAR2 DEFAULT NULL) IS
    l_mensaje_to t_correos.mensaje_to%TYPE;
  BEGIN
    l_mensaje_to := i_to;
  
    IF i_id_usuario IS NOT NULL AND l_mensaje_to IS NULL THEN
      l_mensaje_to := f_direccion_correo_usuario(i_id_usuario);
    END IF;
  
    IF l_mensaje_to IS NULL THEN
      raise_application_error(-20000,
                              'Dirección de correo destino obligatorio');
    END IF;
  
    IF i_subject IS NULL THEN
      raise_application_error(-20000, 'Asunto del mensaje obligatorio');
    END IF;
  
    IF i_body IS NULL THEN
      raise_application_error(-20000, 'Cuerpo del mensaje obligatorio');
    END IF;
  
    IF NOT k_sistema.f_es_produccion THEN
      l_mensaje_to := k_util.f_valor_parametro('DIRECCION_CORREO_PRUEBAS');
    END IF;
  
    INSERT INTO t_correos
      (id_usuario,
       mensaje_to,
       mensaje_subject,
       mensaje_body,
       mensaje_from,
       mensaje_reply_to,
       mensaje_cc,
       mensaje_bcc,
       estado)
    VALUES
      (i_id_usuario,
       l_mensaje_to,
       i_subject,
       i_body,
       k_util.f_valor_parametro('DIRECCION_CORREO_REMITENTE'),
       i_reply_to,
       i_cc,
       i_bcc,
       'P');
  END;

  PROCEDURE p_enviar_mensaje(i_contenido       IN VARCHAR2,
                             i_id_usuario      IN NUMBER DEFAULT NULL,
                             i_numero_telefono IN VARCHAR2 DEFAULT NULL) IS
    l_numero_telefono t_mensajes.numero_telefono%TYPE;
  BEGIN
    l_numero_telefono := i_numero_telefono;
  
    IF i_id_usuario IS NOT NULL AND l_numero_telefono IS NULL THEN
      l_numero_telefono := f_numero_telefono_usuario(i_id_usuario);
    END IF;
  
    IF l_numero_telefono IS NULL THEN
      raise_application_error(-20000,
                              'Número de teléfono destino obligatorio');
    END IF;
  
    IF i_contenido IS NULL THEN
      raise_application_error(-20000, 'Contenido del mensaje obligatorio');
    END IF;
  
    IF NOT k_sistema.f_es_produccion THEN
      l_numero_telefono := k_util.f_valor_parametro('NUMERO_TELEFONO_PRUEBAS');
    END IF;
  
    INSERT INTO t_mensajes
      (id_usuario, numero_telefono, contenido, estado)
    VALUES
      (i_id_usuario, l_numero_telefono, substr(i_contenido, 1, 160), 'P');
  END;

  PROCEDURE p_enviar_notificacion(i_titulo      IN VARCHAR2,
                                  i_contenido   IN VARCHAR2,
                                  i_id_usuario  IN NUMBER DEFAULT NULL,
                                  i_suscripcion IN VARCHAR2 DEFAULT NULL) IS
    l_suscripcion t_notificaciones.suscripcion%TYPE;
  BEGIN
    l_suscripcion := i_suscripcion;
  
    IF i_id_usuario IS NOT NULL AND l_suscripcion IS NULL THEN
      l_suscripcion := k_dispositivo.c_suscripcion_usuario || '_' ||
                       to_char(i_id_usuario);
    END IF;
  
    IF l_suscripcion IS NULL THEN
      raise_application_error(-20000,
                              'Tag o expresión destino obligatorio');
    END IF;
  
    IF i_titulo IS NULL THEN
      raise_application_error(-20000,
                              'Título de la notificación obligatorio');
    END IF;
  
    IF i_contenido IS NULL THEN
      raise_application_error(-20000,
                              'Contenido de la notificación obligatorio');
    END IF;
  
    IF NOT k_sistema.f_es_produccion THEN
      l_suscripcion := k_util.f_valor_parametro('SUSCRIPCION_PRUEBAS');
    END IF;
  
    INSERT INTO t_notificaciones
      (id_usuario, suscripcion, titulo, contenido, estado)
    VALUES
      (i_id_usuario,
       l_suscripcion,
       substr(i_titulo, 1, 160),
       substr(i_contenido, 1, 500),
       'P');
  END;

  FUNCTION f_enviar_correo(i_subject    IN VARCHAR2,
                           i_body       IN CLOB,
                           i_id_usuario IN NUMBER DEFAULT NULL,
                           i_to         IN VARCHAR2 DEFAULT NULL,
                           i_reply_to   IN VARCHAR2 DEFAULT NULL,
                           i_cc         IN VARCHAR2 DEFAULT NULL,
                           i_bcc        IN VARCHAR2 DEFAULT NULL)
    RETURN PLS_INTEGER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_rsp PLS_INTEGER;
  BEGIN
    -- Inicializa respuesta
    l_rsp := 0;
  
    p_enviar_correo(i_subject,
                    i_body,
                    i_id_usuario,
                    i_to,
                    i_reply_to,
                    i_cc,
                    i_bcc);
  
    COMMIT;
    RETURN l_rsp;
  EXCEPTION
    WHEN OTHERS THEN
      l_rsp := utl_call_stack.error_number(1);
      ROLLBACK;
      RETURN l_rsp;
  END;

  FUNCTION f_enviar_mensaje(i_contenido       IN VARCHAR2,
                            i_id_usuario      IN NUMBER DEFAULT NULL,
                            i_numero_telefono IN VARCHAR2 DEFAULT NULL)
    RETURN PLS_INTEGER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_rsp PLS_INTEGER;
  BEGIN
    -- Inicializa respuesta
    l_rsp := 0;
  
    p_enviar_mensaje(i_contenido, i_id_usuario, i_numero_telefono);
  
    COMMIT;
    RETURN l_rsp;
  EXCEPTION
    WHEN OTHERS THEN
      l_rsp := utl_call_stack.error_number(1);
      ROLLBACK;
      RETURN l_rsp;
  END;

  FUNCTION f_enviar_notificacion(i_titulo      IN VARCHAR2,
                                 i_contenido   IN VARCHAR2,
                                 i_id_usuario  IN NUMBER DEFAULT NULL,
                                 i_suscripcion IN VARCHAR2 DEFAULT NULL)
    RETURN PLS_INTEGER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_rsp PLS_INTEGER;
  BEGIN
    -- Inicializa respuesta
    l_rsp := 0;
  
    p_enviar_notificacion(i_titulo,
                          i_contenido,
                          i_id_usuario,
                          i_suscripcion);
  
    COMMIT;
    RETURN l_rsp;
  EXCEPTION
    WHEN OTHERS THEN
      l_rsp := utl_call_stack.error_number(1);
      ROLLBACK;
      RETURN l_rsp;
  END;

END;
/
