CREATE OR REPLACE PACKAGE k_error IS

  /**
  Agrupa operaciones relacionadas con los errores del sistema
  
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

  -- Tipos de error
  c_oracle_predefined_error CONSTANT VARCHAR2(3) := 'OPE';
  c_user_defined_error      CONSTANT VARCHAR2(3) := 'UDE';

  FUNCTION f_tipo_excepcion(i_sqlcode IN NUMBER) RETURN VARCHAR2;

  /**
  Retorna el mensaje de una excepcion de Oracle
  
  %author jtsoya539 27/3/2020 16:23:08
  %param i_sqlerrm Mensaje de excepcion
  %param i_sqlcode Codigo de excepcion
  %return Mensaje de error
  */
  FUNCTION f_mensaje_excepcion(i_sqlerrm IN VARCHAR2,
                               i_sqlcode IN NUMBER DEFAULT NULL)
    RETURN VARCHAR2;

  FUNCTION f_mensaje_error(i_id_error IN VARCHAR2) RETURN VARCHAR2;

END;
/
CREATE OR REPLACE PACKAGE BODY k_error IS

  FUNCTION f_tipo_excepcion(i_sqlcode IN NUMBER) RETURN VARCHAR2 IS
    l_tipo_error VARCHAR2(3);
  BEGIN
    /*IF i_sqlcode >= -20999 AND i_sqlcode <= -20000 THEN*/
    IF i_sqlcode >= 20000 AND i_sqlcode <= 20999 THEN
      l_tipo_error := c_user_defined_error;
    ELSE
      l_tipo_error := c_oracle_predefined_error;
    END IF;
    RETURN l_tipo_error;
  END;

  FUNCTION f_mensaje_excepcion(i_sqlerrm IN VARCHAR2,
                               i_sqlcode IN NUMBER DEFAULT NULL)
    RETURN VARCHAR2 IS
    l_posicion NUMBER := instr(i_sqlerrm, 'ORA-', 1, 2);
  BEGIN
    IF l_posicion > 12 THEN
      RETURN REPLACE(substr(REPLACE(i_sqlerrm, '"', ' '),
                            1,
                            l_posicion - 2),
                     'ORA' || to_char(nvl(i_sqlcode, -20000)) || ':',
                     '');
    ELSE
      RETURN TRIM(REPLACE(REPLACE(i_sqlerrm, '"', ' '),
                          'ORA' || to_char(nvl(i_sqlcode, -20000)) || ':'));
    END IF;
  END;

  FUNCTION f_mensaje_error(i_id_error IN VARCHAR2) RETURN VARCHAR2 IS
    l_mensaje t_errores.mensaje%TYPE;
  BEGIN
    BEGIN
      SELECT mensaje
        INTO l_mensaje
        FROM t_errores
       WHERE id_error = i_id_error;
    EXCEPTION
      WHEN no_data_found THEN
        l_mensaje := 'Error no registrado';
    END;
    RETURN l_mensaje;
  END;

END;
/
