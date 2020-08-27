CREATE OR REPLACE PACKAGE k_dato IS

  /**
  Agrupa operaciones relacionadas con datos adicionales
  
  %author jtsoya539 27/3/2020 16:22:16
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

  FUNCTION f_recuperar_dato(i_tabla      IN VARCHAR2,
                            i_campo      IN VARCHAR2,
                            i_referencia IN VARCHAR2) RETURN anydata;

  PROCEDURE p_guardar_dato(i_tabla      IN VARCHAR2,
                           i_campo      IN VARCHAR2,
                           i_referencia IN VARCHAR2,
                           i_dato       IN anydata);

END;
/
CREATE OR REPLACE PACKAGE BODY k_dato IS

  FUNCTION f_recuperar_dato(i_tabla      IN VARCHAR2,
                            i_campo      IN VARCHAR2,
                            i_referencia IN VARCHAR2) RETURN anydata IS
    l_dato t_datos.contenido%TYPE;
  BEGIN
    -- l_contenido := NEW y_archivo();
  
    BEGIN
      SELECT a.contenido
        INTO l_dato
        FROM t_datos a
       WHERE upper(a.tabla) = upper(i_tabla)
         AND upper(a.campo) = upper(i_campo)
         AND a.referencia = i_referencia;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000, 'Dato adicional inexistente');
      WHEN OTHERS THEN
        raise_application_error(-20000,
                                'Error al recuperar dato adicional');
    END;
  
    RETURN l_dato;
  END;

  PROCEDURE p_guardar_dato(i_tabla      IN VARCHAR2,
                           i_campo      IN VARCHAR2,
                           i_referencia IN VARCHAR2,
                           i_dato       IN anydata) IS
  BEGIN
    UPDATE t_datos a
       SET a.contenido = i_dato
     WHERE upper(a.tabla) = upper(i_tabla)
       AND upper(a.campo) = upper(i_campo)
       AND a.referencia = i_referencia;
  
    IF SQL%NOTFOUND THEN
      INSERT INTO t_datos
        (tabla, campo, referencia, contenido)
      VALUES
        (upper(i_tabla), upper(i_campo), i_referencia, i_dato);
    END IF;
  END;

END;
/
