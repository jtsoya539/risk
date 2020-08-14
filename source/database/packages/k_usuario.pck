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

  FUNCTION f_datos_usuario(i_id_usuario IN NUMBER) RETURN y_usuario;

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

  FUNCTION f_datos_usuario(i_id_usuario IN NUMBER) RETURN y_usuario IS
    l_usuario y_usuario;
    l_roles   y_roles;
    l_rol     y_rol;
  
    CURSOR cr_roles(i_id_usuario IN NUMBER) IS
      SELECT r.id_rol, r.nombre, r.activo, r.detalle
        FROM t_rol_usuarios ru, t_roles r
       WHERE r.id_rol = ru.id_rol
         AND r.activo = 'S'
         AND ru.id_usuario = i_id_usuario;
  BEGIN
    -- Inicializa respuesta
    l_usuario := NEW y_usuario();
    l_roles   := NEW y_roles();
  
    -- Buscando datos del usuario
    BEGIN
      SELECT u.id_usuario,
             u.alias,
             p.nombre,
             p.apellido,
             p.tipo_persona,
             u.estado,
             u.direccion_correo,
             u.numero_telefono,
             k_archivo.f_version_archivo('T_USUARIOS', 'AVATAR', u.alias)
        INTO l_usuario.id_usuario,
             l_usuario.alias,
             l_usuario.nombre,
             l_usuario.apellido,
             l_usuario.tipo_persona,
             l_usuario.estado,
             l_usuario.direccion_correo,
             l_usuario.numero_telefono,
             l_usuario.version_avatar
        FROM t_usuarios u, t_personas p
       WHERE p.id_persona(+) = u.id_persona
         AND u.id_usuario = i_id_usuario;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000, 'Usuario inexistente');
      WHEN OTHERS THEN
        raise_application_error(-20000,
                                'Error al buscar datos del usuario');
    END;
  
    -- Buscando roles del usuario
    FOR c IN cr_roles(l_usuario.id_usuario) LOOP
      l_rol         := NEW y_rol();
      l_rol.id_rol  := c.id_rol;
      l_rol.nombre  := c.nombre;
      l_rol.activo  := c.activo;
      l_rol.detalle := c.detalle;
    
      l_roles.extend;
      l_roles(l_roles.count) := l_rol;
    END LOOP;
    l_usuario.roles := l_roles;
  
    RETURN l_usuario;
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
