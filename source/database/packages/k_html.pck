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

  FUNCTION f_escapar_texto(i_texto IN CLOB) RETURN CLOB;

  FUNCTION f_html RETURN CLOB;

  PROCEDURE p_inicializar(i_doctype IN BOOLEAN DEFAULT TRUE);

  PROCEDURE p_print(i_clob IN CLOB);

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
    l_tmp := REPLACE(l_tmp, 'Á', '&' || 'Aacute;');
    l_tmp := REPLACE(l_tmp, 'É', '&' || 'Eacute;');
    l_tmp := REPLACE(l_tmp, 'Í', '&' || 'Iacute;');
    l_tmp := REPLACE(l_tmp, 'Ó', '&' || 'Oacute;');
    l_tmp := REPLACE(l_tmp, 'Ú', '&' || 'Uacute;');
    l_tmp := REPLACE(l_tmp, 'Ñ', '&' || 'Ntilde;');
    l_tmp := REPLACE(l_tmp, 'Ü', '&' || 'Uuml;');
    l_tmp := REPLACE(l_tmp, 'Ç', '&' || 'Ccedil;');
    --
    l_tmp := REPLACE(l_tmp, 'á', '&' || 'aacute;');
    l_tmp := REPLACE(l_tmp, 'é', '&' || 'eacute;');
    l_tmp := REPLACE(l_tmp, 'í', '&' || 'iacute;');
    l_tmp := REPLACE(l_tmp, 'ó', '&' || 'oacute;');
    l_tmp := REPLACE(l_tmp, 'ú', '&' || 'uacute;');
    l_tmp := REPLACE(l_tmp, 'ñ', '&' || 'ntilde;');
    l_tmp := REPLACE(l_tmp, 'ü', '&' || 'uuml;');
    l_tmp := REPLACE(l_tmp, 'ç', '&' || 'ccedil;');
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
    -- Agrega un salto de línea
    htp.p;
  END;

END;
/
