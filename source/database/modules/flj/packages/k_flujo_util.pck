CREATE OR REPLACE PACKAGE k_flujo_util AS
  /**
  Agrupa herramientas para facilitar el manejo del motor de flujos
  
  %author dmezac 04/05/2025
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

  FUNCTION f_obtener_variable(i_variables IN CLOB,
                              i_clave     IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_editar_variable(i_variables IN CLOB,
                             i_clave     IN VARCHAR2,
                             i_valor     IN VARCHAR2) RETURN CLOB;

  FUNCTION f_reemplazar_variables(i_expresion         IN VARCHAR2,
                                  i_variables         IN CLOB,
                                  i_delimitador_texto IN VARCHAR2 := '''')
    RETURN VARCHAR2;

  FUNCTION f_evaluar_condicion(i_condicion IN VARCHAR2,
                               i_variables IN CLOB) RETURN BOOLEAN;

  FUNCTION f_contiene_valor(i_valor     IN VARCHAR2,
                            i_variables IN CLOB) RETURN BOOLEAN;

END k_flujo_util;
/
CREATE OR REPLACE PACKAGE BODY k_flujo_util AS

  FUNCTION f_obtener_variable(i_variables IN CLOB,
                              i_clave     IN VARCHAR2) RETURN VARCHAR2 IS
    l_resultado VARCHAR2(4000);
    l_clave     VARCHAR2(1000) := '''$.' || i_clave || '''';
    --
    l_sentencia CLOB := 'SELECT json_value(:1, ' || l_clave ||
                        ') FROM dual';
  BEGIN
    --dbms_output.put_line(l_sentencia);
    IF json_query(i_variables, '$') IS NOT NULL THEN
      EXECUTE IMMEDIATE l_sentencia
        INTO l_resultado
        USING i_variables;
    ELSE
      l_resultado := NULL;
    END IF;
    RETURN l_resultado;
  END;

  FUNCTION f_editar_variable(i_variables IN CLOB,
                             i_clave     IN VARCHAR2,
                             i_valor     IN VARCHAR2) RETURN CLOB IS
    l_nuevo CLOB;
  BEGIN
    SELECT json_mergepatch(i_variables,
                           json_object(i_clave VALUE i_valor RETURNING CLOB))
      INTO l_nuevo
      FROM dual;
    RETURN l_nuevo;
  END;

  FUNCTION f_reemplazar_variables(i_expresion         IN VARCHAR2,
                                  i_variables         IN CLOB,
                                  i_delimitador_texto IN VARCHAR2 := '''')
    RETURN VARCHAR2 IS
  
    l_delimitador_texto VARCHAR2(1) := substr(i_delimitador_texto, 1, 1);
    l_expresion         VARCHAR2(4000) := i_expresion;
  
    l_objeto_json json_object_t;
    l_clave       VARCHAR2(100);
    l_valor       json_element_t;
    l_valor_texto VARCHAR2(4000);
  BEGIN
    l_objeto_json := json_object_t.parse(i_variables);
  
    FOR i IN 1 .. l_objeto_json.get_size LOOP
      l_clave := l_objeto_json.get_keys() (i);
      l_valor := l_objeto_json.get(l_clave);
    
      IF l_valor.is_string THEN
        l_valor_texto := '' || l_delimitador_texto || '' ||
                         regexp_replace(l_valor.to_string, '^"(.*)"$', '\1') || '' ||
                         l_delimitador_texto || '';
      ELSIF l_valor.is_number THEN
        l_valor_texto := l_valor.to_string;
      ELSE
        l_valor_texto := 'NULL'; -- podrías manejar booleanos, nulls, etc.
      END IF;
    
      l_expresion := REPLACE(l_expresion, ':' || l_clave, l_valor_texto);
    END LOOP;
  
    --dbms_output.put_line('Expresión generada: ' || l_expresion);
  
    RETURN l_expresion;
  
  END;

  FUNCTION f_evaluar_condicion(i_condicion IN VARCHAR2,
                               i_variables IN CLOB) RETURN BOOLEAN IS
    l_expresion VARCHAR2(4000) := i_condicion;
  BEGIN
    l_expresion := f_reemplazar_variables(l_expresion, i_variables);
  
    -- Evaluación opcional de la expresión (como se mostró antes)
    DECLARE
      l_resultado PLS_INTEGER;
    BEGIN
      EXECUTE IMMEDIATE 'BEGIN IF ' || l_expresion ||
                        ' THEN :r := 1; ELSE :r := 0; END IF; END;'
        USING OUT l_resultado;
    
      IF l_resultado = 1 THEN
        --dbms_output.put_line('Condición evaluada como TRUE');
        RETURN TRUE;
      END IF;
    END;
  
    RETURN FALSE;
  END;

  FUNCTION f_contiene_valor(i_valor     IN VARCHAR2,
                            i_variables IN CLOB) RETURN BOOLEAN IS
    l_sentencia VARCHAR2(4000);
    l_resultado PLS_INTEGER;
  BEGIN
    l_sentencia := 'SELECT COUNT(*) cantidad
        FROM dual
        WHERE json_exists(''' || i_variables ||
                   ''', ''$[*]?(@ == "' || i_valor || '")'')';
  
    EXECUTE IMMEDIATE l_sentencia
      INTO l_resultado;
  
    IF l_resultado > 0 THEN
      --dbms_output.put_line('Condición evaluada como TRUE');
      RETURN TRUE;
    END IF;
  
    RETURN FALSE;
  END;

END k_flujo_util;
/
