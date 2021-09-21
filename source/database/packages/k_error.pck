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

  c_wrap_char CONSTANT VARCHAR2(1) := '@';

  FUNCTION f_tipo_excepcion(i_sqlcode IN NUMBER) RETURN VARCHAR2;

  /**
  Retorna el mensaje de error de una excepcion de Oracle
  
  %author jtsoya539 27/3/2020 16:23:08
  %param i_sqlerrm Mensaje de la excepcion (SQLERRM)
  %return Mensaje de error
  */
  FUNCTION f_mensaje_excepcion(i_sqlerrm IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_mensaje_error(i_id_error  IN VARCHAR2,
                           i_cadenas   IN y_cadenas,
                           i_wrap_char IN VARCHAR2 DEFAULT c_wrap_char)
    RETURN VARCHAR2;

  FUNCTION f_mensaje_error(i_id_error  IN VARCHAR2,
                           i_cadena1   IN VARCHAR2 DEFAULT NULL,
                           i_cadena2   IN VARCHAR2 DEFAULT NULL,
                           i_cadena3   IN VARCHAR2 DEFAULT NULL,
                           i_cadena4   IN VARCHAR2 DEFAULT NULL,
                           i_cadena5   IN VARCHAR2 DEFAULT NULL,
                           i_wrap_char IN VARCHAR2 DEFAULT c_wrap_char)
    RETURN VARCHAR2;

END;
/
CREATE OR REPLACE PACKAGE BODY k_error IS

  FUNCTION f_tipo_excepcion(i_sqlcode IN NUMBER) RETURN VARCHAR2 IS
    l_tipo_error VARCHAR2(3);
  BEGIN
    IF abs(i_sqlcode) BETWEEN 20000 AND 20999 THEN
      l_tipo_error := c_user_defined_error;
    ELSE
      l_tipo_error := c_oracle_predefined_error;
    END IF;
    RETURN l_tipo_error;
  END;

  FUNCTION f_mensaje_excepcion(i_sqlerrm IN VARCHAR2) RETURN VARCHAR2 IS
    l_posicion INTEGER;
    l_mensaje  VARCHAR2(32767);
  BEGIN
    l_mensaje := i_sqlerrm;
  
    -- ORA-NNNNN:
    l_posicion := regexp_instr(l_mensaje, 'ORA-[0-9]{5}:', 1, 2);
    IF l_posicion > length('ORA-NNNNN:') THEN
      l_mensaje := regexp_replace(substr(l_mensaje, 1, l_posicion - 1),
                                  'ORA-[0-9]{5}:');
    ELSE
      l_mensaje := regexp_replace(l_mensaje, 'ORA-[0-9]{5}:');
    END IF;
  
    -- PL/SQL:
    l_posicion := instr(l_mensaje, 'PL/SQL:', 1, 2);
    IF l_posicion > length('PL/SQL:') THEN
      l_mensaje := REPLACE(substr(l_mensaje, 1, l_posicion - 1), 'PL/SQL:');
    ELSE
      l_mensaje := REPLACE(l_mensaje, 'PL/SQL:');
    END IF;
  
    RETURN TRIM(l_mensaje);
  END;

  FUNCTION f_mensaje_error(i_id_error  IN VARCHAR2,
                           i_cadenas   IN y_cadenas,
                           i_wrap_char IN VARCHAR2 DEFAULT c_wrap_char)
    RETURN VARCHAR2 IS
    l_mensaje t_errores.mensaje%TYPE;
  BEGIN
    BEGIN
      SELECT mensaje
        INTO l_mensaje
        FROM t_errores
       WHERE id_error = i_id_error;
    EXCEPTION
      WHEN no_data_found THEN
        l_mensaje := 'Error no registrado [' || i_id_error || ']';
    END;
  
    RETURN k_util.f_unir_cadenas(l_mensaje,
                                 i_cadenas,
                                 nvl(i_wrap_char, c_wrap_char));
  END;

  FUNCTION f_mensaje_error(i_id_error  IN VARCHAR2,
                           i_cadena1   IN VARCHAR2 DEFAULT NULL,
                           i_cadena2   IN VARCHAR2 DEFAULT NULL,
                           i_cadena3   IN VARCHAR2 DEFAULT NULL,
                           i_cadena4   IN VARCHAR2 DEFAULT NULL,
                           i_cadena5   IN VARCHAR2 DEFAULT NULL,
                           i_wrap_char IN VARCHAR2 DEFAULT c_wrap_char)
    RETURN VARCHAR2 IS
    l_mensaje t_errores.mensaje%TYPE;
  BEGIN
    BEGIN
      SELECT mensaje
        INTO l_mensaje
        FROM t_errores
       WHERE id_error = i_id_error;
    EXCEPTION
      WHEN no_data_found THEN
        l_mensaje := 'Error no registrado [' || i_id_error || ']';
    END;
  
    RETURN k_util.f_unir_cadenas(l_mensaje,
                                 i_cadena1,
                                 i_cadena2,
                                 i_cadena3,
                                 i_cadena4,
                                 i_cadena5,
                                 nvl(i_wrap_char, c_wrap_char));
  END;

END;
/
