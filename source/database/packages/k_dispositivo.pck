CREATE OR REPLACE PACKAGE k_dispositivo IS

  /**
  Agrupa operaciones relacionadas con los dispositivos
  
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

  c_suscripcion_defecto CONSTANT VARCHAR2(120) := 'default';
  c_suscripcion_usuario CONSTANT VARCHAR2(120) := 'user';

  FUNCTION f_id_dispositivo(i_token_dispositivo IN VARCHAR2) RETURN NUMBER;

  FUNCTION f_registrar_dispositivo(i_clave_aplicacion          IN VARCHAR2,
                                   i_token_dispositivo         IN VARCHAR2,
                                   i_token_notificacion        IN VARCHAR2 DEFAULT NULL,
                                   i_nombre_sistema_operativo  IN VARCHAR2 DEFAULT NULL,
                                   i_version_sistema_operativo IN VARCHAR2 DEFAULT NULL,
                                   i_tipo                      IN VARCHAR2 DEFAULT NULL,
                                   i_nombre_navegador          IN VARCHAR2 DEFAULT NULL,
                                   i_version_navegador         IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  PROCEDURE p_agregar_suscripcion(i_id_dispositivo IN NUMBER,
                                  i_suscripcion    IN VARCHAR2);

  PROCEDURE p_eliminar_suscripcion(i_id_dispositivo IN NUMBER,
                                   i_suscripcion    IN VARCHAR2);

END;
/
CREATE OR REPLACE PACKAGE BODY k_dispositivo IS

  -- Tiempo de expiración de la suscripción en días
  c_tiempo_expiracion_suscripcion CONSTANT PLS_INTEGER := 30;

  FUNCTION f_id_dispositivo(i_token_dispositivo IN VARCHAR2) RETURN NUMBER IS
    l_id_dispositivo t_dispositivos.id_dispositivo%TYPE;
  BEGIN
    BEGIN
      SELECT id_dispositivo
        INTO l_id_dispositivo
        FROM t_dispositivos
       WHERE token_dispositivo = i_token_dispositivo;
    EXCEPTION
      WHEN no_data_found THEN
        l_id_dispositivo := NULL;
      WHEN OTHERS THEN
        l_id_dispositivo := NULL;
    END;
    RETURN l_id_dispositivo;
  END;

  FUNCTION f_registrar_dispositivo(i_clave_aplicacion          IN VARCHAR2,
                                   i_token_dispositivo         IN VARCHAR2,
                                   i_token_notificacion        IN VARCHAR2 DEFAULT NULL,
                                   i_nombre_sistema_operativo  IN VARCHAR2 DEFAULT NULL,
                                   i_version_sistema_operativo IN VARCHAR2 DEFAULT NULL,
                                   i_tipo                      IN VARCHAR2 DEFAULT NULL,
                                   i_nombre_navegador          IN VARCHAR2 DEFAULT NULL,
                                   i_version_navegador         IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    l_id_dispositivo t_dispositivos.id_dispositivo%TYPE;
    l_id_aplicacion  t_aplicaciones.id_aplicacion%TYPE;
  BEGIN
    -- Busca aplicación
    l_id_aplicacion := k_autenticacion.f_id_aplicacion(i_clave_aplicacion,
                                                       'S');
  
    IF l_id_aplicacion IS NULL THEN
      raise_application_error(-20000, 'Aplicación inexistente o inactiva');
    END IF;
  
    IF i_token_dispositivo IS NULL THEN
      raise_application_error(-20000, 'Parámetro Token es requerido');
    END IF;
  
    -- Busca dispositivo
    l_id_dispositivo := f_id_dispositivo(i_token_dispositivo);
  
    IF l_id_dispositivo IS NOT NULL THEN
      -- Actualiza dispositivo
      UPDATE t_dispositivos
         SET fecha_ultimo_acceso       = SYSDATE,
             id_aplicacion             = l_id_aplicacion,
             nombre_sistema_operativo  = nvl(i_nombre_sistema_operativo,
                                             nombre_sistema_operativo),
             version_sistema_operativo = nvl(i_version_sistema_operativo,
                                             version_sistema_operativo),
             tipo                      = nvl(i_tipo, tipo),
             nombre_navegador          = nvl(i_nombre_navegador,
                                             nombre_navegador),
             version_navegador         = nvl(i_version_navegador,
                                             version_navegador),
             token_notificacion        = nvl(i_token_notificacion,
                                             token_notificacion)
       WHERE id_dispositivo = l_id_dispositivo;
    ELSE
      -- Inserta dispositivo
      INSERT INTO t_dispositivos
        (token_dispositivo,
         fecha_ultimo_acceso,
         id_aplicacion,
         nombre_sistema_operativo,
         version_sistema_operativo,
         tipo,
         nombre_navegador,
         version_navegador,
         token_notificacion)
      VALUES
        (i_token_dispositivo,
         SYSDATE,
         l_id_aplicacion,
         i_nombre_sistema_operativo,
         i_version_sistema_operativo,
         i_tipo,
         i_nombre_navegador,
         i_version_navegador,
         i_token_notificacion)
      RETURNING id_dispositivo INTO l_id_dispositivo;
    END IF;
  
    IF l_id_dispositivo IS NOT NULL THEN
      -- Inserta o actualiza una suscripción por defecto en el dispositivo
      p_agregar_suscripcion(l_id_dispositivo, c_suscripcion_defecto);
    END IF;
  
    RETURN l_id_dispositivo;
  END;

  PROCEDURE p_agregar_suscripcion(i_id_dispositivo IN NUMBER,
                                  i_suscripcion    IN VARCHAR2) IS
  BEGIN
    -- Actualiza suscripción
    UPDATE t_dispositivo_suscripciones s
       SET s.suscripcion      = lower(i_suscripcion),
           s.fecha_expiracion = SYSDATE + c_tiempo_expiracion_suscripcion
     WHERE s.id_dispositivo = i_id_dispositivo
       AND lower(s.suscripcion) = lower(i_suscripcion);
  
    IF SQL%NOTFOUND THEN
      -- Inserta suscripción
      INSERT INTO t_dispositivo_suscripciones
        (id_dispositivo, suscripcion, fecha_expiracion)
      VALUES
        (i_id_dispositivo,
         lower(i_suscripcion),
         SYSDATE + c_tiempo_expiracion_suscripcion);
    END IF;
  END;

  PROCEDURE p_eliminar_suscripcion(i_id_dispositivo IN NUMBER,
                                   i_suscripcion    IN VARCHAR2) IS
  BEGIN
    DELETE t_dispositivo_suscripciones s
     WHERE s.id_dispositivo = i_id_dispositivo
       AND lower(s.suscripcion) = lower(i_suscripcion);
  END;

END;
/
