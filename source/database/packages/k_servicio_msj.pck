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

  FUNCTION listar_mensajes_pendientes(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION cambiar_estado_mensaje(i_parametros IN y_parametros)
    RETURN y_respuesta;

END;
/
CREATE OR REPLACE PACKAGE BODY k_servicio_msj IS

  FUNCTION listar_mensajes_pendientes(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_pagina    y_pagina;
    l_elementos y_objetos;
    l_elemento  y_mensaje;
  
    l_retorno           PLS_INTEGER;
    l_anydata           anydata;
    l_pagina_parametros y_pagina_parametros;
  
    CURSOR cr_elementos IS
      SELECT id_mensaje, numero_telefono, mensaje, estado
        FROM t_mensajes
       WHERE estado IN ('P', 'R')
      -- P-PENDIENTE DE ENVÍO
      -- R-PROCESADO CON ERROR
       ORDER BY id_mensaje
         FOR UPDATE OF estado;
  BEGIN
    -- Inicializa respuesta
    l_rsp       := NEW y_respuesta();
    l_elementos := NEW y_objetos();
  
    l_rsp.lugar := 'Validando parametros';
    l_anydata   := k_servicio.f_valor_parametro(i_parametros,
                                                'pagina_parametros');
    IF l_anydata IS NOT NULL THEN
      l_retorno := l_anydata.getobject(l_pagina_parametros);
    END IF;
    IF l_pagina_parametros IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'msj0001',
                                   'Debe ingresar pagina_parametros');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    FOR ele IN cr_elementos LOOP
      l_elemento                 := NEW y_mensaje();
      l_elemento.id_mensaje      := ele.id_mensaje;
      l_elemento.numero_telefono := ele.numero_telefono;
      l_elemento.contenido       := ele.mensaje;
    
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

  FUNCTION cambiar_estado_mensaje(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessnumber(k_servicio.f_valor_parametro(i_parametros,
                                                         'id_mensaje')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'msj0001',
                                   'Debe ingresar id_mensaje');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    IF anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                           'estado')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'msj0002',
                                   'Debe ingresar estado');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    IF anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                           'respuesta_envio')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'msj0003',
                                   'Debe ingresar respuesta_envio');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    l_rsp.lugar := 'Cambiando estado de mensaje';
    UPDATE t_mensajes m
       SET m.estado          = anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                   'estado')),
           m.respuesta_envio = substr(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                          'respuesta_envio')),
                                      1,
                                      1000),
           m.fecha_envio = CASE
                             WHEN anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                      'estado')) IN
                                  ('E', 'R') THEN
                              SYSDATE
                             ELSE
                              NULL
                           END
     WHERE m.id_mensaje =
           anydata.accessnumber(k_servicio.f_valor_parametro(i_parametros,
                                                             'id_mensaje'));
  
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
