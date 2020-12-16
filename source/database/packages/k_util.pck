CREATE OR REPLACE PACKAGE k_util IS

  /**
  Agrupa herramientas para facilitar el desarrollo
  
  %author jtsoya539 27/3/2020 17:05:34
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

  /**
  Genera trigger de secuencia para un campo de una tabla
  
  %author jtsoya539 27/3/2020 17:06:21
  %param i_tabla Tabla
  %param i_campo Campo
  %param i_trigger Trigger
  */
  PROCEDURE p_generar_trigger_secuencia(i_tabla   IN VARCHAR2,
                                        i_campo   IN VARCHAR2,
                                        i_trigger IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_generar_type_objeto(i_tabla IN VARCHAR2,
                                  i_type  IN VARCHAR2 DEFAULT NULL);

  /**
  Retorna una tabla de cadenas delimitadas por un separador
  
  %author dmezac 10/9/2020 18:05:15
  %param i_cadena Cadena
  %param i_separador Caracter separador. Por defecto '~'
  %return Tabla de cadenas
  */
  FUNCTION f_separar_cadenas(i_cadena    VARCHAR2,
                             i_separador VARCHAR2 DEFAULT '~')
    RETURN y_cadenas
    PIPELINED;

  /**
  Retorna el valor que se encuenta en la posicion indicada dentro de una cadena
  Si la posicion se encuentra fuera de rango retorna el valor mas cercano (primer valor o ultimo valor)
  
  %author jtsoya539 27/3/2020 17:07:15
  %param i_cadena Cadena
  %param i_posicion Posicion dentro de la cadena
  %param i_separador Caracter separador. Por defecto '~'
  %return Valor que se encuenta en la posicion indicada
  */
  FUNCTION f_valor_posicion(i_cadena    IN VARCHAR2,
                            i_posicion  IN NUMBER,
                            i_separador IN VARCHAR2 DEFAULT '~')
    RETURN VARCHAR2;

  FUNCTION f_reemplazar_acentos(i_cadena IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_formatear_titulo(i_titulo IN VARCHAR2) RETURN VARCHAR2
    DETERMINISTIC;

  /**
  Retorna el significado de un codigo dentro de un dominio
  
  %author jtsoya539 27/3/2020 17:08:39
  %param i_dominio Dominio
  %param i_codigo Codigo
  %return Significado
  */
  FUNCTION f_significado_codigo(i_dominio IN VARCHAR2,
                                i_codigo  IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_referencia_codigo(i_dominio IN VARCHAR2,
                               i_codigo  IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_valor_parametro(i_id_parametro IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE p_actualizar_valor_parametro(i_id_parametro IN VARCHAR2,
                                         i_valor        IN VARCHAR2);

  FUNCTION f_hash(i_data      IN VARCHAR2,
                  i_hash_type IN PLS_INTEGER) RETURN VARCHAR2 DETERMINISTIC;

  FUNCTION f_html RETURN CLOB;

  FUNCTION bool_to_string(i_bool IN BOOLEAN) RETURN VARCHAR2;

  FUNCTION string_to_bool(i_string IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION blob_to_clob(p_data IN BLOB) RETURN CLOB;

  FUNCTION clob_to_blob(p_data IN CLOB) RETURN BLOB;

  FUNCTION base64encode(i_blob IN BLOB) RETURN CLOB;

  FUNCTION base64decode(i_clob CLOB) RETURN BLOB;

  FUNCTION json_to_objeto(i_json        IN CLOB,
                          i_nombre_tipo IN VARCHAR2) RETURN anydata;

  FUNCTION objeto_to_json(i_objeto IN anydata) RETURN CLOB;

  FUNCTION read_http_body(resp IN OUT utl_http.resp) RETURN CLOB;

  FUNCTION f_base_datos RETURN VARCHAR2;

  FUNCTION f_terminal RETURN VARCHAR2;

  FUNCTION f_host RETURN VARCHAR2;

  FUNCTION f_direccion_ip RETURN VARCHAR2;

  FUNCTION f_esquema_actual RETURN VARCHAR2;

END;
/
CREATE OR REPLACE PACKAGE BODY k_util IS

  PROCEDURE p_generar_trigger_secuencia(i_tabla   IN VARCHAR2,
                                        i_campo   IN VARCHAR2,
                                        i_trigger IN VARCHAR2 DEFAULT NULL) IS
    l_sentencia VARCHAR2(4000);
    l_trigger   VARCHAR2(30);
  BEGIN
    l_trigger := lower(nvl(i_trigger, 'gs_' || substr(i_tabla, 3)));
  
    -- Genera secuencia
    l_sentencia := 'CREATE SEQUENCE s_' || lower(i_campo);
    EXECUTE IMMEDIATE l_sentencia;
  
    -- Genera trigger
    l_sentencia := 'CREATE OR REPLACE TRIGGER ' || l_trigger || '
  BEFORE INSERT ON ' || lower(i_tabla) || '
  FOR EACH ROW
BEGIN
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
  
  IF :new.' || lower(i_campo) || ' IS NULL THEN
    :new.' || lower(i_campo) || ' := s_' ||
                   lower(i_campo) || '.nextval;
  END IF;
END;';
    EXECUTE IMMEDIATE l_sentencia;
  END;

  PROCEDURE p_generar_type_objeto(i_tabla IN VARCHAR2,
                                  i_type  IN VARCHAR2 DEFAULT NULL) IS
    l_sentencia VARCHAR2(4000);
    l_type      VARCHAR2(30);
    l_comments  VARCHAR2(4000);
    l_campos1   VARCHAR2(4000);
    l_campos2   VARCHAR2(4000);
    l_campos3   VARCHAR2(4000);
    l_data_type VARCHAR2(100);
  
    CURSOR cr_campos IS
      SELECT m.comments,
             c.column_name,
             c.data_type,
             c.data_length,
             c.data_precision,
             c.data_scale
        FROM user_tab_columns c, user_col_comments m
       WHERE m.table_name = c.table_name
         AND m.column_name = c.column_name
         AND lower(c.table_name) LIKE 't\_%' ESCAPE
       '\'
         AND lower(c.table_name) = lower(i_tabla)
         AND lower(c.column_name) NOT IN
             ('usuario_insercion',
              'fecha_insercion',
              'usuario_modificacion',
              'fecha_modificacion')
       ORDER BY c.column_id;
  BEGIN
    l_type := lower(nvl(i_type,
                        'y_' || substr(i_tabla, 3, length(i_tabla) - 3)));
  
    -- Genera type spec
    SELECT c.comments
      INTO l_comments
      FROM user_tab_comments c
     WHERE lower(c.table_name) LIKE 't\_%' ESCAPE
     '\'
       AND lower(c.table_name) = lower(i_tabla);
  
    l_campos1 := '';
    FOR c IN cr_campos LOOP
      l_campos1 := l_campos1 || '/** ' || c.comments || ' */' ||
                   utl_tcp.crlf;
      l_campos1 := l_campos1 || lower(c.column_name) || ' ';
    
      CASE c.data_type
        WHEN 'NUMBER' THEN
          IF c.data_precision IS NOT NULL THEN
            IF c.data_scale > 0 THEN
              l_data_type := c.data_type || '(' ||
                             to_char(c.data_precision) || ',' ||
                             to_char(c.data_scale) || ')';
            ELSE
              l_data_type := c.data_type || '(' ||
                             to_char(c.data_precision) || ')';
            END IF;
          ELSE
            l_data_type := c.data_type;
          END IF;
        WHEN 'VARCHAR2' THEN
          l_data_type := c.data_type || '(' || to_char(c.data_length) || ')';
        ELSE
          l_data_type := c.data_type;
      END CASE;
      l_campos1 := l_campos1 || l_data_type || ',' || utl_tcp.crlf;
    END LOOP;
  
    l_sentencia := 'CREATE OR REPLACE TYPE ' || l_type || ' UNDER y_objeto
(
/**
Agrupa datos de ' || l_comments || '.

%author jtsoya539 30/3/2020 10:54:26
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

' || l_campos1 || '

  CONSTRUCTOR FUNCTION ' || l_type || ' RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)';
    dbms_output.put_line(l_sentencia);
    EXECUTE IMMEDIATE l_sentencia;
  
    -- Genera type body
    l_campos1 := '';
    FOR c IN cr_campos LOOP
      l_campos1 := l_campos1 || 'self.' || lower(c.column_name) ||
                   ' := NULL;' || utl_tcp.crlf;
    END LOOP;
  
    l_campos2 := '';
    FOR c IN cr_campos LOOP
      CASE c.data_type
        WHEN 'VARCHAR2' THEN
          l_data_type := 'string';
        ELSE
          l_data_type := lower(c.data_type);
      END CASE;
    
      l_campos2 := l_campos2 || 'l_objeto.' || lower(c.column_name) ||
                   ' := l_json_object.get_' || l_data_type || '(''' ||
                   lower(c.column_name) || ''');' || utl_tcp.crlf;
    END LOOP;
  
    l_campos3 := '';
    FOR c IN cr_campos LOOP
      l_campos3 := l_campos3 || 'l_json_object.put(''' ||
                   lower(c.column_name) || ''', self.' ||
                   lower(c.column_name) || ');' || utl_tcp.crlf;
    END LOOP;
  
    l_sentencia := 'CREATE OR REPLACE TYPE BODY ' || l_type || ' IS

  CONSTRUCTOR FUNCTION ' || l_type || ' RETURN SELF AS RESULT AS
  BEGIN
' || l_campos1 || '
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_objeto      ' || l_type || ';
    l_json_object json_object_t;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_objeto := NEW ' || l_type || '();
' || l_campos2 || '
    RETURN l_objeto;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
' || l_campos3 || '
    RETURN l_json_object.to_clob;
  END;

END;';
    dbms_output.put_line(l_sentencia);
    EXECUTE IMMEDIATE l_sentencia;
  END;

  FUNCTION f_separar_cadenas(i_cadena    VARCHAR2,
                             i_separador VARCHAR2 DEFAULT '~')
    RETURN y_cadenas
    PIPELINED IS
    l_idx    PLS_INTEGER;
    l_cadena VARCHAR2(32767) := i_cadena;
  BEGIN
    LOOP
      l_idx := instr(l_cadena, i_separador);
      IF l_idx > 0 THEN
        PIPE ROW(substr(l_cadena, 1, l_idx - 1));
        l_cadena := substr(l_cadena, l_idx + length(i_separador));
      ELSE
        PIPE ROW(l_cadena);
        EXIT;
      END IF;
    END LOOP;
    RETURN;
  END;

  FUNCTION f_valor_posicion(i_cadena    IN VARCHAR2,
                            i_posicion  IN NUMBER,
                            i_separador IN VARCHAR2 DEFAULT '~')
    RETURN VARCHAR2 IS
    l_valor           VARCHAR2(1000);
    l_posicion        NUMBER;
    l_separador       VARCHAR2(10);
    l_longitud_valor  NUMBER;
    l_posicion_inicio NUMBER;
    l_posicion_fin    NUMBER;
  BEGIN
    l_separador := i_separador;
  
    IF i_posicion > 0 THEN
      l_posicion := i_posicion;
    ELSE
      l_posicion := 1;
    END IF;
  
    -- Posicion del inicio del valor dentro de la cadena
    IF l_posicion > 1 THEN
      l_posicion_inicio := instr(i_cadena, l_separador, 1, l_posicion - 1);
      IF l_posicion_inicio = 0 THEN
        l_posicion_inicio := instr(i_cadena, l_separador, -1, 1);
      END IF;
      l_posicion_inicio := l_posicion_inicio + 1;
    ELSE
      l_posicion_inicio := 1;
    END IF;
  
    -- Posicion del fin del valor dentro de la cadena
    l_posicion_fin := instr(i_cadena, l_separador, 1, l_posicion);
  
    IF l_posicion_fin = 0 THEN
      l_valor := substr(i_cadena, l_posicion_inicio);
    ELSE
      l_longitud_valor := l_posicion_fin - l_posicion_inicio;
      l_valor          := substr(i_cadena,
                                 l_posicion_inicio,
                                 l_longitud_valor);
    END IF;
    RETURN l_valor;
  END;

  FUNCTION f_reemplazar_acentos(i_cadena IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN translate(i_cadena,
                     'áéíóúàèìòùâêîôûäëïöüçãõÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÄËÏÖÜÇÃÕ',
                     'aeiouaeiouaeiouaeioucaoAEIOUAEIOUAEIOUAEIOUCAO');
  END;

  FUNCTION f_formatear_titulo(i_titulo IN VARCHAR2) RETURN VARCHAR2
    DETERMINISTIC IS
    v_palabra  VARCHAR2(4000);
    v_longitud NUMBER;
    v_inicial  NUMBER;
    v_final    NUMBER;
    v_pinicial NUMBER;
    v_pfinal   NUMBER;
    v_einicial NUMBER;
    v_efinal   NUMBER;
    v_letras   VARCHAR2(20);
  BEGIN
    -- Hace el InitCap para iniciar
    v_palabra := initcap(i_titulo);
    -- Reemplaza los casos mas necesarios  p/, c/, s/, 's
    v_palabra := REPLACE(v_palabra, 'P/', 'p/');
    v_palabra := REPLACE(v_palabra, 'C/', 'c/');
    v_palabra := REPLACE(v_palabra, 'S/', 's/');
    v_palabra := REPLACE(v_palabra, chr(39) || 'S', chr(39) || 's');
    --
    v_inicial  := 1;
    v_final    := 1;
    v_longitud := nvl(length(v_palabra), 0);
    LOOP
      IF v_inicial = 0 OR v_inicial >= v_longitud THEN
        EXIT;
      END IF;
      IF v_final - v_inicial BETWEEN 1 AND 5 THEN
        v_letras := substr(v_palabra, v_inicial, v_final - v_inicial + 1);
        IF lower(ltrim(rtrim(v_letras))) IN
           ('srl', 'sa', 'sacic', 'saeca', 'saci', 'eca') THEN
          -- Pone las letras en mayusculas
          v_palabra := substr(v_palabra, 1, v_inicial - 1) ||
                       upper(v_letras) ||
                       substr(v_palabra, v_final + 1, v_longitud);
        ELSIF lower(ltrim(rtrim(v_letras))) IN
              ('del',
               'a',
               'de',
               'la',
               'el',
               'en',
               'por',
               'para',
               'y',
               'e',
               'con',
               'entre',
               'los',
               'las',
               'contra',
               'sin') THEN
          -- Pone las letras en minusculas
          v_palabra := substr(v_palabra, 1, v_inicial - 1) ||
                       lower(v_letras) ||
                       substr(v_palabra, v_final + 1, v_longitud);
        END IF;
      END IF;
      -- Inicial
      v_pinicial := instr(v_palabra, '.', v_final);
      v_einicial := instr(v_palabra, ' ', v_final);
      IF v_pinicial != 0 AND v_einicial != 0 THEN
        v_inicial := least(v_pinicial, v_einicial);
      ELSE
        v_inicial := greatest(v_pinicial, v_einicial);
      END IF;
      -- Final
      IF v_inicial != 0 THEN
        v_pfinal := instr(v_palabra, '.', v_inicial + 1);
        v_efinal := instr(v_palabra, ' ', v_inicial + 1);
        IF v_pfinal != 0 AND v_efinal != 0 THEN
          v_final := least(v_pfinal, v_efinal);
        ELSE
          v_final := greatest(v_pfinal, v_efinal);
        END IF;
      ELSE
        v_final := 0;
      END IF;
      IF v_final = 0 THEN
        v_final := v_longitud;
      END IF;
      IF v_inicial != 0 THEN
        v_inicial := v_inicial + 1;
      END IF;
    END LOOP;
    -- Retorna el titulo modificado
    RETURN v_palabra;
  END;

  FUNCTION f_significado_codigo(i_dominio IN VARCHAR2,
                                i_codigo  IN VARCHAR2) RETURN VARCHAR2 IS
    l_significado t_significados.significado%TYPE;
  BEGIN
    BEGIN
      SELECT a.significado
        INTO l_significado
        FROM t_significados a
       WHERE a.dominio = i_dominio
         AND a.codigo = i_codigo;
    EXCEPTION
      WHEN OTHERS THEN
        l_significado := NULL;
    END;
    RETURN l_significado;
  END;

  FUNCTION f_referencia_codigo(i_dominio IN VARCHAR2,
                               i_codigo  IN VARCHAR2) RETURN VARCHAR2 IS
    l_referencia t_significados.referencia%TYPE;
  BEGIN
    BEGIN
      SELECT a.referencia
        INTO l_referencia
        FROM t_significados a
       WHERE a.dominio = i_dominio
         AND a.codigo = i_codigo;
    EXCEPTION
      WHEN OTHERS THEN
        l_referencia := NULL;
    END;
    RETURN l_referencia;
  END;

  FUNCTION f_valor_parametro(i_id_parametro IN VARCHAR2) RETURN VARCHAR2 IS
    l_valor t_parametros.valor%TYPE;
  BEGIN
    BEGIN
      SELECT a.valor
        INTO l_valor
        FROM t_parametros a
       WHERE a.id_parametro = i_id_parametro;
    EXCEPTION
      WHEN OTHERS THEN
        l_valor := NULL;
    END;
    RETURN l_valor;
  END;

  PROCEDURE p_actualizar_valor_parametro(i_id_parametro IN VARCHAR2,
                                         i_valor        IN VARCHAR2) IS
  BEGIN
    UPDATE t_parametros a
       SET a.valor = i_valor
     WHERE a.id_parametro = i_id_parametro;
  END;

  FUNCTION f_hash(i_data      IN VARCHAR2,
                  i_hash_type IN PLS_INTEGER) RETURN VARCHAR2 DETERMINISTIC IS
  BEGIN
    RETURN to_char(rawtohex(dbms_crypto.hash(utl_raw.cast_to_raw(i_data),
                                             i_hash_type)));
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

  FUNCTION bool_to_string(i_bool IN BOOLEAN) RETURN VARCHAR2 IS
  BEGIN
    IF i_bool IS NULL THEN
      RETURN NULL;
    ELSIF i_bool THEN
      RETURN 'S';
    ELSE
      RETURN 'N';
    END IF;
  END;

  FUNCTION string_to_bool(i_string IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF i_string IS NULL THEN
      RETURN NULL;
    ELSIF lower(i_string) IN ('1', 'true', 't', 'yes', 'y', 'si', 's') THEN
      RETURN TRUE;
    ELSIF lower(i_string) IN ('0', 'false', 'f', 'no', 'n') THEN
      RETURN FALSE;
    ELSE
      RETURN NULL;
    END IF;
  END;

  FUNCTION blob_to_clob(p_data IN BLOB) RETURN CLOB IS
    -- -----------------------------------------------------------------------------------
    -- File Name    : https://oracle-base.com/dba/miscellaneous/blob_to_clob.sql
    -- Author       : Tim Hall
    -- Description  : Converts a BLOB to a CLOB.
    -- Last Modified: 26/12/2016
    -- -----------------------------------------------------------------------------------
    l_clob         CLOB;
    l_dest_offset  PLS_INTEGER := 1;
    l_src_offset   PLS_INTEGER := 1;
    l_lang_context PLS_INTEGER := dbms_lob.default_lang_ctx;
    l_warning      PLS_INTEGER;
  BEGIN
    dbms_lob.createtemporary(lob_loc => l_clob, cache => TRUE);
  
    dbms_lob.converttoclob(dest_lob     => l_clob,
                           src_blob     => p_data,
                           amount       => dbms_lob.lobmaxsize,
                           dest_offset  => l_dest_offset,
                           src_offset   => l_src_offset,
                           blob_csid    => dbms_lob.default_csid,
                           lang_context => l_lang_context,
                           warning      => l_warning);
  
    RETURN l_clob;
  END;

  FUNCTION clob_to_blob(p_data IN CLOB) RETURN BLOB IS
    -- -----------------------------------------------------------------------------------
    -- File Name    : https://oracle-base.com/dba/miscellaneous/clob_to_blob.sql
    -- Author       : Tim Hall
    -- Description  : Converts a CLOB to a BLOB.
    -- Last Modified: 26/12/2016
    -- -----------------------------------------------------------------------------------
    l_blob         BLOB;
    l_dest_offset  PLS_INTEGER := 1;
    l_src_offset   PLS_INTEGER := 1;
    l_lang_context PLS_INTEGER := dbms_lob.default_lang_ctx;
    l_warning      PLS_INTEGER := dbms_lob.warn_inconvertible_char;
  BEGIN
    dbms_lob.createtemporary(lob_loc => l_blob, cache => TRUE);
  
    dbms_lob.converttoblob(dest_lob     => l_blob,
                           src_clob     => p_data,
                           amount       => dbms_lob.lobmaxsize,
                           dest_offset  => l_dest_offset,
                           src_offset   => l_src_offset,
                           blob_csid    => dbms_lob.default_csid,
                           lang_context => l_lang_context,
                           warning      => l_warning);
  
    RETURN l_blob;
  END;

  FUNCTION base64encode(i_blob IN BLOB) RETURN CLOB IS
    -- -----------------------------------------------------------------------------------
    -- File Name    : https://oracle-base.com/dba/miscellaneous/base64encode.sql
    -- Author       : Tim Hall
    -- Description  : Encodes a BLOB into a Base64 CLOB.
    -- Last Modified: 09/11/2011
    -- -----------------------------------------------------------------------------------
    l_clob CLOB;
    l_step PLS_INTEGER := 12000; -- make sure you set a multiple of 3 not higher than 24573
  BEGIN
    IF i_blob IS NOT NULL AND dbms_lob.getlength(i_blob) > 0 THEN
      FOR i IN 0 .. trunc((dbms_lob.getlength(i_blob) - 1) / l_step) LOOP
        l_clob := l_clob ||
                  utl_raw.cast_to_varchar2(utl_encode.base64_encode(dbms_lob.substr(i_blob,
                                                                                    l_step,
                                                                                    i *
                                                                                    l_step + 1)));
      END LOOP;
    END IF;
    RETURN l_clob;
  END;

  FUNCTION base64decode(i_clob CLOB) RETURN BLOB IS
    -- -----------------------------------------------------------------------------------
    -- File Name    : https://oracle-base.com/dba/miscellaneous/base64decode.sql
    -- Author       : Tim Hall
    -- Description  : Decodes a Base64 CLOB into a BLOB
    -- Last Modified: 09/11/2011
    -- -----------------------------------------------------------------------------------
    l_blob   BLOB;
    l_raw    RAW(32767);
    l_amt    NUMBER := 7700;
    l_offset NUMBER := 1;
    l_temp   VARCHAR2(32767);
  BEGIN
    BEGIN
      dbms_lob.createtemporary(l_blob, FALSE, dbms_lob.call);
      LOOP
        dbms_lob.read(i_clob, l_amt, l_offset, l_temp);
        l_offset := l_offset + l_amt;
        l_raw    := utl_encode.base64_decode(utl_raw.cast_to_raw(l_temp));
        dbms_lob.append(l_blob, to_blob(l_raw));
      END LOOP;
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    RETURN l_blob;
  END;

  FUNCTION json_to_objeto(i_json        IN CLOB,
                          i_nombre_tipo IN VARCHAR2) RETURN anydata IS
    l_retorno anydata;
    l_objeto  y_objeto;
  BEGIN
    IF i_json IS NOT NULL AND i_nombre_tipo IS NOT NULL THEN
      EXECUTE IMMEDIATE 'BEGIN :1 := ' || lower(i_nombre_tipo) ||
                        '.parse_json(i_json => :2); END;'
        USING OUT l_objeto, IN i_json;
      l_retorno := anydata.convertobject(l_objeto);
    END IF;
    RETURN l_retorno;
  END;

  FUNCTION objeto_to_json(i_objeto IN anydata) RETURN CLOB IS
    l_json     CLOB;
    l_typeinfo anytype;
    l_typecode PLS_INTEGER;
  BEGIN
    IF i_objeto IS NOT NULL THEN
      l_typecode := i_objeto.gettype(l_typeinfo);
      IF l_typecode = dbms_types.typecode_object THEN
        EXECUTE IMMEDIATE 'DECLARE
  l_retorno PLS_INTEGER;
  l_anydata anydata := :1;
  l_object  ' || i_objeto.gettypename || ';
  l_clob    CLOB;
BEGIN
  l_retorno := l_anydata.getobject(obj => l_object);
  :2        := l_object.to_json();
END;'
          USING IN i_objeto, OUT l_json;
      END IF;
    END IF;
    RETURN l_json;
  END;

  FUNCTION read_http_body(resp IN OUT utl_http.resp) RETURN CLOB AS
    l_http_body CLOB;
    l_data      VARCHAR2(1024);
  BEGIN
    BEGIN
      LOOP
        utl_http.read_text(resp, l_data, 1024);
        l_http_body := l_http_body || l_data;
      END LOOP;
    EXCEPTION
      WHEN utl_http.end_of_body THEN
        NULL;
      WHEN OTHERS THEN
        l_http_body := NULL;
    END;
    RETURN l_http_body;
  END;

  FUNCTION f_base_datos RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV', 'DB_NAME');
  END;

  FUNCTION f_terminal RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV', 'TERMINAL');
  END;

  FUNCTION f_host RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV', 'HOST');
  END;

  FUNCTION f_direccion_ip RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV', 'IP_ADDRESS');
  END;

  FUNCTION f_esquema_actual RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV', 'CURRENT_SCHEMA');
  END;

END;
/
