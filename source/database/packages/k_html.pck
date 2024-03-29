CREATE OR REPLACE PACKAGE k_html IS

  /**
  Agrupa operaciones relacionadas con la generacion de HTML
  
  %author jtsoya539 27/3/2020 16:36:54
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

  FUNCTION f_query2table(i_query    IN CLOB,
                         i_template IN CLOB := NULL) RETURN CLOB;

  FUNCTION f_escapar_texto(i_texto IN CLOB) RETURN CLOB;

  FUNCTION f_html RETURN CLOB;

  PROCEDURE p_inicializar(i_doctype IN BOOLEAN DEFAULT TRUE);

  PROCEDURE p_print(i_clob IN CLOB);

  PROCEDURE p_font_face(i_fuentes IN VARCHAR2);

END;
/
CREATE OR REPLACE PACKAGE BODY k_html IS

  c_charset_bytes CONSTANT PLS_INTEGER := 4;

  FUNCTION lf_clob_to_htbuf_arr(i_clob IN CLOB) RETURN htp.htbuf_arr IS
    l_htbuf_arr     htp.htbuf_arr;
    l_buffer_length INTEGER;
    l_length        INTEGER;
    k               NUMBER;
  BEGIN
    l_htbuf_arr     := NEW htp.htbuf_arr();
    l_buffer_length := floor(255 / c_charset_bytes);
  
    l_length := dbms_lob.getlength(i_clob);
    IF l_length > 0 AND l_buffer_length > 0 THEN
      k := ceil(l_length / l_buffer_length);
      FOR i IN 1 .. k LOOP
        l_htbuf_arr(i) := dbms_lob.substr(i_clob,
                                          l_buffer_length,
                                          1 + l_buffer_length * (i - 1));
      END LOOP;
    END IF;
  
    RETURN l_htbuf_arr;
  END;

  -- https://dba.stackexchange.com/a/6780
  -- https://stackoverflow.com/a/7755800
  FUNCTION f_query2table(i_query    IN CLOB,
                         i_template IN CLOB := NULL) RETURN CLOB IS
    l_table     CLOB;
    l_ctx       dbms_xmlgen.ctxhandle;
    l_xml_query xmltype;
    l_xml_table xmltype;
    --
    l_template CLOB := nvl(i_template,
                           '<?xml version="1.0" encoding="UTF-8"?>
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
  </xsl:stylesheet>');
  BEGIN
    l_ctx := dbms_xmlgen.newcontext(i_query);
    dbms_xmlgen.setnullhandling(l_ctx, dbms_xmlgen.empty_tag);
    dbms_xmlgen.setprettyprinting(l_ctx, FALSE);
    l_xml_query := dbms_xmlgen.getxmltype(l_ctx);
  
    IF dbms_xmlgen.getnumrowsprocessed(l_ctx) > 0 AND
       l_xml_query IS NOT NULL THEN
      l_xml_table := l_xml_query.transform(xmltype(l_template));
      l_table     := l_xml_table.getclobval;
    END IF;
  
    dbms_xmlgen.closecontext(l_ctx);
  
    RETURN l_table;
  END;

  FUNCTION f_escapar_texto(i_texto IN CLOB) RETURN CLOB IS
    l_tmp CLOB;
  BEGIN
    l_tmp := i_texto;
    --
    l_tmp := REPLACE(l_tmp, '&', '&' || 'amp;');
    l_tmp := REPLACE(l_tmp, '''', '&' || 'apos;');
    l_tmp := REPLACE(l_tmp, '"', '&' || 'quot;');
    l_tmp := REPLACE(l_tmp, '>', '&' || 'gt;');
    l_tmp := REPLACE(l_tmp, '<', '&' || 'lt;');
    --
    l_tmp := REPLACE(l_tmp, '�', '&' || 'Aacute;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'Eacute;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'Iacute;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'Oacute;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'Uacute;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'Ntilde;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'Uuml;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'Ccedil;');
    --
    l_tmp := REPLACE(l_tmp, '�', '&' || 'aacute;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'eacute;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'iacute;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'oacute;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'uacute;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'ntilde;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'uuml;');
    l_tmp := REPLACE(l_tmp, '�', '&' || 'ccedil;');
    RETURN l_tmp;
  END;

  FUNCTION f_html RETURN CLOB IS
    l_html CLOB;
    l_page htp.htbuf_arr;
    l_rows INTEGER := 999999;
    i      BINARY_INTEGER;
  BEGIN
    htp.get_page(l_page, l_rows);
  
    i := l_page.first;
    WHILE i IS NOT NULL LOOP
      l_html := l_html || l_page(i);
      i      := l_page.next(i);
    END LOOP;
  
    RETURN l_html;
  END;

  PROCEDURE p_inicializar(i_doctype IN BOOLEAN DEFAULT TRUE) IS
  BEGIN
    owa.num_cgi_vars := 0;
    -- https://forums.allroundautomations.com/ubb/ubbthreads.php?ubb=showflat&Number=60068
    htp.htbuf_len := floor(255 / c_charset_bytes);
    htp.init;
    htp.adddefaulthtmlhdr(FALSE);
  
    IF i_doctype THEN
      htp.p('<!DOCTYPE html>');
    END IF;
  END;

  PROCEDURE p_print(i_clob IN CLOB) IS
    l_htbuf_arr htp.htbuf_arr;
    i           INTEGER;
  BEGIN
    l_htbuf_arr := lf_clob_to_htbuf_arr(i_clob);
    i           := l_htbuf_arr.first;
    WHILE i IS NOT NULL LOOP
      htp.prn(l_htbuf_arr(i));
      i := l_htbuf_arr.next(i);
    END LOOP;
    -- Agrega un salto de l�nea
    htp.p;
  END;

  -- https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face
  PROCEDURE p_font_face(i_fuentes IN VARCHAR2) IS
    CURSOR c_fuentes IS
      SELECT a.tabla,
             a.campo,
             a.referencia,
             a.nombre,
             decode(upper(a.extension),
                    'TTF',
                    'truetype',
                    'OTF',
                    'opentype',
                    'WOFF',
                    'woff',
                    'WOFF2',
                    'woff2') format
        FROM t_archivos a
       WHERE a.tabla = k_archivo.c_carpeta_fuentes
         AND a.campo = 'ARCHIVO'
         AND a.contenido IS NOT NULL
         AND a.nombre IS NOT NULL
         AND a.extension IS NOT NULL
         AND a.referencia IN
             (SELECT * FROM k_cadena.f_separar_cadenas(i_fuentes, ','));
  BEGIN
    FOR c IN c_fuentes LOOP
      p_print('@font-face { font-family: "' || c.nombre || '"; src: url("' ||
              k_archivo.f_data_url(c.tabla, c.campo, c.referencia) ||
              '") format("' || c.format || '"); }');
    END LOOP;
  END;

END;
/
