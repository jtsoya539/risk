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

  FUNCTION version_servicio(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION valor_parametro(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION significado_codigo(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION listar_significados(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION listar_errores(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION recuperar_archivo(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION guardar_archivo(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION recuperar_texto(i_parametros IN y_parametros) RETURN y_respuesta;

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
        FROM t_modulos
       WHERE id_modulo = 'RISK';
    EXCEPTION
      WHEN OTHERS THEN
        k_operacion.p_respuesta_error(l_rsp,
                                      'gen0001',
                                      'Error al obtener versión del sistema');
        RAISE k_operacion.ex_error_general;
    END;
  
    k_operacion.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
                                        utl_call_stack.error_number(1),
                                        utl_call_stack.error_msg(1),
                                        dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION version_servicio(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp  y_respuesta;
    l_dato y_dato;
    --
    l_servicio t_operaciones.nombre%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Obteniendo parámetros';
    l_servicio  := k_operacion.f_valor_parametro_string(i_parametros,
                                                        'servicio');
  
    l_rsp.lugar := 'Validando parametros';
    k_operacion.p_validar_parametro(l_rsp,
                                    l_servicio IS NOT NULL,
                                    'Debe ingresar servicio');
  
    l_rsp.lugar := 'Obteniendo versión del servicio ' || l_servicio;
    BEGIN
      SELECT version_actual
        INTO l_dato.contenido
        FROM t_operaciones
       WHERE nombre = upper(l_servicio);
    EXCEPTION
      WHEN OTHERS THEN
        k_operacion.p_respuesta_error(l_rsp,
                                      'gen0001',
                                      'Error al obtener versión del servicio ' ||
                                      l_servicio);
        RAISE k_operacion.ex_error_general;
    END;
  
    k_operacion.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
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
    k_operacion.p_validar_parametro(l_rsp,
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'parametro') IS NOT NULL,
                                    'Debe ingresar parametro');
  
    l_rsp.lugar      := 'Obteniendo valor del parametro';
    l_dato.contenido := k_util.f_valor_parametro(k_operacion.f_valor_parametro_string(i_parametros,
                                                                                      'parametro'));
  
    IF l_dato.contenido IS NULL THEN
      k_operacion.p_respuesta_error(l_rsp,
                                    'gen0001',
                                    'Parametro inexistente');
      RAISE k_operacion.ex_error_general;
    END IF;
  
    k_operacion.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
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
    k_operacion.p_validar_parametro(l_rsp,
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'dominio') IS NOT NULL,
                                    'Debe ingresar dominio');
  
    k_operacion.p_validar_parametro(l_rsp,
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'codigo') IS NOT NULL,
                                    'Debe ingresar codigo');
  
    l_rsp.lugar      := 'Obteniendo significado';
    l_dato.contenido := k_util.f_significado_codigo(k_operacion.f_valor_parametro_string(i_parametros,
                                                                                         'dominio'),
                                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                                         'codigo'));
  
    IF l_dato.contenido IS NULL THEN
      k_operacion.p_respuesta_error(l_rsp,
                                    'gen0001',
                                    'Significado inexistente');
      RAISE k_operacion.ex_error_general;
    END IF;
  
    k_operacion.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
                                        utl_call_stack.error_number(1),
                                        utl_call_stack.error_msg(1),
                                        dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION listar_significados(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_pagina    y_pagina;
    l_elementos y_objetos;
    l_elemento  y_significado;
  
    CURSOR cr_elementos(i_dominio IN VARCHAR2) IS
      SELECT a.dominio, a.codigo, a.significado, a.referencia, a.activo
        FROM t_significados a
       WHERE a.dominio = i_dominio
       ORDER BY a.significado;
  BEGIN
    -- Inicializa respuesta
    l_rsp       := NEW y_respuesta();
    l_elementos := NEW y_objetos();
  
    FOR ele IN cr_elementos(k_operacion.f_valor_parametro_string(i_parametros,
                                                                 'dominio')) LOOP
      l_elemento             := NEW y_significado();
      l_elemento.dominio     := ele.dominio;
      l_elemento.codigo      := ele.codigo;
      l_elemento.significado := ele.significado;
      l_elemento.referencia  := ele.referencia;
      l_elemento.activo      := ele.activo;
    
      l_elementos.extend;
      l_elementos(l_elementos.count) := l_elemento;
    END LOOP;
  
    l_pagina := k_servicio.f_paginar_elementos(l_elementos,
                                               k_servicio.f_pagina_parametros(i_parametros));
  
    k_operacion.p_respuesta_ok(l_rsp, l_pagina);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
                                        utl_call_stack.error_number(1),
                                        utl_call_stack.error_msg(1),
                                        dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION listar_errores(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_pagina    y_pagina;
    l_elementos y_objetos;
    l_elemento  y_error;
  
    CURSOR cr_elementos(i_id_error IN VARCHAR2) IS
      SELECT a.id_error, a.mensaje
        FROM t_errores a
       WHERE a.id_error = nvl(i_id_error, a.id_error)
       ORDER BY a.id_error;
  BEGIN
    -- Inicializa respuesta
    l_rsp       := NEW y_respuesta();
    l_elementos := NEW y_objetos();
  
    FOR ele IN cr_elementos(k_operacion.f_valor_parametro_string(i_parametros,
                                                                 'id_error')) LOOP
      l_elemento          := NEW y_error();
      l_elemento.id_error := ele.id_error;
      l_elemento.mensaje  := ele.mensaje;
    
      l_elementos.extend;
      l_elementos(l_elementos.count) := l_elemento;
    END LOOP;
  
    l_pagina := k_servicio.f_paginar_elementos(l_elementos,
                                               k_servicio.f_pagina_parametros(i_parametros));
  
    k_operacion.p_respuesta_ok(l_rsp, l_pagina);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
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
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_operacion.p_validar_parametro(l_rsp,
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'tabla') IS NOT NULL,
                                    'Debe ingresar tabla');
  
    k_operacion.p_validar_parametro(l_rsp,
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'campo') IS NOT NULL,
                                    'Debe ingresar campo');
  
    k_operacion.p_validar_parametro(l_rsp,
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'referencia') IS NOT NULL,
                                    'Debe ingresar referencia');
  
    l_rsp.lugar := 'Recuperando archivo';
    l_archivo   := k_archivo.f_recuperar_archivo(k_operacion.f_valor_parametro_string(i_parametros,
                                                                                      'tabla'),
                                                 k_operacion.f_valor_parametro_string(i_parametros,
                                                                                      'campo'),
                                                 k_operacion.f_valor_parametro_string(i_parametros,
                                                                                      'referencia'),
                                                 k_operacion.f_valor_parametro_number(i_parametros,
                                                                                      'version'));
  
    IF (l_archivo.contenido IS NULL OR
       dbms_lob.getlength(l_archivo.contenido) = 0) AND
       l_archivo.url IS NULL THEN
      k_operacion.p_respuesta_error(l_rsp,
                                    'gen0001',
                                    'Archivo inexistente');
      RAISE k_operacion.ex_error_general;
    END IF;
  
    k_operacion.p_respuesta_ok(l_rsp, l_archivo);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
                                        utl_call_stack.error_number(1),
                                        utl_call_stack.error_msg(1),
                                        dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION guardar_archivo(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp     y_respuesta;
    l_archivo y_archivo;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_operacion.p_validar_parametro(l_rsp,
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'tabla') IS NOT NULL,
                                    'Debe ingresar tabla');
  
    k_operacion.p_validar_parametro(l_rsp,
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'campo') IS NOT NULL,
                                    'Debe ingresar campo');
  
    k_operacion.p_validar_parametro(l_rsp,
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'referencia') IS NOT NULL,
                                    'Debe ingresar referencia');
  
    k_operacion.p_validar_parametro(l_rsp,
                                    k_operacion.f_valor_parametro_object(i_parametros,
                                                                         'archivo') IS NOT NULL,
                                    'Debe ingresar archivo');
    l_archivo := treat(k_operacion.f_valor_parametro_object(i_parametros,
                                                            'archivo') AS
                       y_archivo);
  
    l_rsp.lugar := 'Guardando archivo';
    k_archivo.p_guardar_archivo(k_operacion.f_valor_parametro_string(i_parametros,
                                                                     'tabla'),
                                k_operacion.f_valor_parametro_string(i_parametros,
                                                                     'campo'),
                                k_operacion.f_valor_parametro_string(i_parametros,
                                                                     'referencia'),
                                l_archivo);
  
    k_operacion.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
                                        utl_call_stack.error_number(1),
                                        utl_call_stack.error_msg(1),
                                        dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION recuperar_texto(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp     y_respuesta;
    l_dato    y_dato;
    l_archivo y_archivo;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Validando parametros';
    k_operacion.p_validar_parametro(l_rsp,
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'referencia') IS NOT NULL,
                                    'Debe ingresar referencia');
  
    l_rsp.lugar := 'Recuperando texto';
    l_archivo   := k_archivo.f_recuperar_archivo(k_archivo.c_carpeta_textos,
                                                 'ARCHIVO',
                                                 k_operacion.f_valor_parametro_string(i_parametros,
                                                                                      'referencia'));
  
    IF l_archivo.contenido IS NULL OR
       dbms_lob.getlength(l_archivo.contenido) = 0 THEN
      k_operacion.p_respuesta_error(l_rsp, 'gen0001', 'Texto inexistente');
      RAISE k_operacion.ex_error_general;
    END IF;
  
    l_dato.contenido := k_util.blob_to_clob(l_archivo.contenido);
  
    k_operacion.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
                                        utl_call_stack.error_number(1),
                                        utl_call_stack.error_msg(1),
                                        dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

END;
/
