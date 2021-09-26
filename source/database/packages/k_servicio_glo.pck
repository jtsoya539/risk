CREATE OR REPLACE PACKAGE k_servicio_glo IS

  /**
  Agrupa operaciones relacionadas con los Servicios Web del dominio GLO
  
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

  FUNCTION listar_paises(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION listar_departamentos(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION listar_ciudades(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION listar_barrios(i_parametros IN y_parametros) RETURN y_respuesta;

END;
/
CREATE OR REPLACE PACKAGE BODY k_servicio_glo IS

  FUNCTION listar_paises(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_pagina    y_pagina;
    l_elementos y_objetos;
    l_elemento  y_pais;
  
    CURSOR cr_elementos(i_id_pais IN NUMBER) IS
      SELECT p.id_pais,
             p.nombre,
             p.iso_alpha_2,
             p.iso_alpha_3,
             p.iso_numeric
        FROM t_paises p
       WHERE p.id_pais = nvl(i_id_pais, p.id_pais)
       ORDER BY p.nombre;
  BEGIN
    -- Inicializa respuesta
    l_rsp       := NEW y_respuesta();
    l_elementos := NEW y_objetos();
  
    FOR ele IN cr_elementos(k_operacion.f_valor_parametro_number(i_parametros,
                                                                 'id_pais')) LOOP
      l_elemento             := NEW y_pais();
      l_elemento.id_pais     := ele.id_pais;
      l_elemento.nombre      := ele.nombre;
      l_elemento.iso_alpha_2 := ele.iso_alpha_2;
      l_elemento.iso_alpha_3 := ele.iso_alpha_3;
      l_elemento.iso_numeric := ele.iso_numeric;
    
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

  FUNCTION listar_departamentos(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_pagina    y_pagina;
    l_elementos y_objetos;
    l_elemento  y_departamento;
  
    CURSOR cr_elementos(i_id_departamento IN NUMBER,
                        i_id_pais         IN NUMBER) IS
      SELECT a.id_departamento, a.nombre, a.id_pais
        FROM t_departamentos a
       WHERE a.id_departamento = nvl(i_id_departamento, a.id_departamento)
         AND a.id_pais = nvl(i_id_pais, a.id_pais)
       ORDER BY a.nombre;
  BEGIN
    -- Inicializa respuesta
    l_rsp       := NEW y_respuesta();
    l_elementos := NEW y_objetos();
  
    FOR ele IN cr_elementos(k_operacion.f_valor_parametro_number(i_parametros,
                                                                 'id_departamento'),
                            k_operacion.f_valor_parametro_number(i_parametros,
                                                                 'id_pais')) LOOP
      l_elemento                 := NEW y_departamento();
      l_elemento.id_departamento := ele.id_departamento;
      l_elemento.nombre          := ele.nombre;
      l_elemento.id_pais         := ele.id_pais;
    
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

  FUNCTION listar_ciudades(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_pagina    y_pagina;
    l_elementos y_objetos;
    l_elemento  y_ciudad;
  
    CURSOR cr_elementos(i_id_ciudad       IN NUMBER,
                        i_id_pais         IN NUMBER,
                        i_id_departamento IN NUMBER) IS
      SELECT a.id_ciudad, a.nombre, a.id_pais, a.id_departamento
        FROM t_ciudades a
       WHERE a.id_ciudad = nvl(i_id_ciudad, a.id_ciudad)
         AND a.id_pais = nvl(i_id_pais, a.id_pais)
         AND a.id_departamento = nvl(i_id_departamento, a.id_departamento)
       ORDER BY a.nombre;
  BEGIN
    -- Inicializa respuesta
    l_rsp       := NEW y_respuesta();
    l_elementos := NEW y_objetos();
  
    FOR ele IN cr_elementos(k_operacion.f_valor_parametro_number(i_parametros,
                                                                 'id_ciudad'),
                            k_operacion.f_valor_parametro_number(i_parametros,
                                                                 'id_pais'),
                            k_operacion.f_valor_parametro_number(i_parametros,
                                                                 'id_departamento')) LOOP
      l_elemento                 := NEW y_ciudad();
      l_elemento.id_ciudad       := ele.id_ciudad;
      l_elemento.nombre          := ele.nombre;
      l_elemento.id_pais         := ele.id_pais;
      l_elemento.id_departamento := ele.id_departamento;
    
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

  FUNCTION listar_barrios(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_pagina    y_pagina;
    l_elementos y_objetos;
    l_elemento  y_barrio;
  
    CURSOR cr_elementos(i_id_barrio       IN NUMBER,
                        i_id_pais         IN NUMBER,
                        i_id_departamento IN NUMBER,
                        i_id_ciudad       IN NUMBER) IS
      SELECT a.id_barrio,
             a.nombre,
             a.id_pais,
             a.id_departamento,
             a.id_ciudad
        FROM t_barrios a
       WHERE a.id_barrio = nvl(i_id_barrio, a.id_barrio)
         AND a.id_pais = nvl(i_id_pais, a.id_pais)
         AND a.id_departamento = nvl(i_id_departamento, a.id_departamento)
         AND a.id_ciudad = nvl(i_id_ciudad, a.id_ciudad)
       ORDER BY a.nombre;
  BEGIN
    -- Inicializa respuesta
    l_rsp       := NEW y_respuesta();
    l_elementos := NEW y_objetos();
  
    FOR ele IN cr_elementos(k_operacion.f_valor_parametro_number(i_parametros,
                                                                 'id_barrio'),
                            k_operacion.f_valor_parametro_number(i_parametros,
                                                                 'id_pais'),
                            k_operacion.f_valor_parametro_number(i_parametros,
                                                                 'id_departamento'),
                            k_operacion.f_valor_parametro_number(i_parametros,
                                                                 'id_ciudad')) LOOP
      l_elemento                 := NEW y_barrio();
      l_elemento.id_barrio       := ele.id_barrio;
      l_elemento.nombre          := ele.nombre;
      l_elemento.id_pais         := ele.id_pais;
      l_elemento.id_departamento := ele.id_departamento;
      l_elemento.id_ciudad       := ele.id_ciudad;
    
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

END;
/
