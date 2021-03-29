FUNCTION &nombre_reporte(i_parametros IN y_parametros) RETURN y_archivo IS
  l_rsp       y_respuesta;
  l_contenido BLOB;
  l_formato   VARCHAR2(10);
BEGIN
  -- Inicializa respuesta
  l_rsp := NEW y_respuesta();

  l_rsp.lugar := 'Validando parámetros';
  k_servicio.p_validar_parametro(l_rsp,
                                 k_operacion.f_valor_parametro_string(i_parametros,
                                                                      'formato') IN
                                 (k_reporte.c_formato_pdf,
                                  k_reporte.c_formato_docx,
                                  k_reporte.c_formato_xlsx,
                                  k_reporte.c_formato_csv,
                                  k_reporte.c_formato_html),
                                 'Formato de salida no soportado');

  l_formato := k_operacion.f_valor_parametro_string(i_parametros, 'formato');

  /* TODO: text="Implementar validación de parámetros" */

  l_rsp.lugar := 'Procesando reporte';
  /* TODO: text="Implementar proceso del reporte" */
  [#]

  CASE l_formato
    WHEN k_reporte.c_formato_pdf THEN
      -- PDF
      /* TODO: text="Implementar reporte en formato PDF" */
      l_contenido := NULL;
    
    WHEN k_reporte.c_formato_docx THEN
      -- DOCX
      /* TODO: text="Implementar reporte en formato DOCX" */
      l_contenido := NULL;
    
    WHEN k_reporte.c_formato_xlsx THEN
      -- XLSX
      /* TODO: text="Implementar reporte en formato XLSX" */
      l_contenido := NULL;
    
    WHEN k_reporte.c_formato_csv THEN
      -- CSV
      /* TODO: text="Implementar reporte en formato CSV" */
      l_contenido := NULL;
    
    WHEN k_reporte.c_formato_html THEN
      -- HTML
      /* TODO: text="Implementar reporte en formato HTML" */
      l_contenido := NULL;
    
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
