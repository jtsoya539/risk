CREATE OR REPLACE PACKAGE k_mensajeria IS

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
                       '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');
  END;

  FUNCTION f_validar_numero_telefono(i_numero_telefono VARCHAR2)
    RETURN BOOLEAN IS
  BEGIN
    RETURN regexp_like(i_numero_telefono, 'regexp');
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
