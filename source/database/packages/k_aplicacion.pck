CREATE OR REPLACE PACKAGE k_aplicacion IS

  /**
  Agrupa operaciones relacionadas con las aplicaciones
  
  %author jtsoya539 27/3/2020 16:16:59
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

  FUNCTION f_id_aplicacion(i_clave_aplicacion IN VARCHAR2,
                           i_activo           IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2;

  FUNCTION f_generar_clave RETURN VARCHAR2;

  FUNCTION f_validar_clave(i_clave_aplicacion IN VARCHAR2) RETURN BOOLEAN;

  PROCEDURE p_validar_clave(i_clave_aplicacion IN VARCHAR2);

END;
/
CREATE OR REPLACE PACKAGE BODY k_aplicacion IS

  FUNCTION f_id_aplicacion(i_clave_aplicacion IN VARCHAR2,
                           i_activo           IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2 IS
    l_id_aplicacion t_aplicaciones.id_aplicacion%TYPE;
  BEGIN
    BEGIN
      SELECT id_aplicacion
        INTO l_id_aplicacion
        FROM t_aplicaciones
       WHERE clave = i_clave_aplicacion
         AND activo = nvl(i_activo, activo);
    EXCEPTION
      WHEN no_data_found THEN
        l_id_aplicacion := NULL;
      WHEN OTHERS THEN
        l_id_aplicacion := NULL;
    END;
    RETURN l_id_aplicacion;
  END;

  FUNCTION f_generar_clave RETURN VARCHAR2 IS
  BEGIN
    RETURN utl_raw.cast_to_varchar2(utl_encode.base64_encode(dbms_crypto.randombytes(number_bytes => 32)));
  END;

  FUNCTION f_validar_clave(i_clave_aplicacion IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF f_id_aplicacion(i_clave_aplicacion, 'S') IS NULL THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;

  PROCEDURE p_validar_clave(i_clave_aplicacion IN VARCHAR2) IS
  BEGIN
    IF NOT f_validar_clave(i_clave_aplicacion) THEN
      raise_application_error(-20000, 'Aplicación inexistente o inactiva');
    END IF;
  END;

END;
/
