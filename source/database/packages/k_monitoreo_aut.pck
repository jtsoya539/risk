CREATE OR REPLACE PACKAGE k_monitoreo_aut IS

  /**
  Agrupa operaciones relacionadas con los Monitoreos de Conflictos del dominio AUT
  
  %author dmezac 26/5/2022 14:54:41
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

  --Expira sesiones de usuario
  FUNCTION sesiones_expiradas(i_parametros IN y_parametros)
    RETURN y_respuesta;

END;
/
CREATE OR REPLACE PACKAGE BODY k_monitoreo_aut IS

  FUNCTION sesiones_expiradas(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp        y_respuesta;
    l_id_usuario t_usuarios.id_usuario%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar  := 'Obteniendo parámetros';
    l_id_usuario := k_operacion.f_valor_parametro_number(i_parametros,
                                                         'id_usuario');
  
    l_rsp.lugar := 'Validando parámetros';
    k_operacion.p_validar_parametro(l_rsp,
                                    l_id_usuario IS NOT NULL,
                                    'Debe ingresar id_usuario');
  
    l_rsp.lugar := 'Expirando sesiones de usuario';
    k_sesion.p_expirar_sesiones(i_id_usuario => l_id_usuario);
  
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

END;
/
