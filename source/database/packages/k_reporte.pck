CREATE OR REPLACE PACKAGE k_reporte IS

  /**
  Agrupa operaciones relacionadas con los Reportes del sistema
  
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

  -- Formatos de salida
  c_formato_pdf  CONSTANT VARCHAR2(10) := 'PDF';
  c_formato_docx CONSTANT VARCHAR2(10) := 'DOCX';
  c_formato_xlsx CONSTANT VARCHAR2(10) := 'XLSX';
  c_formato_csv  CONSTANT VARCHAR2(10) := 'CSV';
  c_formato_html CONSTANT VARCHAR2(10) := 'HTML';

  -- Orientaciones
  c_orientacion_vertical   CONSTANT VARCHAR2(10) := 'PORTRAIT';
  c_orientacion_horizontal CONSTANT VARCHAR2(10) := 'LANDSCAPE';

  -- Nombres de metadatos para conversión de reportes HTML a PDF
  c_meta_format           CONSTANT VARCHAR2(30) := 'risk:format';
  c_meta_page_size        CONSTANT VARCHAR2(30) := 'risk:page_size';
  c_meta_page_orientation CONSTANT VARCHAR2(30) := 'risk:page_orientation';

  PROCEDURE p_registrar_sql_ejecucion(i_id_reporte IN NUMBER,
                                      i_sql        IN CLOB);

  PROCEDURE p_limpiar_historial;

  FUNCTION f_archivo_ok(i_contenido IN BLOB,
                        i_formato   IN VARCHAR2 DEFAULT NULL,
                        i_nombre    IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo;

  FUNCTION f_archivo_error(i_respuesta IN y_respuesta,
                           i_formato   IN VARCHAR2 DEFAULT NULL,
                           i_nombre    IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo;

  FUNCTION f_formato(i_parametros IN y_parametros) RETURN VARCHAR2;

  /**
  Agrega encabezado y pie de página al reporte PDF con formato:
  
  enc1                   enc3
  enc2                   enc4
  ---------------------------
  
  
     Contenido del reporte
  
  
  ---------------------------
  pie1                   pie2
  
  %author jtsoya539 19/3/2024 13:13:50
  %param i_encabezado1 Texto 1 del encabezado
  %param i_encabezado2 Texto 2 del encabezado
  %param i_encabezado3 Texto 3 del encabezado
  %param i_encabezado4 Texto 4 del encabezado
  %param i_pie1 Texto 1 del pie
  %param i_pie2 Texto 2 del pie
  %param i_page_nr Número de página actual
  %param i_page_count Número total de páginas
  */
  PROCEDURE p_agregar_encabezado_pie_pdf(i_encabezado1 IN VARCHAR2 DEFAULT NULL,
                                         i_encabezado2 IN VARCHAR2 DEFAULT NULL,
                                         i_encabezado3 IN VARCHAR2 DEFAULT NULL,
                                         i_encabezado4 IN VARCHAR2 DEFAULT NULL,
                                         i_pie1        IN VARCHAR2 DEFAULT NULL,
                                         i_pie2        IN VARCHAR2 DEFAULT NULL,
                                         i_page_nr     IN NUMBER DEFAULT NULL,
                                         i_page_count  IN NUMBER DEFAULT NULL);

  FUNCTION f_reporte_sql(i_consulta_sql IN CLOB,
                         i_formato      IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo;

  FUNCTION f_reporte_sql(i_id_reporte IN NUMBER,
                         i_parametros IN y_parametros) RETURN y_archivo;

  FUNCTION f_procesar_reporte(i_id_reporte IN NUMBER,
                              i_parametros IN CLOB,
                              i_contexto   IN CLOB DEFAULT NULL,
                              i_version    IN VARCHAR2 DEFAULT NULL)
    RETURN CLOB;

  FUNCTION f_procesar_reporte(i_nombre     IN VARCHAR2,
                              i_dominio    IN VARCHAR2,
                              i_parametros IN CLOB,
                              i_contexto   IN CLOB DEFAULT NULL,
                              i_version    IN VARCHAR2 DEFAULT NULL)
    RETURN CLOB;

END;
/
CREATE OR REPLACE PACKAGE BODY k_reporte IS

  PROCEDURE lp_registrar_ejecucion(i_id_reporte IN NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE t_reportes
       SET cantidad_ejecuciones   = nvl(cantidad_ejecuciones, 0) + 1,
           fecha_ultima_ejecucion = SYSDATE
     WHERE id_reporte = i_id_reporte;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  PROCEDURE p_registrar_sql_ejecucion(i_id_reporte IN NUMBER,
                                      i_sql        IN CLOB) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE t_reportes
       SET sql_ultima_ejecucion = i_sql
     WHERE id_reporte = i_id_reporte;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  FUNCTION lf_procesar_reporte(i_id_reporte IN NUMBER,
                               i_parametros IN CLOB,
                               i_contexto   IN CLOB DEFAULT NULL,
                               i_version    IN VARCHAR2 DEFAULT NULL)
    RETURN y_respuesta IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_rsp                 y_respuesta;
    l_prms                y_parametros;
    l_ctx                 y_parametros;
    l_archivo             y_archivo;
    l_nombre_reporte      t_operaciones.nombre%TYPE;
    l_tipo_implementacion t_operaciones.tipo_implementacion%TYPE;
    l_tipo_reporte        t_reportes.tipo%TYPE;
    l_consulta_sql        t_servicios.consulta_sql%TYPE;
    l_sentencia           CLOB;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Buscando datos del reporte';
    BEGIN
      SELECT upper(o.nombre), o.tipo_implementacion, r.tipo, r.consulta_sql
        INTO l_nombre_reporte,
             l_tipo_implementacion,
             l_tipo_reporte,
             l_consulta_sql
        FROM t_reportes r, t_operaciones o
       WHERE o.id_operacion = r.id_reporte
         AND o.activo = 'S'
         AND r.id_reporte = i_id_reporte;
    EXCEPTION
      WHEN no_data_found THEN
        k_operacion.p_respuesta_error(l_rsp,
                                      k_operacion.c_servicio_no_implementado,
                                      'Reporte inexistente o inactivo');
        RAISE k_operacion.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Procesando parámetros del reporte';
    BEGIN
      l_prms := k_operacion.f_procesar_parametros(i_id_reporte,
                                                  i_parametros,
                                                  i_version);
    EXCEPTION
      WHEN OTHERS THEN
        k_operacion.p_respuesta_error(l_rsp,
                                      k_operacion.c_error_parametro,
                                      CASE
                                      k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                                      k_error.c_user_defined_error THEN
                                      utl_call_stack.error_msg(1) WHEN
                                      k_error.c_oracle_predefined_error THEN
                                      k_error.f_mensaje_error(k_operacion.c_error_parametro) END,
                                      dbms_utility.format_error_stack);
        RAISE k_operacion.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Procesando contexto';
    BEGIN
      l_ctx := k_operacion.f_procesar_parametros(k_operacion.c_id_operacion_contexto,
                                                 i_contexto);
    EXCEPTION
      WHEN OTHERS THEN
        k_operacion.p_respuesta_error(l_rsp,
                                      k_operacion.c_error_parametro,
                                      CASE
                                      k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                                      k_error.c_user_defined_error THEN
                                      utl_call_stack.error_msg(1) WHEN
                                      k_error.c_oracle_predefined_error THEN
                                      k_error.f_mensaje_error(k_operacion.c_error_parametro) END,
                                      dbms_utility.format_error_stack);
        RAISE k_operacion.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Definiendo parámetros en la sesión';
    k_operacion.p_definir_parametros(i_id_reporte, l_ctx);
  
    l_rsp.lugar := 'Validando permiso por aplicación';
    IF k_sistema.f_valor_parametro_string(k_sistema.c_id_aplicacion) IS NOT NULL THEN
      IF NOT k_operacion.f_validar_permiso_aplicacion(k_sistema.f_valor_parametro_string(k_sistema.c_id_aplicacion),
                                                      i_id_reporte) THEN
        k_operacion.p_respuesta_error(l_rsp,
                                      k_operacion.c_error_permiso,
                                      k_error.f_mensaje_error(k_operacion.c_error_permiso));
        RAISE k_operacion.ex_error_general;
      END IF;
    END IF;
  
    l_rsp.lugar := 'Validando permiso por usuario';
    IF k_sistema.f_valor_parametro_number(k_sistema.c_id_usuario) IS NOT NULL THEN
      IF NOT
          k_autorizacion.f_validar_permiso(k_sistema.f_valor_parametro_number(k_sistema.c_id_usuario),
                                           k_operacion.f_id_permiso(i_id_reporte)) THEN
        k_operacion. p_respuesta_error(l_rsp,
                                       k_operacion.c_error_permiso,
                                       k_error.f_mensaje_error(k_operacion.c_error_permiso));
        RAISE k_operacion.ex_error_general;
      END IF;
    END IF;
  
    IF l_tipo_reporte = 'C' THEN
      -- CONSULTA
      l_archivo := f_reporte_sql(i_id_reporte, l_prms);
    
    ELSE
      l_rsp.lugar := 'Construyendo sentencia';
      IF l_tipo_implementacion IN
         (k_operacion.c_tipo_implementacion_paquete,
          k_operacion.c_tipo_implementacion_funcion) THEN
        l_sentencia := 'BEGIN :1 := ' ||
                       k_operacion.f_nombre_programa(i_id_reporte,
                                                     i_version) ||
                       '(:2); END;';
      ELSIF l_tipo_implementacion =
            k_operacion.c_tipo_implementacion_bloque THEN
        l_sentencia := 'DECLARE ' || l_consulta_sql || ' BEGIN :1 := ' ||
                       k_operacion.f_nombre_programa(i_id_reporte,
                                                     i_version) ||
                       '(:2); END;';
      END IF;
    
      -- Registra SQL
      p_registrar_sql_ejecucion(i_id_reporte, l_sentencia);
    
      l_rsp.lugar := 'Procesando reporte';
      BEGIN
        EXECUTE IMMEDIATE l_sentencia
          USING OUT l_archivo, IN l_prms;
      EXCEPTION
        WHEN k_operacion.ex_servicio_no_implementado THEN
          k_operacion.p_respuesta_error(l_rsp,
                                        k_operacion.c_servicio_no_implementado,
                                        'Servicio no implementado',
                                        dbms_utility.format_error_stack);
          RAISE k_operacion.ex_error_general;
        WHEN OTHERS THEN
          k_operacion.p_respuesta_error(l_rsp,
                                        k_operacion.c_error_general,
                                        CASE
                                        k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                                        k_error.c_user_defined_error THEN
                                        utl_call_stack.error_msg(1) WHEN
                                        k_error.c_oracle_predefined_error THEN
                                        'Error al procesar servicio' END,
                                        dbms_utility.format_error_stack);
          RAISE k_operacion.ex_error_general;
      END;
    
    END IF;
  
    l_rsp.datos := l_archivo;
  
    IF l_rsp.codigo = k_operacion.c_ok THEN
      COMMIT;
    ELSE
      RAISE k_operacion.ex_error_general;
    END IF;
  
    k_operacion.p_respuesta_ok(l_rsp, l_rsp.datos);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_operacion.ex_error_general THEN
      ROLLBACK;
      RETURN l_rsp;
    WHEN OTHERS THEN
      ROLLBACK;
      k_operacion.p_respuesta_excepcion(l_rsp,
                                        utl_call_stack.error_number(1),
                                        utl_call_stack.error_msg(1),
                                        dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  PROCEDURE p_limpiar_historial IS
  BEGIN
    UPDATE t_reportes
       SET cantidad_ejecuciones   = NULL,
           fecha_ultima_ejecucion = NULL,
           sql_ultima_ejecucion   = NULL;
  END;

  FUNCTION f_archivo_ok(i_contenido IN BLOB,
                        i_formato   IN VARCHAR2 DEFAULT NULL,
                        i_nombre    IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo IS
    l_archivo y_archivo;
    l_formato VARCHAR2(10);
  BEGIN
    -- Inicializa archivo
    l_archivo := NEW y_archivo();
  
    l_formato := upper(nvl(i_formato,
                           k_util.f_valor_parametro('REPORTE_FORMATO_SALIDA_DEFECTO')));
  
    l_archivo.contenido := i_contenido;
    k_archivo.p_calcular_propiedades(l_archivo.contenido,
                                     l_archivo.checksum,
                                     l_archivo.tamano);
    l_archivo.nombre    := lower(nvl(i_nombre,
                                     k_sistema.f_valor_parametro_string(k_sistema.c_nombre_operacion) ||
                                     to_char(SYSDATE, '_YYYYMMDD_HH24MISS')));
    l_archivo.extension := lower(l_formato);
    l_archivo.tipo_mime := k_archivo.f_tipo_mime('EXTENSION_REPORTE',
                                                 l_formato);
  
    RETURN l_archivo;
  END;

  FUNCTION f_archivo_error(i_respuesta IN y_respuesta,
                           i_formato   IN VARCHAR2 DEFAULT NULL,
                           i_nombre    IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo IS
    l_archivo y_archivo;
    l_formato VARCHAR2(10);
  BEGIN
    -- Inicializa archivo
    l_archivo := NEW y_archivo();
  
    l_formato := upper(nvl(i_formato,
                           k_util.f_valor_parametro('REPORTE_FORMATO_SALIDA_DEFECTO')));
  
    CASE l_formato
      WHEN c_formato_pdf THEN
        -- PDF
        as_pdf.init;
        as_pdf.set_info(k_sistema.f_valor_parametro_string(k_sistema.c_nombre_operacion),
                        k_sistema.f_usuario);
        as_pdf.set_page_format('A4');
        as_pdf.set_page_orientation('PORTRAIT');
        as_pdf.set_margins(2.5, 3, 2.5, 3, 'cm');
        as_pdf.write('Código: ' || i_respuesta.codigo);
        as_pdf.write(utl_tcp.crlf);
        as_pdf.write('Mensaje: ' || i_respuesta.mensaje);
        l_archivo.contenido := as_pdf.get_pdf;
      
      WHEN c_formato_docx THEN
        -- DOCX
        DECLARE
          l_document  PLS_INTEGER;
          l_paragraph PLS_INTEGER;
        BEGIN
          l_document          := zt_word.f_new_document;
          l_paragraph         := zt_word.f_new_paragraph(p_doc_id => l_document,
                                                         p_text   => 'Código: ' ||
                                                                     i_respuesta.codigo);
          l_paragraph         := zt_word.f_new_paragraph(p_doc_id => l_document,
                                                         p_text   => 'Mensaje: ' ||
                                                                     i_respuesta.mensaje);
          l_archivo.contenido := zt_word.f_make_document(l_document);
        END;
      
      WHEN c_formato_xlsx THEN
        -- XLSX
        as_xlsx.clear_workbook;
        as_xlsx.new_sheet('Error');
        as_xlsx.cell(1,
                     1,
                     'Código',
                     p_fontid => as_xlsx.get_font(p_name => 'Calibri',
                                                  p_bold => TRUE));
        as_xlsx.cell(1,
                     2,
                     'Mensaje',
                     p_fontid => as_xlsx.get_font(p_name => 'Calibri',
                                                  p_bold => TRUE));
        as_xlsx.cell(2, 1, i_respuesta.codigo);
        as_xlsx.cell(2, 2, i_respuesta.mensaje);
        -- as_xlsx.set_column_width(2, 100);
        l_archivo.contenido := as_xlsx.finish;
      
      WHEN c_formato_csv THEN
        -- CSV
        DECLARE
          l_txt CLOB;
        BEGIN
          l_txt               := 'Código: ' || i_respuesta.codigo ||
                                 utl_tcp.crlf || 'Mensaje: ' ||
                                 i_respuesta.mensaje;
          l_archivo.contenido := k_util.clob_to_blob(l_txt);
        END;
      
      WHEN c_formato_html THEN
        -- HTML
        k_html.p_inicializar;
        htp.htmlopen;
        htp.headopen;
        htp.p('<meta charset="utf-8">');
        htp.meta(NULL, c_meta_format, c_formato_pdf);
        htp.meta(NULL, c_meta_page_size, 'A4');
        htp.meta(NULL, c_meta_page_orientation, c_orientacion_vertical);
        htp.meta(NULL, 'author', k_sistema.f_usuario);
        htp.meta(NULL, 'description', '');
        htp.title(k_sistema.f_valor_parametro_string(k_sistema.c_nombre_operacion));
        htp.headclose;
        htp.bodyopen;
        htp.header(1, k_html.f_escapar_texto('Código'));
        htp.p('<p>' || k_html.f_escapar_texto(i_respuesta.codigo) ||
              '</p>');
        htp.header(1, k_html.f_escapar_texto('Mensaje'));
        htp.p('<p>' || k_html.f_escapar_texto(i_respuesta.mensaje) ||
              '</p>');
        htp.bodyclose;
        htp.htmlclose;
        l_archivo.contenido := k_util.clob_to_blob(k_html.f_html);
      
      ELSE
        raise_application_error(-20000, 'Formato de salida no soportado');
    END CASE;
  
    k_archivo.p_calcular_propiedades(l_archivo.contenido,
                                     l_archivo.checksum,
                                     l_archivo.tamano);
    l_archivo.nombre    := lower(nvl(i_nombre,
                                     k_sistema.f_valor_parametro_string(k_sistema.c_nombre_operacion) ||
                                     to_char(SYSDATE, '_YYYYMMDD_HH24MISS')));
    l_archivo.extension := lower(l_formato);
    l_archivo.tipo_mime := k_archivo.f_tipo_mime('EXTENSION_REPORTE',
                                                 l_formato);
  
    RETURN l_archivo;
  END;

  FUNCTION f_formato(i_parametros IN y_parametros) RETURN VARCHAR2 IS
  BEGIN
    RETURN upper(substr(nvl(k_operacion.f_valor_parametro_string(i_parametros,
                                                                 'formato'),
                            k_util.f_valor_parametro('REPORTE_FORMATO_SALIDA_DEFECTO')),
                        1,
                        10));
  
  EXCEPTION
    WHEN OTHERS THEN
      RETURN upper(substr(k_util.f_valor_parametro('REPORTE_FORMATO_SALIDA_DEFECTO'),
                          1,
                          10));
  END;

  PROCEDURE p_agregar_encabezado_pie_pdf(i_encabezado1 IN VARCHAR2 DEFAULT NULL,
                                         i_encabezado2 IN VARCHAR2 DEFAULT NULL,
                                         i_encabezado3 IN VARCHAR2 DEFAULT NULL,
                                         i_encabezado4 IN VARCHAR2 DEFAULT NULL,
                                         i_pie1        IN VARCHAR2 DEFAULT NULL,
                                         i_pie2        IN VARCHAR2 DEFAULT NULL,
                                         i_page_nr     IN NUMBER DEFAULT NULL,
                                         i_page_count  IN NUMBER DEFAULT NULL) IS
    c_font  CONSTANT VARCHAR2(100) := 'helvetica';
    c_color CONSTANT VARCHAR2(6) := '7f7f7f';
    --
    l_encabezado1  VARCHAR2(300);
    l_encabezado2  VARCHAR2(300);
    l_encabezado3  VARCHAR2(300);
    l_encabezado4  VARCHAR2(300);
    l_pie1         VARCHAR2(300);
    l_pie2         VARCHAR2(300);
    l_x            NUMBER;
    l_y_encabezado NUMBER;
    l_y_pie        NUMBER;
  BEGIN
    l_encabezado1 := substr(i_encabezado1, 1, 300);
    l_encabezado2 := substr(i_encabezado2, 1, 300);
    l_encabezado3 := substr(nvl(i_encabezado3,
                                to_char(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')),
                            1,
                            300);
    l_encabezado4 := substr(nvl(i_encabezado4, k_sistema.f_usuario), 1, 300);
    l_pie1        := substr(nvl(i_pie1,
                                k_sistema.f_valor_parametro_string(k_sistema.c_nombre_operacion)),
                            1,
                            300);
    l_pie2        := substr(nvl(i_pie2,
                                'Página ' || to_char(i_page_nr) || ' de ' ||
                                to_char(i_page_count)),
                            1,
                            300);
    --
    as_pdf.set_font(c_font, 8);
    as_pdf.set_color(c_color);
    --
    l_x            := as_pdf.get(as_pdf.c_get_margin_left);
    l_y_encabezado := as_pdf.get(as_pdf.c_get_page_height) -
                      (as_pdf.get(as_pdf.c_get_margin_top) / 1.1);
    l_y_pie        := as_pdf.get(as_pdf.c_get_margin_bottom) / 1.1;
    -- Encabezado
    as_pdf.horizontal_line(l_x,
                           l_y_encabezado,
                           as_pdf.get(as_pdf.c_get_page_width) -
                           (as_pdf.get(as_pdf.c_get_margin_left) +
                            as_pdf.get(as_pdf.c_get_margin_right)),
                           1,
                           c_color);
    --
    as_pdf.write(p_txt       => l_encabezado1,
                 p_x         => l_x,
                 p_y         => l_y_encabezado + 15,
                 p_alignment => 'left');
    as_pdf.write(p_txt       => l_encabezado2,
                 p_x         => l_x,
                 p_y         => l_y_encabezado + 5,
                 p_alignment => 'left');
    as_pdf.write(p_txt       => l_encabezado3,
                 p_x         => l_x,
                 p_y         => l_y_encabezado + 5,
                 p_alignment => 'right');
    as_pdf.write(p_txt       => l_encabezado4,
                 p_x         => l_x,
                 p_y         => l_y_encabezado + 15,
                 p_alignment => 'right');
    -- Pie
    as_pdf.horizontal_line(l_x,
                           l_y_pie,
                           as_pdf.get(as_pdf.c_get_page_width) -
                           (as_pdf.get(as_pdf.c_get_margin_left) +
                            as_pdf.get(as_pdf.c_get_margin_right)),
                           1,
                           c_color);
    --
    as_pdf.put_txt(l_x, l_y_pie - 13, l_pie1);
    as_pdf.put_txt(as_pdf.get(as_pdf.c_get_page_width) -
                   as_pdf.get(as_pdf.c_get_margin_right) -
                   as_pdf.str_len(l_pie2),
                   l_y_pie - 13,
                   l_pie2);
  END;

  FUNCTION f_reporte_sql(i_consulta_sql IN CLOB,
                         i_formato      IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo IS
    l_rsp          y_respuesta;
    l_contenido    BLOB;
    l_formato      VARCHAR2(10);
    l_consulta_sql t_reportes.consulta_sql%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_consulta_sql := i_consulta_sql;
    l_formato      := upper(nvl(i_formato,
                                k_util.f_valor_parametro('REPORTE_FORMATO_SALIDA_DEFECTO')));
  
    CASE l_formato
      WHEN c_formato_pdf THEN
        -- PDF
        DECLARE
          l_cursor        PLS_INTEGER;
          l_col_cnt       PLS_INTEGER;
          l_desc_tab      dbms_sql.desc_tab2;
          l_columns       as_pdf.tp_columns;
          l_max_tab_width NUMBER;
        BEGIN
          as_pdf.init;
          as_pdf.set_info(k_sistema.f_valor_parametro_string(k_sistema.c_nombre_operacion),
                          k_sistema.f_usuario);
          as_pdf.set_page_format('A4');
          as_pdf.set_page_orientation('LANDSCAPE');
          as_pdf.set_margins(1.27, 1.27, 1.27, 1.27, 'cm');
          as_pdf.set_font('helvetica', 8);
        
          l_cursor := dbms_sql.open_cursor;
          dbms_sql.parse(l_cursor, l_consulta_sql, dbms_sql.native);
          dbms_sql.describe_columns2(l_cursor, l_col_cnt, l_desc_tab);
        
          l_max_tab_width := as_pdf.get(as_pdf.c_get_page_width) -
                             as_pdf.get(as_pdf.c_get_margin_left) -
                             as_pdf.get(as_pdf.c_get_margin_right);
        
          l_columns := NEW as_pdf.tp_columns();
          FOR i IN 1 .. l_col_cnt LOOP
            l_columns.extend;
            l_columns(l_columns.count).collabel := l_desc_tab(i).col_name;
            l_columns(l_columns.count).colwidth := round(l_max_tab_width /
                                                         l_col_cnt,
                                                         1);
          END LOOP;
        
          as_pdf.query2table(l_consulta_sql,
                             l_columns,
                             as_pdf.c_dft_colours);
          l_contenido := as_pdf.get_pdf;
        END;
      
      WHEN c_formato_docx THEN
        -- DOCX
        DECLARE
          l_document      PLS_INTEGER;
          l_table         PLS_INTEGER;
          l_cursor        PLS_INTEGER;
          l_row_cnt       PLS_INTEGER;
          l_col_cnt       PLS_INTEGER;
          l_row_counter   PLS_INTEGER;
          l_page          zt_word.r_page;
          l_desc_tab      dbms_sql.desc_tab2;
          l_columns_width VARCHAR2(4000);
          l_buffer        VARCHAR2(32767);
        BEGIN
          l_document           := zt_word.f_new_document;
          l_page               := zt_word.f_get_default_page(l_document);
          l_page.orientation   := 'landscape';
          l_page.margin_top    := 720; -- 1.27 cm
          l_page.margin_bottom := 720; -- 1.27 cm
          l_page.margin_left   := 720; -- 1.27 cm
          l_page.margin_right  := 720; -- 1.27 cm
          zt_word.p_set_default_page(l_document, l_page);
        
          -- Obtiene la cantidad total de registros de la consulta
          EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM (' || l_consulta_sql || ')'
            INTO l_row_cnt;
        
          l_cursor := dbms_sql.open_cursor;
          dbms_sql.parse(l_cursor, l_consulta_sql, dbms_sql.native);
          dbms_sql.describe_columns2(l_cursor, l_col_cnt, l_desc_tab);
        
          FOR i IN 1 .. l_col_cnt LOOP
            dbms_sql.define_column(l_cursor, i, l_buffer, 32767);
            IF i > 1 THEN
              l_columns_width := l_columns_width || ',';
            END IF;
            l_columns_width := l_columns_width || '0';
          END LOOP;
        
          -- Crea una tabla con la cantidad calculada de filas y columnas
          l_table := zt_word.f_new_table(p_doc_id        => l_document,
                                         p_rows          => l_row_cnt + 1,
                                         p_columns       => l_col_cnt,
                                         p_columns_width => l_columns_width);
        
          -- Define los encabezados en la primera fila de la tabla
          FOR i IN 1 .. l_col_cnt LOOP
            zt_word.p_table_cell(p_doc_id           => l_document,
                                 p_table_id         => l_table,
                                 p_row              => 1,
                                 p_column           => i,
                                 p_alignment_h      => 'LEFT',
                                 p_font             => zt_word.f_font(p_font_size => 9,
                                                                      p_bold      => TRUE),
                                 p_background_color => 'CCCCCC',
                                 p_text             => l_desc_tab(i).col_name);
          END LOOP;
        
          l_row_cnt := dbms_sql.execute(l_cursor);
        
          -- Define los campos a partir de la segunda fila de la tabla
          l_row_counter := 1;
          LOOP
            EXIT WHEN dbms_sql.fetch_rows(l_cursor) = 0;
            l_row_counter := l_row_counter + 1;
            FOR i IN 1 .. l_col_cnt LOOP
              IF l_desc_tab(i).col_type IN (dbms_types.typecode_blob) THEN
                l_buffer := NULL;
              ELSE
                dbms_sql.column_value(l_cursor, i, l_buffer);
              END IF;
              l_buffer := REPLACE(l_buffer, '<', '&lt;');
              l_buffer := REPLACE(l_buffer, '>', '&gt;');
              l_buffer := REPLACE(l_buffer, '&', '&amp;');
              l_buffer := REPLACE(l_buffer, '"', '&quot;');
              l_buffer := REPLACE(l_buffer, '''', '&apos;');
              l_buffer := k_cadena.f_reemplazar_acentos(l_buffer);
              l_buffer := nvl(l_buffer, ' ');
              zt_word.p_table_cell(p_doc_id      => l_document,
                                   p_table_id    => l_table,
                                   p_row         => l_row_counter,
                                   p_column      => i,
                                   p_alignment_h => 'LEFT',
                                   p_font        => zt_word.f_font(p_font_size => 9),
                                   p_text        => l_buffer);
            END LOOP;
          END LOOP;
        
          dbms_sql.close_cursor(l_cursor);
        
          l_contenido := zt_word.f_make_document(l_document);
        END;
      
      WHEN c_formato_xlsx THEN
        -- XLSX
        as_xlsx.clear_workbook;
        as_xlsx.query2sheet(l_consulta_sql);
        l_contenido := as_xlsx.finish;
      
      WHEN c_formato_csv THEN
        -- CSV
        csv.generate_clob(l_consulta_sql);
        l_contenido := k_util.clob_to_blob(csv.get_clob);
      
      WHEN c_formato_html THEN
        -- HTML
        DECLARE
          l_table CLOB;
        BEGIN
          l_table := k_html.f_query2table(l_consulta_sql);
          --
          k_html.p_inicializar;
          htp.htmlopen;
          htp.headopen;
          htp.p('<meta charset="utf-8">');
          htp.meta(NULL, c_meta_format, c_formato_pdf);
          htp.meta(NULL, c_meta_page_size, 'A4');
          htp.meta(NULL, c_meta_page_orientation, c_orientacion_horizontal);
          htp.meta(NULL, 'author', k_sistema.f_usuario);
          htp.meta(NULL, 'description', '');
          htp.title(k_sistema.f_valor_parametro_string(k_sistema.c_nombre_operacion));
          htp.headclose;
          htp.bodyopen;
          --
          k_html.p_print(nvl(l_table, '&' || 'nbsp;'));
          --
          htp.bodyclose;
          htp.htmlclose;
          l_contenido := k_util.clob_to_blob(k_html.f_html);
        END;
      
    END CASE;
  
    RETURN f_archivo_ok(l_contenido, l_formato);
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN f_archivo_error(l_rsp, l_formato);
    WHEN k_operacion.ex_error_general THEN
      RETURN f_archivo_error(l_rsp, l_formato);
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
                                        utl_call_stack.error_number(1),
                                        utl_call_stack.error_msg(1),
                                        dbms_utility.format_error_stack);
      RETURN f_archivo_error(l_rsp, l_formato);
  END;

  FUNCTION f_reporte_sql(i_id_reporte IN NUMBER,
                         i_parametros IN y_parametros) RETURN y_archivo IS
    l_rsp          y_respuesta;
    l_formato      VARCHAR2(10);
    l_consulta_sql t_reportes.consulta_sql%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Buscando datos del reporte';
    BEGIN
      SELECT r.consulta_sql
        INTO l_consulta_sql
        FROM t_reportes r, t_operaciones o
       WHERE o.id_operacion = r.id_reporte
         AND o.activo = 'S'
         AND r.id_reporte = i_id_reporte;
    EXCEPTION
      WHEN no_data_found THEN
        k_operacion.p_respuesta_error(l_rsp,
                                      k_operacion.c_error_parametro,
                                      'Reporte inexistente o inactivo');
        RAISE k_operacion.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Validando parámetros';
    l_formato   := f_formato(i_parametros);
  
    IF l_consulta_sql IS NULL THEN
      k_operacion.p_respuesta_error(l_rsp,
                                    k_operacion.c_error_general,
                                    'Consulta SQL no definida');
      RAISE k_operacion.ex_error_parametro;
    END IF;
  
    l_consulta_sql := 'SELECT * FROM (' || l_consulta_sql || ')' ||
                      k_operacion.f_filtros_sql(i_parametros);
    -- Registra SQL
    p_registrar_sql_ejecucion(i_id_reporte, l_consulta_sql);
  
    RETURN f_reporte_sql(l_consulta_sql, l_formato);
  EXCEPTION
    WHEN k_operacion.ex_error_parametro THEN
      RETURN f_archivo_error(l_rsp, l_formato);
    WHEN k_operacion.ex_error_general THEN
      RETURN f_archivo_error(l_rsp, l_formato);
    WHEN OTHERS THEN
      k_operacion.p_respuesta_excepcion(l_rsp,
                                        utl_call_stack.error_number(1),
                                        utl_call_stack.error_msg(1),
                                        dbms_utility.format_error_stack);
      RETURN f_archivo_error(l_rsp, l_formato);
  END;

  FUNCTION f_procesar_reporte(i_id_reporte IN NUMBER,
                              i_parametros IN CLOB,
                              i_contexto   IN CLOB DEFAULT NULL,
                              i_version    IN VARCHAR2 DEFAULT NULL)
    RETURN CLOB IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa parámetros de la sesión
    k_sistema.p_inicializar_parametros;
    -- Registra ejecución
    lp_registrar_ejecucion(i_id_reporte);
    -- Reserva identificador para log
    k_operacion.p_reservar_id_log(i_id_reporte);
    -- Procesa reporte
    l_rsp := lf_procesar_reporte(i_id_reporte,
                                 i_parametros,
                                 i_contexto,
                                 i_version);
    -- Registra log con datos de entrada y salida
    k_operacion.p_registrar_log(i_id_reporte,
                                i_parametros,
                                l_rsp.codigo,
                                l_rsp.to_json,
                                i_contexto,
                                i_version);
    RETURN l_rsp.to_json;
  END;

  FUNCTION f_procesar_reporte(i_nombre     IN VARCHAR2,
                              i_dominio    IN VARCHAR2,
                              i_parametros IN CLOB,
                              i_contexto   IN CLOB DEFAULT NULL,
                              i_version    IN VARCHAR2 DEFAULT NULL)
    RETURN CLOB IS
    l_rsp        y_respuesta;
    l_id_reporte t_reportes.id_reporte%TYPE;
  BEGIN
    -- Inicializa parámetros de la sesión
    k_sistema.p_inicializar_parametros;
    -- Busca reporte
    l_id_reporte := k_operacion.f_id_operacion(k_operacion.c_tipo_reporte,
                                               i_nombre,
                                               i_dominio);
    -- Registra ejecución
    lp_registrar_ejecucion(l_id_reporte);
    -- Reserva identificador para log
    k_operacion.p_reservar_id_log(l_id_reporte);
    -- Procesa reporte
    l_rsp := lf_procesar_reporte(l_id_reporte,
                                 i_parametros,
                                 i_contexto,
                                 i_version);
    -- Registra log con datos de entrada y salida
    k_operacion.p_registrar_log(l_id_reporte,
                                i_parametros,
                                l_rsp.codigo,
                                l_rsp.to_json,
                                i_contexto,
                                i_version);
    RETURN l_rsp.to_json;
  END;

END;
/
