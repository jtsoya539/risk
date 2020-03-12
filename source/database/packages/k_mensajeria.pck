CREATE OR REPLACE PACKAGE k_mensajeria IS

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

  -- Agrupa operaciones relacionadas con el envio de mensajes a los usuarios
  -- a traves de:
  -- * Correo electronico (E-mail)
  -- * Mensaje de texto (SMS)
  --
  -- %author jmeza 5/1/2019 21:42:37

  FUNCTION f_validar_direccion_correo(i_direccion_correo VARCHAR2)
    RETURN BOOLEAN;

  FUNCTION f_validar_numero_telefono(i_numero_telefono VARCHAR2)
    RETURN BOOLEAN;

  FUNCTION f_direccion_correo_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2;

  FUNCTION f_numero_telefono_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2;

END;
/
CREATE OR REPLACE PACKAGE BODY k_mensajeria IS

  FUNCTION f_validar_direccion_correo(i_direccion_correo VARCHAR2)
    RETURN BOOLEAN IS
  BEGIN
    RETURN regexp_like(i_direccion_correo,
                       k_util.f_valor_parametro('REGEXP_VALIDAR_DIRECCION_CORREO'));
  END;

  FUNCTION f_validar_numero_telefono(i_numero_telefono VARCHAR2)
    RETURN BOOLEAN IS
  BEGIN
    RETURN regexp_like(i_numero_telefono,
                       k_util.f_valor_parametro('REGEXP_VALIDAR_NUMERO_TELEFONO'));
  END;

  FUNCTION f_direccion_correo_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2 IS
    l_direccion_correo t_usuarios.direccion_correo%TYPE;
  BEGIN
    BEGIN
      SELECT direccion_correo
        INTO l_direccion_correo
        FROM t_usuarios
       WHERE id_usuario = i_id_usuario;
    EXCEPTION
      WHEN no_data_found THEN
        l_direccion_correo := NULL;
    END;
    RETURN l_direccion_correo;
  END;

  FUNCTION f_numero_telefono_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2 IS
    l_numero_telefono t_usuarios.numero_telefono%TYPE;
  BEGIN
    BEGIN
      SELECT numero_telefono
        INTO l_numero_telefono
        FROM t_usuarios
       WHERE id_usuario = i_id_usuario;
    EXCEPTION
      WHEN no_data_found THEN
        l_numero_telefono := NULL;
    END;
    RETURN l_numero_telefono;
  END;

BEGIN
  -- Initialization
  NULL;
END;
/
