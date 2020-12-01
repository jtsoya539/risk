CREATE OR REPLACE PACKAGE k_servicio_msj IS

  /**
  Agrupa operaciones relacionadas con los Servicios Web del dominio MSJ
  
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

  FUNCTION listar_correos_pendientes(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION listar_mensajes_pendientes(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION listar_notificaciones_pendientes(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION cambiar_estado_mensajeria(i_parametros IN y_parametros)
    RETURN y_respuesta;

END;
/
CREATE OR REPLACE PACKAGE BODY k_servicio_msj IS

  FUNCTION lf_adjuntos(i_id_correo IN NUMBER) RETURN y_archivos IS
    l_adjuntos y_archivos;
    l_archivo  y_archivo;
  
    CURSOR cr_elementos IS
      SELECT id_correo_adjunto
        FROM t_correo_adjuntos
       WHERE id_correo = i_id_correo
       ORDER BY id_correo_adjunto;
  BEGIN
    -- Inicializa respuesta
    l_adjuntos := NEW y_archivos();
  
    FOR ele IN cr_elementos LOOP
      l_archivo := NEW y_archivo();
      l_archivo := k_archivo.f_recuperar_archivo('T_CORREO_ADJUNTOS',
                                                 'ARCHIVO',
                                                 to_char(ele.id_correo_adjunto));
      l_adjuntos.extend;
      l_adjuntos(l_adjuntos.count) := l_archivo;
    END LOOP;
  
    RETURN l_adjuntos;
  END;

  FUNCTION listar_correos_pendientes(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_pagina    y_pagina;
    l_elementos y_objetos;
    l_elemento  y_correo;
  
    l_pagina_parametros y_pagina_parametros;
  
    CURSOR cr_elementos IS
      SELECT id_correo,
             id_usuario,
             mensaje_to,
             mensaje_subject,
             mensaje_body,
             mensaje_from,
             mensaje_reply_to,
             mensaje_cc,
             mensaje_bcc,
             estado,
             fecha_envio,
             respuesta_envio
        FROM t_correos
       WHERE estado IN ('P', 'R')
      -- P-PENDIENTE DE ENVÍO
      -- R-PROCESADO CON ERROR
       ORDER BY nvl(prioridad_envio, k_mensajeria.c_prioridad_media),
                id_correo
         FOR UPDATE OF estado;
  BEGIN
    -- Inicializa respuesta
    l_rsp       := NEW y_respuesta();
    l_elementos := NEW y_objetos();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_object(i_parametros,
                                                                        'pagina_parametros') IS NOT NULL,
                                   'Debe ingresar pagina_parametros');
    l_pagina_parametros := treat(k_operacion.f_valor_parametro_object(i_parametros,
                                                                      'pagina_parametros') AS
                                 y_pagina_parametros);
  
    FOR ele IN cr_elementos LOOP
      l_elemento                  := NEW y_correo();
      l_elemento.id_correo        := ele.id_correo;
      l_elemento.mensaje_to       := ele.mensaje_to;
      l_elemento.mensaje_subject  := ele.mensaje_subject;
      l_elemento.mensaje_body     := ele.mensaje_body;
      l_elemento.mensaje_from     := ele.mensaje_from;
      l_elemento.mensaje_reply_to := ele.mensaje_reply_to;
      l_elemento.mensaje_cc       := ele.mensaje_cc;
      l_elemento.mensaje_bcc      := ele.mensaje_bcc;
      l_elemento.adjuntos         := lf_adjuntos(ele.id_correo);
    
      l_elementos.extend;
      l_elementos(l_elementos.count) := l_elemento;
    
      UPDATE t_correos
         SET estado = 'N' -- N-EN PROCESO DE ENVÍO
       WHERE CURRENT OF cr_elementos;
    END LOOP;
  
    l_pagina := k_servicio.f_paginar_elementos(l_elementos,
                                               l_pagina_parametros.pagina,
                                               l_pagina_parametros.por_pagina,
                                               l_pagina_parametros.no_paginar);
  
    k_servicio.p_respuesta_ok(l_rsp, l_pagina);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION listar_mensajes_pendientes(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_pagina    y_pagina;
    l_elementos y_objetos;
    l_elemento  y_mensaje;
  
    l_pagina_parametros y_pagina_parametros;
  
    CURSOR cr_elementos IS
      SELECT id_mensaje, numero_telefono, contenido, estado
        FROM t_mensajes
       WHERE estado IN ('P', 'R')
      -- P-PENDIENTE DE ENVÍO
      -- R-PROCESADO CON ERROR
       ORDER BY nvl(prioridad_envio, k_mensajeria.c_prioridad_media),
                id_mensaje
         FOR UPDATE OF estado;
  BEGIN
    -- Inicializa respuesta
    l_rsp       := NEW y_respuesta();
    l_elementos := NEW y_objetos();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_object(i_parametros,
                                                                        'pagina_parametros') IS NOT NULL,
                                   'Debe ingresar pagina_parametros');
    l_pagina_parametros := treat(k_operacion.f_valor_parametro_object(i_parametros,
                                                                      'pagina_parametros') AS
                                 y_pagina_parametros);
  
    FOR ele IN cr_elementos LOOP
      l_elemento                 := NEW y_mensaje();
      l_elemento.id_mensaje      := ele.id_mensaje;
      l_elemento.numero_telefono := ele.numero_telefono;
      l_elemento.contenido       := ele.contenido;
    
      l_elementos.extend;
      l_elementos(l_elementos.count) := l_elemento;
    
      UPDATE t_mensajes
         SET estado = 'N' -- N-EN PROCESO DE ENVÍO
       WHERE CURRENT OF cr_elementos;
    END LOOP;
  
    l_pagina := k_servicio.f_paginar_elementos(l_elementos,
                                               l_pagina_parametros.pagina,
                                               l_pagina_parametros.por_pagina,
                                               l_pagina_parametros.no_paginar);
  
    k_servicio.p_respuesta_ok(l_rsp, l_pagina);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION listar_notificaciones_pendientes(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_pagina    y_pagina;
    l_elementos y_objetos;
    l_elemento  y_notificacion;
  
    l_pagina_parametros y_pagina_parametros;
  
    CURSOR cr_elementos IS
      SELECT id_notificacion, suscripcion, titulo, contenido, estado
        FROM t_notificaciones
       WHERE estado IN ('P', 'R')
      -- P-PENDIENTE DE ENVÍO
      -- R-PROCESADO CON ERROR
       ORDER BY nvl(prioridad_envio, k_mensajeria.c_prioridad_media),
                id_notificacion
         FOR UPDATE OF estado;
  BEGIN
    -- Inicializa respuesta
    l_rsp       := NEW y_respuesta();
    l_elementos := NEW y_objetos();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_object(i_parametros,
                                                                        'pagina_parametros') IS NOT NULL,
                                   'Debe ingresar pagina_parametros');
    l_pagina_parametros := treat(k_operacion.f_valor_parametro_object(i_parametros,
                                                                      'pagina_parametros') AS
                                 y_pagina_parametros);
  
    FOR ele IN cr_elementos LOOP
      l_elemento                 := NEW y_notificacion();
      l_elemento.id_notificacion := ele.id_notificacion;
      l_elemento.suscripcion     := ele.suscripcion;
      l_elemento.titulo          := ele.titulo;
      l_elemento.contenido       := ele.contenido;
    
      l_elementos.extend;
      l_elementos(l_elementos.count) := l_elemento;
    
      UPDATE t_notificaciones
         SET estado = 'N' -- N-EN PROCESO DE ENVÍO
       WHERE CURRENT OF cr_elementos;
    END LOOP;
  
    l_pagina := k_servicio.f_paginar_elementos(l_elementos,
                                               l_pagina_parametros.pagina,
                                               l_pagina_parametros.por_pagina,
                                               l_pagina_parametros.no_paginar);
  
    k_servicio.p_respuesta_ok(l_rsp, l_pagina);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION cambiar_estado_mensajeria(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parámetros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'tipo_mensajeria') IS NOT NULL,
                                   'Debe ingresar tipo_mensajeria');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'tipo_mensajeria') IN
                                   ('M', 'S', 'P'),
                                   'Valor no válido para tipo_mensajeria');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_number(i_parametros,
                                                                        'id_mensajeria') IS NOT NULL,
                                   'Debe ingresar id_mensajeria');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'estado') IS NOT NULL,
                                   'Debe ingresar estado');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'respuesta_envio') IS NOT NULL,
                                   'Debe ingresar respuesta_envio');
  
    l_rsp.lugar := 'Cambiando estado de mensajería';
    CASE
     k_operacion.f_valor_parametro_string(i_parametros, 'tipo_mensajeria')
    
      WHEN 'M' THEN
        -- Mail
        UPDATE t_correos m
           SET m.cantidad_intentos_envio = nvl(m.cantidad_intentos_envio, 0) + 1,
               m.estado                  = CASE
                                             WHEN k_operacion.f_valor_parametro_string(i_parametros, 'estado') IN
                                                  ('R') AND nvl(m.cantidad_intentos_envio, 0) >=
                                                  k_mensajeria.c_cantidad_intentos_permitidos THEN
                                              'A' -- ANULADO
                                             ELSE
                                              k_operacion.f_valor_parametro_string(i_parametros, 'estado')
                                           END,
               m.respuesta_envio         = substr(k_operacion.f_valor_parametro_string(i_parametros,
                                                                                       'respuesta_envio'),
                                                  1,
                                                  1000),
               m.fecha_envio             = CASE
                                             WHEN k_operacion.f_valor_parametro_string(i_parametros, 'estado') IN
                                                  ('E', 'R') THEN
                                              SYSDATE
                                             ELSE
                                              NULL
                                           END
         WHERE m.id_correo =
               k_operacion.f_valor_parametro_number(i_parametros,
                                                    'id_mensajeria');
      
      WHEN 'S' THEN
        -- SMS
        UPDATE t_mensajes m
           SET m.cantidad_intentos_envio = nvl(m.cantidad_intentos_envio, 0) + 1,
               m.estado                  = CASE
                                             WHEN k_operacion.f_valor_parametro_string(i_parametros, 'estado') IN
                                                  ('R') AND nvl(m.cantidad_intentos_envio, 0) >=
                                                  k_mensajeria.c_cantidad_intentos_permitidos THEN
                                              'A' -- ANULADO
                                             ELSE
                                              k_operacion.f_valor_parametro_string(i_parametros, 'estado')
                                           END,
               m.respuesta_envio         = substr(k_operacion.f_valor_parametro_string(i_parametros,
                                                                                       'respuesta_envio'),
                                                  1,
                                                  1000),
               m.fecha_envio             = CASE
                                             WHEN k_operacion.f_valor_parametro_string(i_parametros, 'estado') IN
                                                  ('E', 'R') THEN
                                              SYSDATE
                                             ELSE
                                              NULL
                                           END
         WHERE m.id_mensaje =
               k_operacion.f_valor_parametro_number(i_parametros,
                                                    'id_mensajeria');
      
      WHEN 'P' THEN
        -- Push
        UPDATE t_notificaciones m
           SET m.cantidad_intentos_envio = nvl(m.cantidad_intentos_envio, 0) + 1,
               m.estado                  = CASE
                                             WHEN k_operacion.f_valor_parametro_string(i_parametros, 'estado') IN
                                                  ('R') AND nvl(m.cantidad_intentos_envio, 0) >=
                                                  k_mensajeria.c_cantidad_intentos_permitidos THEN
                                              'A' -- ANULADO
                                             ELSE
                                              k_operacion.f_valor_parametro_string(i_parametros, 'estado')
                                           END,
               m.respuesta_envio         = substr(k_operacion.f_valor_parametro_string(i_parametros,
                                                                                       'respuesta_envio'),
                                                  1,
                                                  1000),
               m.fecha_envio             = CASE
                                             WHEN k_operacion.f_valor_parametro_string(i_parametros, 'estado') IN
                                                  ('E', 'R') THEN
                                              SYSDATE
                                             ELSE
                                              NULL
                                           END
         WHERE m.id_notificacion =
               k_operacion.f_valor_parametro_number(i_parametros,
                                                    'id_mensajeria');
      
    END CASE;
  
    k_servicio.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

END;
/
