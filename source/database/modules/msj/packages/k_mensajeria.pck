CREATE OR REPLACE PACKAGE k_mensajeria IS

  /**
  Agrupa operaciones relacionadas con el env�o de mensajes a los usuarios
  
  El env�o de mensajes se puede realizar a trav�s de:
  <ul>
  <li>Correo electr�nico (E-mail)</li>
  <li>Mensaje de texto (SMS)</li>
  <li>Notificaci�n push</li>
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

  c_ok                           CONSTANT PLS_INTEGER := 0;
  c_cantidad_intentos_permitidos CONSTANT PLS_INTEGER := 3;

  -- Prioridades de env�o
  c_prioridad_urgente    CONSTANT PLS_INTEGER := 1;
  c_prioridad_importante CONSTANT PLS_INTEGER := 2;
  c_prioridad_media      CONSTANT PLS_INTEGER := 3;
  c_prioridad_baja       CONSTANT PLS_INTEGER := 4;

  FUNCTION f_validar_direccion_correo(i_direccion_correo VARCHAR2)
    RETURN BOOLEAN;

  FUNCTION f_validar_numero_telefono(i_numero_telefono VARCHAR2)
    RETURN BOOLEAN;

  FUNCTION f_direccion_correo_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2;

  FUNCTION f_numero_telefono_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2;

  FUNCTION f_correo_html(i_contenido      IN VARCHAR2,
                         i_titulo         IN VARCHAR2 DEFAULT NULL,
                         i_encabezado     IN VARCHAR2 DEFAULT NULL,
                         i_pie            IN VARCHAR2 DEFAULT NULL,
                         i_boton_etiqueta IN VARCHAR2 DEFAULT NULL,
                         i_boton_accion   IN VARCHAR2 DEFAULT NULL)
    RETURN CLOB;

  PROCEDURE p_enviar_correo(i_subject         IN VARCHAR2,
                            i_body            IN CLOB,
                            i_id_usuario      IN NUMBER DEFAULT NULL,
                            i_to              IN VARCHAR2 DEFAULT NULL,
                            i_reply_to        IN VARCHAR2 DEFAULT NULL,
                            i_cc              IN VARCHAR2 DEFAULT NULL,
                            i_bcc             IN VARCHAR2 DEFAULT NULL,
                            i_adjuntos        IN y_archivos DEFAULT NULL,
                            i_prioridad_envio IN NUMBER DEFAULT NULL);

  PROCEDURE p_enviar_mensaje(i_contenido       IN VARCHAR2,
                             i_id_usuario      IN NUMBER DEFAULT NULL,
                             i_numero_telefono IN VARCHAR2 DEFAULT NULL,
                             i_prioridad_envio IN NUMBER DEFAULT NULL);

  PROCEDURE p_enviar_notificacion(i_titulo          IN VARCHAR2,
                                  i_contenido       IN VARCHAR2,
                                  i_id_usuario      IN NUMBER DEFAULT NULL,
                                  i_suscripcion     IN VARCHAR2 DEFAULT NULL,
                                  i_prioridad_envio IN NUMBER DEFAULT NULL);

  FUNCTION f_enviar_correo(i_subject         IN VARCHAR2,
                           i_body            IN CLOB,
                           i_id_usuario      IN NUMBER DEFAULT NULL,
                           i_to              IN VARCHAR2 DEFAULT NULL,
                           i_reply_to        IN VARCHAR2 DEFAULT NULL,
                           i_cc              IN VARCHAR2 DEFAULT NULL,
                           i_bcc             IN VARCHAR2 DEFAULT NULL,
                           i_adjuntos        IN y_archivos DEFAULT NULL,
                           i_prioridad_envio IN NUMBER DEFAULT NULL)
    RETURN PLS_INTEGER;

  FUNCTION f_enviar_mensaje(i_contenido       IN VARCHAR2,
                            i_id_usuario      IN NUMBER DEFAULT NULL,
                            i_numero_telefono IN VARCHAR2 DEFAULT NULL,
                            i_prioridad_envio IN NUMBER DEFAULT NULL)
    RETURN PLS_INTEGER;

  FUNCTION f_enviar_notificacion(i_titulo          IN VARCHAR2,
                                 i_contenido       IN VARCHAR2,
                                 i_id_usuario      IN NUMBER DEFAULT NULL,
                                 i_suscripcion     IN VARCHAR2 DEFAULT NULL,
                                 i_prioridad_envio IN NUMBER DEFAULT NULL)
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

  FUNCTION f_correo_html(i_contenido      IN VARCHAR2,
                         i_titulo         IN VARCHAR2 DEFAULT NULL,
                         i_encabezado     IN VARCHAR2 DEFAULT NULL,
                         i_pie            IN VARCHAR2 DEFAULT NULL,
                         i_boton_etiqueta IN VARCHAR2 DEFAULT NULL,
                         i_boton_accion   IN VARCHAR2 DEFAULT NULL)
    RETURN CLOB IS
    l_html      CLOB;
    l_contenido CLOB;
    l_archivo   y_archivo;
  BEGIN
    l_archivo := k_archivo.f_recuperar_archivo(k_archivo.c_carpeta_textos,
                                               'ARCHIVO',
                                               'email-inlined.html');
  
    IF l_archivo.contenido IS NULL OR
       dbms_lob.getlength(l_archivo.contenido) = 0 THEN
      raise_application_error(-20000, 'Template de correo no definido');
    END IF;
  
    l_html := k_util.blob_to_clob(l_archivo.contenido);
  
    -- Reemplaza CRLF por <br> en el contenido
    l_contenido := REPLACE(i_contenido, utl_tcp.crlf, '<br>');
  
    l_html := REPLACE(l_html, '&CONTENIDO', l_contenido);
    l_html := REPLACE(l_html, '&TITULO', i_titulo);
    l_html := REPLACE(l_html, '&ENCABEZADO', i_encabezado);
    l_html := REPLACE(l_html, '&PIE', i_pie);
  
    IF i_boton_etiqueta IS NOT NULL AND i_boton_accion IS NOT NULL THEN
      l_html := REPLACE(l_html, '&BOTON_ETIQUETA', i_boton_etiqueta);
      l_html := REPLACE(l_html, '&BOTON_ACCION', i_boton_accion);
      l_html := REPLACE(l_html, '&BOTON_HIDDEN');
    ELSE
      l_html := REPLACE(l_html, '&BOTON_HIDDEN', 'style="display: none;"');
    END IF;
  
    RETURN l_html;
  END;

  PROCEDURE p_enviar_correo(i_subject         IN VARCHAR2,
                            i_body            IN CLOB,
                            i_id_usuario      IN NUMBER DEFAULT NULL,
                            i_to              IN VARCHAR2 DEFAULT NULL,
                            i_reply_to        IN VARCHAR2 DEFAULT NULL,
                            i_cc              IN VARCHAR2 DEFAULT NULL,
                            i_bcc             IN VARCHAR2 DEFAULT NULL,
                            i_adjuntos        IN y_archivos DEFAULT NULL,
                            i_prioridad_envio IN NUMBER DEFAULT NULL) IS
    l_mensaje_to        t_correos.mensaje_to%TYPE;
    l_id_correo         t_correos.id_correo%TYPE;
    l_id_correo_adjunto t_correo_adjuntos.id_correo_adjunto%TYPE;
    i                   INTEGER;
  BEGIN
    l_mensaje_to := i_to;
  
    IF i_id_usuario IS NOT NULL AND l_mensaje_to IS NULL THEN
      l_mensaje_to := f_direccion_correo_usuario(i_id_usuario);
    END IF;
  
    IF l_mensaje_to IS NULL THEN
      raise_application_error(-20000,
                              'Direcci�n de correo destino obligatorio');
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
       estado,
       prioridad_envio)
    VALUES
      (i_id_usuario,
       l_mensaje_to,
       i_subject,
       i_body,
       k_util.f_valor_parametro('DIRECCION_CORREO_REMITENTE'),
       i_reply_to,
       i_cc,
       i_bcc,
       'P',
       nvl(i_prioridad_envio, c_prioridad_media))
    RETURNING id_correo INTO l_id_correo;
  
    IF i_adjuntos IS NOT NULL THEN
      i := i_adjuntos.first;
      WHILE i IS NOT NULL LOOP
        INSERT INTO t_correo_adjuntos
          (id_correo)
        VALUES
          (l_id_correo)
        RETURNING id_correo_adjunto INTO l_id_correo_adjunto;
      
        k_archivo.p_guardar_archivo('T_CORREO_ADJUNTOS',
                                    'ARCHIVO',
                                    to_char(l_id_correo_adjunto),
                                    i_adjuntos(i));
      
        i := i_adjuntos.next(i);
      END LOOP;
    END IF;
  END;

  PROCEDURE p_enviar_mensaje(i_contenido       IN VARCHAR2,
                             i_id_usuario      IN NUMBER DEFAULT NULL,
                             i_numero_telefono IN VARCHAR2 DEFAULT NULL,
                             i_prioridad_envio IN NUMBER DEFAULT NULL) IS
    l_numero_telefono t_mensajes.numero_telefono%TYPE;
  BEGIN
    l_numero_telefono := i_numero_telefono;
  
    IF i_id_usuario IS NOT NULL AND l_numero_telefono IS NULL THEN
      l_numero_telefono := f_numero_telefono_usuario(i_id_usuario);
    END IF;
  
    IF l_numero_telefono IS NULL THEN
      raise_application_error(-20000,
                              'N�mero de tel�fono destino obligatorio');
    END IF;
  
    IF i_contenido IS NULL THEN
      raise_application_error(-20000, 'Contenido del mensaje obligatorio');
    END IF;
  
    IF NOT k_sistema.f_es_produccion THEN
      l_numero_telefono := k_util.f_valor_parametro('NUMERO_TELEFONO_PRUEBAS');
    END IF;
  
    INSERT INTO t_mensajes
      (id_usuario, numero_telefono, contenido, estado, prioridad_envio)
    VALUES
      (i_id_usuario,
       l_numero_telefono,
       substr(i_contenido, 1, 160),
       'P',
       nvl(i_prioridad_envio, c_prioridad_media));
  END;

  PROCEDURE p_enviar_notificacion(i_titulo          IN VARCHAR2,
                                  i_contenido       IN VARCHAR2,
                                  i_id_usuario      IN NUMBER DEFAULT NULL,
                                  i_suscripcion     IN VARCHAR2 DEFAULT NULL,
                                  i_prioridad_envio IN NUMBER DEFAULT NULL) IS
    l_suscripcion t_notificaciones.suscripcion%TYPE;
  BEGIN
    l_suscripcion := i_suscripcion;
  
    IF i_id_usuario IS NOT NULL AND l_suscripcion IS NULL THEN
      l_suscripcion := k_dispositivo.c_suscripcion_usuario || '_' ||
                       to_char(i_id_usuario);
    END IF;
  
    IF l_suscripcion IS NULL THEN
      raise_application_error(-20000,
                              'Tag o expresi�n destino obligatorio');
    END IF;
  
    IF i_titulo IS NULL THEN
      raise_application_error(-20000,
                              'T�tulo de la notificaci�n obligatorio');
    END IF;
  
    IF i_contenido IS NULL THEN
      raise_application_error(-20000,
                              'Contenido de la notificaci�n obligatorio');
    END IF;
  
    IF NOT k_sistema.f_es_produccion THEN
      l_suscripcion := k_util.f_valor_parametro('SUSCRIPCION_PRUEBAS');
    END IF;
  
    INSERT INTO t_notificaciones
      (id_usuario, suscripcion, titulo, contenido, estado, prioridad_envio)
    VALUES
      (i_id_usuario,
       l_suscripcion,
       substr(i_titulo, 1, 160),
       substr(i_contenido, 1, 500),
       'P',
       nvl(i_prioridad_envio, c_prioridad_media));
  END;

  FUNCTION f_enviar_correo(i_subject         IN VARCHAR2,
                           i_body            IN CLOB,
                           i_id_usuario      IN NUMBER DEFAULT NULL,
                           i_to              IN VARCHAR2 DEFAULT NULL,
                           i_reply_to        IN VARCHAR2 DEFAULT NULL,
                           i_cc              IN VARCHAR2 DEFAULT NULL,
                           i_bcc             IN VARCHAR2 DEFAULT NULL,
                           i_adjuntos        IN y_archivos DEFAULT NULL,
                           i_prioridad_envio IN NUMBER DEFAULT NULL)
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
                    i_bcc,
                    i_adjuntos,
                    i_prioridad_envio);
  
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
                            i_numero_telefono IN VARCHAR2 DEFAULT NULL,
                            i_prioridad_envio IN NUMBER DEFAULT NULL)
    RETURN PLS_INTEGER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_rsp PLS_INTEGER;
  BEGIN
    -- Inicializa respuesta
    l_rsp := 0;
  
    p_enviar_mensaje(i_contenido,
                     i_id_usuario,
                     i_numero_telefono,
                     i_prioridad_envio);
  
    COMMIT;
    RETURN l_rsp;
  EXCEPTION
    WHEN OTHERS THEN
      l_rsp := utl_call_stack.error_number(1);
      ROLLBACK;
      RETURN l_rsp;
  END;

  FUNCTION f_enviar_notificacion(i_titulo          IN VARCHAR2,
                                 i_contenido       IN VARCHAR2,
                                 i_id_usuario      IN NUMBER DEFAULT NULL,
                                 i_suscripcion     IN VARCHAR2 DEFAULT NULL,
                                 i_prioridad_envio IN NUMBER DEFAULT NULL)
    RETURN PLS_INTEGER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_rsp PLS_INTEGER;
  BEGIN
    -- Inicializa respuesta
    l_rsp := 0;
  
    p_enviar_notificacion(i_titulo,
                          i_contenido,
                          i_id_usuario,
                          i_suscripcion,
                          i_prioridad_envio);
  
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
