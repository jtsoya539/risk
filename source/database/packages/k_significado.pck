CREATE OR REPLACE PACKAGE k_significado IS

  /**
  Agrupa operaciones relacionadas con significados
  
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
  Retorna el significado de un codigo dentro de un dominio de significados
  
  %author jtsoya539 27/3/2020 17:08:39
  %param i_dominio Dominio de significados
  %param i_codigo Codigo
  %return Significado
  */
  FUNCTION f_significado_codigo(i_dominio IN VARCHAR2,
                                i_codigo  IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_referencia_codigo(i_dominio IN VARCHAR2,
                               i_codigo  IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_existe_codigo(i_dominio IN VARCHAR2,
                           i_codigo  IN VARCHAR2) RETURN BOOLEAN;

END;
/
CREATE OR REPLACE PACKAGE BODY k_significado IS

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

  FUNCTION f_existe_codigo(i_dominio IN VARCHAR2,
                           i_codigo  IN VARCHAR2) RETURN BOOLEAN IS
    l_existe VARCHAR2(1);
  BEGIN
    BEGIN
      SELECT 'S'
        INTO l_existe
        FROM t_significados a
       WHERE a.dominio = i_dominio
         AND a.codigo = i_codigo;
    EXCEPTION
      WHEN no_data_found THEN
        l_existe := 'N';
      WHEN too_many_rows THEN
        l_existe := 'S';
    END;
    RETURN k_util.string_to_bool(l_existe);
  END;

END;
/
