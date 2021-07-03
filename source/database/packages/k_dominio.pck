CREATE OR REPLACE PACKAGE k_dominio IS

  /**
  Agrupa operaciones relacionadas con los dominios
  
  %author jtsoya539 27/3/2020 16:58:36
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

  FUNCTION f_id_modulo(i_id_dominio IN VARCHAR2) RETURN VARCHAR2;

END;
/

CREATE OR REPLACE PACKAGE BODY k_dominio IS

  FUNCTION f_id_modulo(i_id_dominio IN VARCHAR2) RETURN VARCHAR2 IS
    l_id_modulo t_modulos.id_modulo%TYPE;
  BEGIN
    BEGIN
      SELECT a.id_modulo
        INTO l_id_modulo
        FROM t_dominios a
       WHERE a.id_dominio = i_id_dominio;
    EXCEPTION
      WHEN no_data_found THEN
        l_id_modulo := NULL;
      WHEN OTHERS THEN
        l_id_modulo := NULL;
    END;
    RETURN l_id_modulo;
  END;

END;
/

