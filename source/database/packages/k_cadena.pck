CREATE OR REPLACE PACKAGE k_cadena IS

  /**
  Agrupa operaciones relacionadas con cadenas
  
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

  -- https://github.com/osalvador/tePLSQL
  --Define data type for Template Variable names
  SUBTYPE t_template_variable_name IS VARCHAR2(255);

  --Define data type for Template Variable values
  SUBTYPE t_template_variable_value IS VARCHAR2(32767);

  --Define Associative Array
  TYPE t_assoc_array IS TABLE OF t_template_variable_value INDEX BY t_template_variable_name;

  null_assoc_array t_assoc_array;

  /**
  Retorna una tabla de cadenas delimitadas por un separador
  
  %author dmezac 10/9/2020 18:05:15
  %param i_cadena Cadena
  %param i_separador Caracter separador. Por defecto '~'
  %return Tabla de cadenas
  */
  FUNCTION f_separar_cadenas(i_cadena    IN VARCHAR2,
                             i_separador IN VARCHAR2 DEFAULT '~')
    RETURN y_cadenas
    PIPELINED;

  FUNCTION f_unir_cadenas(i_cadena    IN VARCHAR2,
                          i_cadenas   IN y_cadenas,
                          i_wrap_char IN VARCHAR2 DEFAULT '@')
    RETURN VARCHAR2;

  FUNCTION f_unir_cadenas(i_cadena    IN VARCHAR2,
                          i_cadena1   IN VARCHAR2 DEFAULT NULL,
                          i_cadena2   IN VARCHAR2 DEFAULT NULL,
                          i_cadena3   IN VARCHAR2 DEFAULT NULL,
                          i_cadena4   IN VARCHAR2 DEFAULT NULL,
                          i_cadena5   IN VARCHAR2 DEFAULT NULL,
                          i_wrap_char IN VARCHAR2 DEFAULT '@')
    RETURN VARCHAR2;

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

  FUNCTION f_procesar_plantilla(i_plantilla IN CLOB,
                                i_variables IN t_assoc_array DEFAULT null_assoc_array,
                                i_wrap_char IN VARCHAR2 DEFAULT '@')
    RETURN CLOB;

END;
/
CREATE OR REPLACE PACKAGE BODY k_cadena IS

  FUNCTION f_separar_cadenas(i_cadena    IN VARCHAR2,
                             i_separador IN VARCHAR2 DEFAULT '~')
    RETURN y_cadenas
    PIPELINED IS
    l_idx    PLS_INTEGER;
    l_cadena VARCHAR2(32767);
  BEGIN
    l_cadena := i_cadena;
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

  FUNCTION f_unir_cadenas(i_cadena    IN VARCHAR2,
                          i_cadenas   IN y_cadenas,
                          i_wrap_char IN VARCHAR2 DEFAULT '@')
    RETURN VARCHAR2 IS
    l_cadena VARCHAR2(32767);
  BEGIN
    l_cadena := i_cadena;
    IF l_cadena IS NOT NULL AND i_cadenas.count > 0 THEN
      FOR i IN i_cadenas.first .. i_cadenas.last LOOP
        -- Given the index "i" find the related placeholder in the message and
        -- replace the placeholder with the array's value at index "i".
        l_cadena := REPLACE(l_cadena,
                            i_wrap_char || to_char(i) || i_wrap_char,
                            i_cadenas(i));
      END LOOP;
    END IF;
  
    RETURN l_cadena;
  END;

  FUNCTION f_unir_cadenas(i_cadena    IN VARCHAR2,
                          i_cadena1   IN VARCHAR2 DEFAULT NULL,
                          i_cadena2   IN VARCHAR2 DEFAULT NULL,
                          i_cadena3   IN VARCHAR2 DEFAULT NULL,
                          i_cadena4   IN VARCHAR2 DEFAULT NULL,
                          i_cadena5   IN VARCHAR2 DEFAULT NULL,
                          i_wrap_char IN VARCHAR2 DEFAULT '@')
    RETURN VARCHAR2 IS
    l_cadenas y_cadenas;
  BEGIN
    l_cadenas := NEW y_cadenas();
    l_cadenas.extend(5);
  
    IF i_cadena1 IS NOT NULL THEN
      l_cadenas(1) := i_cadena1;
    END IF;
    IF i_cadena2 IS NOT NULL THEN
      l_cadenas(2) := i_cadena2;
    END IF;
    IF i_cadena3 IS NOT NULL THEN
      l_cadenas(3) := i_cadena3;
    END IF;
    IF i_cadena4 IS NOT NULL THEN
      l_cadenas(4) := i_cadena4;
    END IF;
    IF i_cadena5 IS NOT NULL THEN
      l_cadenas(5) := i_cadena5;
    END IF;
  
    RETURN f_unir_cadenas(i_cadena, l_cadenas, nvl(i_wrap_char, '@'));
  END;

  FUNCTION f_valor_posicion(i_cadena    IN VARCHAR2,
                            i_posicion  IN NUMBER,
                            i_separador IN VARCHAR2 DEFAULT '~')
    RETURN VARCHAR2 IS
    l_valor           VARCHAR2(32767);
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
      l_posicion_inicio := l_posicion_inicio + length(l_separador);
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
      IF v_pinicial <> 0 AND v_einicial <> 0 THEN
        v_inicial := least(v_pinicial, v_einicial);
      ELSE
        v_inicial := greatest(v_pinicial, v_einicial);
      END IF;
      -- Final
      IF v_inicial <> 0 THEN
        v_pfinal := instr(v_palabra, '.', v_inicial + 1);
        v_efinal := instr(v_palabra, ' ', v_inicial + 1);
        IF v_pfinal <> 0 AND v_efinal <> 0 THEN
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
      IF v_inicial <> 0 THEN
        v_inicial := v_inicial + 1;
      END IF;
    END LOOP;
    -- Retorna el titulo modificado
    RETURN v_palabra;
  END;

  -- https://github.com/osalvador/tePLSQL
  FUNCTION f_procesar_plantilla(i_plantilla IN CLOB,
                                i_variables IN t_assoc_array DEFAULT null_assoc_array,
                                i_wrap_char IN VARCHAR2 DEFAULT '@')
    RETURN CLOB IS
    l_key     t_template_variable_name;
    l_value   t_template_variable_value;
    l_retorno CLOB;
  BEGIN
    l_retorno := i_plantilla;
  
    l_key := i_variables.first;
    WHILE l_key IS NOT NULL LOOP
      l_value := i_variables(l_key);
    
      l_retorno := REPLACE(l_retorno,
                           i_wrap_char || l_key || i_wrap_char,
                           l_value);
      l_retorno := REPLACE(l_retorno,
                           i_wrap_char || lower(l_key) || i_wrap_char,
                           l_value);
      l_retorno := REPLACE(l_retorno,
                           i_wrap_char || upper(l_key) || i_wrap_char,
                           l_value);
      l_retorno := REPLACE(l_retorno,
                           i_wrap_char || initcap(l_key) || i_wrap_char,
                           l_value);
    
      l_key := i_variables.next(l_key);
    END LOOP;
  
    RETURN l_retorno;
  END;

END;
/
