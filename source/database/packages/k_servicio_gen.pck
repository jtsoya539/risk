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

  FUNCTION listar_paises(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION recuperar_archivo(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION guardar_archivo(i_parametros IN y_parametros) RETURN y_respuesta;

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
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
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
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
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
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION listar_paises(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp    y_respuesta;
    l_pagina y_pagina;
    l_paises y_objetos;
    l_pais   y_pais;
  
    CURSOR cr_paises(i_id_pais IN NUMBER) IS
      SELECT p.id_pais,
             p.nombre,
             p.iso_alpha_2,
             p.iso_alpha_3,
             p.iso_numeric
        FROM t_paises p
       WHERE p.id_pais = nvl(i_id_pais, p.id_pais);
  BEGIN
    -- Inicializa respuesta
    l_rsp    := NEW y_respuesta();
    l_pagina := NEW y_pagina();
    l_paises := NEW y_objetos();
  
    FOR pai IN cr_paises(anydata.accessnumber(k_servicio.f_valor_parametro(i_parametros,
                                                                           'id_pais'))) LOOP
      l_pais         := NEW y_pais();
      l_pais.id_pais := pai.id_pais;
      l_pais.nombre  := pai.nombre;
    
      l_paises.extend;
      l_paises(l_paises.count) := l_pais;
    END LOOP;
    l_pagina.numero_actual      := 0;
    l_pagina.numero_siguiente   := 0;
    l_pagina.numero_ultima      := 0;
    l_pagina.numero_primera     := 0;
    l_pagina.numero_anterior    := 0;
    l_pagina.cantidad_elementos := l_paises.count;
    l_pagina.elementos          := l_paises;
  
    k_servicio.p_respuesta_ok(l_rsp, l_pagina);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION recuperar_archivo(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp     y_respuesta;
    l_archivo y_archivo;
  BEGIN
    -- Inicializa respuesta
    l_rsp     := NEW y_respuesta();
    l_archivo := NEW y_archivo();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                           'tabla')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp, 'gen0001', 'Debe ingresar tabla');
      RAISE k_servicio.ex_error_parametro;
    END IF;
  
    IF anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                           'campo')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp, 'gen0002', 'Debe ingresar campo');
      RAISE k_servicio.ex_error_parametro;
    END IF;
  
    IF anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                           'referencia')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'gen0003',
                                   'Debe ingresar referencia');
      RAISE k_servicio.ex_error_parametro;
    END IF;
  
    l_rsp.lugar := 'Recuperando archivo';
    l_archivo   := k_archivo.f_recuperar_archivo(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                     'tabla')),
                                                 anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                     'campo')),
                                                 anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                     'referencia')));
  
    IF l_archivo.contenido IS NULL OR
       dbms_lob.getlength(l_archivo.contenido) = 0 THEN
      k_servicio.p_respuesta_error(l_rsp, 'gen0001', 'Archivo inexistente');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    k_servicio.p_respuesta_ok(l_rsp, l_archivo);
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

  FUNCTION guardar_archivo(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp     y_respuesta;
    l_retorno PLS_INTEGER;
    l_anydata anydata;
    l_archivo y_archivo;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    IF anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                           'tabla')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp, 'gen0001', 'Debe ingresar tabla');
      RAISE k_servicio.ex_error_parametro;
    END IF;
  
    IF anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                           'campo')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp, 'gen0002', 'Debe ingresar campo');
      RAISE k_servicio.ex_error_parametro;
    END IF;
  
    IF anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                           'referencia')) IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'gen0003',
                                   'Debe ingresar referencia');
      RAISE k_servicio.ex_error_parametro;
    END IF;
  
    l_anydata := k_servicio.f_valor_parametro(i_parametros, 'archivo');
    l_retorno := l_anydata.getobject(l_archivo);
    IF l_archivo IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'gen0004',
                                   'Debe ingresar archivo');
      RAISE k_servicio.ex_error_parametro;
    END IF;
  
    l_rsp.lugar := 'Guardando archivo';
    k_archivo.p_guardar_archivo(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                    'tabla')),
                                anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                    'campo')),
                                anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                    'referencia')),
                                l_archivo);
  
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
