CREATE OR REPLACE PACKAGE k_reporte_gen IS

  /**
  Agrupa operaciones relacionadas con los Reportes del dominio GEN
  
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
    l_formato        VARCHAR2(10);
    l_version_actual t_sistemas.version_actual%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando par�metros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'formato') IN
                                   (k_reporte.c_formato_pdf,
                                    k_reporte.c_formato_docx,
                                    k_reporte.c_formato_xlsx,
                                    k_reporte.c_formato_txt),
                                   'Formato de salida no soportado');
  
    l_formato := k_operacion.f_valor_parametro_string(i_parametros,
                                                      'formato');
  
    l_rsp.lugar := 'Obteniendo versi�n del sistema';
    BEGIN
      SELECT version_actual
        INTO l_version_actual
        FROM t_sistemas
       WHERE id_sistema = 'RISK';
    EXCEPTION
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'gen0001',
                                     'Error al obtener versi�n del sistema');
        RAISE k_servicio.ex_error_general;
    END;
  
    CASE l_formato
      WHEN k_reporte.c_formato_pdf THEN
        -- PDF
        as_pdf3.init;
        as_pdf3.set_page_format('A4');
        as_pdf3.set_page_orientation('PORTRAIT');
        as_pdf3.set_margins(2.5, 3, 2.5, 3, 'cm');
        as_pdf3.write(l_version_actual);
        l_contenido := as_pdf3.get_pdf;
      
      WHEN k_reporte.c_formato_docx THEN
        -- DOCX
        DECLARE
          l_document  PLS_INTEGER;
          l_paragraph PLS_INTEGER;
        BEGIN
          l_document  := zt_word.f_new_document;
          l_paragraph := zt_word.f_new_paragraph(p_doc_id => l_document,
                                                 p_text   => l_version_actual);
          l_contenido := zt_word.f_make_document(l_document);
        END;
      
      WHEN k_reporte.c_formato_xlsx THEN
        -- XLSX
        as_xlsx.clear_workbook;
        as_xlsx.new_sheet;
        as_xlsx.cell(1, 1, l_version_actual);
        l_contenido := as_xlsx.finish;
      
      WHEN k_reporte.c_formato_txt THEN
        -- TXT
        DECLARE
          l_txt CLOB;
        BEGIN
          l_txt       := l_version_actual;
          l_contenido := k_util.clob_to_blob(l_txt);
        END;
      
      ELSE
        k_servicio.p_respuesta_error(l_rsp,
                                     'gen0002',
                                     'Formato de salida no implementado');
        RAISE k_servicio.ex_error_general;
    END CASE;
  
    RETURN k_reporte.f_archivo_ok(l_contenido, l_formato);
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN k_reporte.f_archivo_error(l_rsp, l_formato);
    WHEN k_servicio.ex_error_general THEN
      RETURN k_reporte.f_archivo_error(l_rsp, l_formato);
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN k_reporte.f_archivo_error(l_rsp, l_formato);
  END;

END;
/
