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

  -- Excepciones
  ex_tipo_inexistente EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_tipo_inexistente, -6550);

  /**
  Genera trigger de secuencia para un campo de una tabla
  
  %author jtsoya539 27/3/2020 17:06:21
  %param i_tabla Tabla
  %param i_campo Campo
  %param i_trigger Trigger
  %param i_ejecutar Ejecutar la(s) sentencia(s)?
  */
  PROCEDURE p_generar_trigger_secuencia(i_tabla    IN VARCHAR2,
                                        i_campo    IN VARCHAR2,
                                        i_trigger  IN VARCHAR2 DEFAULT NULL,
                                        i_ejecutar IN BOOLEAN DEFAULT TRUE);

  PROCEDURE p_generar_type_objeto(i_tabla    IN VARCHAR2,
                                  i_type     IN VARCHAR2 DEFAULT NULL,
                                  i_ejecutar IN BOOLEAN DEFAULT TRUE);

  FUNCTION f_valor_parametro(i_id_parametro IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE p_actualizar_valor_parametro(i_id_parametro IN VARCHAR2,
                                         i_valor        IN VARCHAR2);

  FUNCTION f_hash(i_data      IN VARCHAR2,
                  i_hash_type IN PLS_INTEGER) RETURN VARCHAR2 DETERMINISTIC;

  FUNCTION bool_to_string(i_bool IN BOOLEAN) RETURN VARCHAR2;

  FUNCTION string_to_bool(i_string IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION blob_to_clob(p_data IN BLOB) RETURN CLOB;

  FUNCTION clob_to_blob(p_data IN CLOB) RETURN BLOB;

  FUNCTION base64encode(i_blob IN BLOB) RETURN CLOB;

  FUNCTION base64decode(i_clob IN CLOB) RETURN BLOB;

  FUNCTION encrypt(i_src IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION decrypt(i_src IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION json_to_objeto(i_json        IN CLOB,
                          i_nombre_tipo IN VARCHAR2) RETURN anydata;

  FUNCTION objeto_to_json(i_objeto IN anydata) RETURN CLOB;

  FUNCTION read_http_body(resp IN OUT utl_http.resp) RETURN CLOB;

  FUNCTION f_base_datos RETURN VARCHAR2;

  FUNCTION f_terminal RETURN VARCHAR2;

  FUNCTION f_host RETURN VARCHAR2;

  FUNCTION f_direccion_ip RETURN VARCHAR2;

  FUNCTION f_esquema_actual RETURN VARCHAR2;

  FUNCTION f_charset RETURN VARCHAR2;

  /**
  Retorna si el valor recibido es de tipo numérico
  
  %author dmezac 26/1/2022 19:48:15
  %param i_valor Zona horaria en formato decimal
  %return Si el valor recibido es de tipo numérico
  */
  FUNCTION f_es_valor_numerico(i_valor IN VARCHAR2) RETURN BOOLEAN;

  /**
  Retorna una zona horaria en formato '(+|-)HH:MM'
  
  %author dmezac 26/1/2022 19:43:15
  %param i_zona_horaria Zona horaria en formato decimal
  %return Zona horaria en formato '(+|-)HH:MM'
  */
  FUNCTION f_zona_horaria(i_zona_horaria IN VARCHAR2) RETURN VARCHAR2;

END;
/
CREATE OR REPLACE PACKAGE BODY k_util IS

  c_algoritmo CONSTANT PLS_INTEGER := as_crypto.encrypt_aes +
                                      as_crypto.chain_cbc +
                                      as_crypto.pad_pkcs5; -- dbms_crypto.aes_cbc_pkcs5;

  PROCEDURE p_generar_trigger_secuencia(i_tabla    IN VARCHAR2,
                                        i_campo    IN VARCHAR2,
                                        i_trigger  IN VARCHAR2 DEFAULT NULL,
                                        i_ejecutar IN BOOLEAN DEFAULT TRUE) IS
    l_sentencia VARCHAR2(4000);
    l_trigger   VARCHAR2(30);
  BEGIN
    l_trigger := lower(nvl(i_trigger, 'gs_' || substr(i_tabla, 3)));
  
    -- Genera secuencia
    l_sentencia := 'CREATE SEQUENCE s_' || lower(i_campo) || ' NOCACHE';
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
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
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  END;

  PROCEDURE p_generar_type_objeto(i_tabla    IN VARCHAR2,
                                  i_type     IN VARCHAR2 DEFAULT NULL,
                                  i_ejecutar IN BOOLEAN DEFAULT TRUE) IS
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
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
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
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
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
    RETURN rawtohex(as_crypto.hash(utl_raw.cast_to_raw(i_data),
                                   i_hash_type));
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

  FUNCTION base64decode(i_clob IN CLOB) RETURN BLOB IS
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

  FUNCTION encrypt(i_src IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN rawtohex(as_crypto.encrypt(src => utl_i18n.string_to_raw(i_src,
                                                                    'AL32UTF8'),
                                      typ => c_algoritmo,
                                      key => hextoraw(f_valor_parametro('CLAVE_ENCRIPTACION_DESENCRIPTACION'))));
  END;

  FUNCTION decrypt(i_src IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN utl_i18n.raw_to_char(as_crypto.decrypt(src => hextoraw(i_src),
                                                  typ => c_algoritmo,
                                                  key => hextoraw(f_valor_parametro('CLAVE_ENCRIPTACION_DESENCRIPTACION'))),
                                'AL32UTF8');
  END;

  FUNCTION json_to_objeto(i_json        IN CLOB,
                          i_nombre_tipo IN VARCHAR2) RETURN anydata IS
    l_retorno anydata;
    l_objeto  y_objeto;
  BEGIN
    IF i_json IS NOT NULL AND i_nombre_tipo IS NOT NULL THEN
      BEGIN
        EXECUTE IMMEDIATE 'BEGIN :1 := ' || lower(i_nombre_tipo) ||
                          '.parse_json(i_json => :2); END;'
          USING OUT l_objeto, IN i_json;
      EXCEPTION
        WHEN ex_tipo_inexistente THEN
          raise_application_error(-20000,
                                  'Tipo ' || lower(i_nombre_tipo) ||
                                  ' no existe');
      END;
    END IF;
  
    l_retorno := anydata.convertobject(l_objeto);
  
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

  FUNCTION f_charset RETURN VARCHAR2 IS
    l_characterset nls_database_parameters.value%TYPE;
  BEGIN
    BEGIN
      SELECT VALUE
        INTO l_characterset
        FROM nls_database_parameters
       WHERE parameter = 'NLS_CHARACTERSET';
    EXCEPTION
      WHEN OTHERS THEN
        l_characterset := NULL;
    END;
    RETURN utl_i18n.map_charset(l_characterset);
  END;

  FUNCTION f_es_valor_numerico(i_valor IN VARCHAR2) RETURN BOOLEAN IS
    l_numero NUMBER(20, 2);
    l_result BOOLEAN;
  BEGIN
    l_result := FALSE;
    l_numero := to_number(i_valor);
    l_result := TRUE;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN l_result;
  END;

  FUNCTION f_zona_horaria(i_zona_horaria IN VARCHAR2) RETURN VARCHAR2 IS
    l_zona   NUMBER(18, 2);
    l_tiempo NUMBER(15);
    l_hora   NUMBER(15);
    l_minuto NUMBER(3);
    --
    l_retorno    VARCHAR2(10);
    l_validacion DATE;
  BEGIN
    IF f_es_valor_numerico(i_zona_horaria) THEN
      l_zona := to_number(i_zona_horaria);
    
      l_tiempo := l_zona * 3600;
    
      l_hora   := trunc(l_tiempo / 3600);
      l_tiempo := abs((l_tiempo - (l_hora * 3600)) MOD 3600);
      l_minuto := trunc(l_tiempo / 60);
    
      l_retorno := to_char(l_hora) || ':' || to_char(l_minuto);
    ELSE
      l_retorno := i_zona_horaria;
    END IF;
  
    SELECT CAST(current_timestamp at TIME ZONE (SELECT l_retorno FROM dual) AS DATE) fecha
      INTO l_validacion
      FROM dual;
  
    RETURN l_retorno;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

END;
/
