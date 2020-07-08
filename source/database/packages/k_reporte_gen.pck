CREATE OR REPLACE PACKAGE k_reporte_gen IS

  /**
  Agrupa operaciones relacionadas con reportes del dominio GEN
  
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

  FUNCTION version_sistema(i_parametros IN y_parametros) RETURN y_archivo;

END;
/
CREATE OR REPLACE PACKAGE BODY k_reporte_gen IS

  FUNCTION version_sistema(i_parametros IN y_parametros) RETURN y_archivo IS
    l_rsp            y_respuesta;
    l_contenido      BLOB;
    l_version_actual t_sistemas.version_actual%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Obteniendo versión del sistema';
    BEGIN
      SELECT version_actual
        INTO l_version_actual
        FROM t_sistemas
       WHERE id_sistema = 'RISK';
    EXCEPTION
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'gen0001',
                                     'Error al obtener versión del sistema');
        RAISE k_servicio.ex_error_general;
    END;
  
    as_pdf3_v5.init;
    as_pdf3_v5.set_page_format('A4');
    as_pdf3_v5.set_page_orientation('P');
    as_pdf3_v5.write(l_version_actual);
  
    l_contenido := as_pdf3_v5.get_pdf;
    RETURN k_reporte.f_archivo_ok(l_contenido);
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN k_reporte.f_archivo_error(l_rsp);
    WHEN k_servicio.ex_error_general THEN
      RETURN k_reporte.f_archivo_error(l_rsp);
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN k_reporte.f_archivo_error(l_rsp);
  END;

END;
/
