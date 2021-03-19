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

  PROCEDURE p_limpiar_historial;

  FUNCTION f_archivo_ok(i_contenido IN BLOB,
                        i_formato   IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo;

  FUNCTION f_archivo_error(i_respuesta IN y_respuesta,
                           i_formato   IN VARCHAR2 DEFAULT NULL)
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

  PROCEDURE lp_registrar_sql_ejecucion(i_id_reporte IN NUMBER,
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
    l_rsp             y_respuesta;
    l_prms            y_parametros;
    l_ctx             y_parametros;
    l_archivo         y_archivo;
    l_nombre_reporte  t_operaciones.nombre%TYPE;
    l_dominio_reporte t_operaciones.dominio%TYPE;
    l_version_actual  t_operaciones.version_actual%TYPE;
    l_tipo_reporte    t_reportes.tipo%TYPE;
    l_sentencia       VARCHAR2(4000);
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Buscando datos del reporte';
    BEGIN
      SELECT upper(o.nombre), upper(o.dominio), o.version_actual, r.tipo
        INTO l_nombre_reporte,
             l_dominio_reporte,
             l_version_actual,
             l_tipo_reporte
        FROM t_reportes r, t_operaciones o
       WHERE o.id_operacion = r.id_reporte
         AND o.activo = 'S'
         AND r.id_reporte = i_id_reporte;
    EXCEPTION
      WHEN no_data_found THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     k_servicio.c_servicio_no_implementado,
                                     'Reporte inexistente o inactivo');
        RAISE k_servicio.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Procesando parámetros del reporte';
    BEGIN
      l_prms := k_operacion.f_procesar_parametros(i_id_reporte,
                                                  i_parametros,
                                                  nvl(i_version,
                                                      l_version_actual));
    EXCEPTION
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     k_servicio.c_error_parametro,
                                     CASE
                                     k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                                     k_error.c_user_defined_error THEN
                                     utl_call_stack.error_msg(1) WHEN
                                     k_error.c_oracle_predefined_error THEN
                                     k_error.f_mensaje_error(k_servicio.c_error_parametro) END,
                                     dbms_utility.format_error_stack);
        RAISE k_servicio.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Procesando contexto';
    BEGIN
      l_ctx := k_operacion.f_procesar_parametros(k_operacion.c_id_operacion_contexto,
                                                 i_contexto);
    EXCEPTION
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     k_servicio.c_error_parametro,
                                     CASE
                                     k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                                     k_error.c_user_defined_error THEN
                                     utl_call_stack.error_msg(1) WHEN
                                     k_error.c_oracle_predefined_error THEN
                                     k_error.f_mensaje_error(k_servicio.c_error_parametro) END,
                                     dbms_utility.format_error_stack);
        RAISE k_servicio.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Definiendo parámetros en la sesión';
    k_sistema.p_definir_parametro_string(k_sistema.c_direccion_ip,
                                         k_operacion.f_valor_parametro_string(l_ctx,
                                                                              'direccion_ip'));
    k_sistema.p_definir_parametro_number(k_sistema.c_id_operacion,
                                         i_id_reporte);
    k_sistema.p_definir_parametro_string(k_sistema.c_nombre_operacion,
                                         l_nombre_reporte);
    k_sistema.p_definir_parametro_string(k_sistema.c_id_aplicacion,
                                         k_aplicacion.f_id_aplicacion(k_operacion.f_valor_parametro_string(l_ctx,
                                                                                                           'clave_aplicacion'),
                                                                      'S'));
    k_sistema.p_definir_parametro_number(k_sistema.c_id_sesion,
                                         k_sesion.f_id_sesion(k_operacion.f_valor_parametro_string(l_ctx,
                                                                                                   'access_token')));
    k_sistema.p_definir_parametro_number(k_sistema.c_id_usuario,
                                         k_usuario.f_id_usuario(k_operacion.f_valor_parametro_string(l_ctx,
                                                                                                     'usuario')));
    k_sistema.p_definir_parametro_string(k_sistema.c_usuario,
                                         k_operacion.f_valor_parametro_string(l_ctx,
                                                                              'usuario'));
  
    l_rsp.lugar := 'Validando permiso';
    IF k_sistema.f_valor_parametro_number(k_sistema.c_id_usuario) IS NOT NULL THEN
      IF NOT
          k_autorizacion.f_validar_permiso(k_sistema.f_valor_parametro_number(k_sistema.c_id_usuario),
                                           k_operacion.f_id_permiso(i_id_reporte)) THEN
        k_servicio. p_respuesta_error(l_rsp,
                                      k_servicio.c_error_permiso,
                                      k_error.f_mensaje_error(k_servicio.c_error_permiso));
        RAISE k_servicio.ex_error_general;
      END IF;
    END IF;
  
    IF l_tipo_reporte = 'C' THEN
      -- CONSULTA
      l_archivo := f_reporte_sql(i_id_reporte, l_prms);
    
    ELSE
      l_rsp.lugar := 'Construyendo sentencia';
      IF nvl(i_version, l_version_actual) = l_version_actual THEN
        l_sentencia := 'BEGIN :1 := K_REPORTE_' || l_dominio_reporte || '.' ||
                       l_nombre_reporte || '(:2); END;';
      ELSE
        l_sentencia := 'BEGIN :1 := K_REPORTE_' || l_dominio_reporte || '.' ||
                       l_nombre_reporte || '_' ||
                       REPLACE(i_version, '.', '_') || '(:2); END;';
      END IF;
    
      l_rsp.lugar := 'Procesando reporte';
      BEGIN
        EXECUTE IMMEDIATE l_sentencia
          USING OUT l_archivo, IN l_prms;
      EXCEPTION
        WHEN k_servicio.ex_servicio_no_implementado THEN
          k_servicio.p_respuesta_error(l_rsp,
                                       k_servicio.c_servicio_no_implementado,
                                       'Servicio no implementado',
                                       dbms_utility.format_error_stack);
          RAISE k_servicio.ex_error_general;
        WHEN OTHERS THEN
          k_servicio.p_respuesta_error(l_rsp,
                                       k_servicio.c_error_general,
                                       CASE
                                       k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                                       k_error.c_user_defined_error THEN
                                       utl_call_stack.error_msg(1) WHEN
                                       k_error.c_oracle_predefined_error THEN
                                       'Error al procesar servicio' END,
                                       dbms_utility.format_error_stack);
          RAISE k_servicio.ex_error_general;
      END;
    
    END IF;
  
    l_rsp.datos := l_archivo;
  
    IF l_rsp.codigo = k_servicio.c_ok THEN
      COMMIT;
    ELSE
      RAISE k_servicio.ex_error_general;
    END IF;
  
    k_servicio.p_respuesta_ok(l_rsp, l_rsp.datos);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      ROLLBACK;
      RETURN l_rsp;
    WHEN OTHERS THEN
      ROLLBACK;
      k_servicio.p_respuesta_excepcion(l_rsp,
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
                        i_formato   IN VARCHAR2 DEFAULT NULL)
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
    l_archivo.nombre    := lower(k_sistema.f_valor_parametro_string(k_sistema.c_nombre_operacion) ||
                                 to_char(SYSDATE, '_YYYYMMDD_HH24MISS'));
    l_archivo.extension := lower(l_formato);
    l_archivo.tipo_mime := k_archivo.f_tipo_mime('EXTENSION_REPORTE',
                                                 l_formato);
  
    RETURN l_archivo;
  END;

  FUNCTION f_archivo_error(i_respuesta IN y_respuesta,
                           i_formato   IN VARCHAR2 DEFAULT NULL)
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
        as_pdf3.init;
        as_pdf3.set_page_format('A4');
        as_pdf3.set_page_orientation('PORTRAIT');
        as_pdf3.set_margins(2.5, 3, 2.5, 3, 'cm');
        as_pdf3.write('Código: ' || i_respuesta.codigo);
        as_pdf3.write(utl_tcp.crlf);
        as_pdf3.write('Mensaje: ' || i_respuesta.mensaje);
        l_archivo.contenido := as_pdf3.get_pdf;
      
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
        k_util.p_inicializar_html;
        htp.htmlopen;
        htp.headopen;
        htp.title(k_sistema.f_valor_parametro_string(k_sistema.c_nombre_operacion));
        htp.headclose;
        htp.bodyopen;
        htp.header(1, 'Código');
        htp.p('<p>' || i_respuesta.codigo || '</p>');
        htp.header(1, 'Mensaje');
        htp.p('<p>' || i_respuesta.mensaje || '</p>');
        htp.bodyclose;
        htp.htmlclose;
        l_archivo.contenido := k_util.clob_to_blob(k_util.f_html);
      
      ELSE
        raise_application_error(-20000, 'Formato de salida no soportado');
    END CASE;
  
    k_archivo.p_calcular_propiedades(l_archivo.contenido,
                                     l_archivo.checksum,
                                     l_archivo.tamano);
    l_archivo.nombre    := lower(k_sistema.f_valor_parametro_string(k_sistema.c_nombre_operacion) ||
                                 to_char(SYSDATE, '_YYYYMMDD_HH24MISS'));
    l_archivo.extension := lower(l_formato);
    l_archivo.tipo_mime := k_archivo.f_tipo_mime('EXTENSION_REPORTE',
                                                 l_formato);
  
    RETURN l_archivo;
  END;

  FUNCTION f_reporte_sql(i_id_reporte IN NUMBER,
                         i_parametros IN y_parametros) RETURN y_archivo IS
    l_rsp             y_respuesta;
    l_contenido       BLOB;
    l_formato         VARCHAR2(10);
    l_nombre_reporte  t_operaciones.nombre%TYPE;
    l_dominio_reporte t_operaciones.dominio%TYPE;
    l_consulta_sql    t_reportes.consulta_sql%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Buscando datos del reporte';
    BEGIN
      SELECT upper(o.nombre), upper(o.dominio), r.consulta_sql
        INTO l_nombre_reporte, l_dominio_reporte, l_consulta_sql
        FROM t_reportes r, t_operaciones o
       WHERE o.id_operacion = r.id_reporte
         AND o.activo = 'S'
         AND r.id_reporte = i_id_reporte;
    EXCEPTION
      WHEN no_data_found THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     k_servicio.c_error_parametro,
                                     'Reporte inexistente o inactivo');
        RAISE k_servicio.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Validando parámetros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'formato') IN
                                   (c_formato_pdf,
                                    c_formato_docx,
                                    c_formato_xlsx,
                                    c_formato_csv,
                                    c_formato_html),
                                   'Formato de salida no soportado');
  
    l_formato := k_operacion.f_valor_parametro_string(i_parametros,
                                                      'formato');
  
    IF l_consulta_sql IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   k_servicio.c_error_general,
                                   'Consulta SQL no definida');
      RAISE k_servicio.ex_error_parametro;
    END IF;
  
    l_consulta_sql := 'SELECT * FROM (' || l_consulta_sql || ')' ||
                      k_operacion.f_filtros_sql(i_parametros);
    -- Registra SQL
    lp_registrar_sql_ejecucion(i_id_reporte, l_consulta_sql);
  
    CASE l_formato
      WHEN c_formato_pdf THEN
        -- PDF
        DECLARE
          l_cursor   PLS_INTEGER;
          l_col_cnt  PLS_INTEGER;
          l_desc_tab dbms_sql.desc_tab2;
          l_headers  as_pdf3.tp_headers;
        BEGIN
          as_pdf3.init;
          as_pdf3.set_page_format('A4');
          as_pdf3.set_page_orientation('LANDSCAPE');
          as_pdf3.set_margins(1.27, 1.27, 1.27, 1.27, 'cm');
          as_pdf3.set_font('helvetica', 8);
        
          l_cursor := dbms_sql.open_cursor;
          dbms_sql.parse(l_cursor, l_consulta_sql, dbms_sql.native);
          dbms_sql.describe_columns2(l_cursor, l_col_cnt, l_desc_tab);
          l_headers := NEW as_pdf3.tp_headers();
          FOR i IN 1 .. l_col_cnt LOOP
            l_headers.extend;
            l_headers(l_headers.count) := l_desc_tab(i).col_name;
          END LOOP;
        
          as_pdf3.query2table(l_consulta_sql, NULL, l_headers);
          l_contenido := as_pdf3.get_pdf;
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
          -- https://dba.stackexchange.com/a/6780
          l_ctx   dbms_xmlgen.ctxhandle;
          l_xml   xmltype;
          l_table CLOB;
        BEGIN
          l_ctx := dbms_xmlgen.newcontext(l_consulta_sql);
          dbms_xmlgen.setnullhandling(l_ctx, dbms_xmlgen.empty_tag);
          dbms_xmlgen.setprettyprinting(l_ctx, FALSE);
          l_xml := dbms_xmlgen.getxmltype(l_ctx);
        
          IF dbms_xmlgen.getnumrowsprocessed(l_ctx) > 0 AND
             l_xml IS NOT NULL THEN
            l_table := l_xml.transform(xmltype('<?xml version="1.0" encoding="ISO-8859-1"?>
  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  <xsl:template match="/">
    <table border="1" cellspacing="0">
      <tr bgcolor="lightgray">
        <xsl:for-each select="/ROWSET/ROW[1]/*">
          <th><xsl:value-of select="name()"/></th>
        </xsl:for-each>
      </tr>
      <xsl:for-each select="/ROWSET/*">
        <tr>
          <xsl:for-each select="./*">
            <td><xsl:value-of select="text()"/></td>
          </xsl:for-each>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  </xsl:stylesheet>')).getclobval;
          END IF;
        
          dbms_xmlgen.closecontext(l_ctx);
          --
          k_util.p_inicializar_html;
          htp.htmlopen;
          htp.headopen;
          htp.title(k_sistema.f_valor_parametro_string(k_sistema.c_nombre_operacion));
          htp.headclose;
          htp.bodyopen;
          htp.p(l_table);
          htp.bodyclose;
          htp.htmlclose;
          l_contenido := k_util.clob_to_blob(k_util.f_html);
        END;
      
    END CASE;
  
    RETURN f_archivo_ok(l_contenido, l_formato);
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN f_archivo_error(l_rsp, l_formato);
    WHEN k_servicio.ex_error_general THEN
      RETURN f_archivo_error(l_rsp, l_formato);
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
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
