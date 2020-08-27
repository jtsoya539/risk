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

  FUNCTION f_recuperar_dato_string(i_tabla      IN VARCHAR2,
                                   i_campo      IN VARCHAR2,
                                   i_referencia IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_recuperar_dato_number(i_tabla      IN VARCHAR2,
                                   i_campo      IN VARCHAR2,
                                   i_referencia IN VARCHAR2) RETURN NUMBER;

  FUNCTION f_recuperar_dato_boolean(i_tabla      IN VARCHAR2,
                                    i_campo      IN VARCHAR2,
                                    i_referencia IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION f_recuperar_dato_date(i_tabla      IN VARCHAR2,
                                 i_campo      IN VARCHAR2,
                                 i_referencia IN VARCHAR2) RETURN DATE;

  PROCEDURE p_guardar_dato(i_tabla      IN VARCHAR2,
                           i_campo      IN VARCHAR2,
                           i_referencia IN VARCHAR2,
                           i_dato       IN anydata);

  PROCEDURE p_guardar_dato_string(i_tabla      IN VARCHAR2,
                                  i_campo      IN VARCHAR2,
                                  i_referencia IN VARCHAR2,
                                  i_dato       IN VARCHAR2);

  PROCEDURE p_guardar_dato_number(i_tabla      IN VARCHAR2,
                                  i_campo      IN VARCHAR2,
                                  i_referencia IN VARCHAR2,
                                  i_dato       IN NUMBER);

  PROCEDURE p_guardar_dato_boolean(i_tabla      IN VARCHAR2,
                                   i_campo      IN VARCHAR2,
                                   i_referencia IN VARCHAR2,
                                   i_dato       IN BOOLEAN);

  PROCEDURE p_guardar_dato_date(i_tabla      IN VARCHAR2,
                                i_campo      IN VARCHAR2,
                                i_referencia IN VARCHAR2,
                                i_dato       IN DATE);

END;
/
CREATE OR REPLACE PACKAGE BODY k_dato IS

  FUNCTION f_recuperar_dato(i_tabla      IN VARCHAR2,
                            i_campo      IN VARCHAR2,
                            i_referencia IN VARCHAR2) RETURN anydata IS
    l_dato t_datos.contenido%TYPE;
  BEGIN
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

  FUNCTION f_recuperar_dato_string(i_tabla      IN VARCHAR2,
                                   i_campo      IN VARCHAR2,
                                   i_referencia IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN anydata.accessvarchar2(f_recuperar_dato(i_tabla,
                                                   i_campo,
                                                   i_referencia));
  END;

  FUNCTION f_recuperar_dato_number(i_tabla      IN VARCHAR2,
                                   i_campo      IN VARCHAR2,
                                   i_referencia IN VARCHAR2) RETURN NUMBER IS
  BEGIN
    RETURN anydata.accessnumber(f_recuperar_dato(i_tabla,
                                                 i_campo,
                                                 i_referencia));
  END;

  FUNCTION f_recuperar_dato_boolean(i_tabla      IN VARCHAR2,
                                    i_campo      IN VARCHAR2,
                                    i_referencia IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN sys.diutil.int_to_bool(anydata.accessnumber(f_recuperar_dato(i_tabla,
                                                                        i_campo,
                                                                        i_referencia)));
  END;

  FUNCTION f_recuperar_dato_date(i_tabla      IN VARCHAR2,
                                 i_campo      IN VARCHAR2,
                                 i_referencia IN VARCHAR2) RETURN DATE IS
  BEGIN
    RETURN anydata.accessdate(f_recuperar_dato(i_tabla,
                                               i_campo,
                                               i_referencia));
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

  PROCEDURE p_guardar_dato_string(i_tabla      IN VARCHAR2,
                                  i_campo      IN VARCHAR2,
                                  i_referencia IN VARCHAR2,
                                  i_dato       IN VARCHAR2) IS
  BEGIN
    p_guardar_dato(i_tabla,
                   i_campo,
                   i_referencia,
                   anydata.convertvarchar2(i_dato));
  END;

  PROCEDURE p_guardar_dato_number(i_tabla      IN VARCHAR2,
                                  i_campo      IN VARCHAR2,
                                  i_referencia IN VARCHAR2,
                                  i_dato       IN NUMBER) IS
  BEGIN
    p_guardar_dato(i_tabla,
                   i_campo,
                   i_referencia,
                   anydata.convertnumber(i_dato));
  END;

  PROCEDURE p_guardar_dato_boolean(i_tabla      IN VARCHAR2,
                                   i_campo      IN VARCHAR2,
                                   i_referencia IN VARCHAR2,
                                   i_dato       IN BOOLEAN) IS
  BEGIN
    p_guardar_dato(i_tabla,
                   i_campo,
                   i_referencia,
                   anydata.convertnumber(sys.diutil.bool_to_int(i_dato)));
  END;

  PROCEDURE p_guardar_dato_date(i_tabla      IN VARCHAR2,
                                i_campo      IN VARCHAR2,
                                i_referencia IN VARCHAR2,
                                i_dato       IN DATE) IS
  BEGIN
    p_guardar_dato(i_tabla,
                   i_campo,
                   i_referencia,
                   anydata.convertdate(i_dato));
  END;

END;
/
