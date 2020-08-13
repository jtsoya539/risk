CREATE OR REPLACE PACKAGE k_usuario IS

  /**
  Agrupa operaciones relacionadas con los usuarios
  
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
  ex_usuario_inexistente EXCEPTION;

  FUNCTION f_id_usuario(i_alias IN VARCHAR2) RETURN NUMBER;

  FUNCTION f_alias(i_id_usuario IN NUMBER) RETURN VARCHAR2;

  FUNCTION f_validar_alias(i_alias VARCHAR2) RETURN BOOLEAN;

  PROCEDURE p_cambiar_estado(i_usuario IN VARCHAR2,
                             i_estado  IN VARCHAR2);

END;
/
CREATE OR REPLACE PACKAGE BODY k_usuario IS

  FUNCTION f_id_usuario(i_alias IN VARCHAR2) RETURN NUMBER IS
    l_id_usuario t_usuarios.id_usuario%TYPE;
  BEGIN
    BEGIN
      SELECT id_usuario
        INTO l_id_usuario
        FROM t_usuarios
       WHERE alias = i_alias;
    EXCEPTION
      WHEN no_data_found THEN
        l_id_usuario := NULL;
      WHEN OTHERS THEN
        l_id_usuario := NULL;
    END;
    RETURN l_id_usuario;
  END;

  FUNCTION f_alias(i_id_usuario IN NUMBER) RETURN VARCHAR2 IS
    l_alias t_usuarios.alias%TYPE;
  BEGIN
    BEGIN
      SELECT u.alias
        INTO l_alias
        FROM t_usuarios u
       WHERE u.id_usuario = i_id_usuario;
    EXCEPTION
      WHEN no_data_found THEN
        l_alias := NULL;
      WHEN OTHERS THEN
        l_alias := NULL;
    END;
    RETURN l_alias;
  END;

  FUNCTION f_validar_alias(i_alias VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN nvl(regexp_like(i_alias,
                           k_util.f_valor_parametro('REGEXP_VALIDAR_ALIAS_USUARIO')),
               TRUE);
  END;

  PROCEDURE p_cambiar_estado(i_usuario IN VARCHAR2,
                             i_estado  IN VARCHAR2) IS
    l_id_usuario t_usuarios.id_usuario%TYPE;
  BEGIN
    -- Busca usuario
    l_id_usuario := f_id_usuario(i_usuario);
  
    IF l_id_usuario IS NULL THEN
      RAISE ex_usuario_inexistente;
    END IF;
  
    -- Actualiza usuario
    UPDATE t_usuarios
       SET estado = i_estado
     WHERE id_usuario = l_id_usuario
       AND estado <> i_estado;
  EXCEPTION
    WHEN ex_usuario_inexistente THEN
      raise_application_error(-20000, 'Usuario inexistente');
  END;

END;
/
