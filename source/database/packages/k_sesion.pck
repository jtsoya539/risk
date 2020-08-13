CREATE OR REPLACE PACKAGE k_sesion IS

  /**
  Agrupa operaciones relacionadas con las sesiones
  
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

  -- Excepciones
  ex_sesion_inexistente EXCEPTION;

  FUNCTION f_id_sesion(i_access_token IN VARCHAR2,
                       i_estado       IN VARCHAR2 DEFAULT NULL) RETURN NUMBER;

  FUNCTION f_validar_sesion(i_access_token IN VARCHAR2) RETURN BOOLEAN;

  PROCEDURE p_validar_sesion(i_access_token IN VARCHAR2);

  PROCEDURE p_cambiar_estado(i_access_token IN VARCHAR2,
                             i_estado       IN VARCHAR2);

END;
/
CREATE OR REPLACE PACKAGE BODY k_sesion IS

  FUNCTION f_id_sesion(i_access_token IN VARCHAR2,
                       i_estado       IN VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
    l_id_sesion t_sesiones.id_sesion%TYPE;
  BEGIN
    BEGIN
      SELECT id_sesion
        INTO l_id_sesion
        FROM t_sesiones
       WHERE access_token = i_access_token
         AND estado = nvl(i_estado, estado);
    EXCEPTION
      WHEN no_data_found THEN
        l_id_sesion := NULL;
      WHEN OTHERS THEN
        l_id_sesion := NULL;
    END;
    RETURN l_id_sesion;
  END;

  FUNCTION f_validar_sesion(i_access_token IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF f_id_sesion(i_access_token, 'A') IS NULL THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN FALSE;
  END;

  PROCEDURE p_validar_sesion(i_access_token IN VARCHAR2) IS
  BEGIN
    IF NOT f_validar_sesion(i_access_token) THEN
      raise_application_error(-20000, 'Sesión finalizada o expirada');
    END IF;
  END;

  PROCEDURE p_cambiar_estado(i_access_token IN VARCHAR2,
                             i_estado       IN VARCHAR2) IS
    l_id_sesion t_sesiones.id_sesion%TYPE;
  BEGIN
    -- Busca sesion
    l_id_sesion := f_id_sesion(i_access_token);
  
    IF l_id_sesion IS NULL THEN
      RAISE ex_sesion_inexistente;
    END IF;
  
    -- Actualiza sesion
    UPDATE t_sesiones
       SET estado = i_estado
     WHERE id_sesion = l_id_sesion
       AND estado <> i_estado;
  
    -- Elimina sesion
    /*DELETE t_sesiones WHERE id_sesion = l_id_sesion;*/
  EXCEPTION
    WHEN ex_sesion_inexistente THEN
      /*raise_application_error(-20000, 'Sesion inexistente');*/
      NULL;
  END;

END;
/
