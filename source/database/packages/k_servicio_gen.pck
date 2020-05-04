CREATE OR REPLACE PACKAGE k_servicio_gen IS

  /**
  Agrupa operaciones relacionadas con los Servicios Web del dominio GEN
  
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

  FUNCTION version_sistema(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION valor_parametro(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION significado_codigo(i_parametros IN y_parametros)
    RETURN y_respuesta;

END;
/
CREATE OR REPLACE PACKAGE BODY k_servicio_gen IS

  FUNCTION version_sistema(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp  y_respuesta;
    l_dato y_dato;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Obteniendo versión del sistema';
    BEGIN
      SELECT version_actual
        INTO l_dato.contenido
        FROM t_sistemas
       WHERE id_sistema = 'RISK';
    EXCEPTION
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'gen0001',
                                     'Error al obtener versión del sistema');
        RAISE k_servicio.ex_error_general;
    END;
  
    k_servicio.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   k_servicio.c_error_inesperado,
                                   k_error.f_mensaje_error(k_servicio.c_error_inesperado),
                                   dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION valor_parametro(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp  y_respuesta;
    l_dato y_dato;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                           'parametro')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'gen0001',
                                   'Debe ingresar parametro');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    l_rsp.lugar      := 'Obteniendo valor del parametro';
    l_dato.contenido := k_util.f_valor_parametro(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                     'parametro')));
  
    IF l_dato.contenido IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'gen0002',
                                   'Parametro inexistente');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    k_servicio.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   k_servicio.c_error_inesperado,
                                   k_error.f_mensaje_error(k_servicio.c_error_inesperado),
                                   dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION significado_codigo(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp  y_respuesta;
    l_dato y_dato;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                           'dominio')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'gen0001',
                                   'Debe ingresar dominio');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    IF anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                           'codigo')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'gen0002',
                                   'Debe ingresar codigo');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    l_rsp.lugar      := 'Obteniendo significado';
    l_dato.contenido := k_util.f_significado_codigo(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                        'dominio')),
                                                    anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                        'codigo')));
  
    IF l_dato.contenido IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'gen0003',
                                   'Significado inexistente');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    k_servicio.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   k_servicio.c_error_inesperado,
                                   k_error.f_mensaje_error(k_servicio.c_error_inesperado),
                                   dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

END;
/
