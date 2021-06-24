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

  FUNCTION f_suscripcion_defecto RETURN VARCHAR2;

  FUNCTION f_suscripcion_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2;

  FUNCTION f_id_dispositivo(i_token_dispositivo IN VARCHAR2) RETURN NUMBER;

  FUNCTION f_registrar_dispositivo(i_id_aplicacion             IN VARCHAR2,
                                   i_token_dispositivo         IN VARCHAR2,
                                   i_token_notificacion        IN VARCHAR2 DEFAULT NULL,
                                   i_nombre_sistema_operativo  IN VARCHAR2 DEFAULT NULL,
                                   i_version_sistema_operativo IN VARCHAR2 DEFAULT NULL,
                                   i_tipo                      IN VARCHAR2 DEFAULT NULL,
                                   i_nombre_navegador          IN VARCHAR2 DEFAULT NULL,
                                   i_version_navegador         IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER;

  FUNCTION f_datos_dispositivo(i_id_dispositivo IN NUMBER)
    RETURN y_dispositivo;

  PROCEDURE p_suscribir_notificacion(i_id_dispositivo   IN NUMBER,
                                     i_suscripcion_alta IN VARCHAR2);

  /**
  Suscribe a una notificaci�n a partir de otra suscripci�n
  
  %author dmezac 24/6/2021 10:05:15
  %param i_suscripcion Suscripci�n original
  %param i_suscripcion_alta Suscripci�n a dar de alta
  */
  PROCEDURE p_suscribir_notificacion_s(i_suscripcion      IN VARCHAR2,
                                       i_suscripcion_alta IN VARCHAR2);

  PROCEDURE p_desuscribir_notificacion(i_id_dispositivo   IN NUMBER,
                                       i_suscripcion_baja IN VARCHAR2);

  /**
  Desuscribe de una notificaci�n a partir de otra suscripci�n
  
  %author dmezac 24/6/2021 10:05:15
  %param i_suscripcion Suscripci�n original
  %param i_suscripcion_alta Suscripci�n a dar de baja
  */
  PROCEDURE p_desuscribir_notificacion_s(i_suscripcion      IN VARCHAR2,
                                         i_suscripcion_baja IN VARCHAR2);

  PROCEDURE p_registrar_ubicacion(i_id_dispositivo IN NUMBER,
                                  i_latitud        IN NUMBER,
                                  i_longitud       IN NUMBER);

END;
/
CREATE OR REPLACE PACKAGE BODY k_dispositivo IS

  -- Tiempo de expiraci�n de la suscripci�n en d�as
  c_tiempo_expiracion_suscripcion CONSTANT PLS_INTEGER := 30;

  FUNCTION f_suscripcion_defecto RETURN VARCHAR2 IS
  BEGIN
    RETURN c_suscripcion_defecto;
  END;

  FUNCTION f_suscripcion_usuario(i_id_usuario IN NUMBER) RETURN VARCHAR2 IS
  BEGIN
    RETURN c_suscripcion_usuario || '_' || to_char(i_id_usuario);
  END;

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

  FUNCTION f_registrar_dispositivo(i_id_aplicacion             IN VARCHAR2,
                                   i_token_dispositivo         IN VARCHAR2,
                                   i_token_notificacion        IN VARCHAR2 DEFAULT NULL,
                                   i_nombre_sistema_operativo  IN VARCHAR2 DEFAULT NULL,
                                   i_version_sistema_operativo IN VARCHAR2 DEFAULT NULL,
                                   i_tipo                      IN VARCHAR2 DEFAULT NULL,
                                   i_nombre_navegador          IN VARCHAR2 DEFAULT NULL,
                                   i_version_navegador         IN VARCHAR2 DEFAULT NULL)
    RETURN NUMBER IS
    l_id_dispositivo t_dispositivos.id_dispositivo%TYPE;
  BEGIN
    -- Valida aplicaci�n
    IF i_id_aplicacion IS NULL THEN
      raise_application_error(-20000, 'Aplicaci�n inexistente o inactiva');
    END IF;
  
    IF i_token_dispositivo IS NULL THEN
      raise_application_error(-20000, 'Par�metro Token es requerido');
    END IF;
  
    -- Busca dispositivo
    l_id_dispositivo := f_id_dispositivo(i_token_dispositivo);
  
    IF l_id_dispositivo IS NOT NULL THEN
      -- Actualiza dispositivo
      UPDATE t_dispositivos
         SET fecha_ultimo_acceso       = SYSDATE,
             id_aplicacion             = i_id_aplicacion,
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
         i_id_aplicacion,
         i_nombre_sistema_operativo,
         i_version_sistema_operativo,
         i_tipo,
         i_nombre_navegador,
         i_version_navegador,
         i_token_notificacion)
      RETURNING id_dispositivo INTO l_id_dispositivo;
    END IF;
  
    IF l_id_dispositivo IS NOT NULL THEN
      -- Inserta o actualiza una suscripci�n por defecto en el dispositivo
      p_suscribir_notificacion(l_id_dispositivo, c_suscripcion_defecto);
    END IF;
  
    RETURN l_id_dispositivo;
  END;

  FUNCTION f_datos_dispositivo(i_id_dispositivo IN NUMBER)
    RETURN y_dispositivo IS
    l_dispositivo   y_dispositivo;
    l_suscripciones y_datos;
    l_suscripcion   y_dato;
    l_plantilla     y_plantilla;
    l_plantillas    y_datos;
    l_id_aplicacion t_aplicaciones.id_aplicacion%TYPE;
  
    $if k_modulo.c_instalado_msj $then
    CURSOR cr_plantillas(i_id_aplicacion IN VARCHAR2) IS
      SELECT n.nombre, n.plantilla
        FROM t_notificacion_plantillas n
       WHERE n.id_aplicacion = i_id_aplicacion;
    $end
  
    CURSOR cr_suscripciones(i_id_dispositivo IN NUMBER) IS
      SELECT s.suscripcion
        FROM t_dispositivo_suscripciones s
       WHERE (s.fecha_expiracion IS NULL OR s.fecha_expiracion > SYSDATE)
         AND s.id_dispositivo = i_id_dispositivo;
  BEGIN
    -- Inicializa respuesta
    l_dispositivo   := NEW y_dispositivo();
    l_suscripciones := NEW y_datos();
    l_plantillas    := NEW y_datos();
  
    -- Buscando datos del dispositivo
    BEGIN
      SELECT d.id_dispositivo,
             d.token_dispositivo,
             d.nombre_sistema_operativo,
             d.version_sistema_operativo,
             d.tipo,
             d.nombre_navegador,
             d.version_navegador,
             d.token_notificacion,
             a.plataforma_notificacion,
             a.id_aplicacion
        INTO l_dispositivo.id_dispositivo,
             l_dispositivo.token_dispositivo,
             l_dispositivo.nombre_sistema_operativo,
             l_dispositivo.version_sistema_operativo,
             l_dispositivo.tipo,
             l_dispositivo.nombre_navegador,
             l_dispositivo.version_navegador,
             l_dispositivo.token_notificacion,
             l_dispositivo.plataforma_notificacion,
             l_id_aplicacion
        FROM t_dispositivos d, t_aplicaciones a
       WHERE a.id_aplicacion(+) = d.id_aplicacion
         AND d.id_dispositivo = i_id_dispositivo;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000, 'Dispositivo inexistente');
      WHEN OTHERS THEN
        raise_application_error(-20000,
                                'Error al buscar datos del dispositivo');
    END;
  
    -- Buscando plantillas de la aplicaci�n
    $if k_modulo.c_instalado_msj $then
    FOR c IN cr_plantillas(l_id_aplicacion) LOOP
      l_plantilla           := NEW y_plantilla();
      l_plantilla.contenido := c.plantilla;
      l_plantilla.nombre    := c.nombre;
    
      l_plantillas.extend;
      l_plantillas(l_plantillas.count) := l_plantilla;
    END LOOP;
    $end
    l_dispositivo.plantillas := l_plantillas;
  
    -- Buscando suscripciones del dispositivo
    FOR c IN cr_suscripciones(l_dispositivo.id_dispositivo) LOOP
      l_suscripcion           := NEW y_dato();
      l_suscripcion.contenido := c.suscripcion;
    
      l_suscripciones.extend;
      l_suscripciones(l_suscripciones.count) := l_suscripcion;
    END LOOP;
    l_dispositivo.suscripciones := l_suscripciones;
  
    RETURN l_dispositivo;
  END;

  PROCEDURE p_suscribir_notificacion(i_id_dispositivo   IN NUMBER,
                                     i_suscripcion_alta IN VARCHAR2) IS
  BEGIN
    -- Actualiza suscripci�n
    UPDATE t_dispositivo_suscripciones s
       SET s.suscripcion      = lower(i_suscripcion_alta),
           s.fecha_expiracion = SYSDATE + c_tiempo_expiracion_suscripcion
     WHERE s.id_dispositivo = i_id_dispositivo
       AND lower(s.suscripcion) = lower(i_suscripcion_alta);
  
    IF SQL%NOTFOUND THEN
      -- Inserta suscripci�n
      INSERT INTO t_dispositivo_suscripciones
        (id_dispositivo, suscripcion, fecha_expiracion)
      VALUES
        (i_id_dispositivo,
         lower(i_suscripcion_alta),
         SYSDATE + c_tiempo_expiracion_suscripcion);
    END IF;
  END;

  PROCEDURE p_suscribir_notificacion_s(i_suscripcion      IN VARCHAR2,
                                       i_suscripcion_alta IN VARCHAR2) IS
    CURSOR cr_dispositivos(i_suscripcion IN VARCHAR2) IS
      SELECT s.id_dispositivo
        FROM t_dispositivo_suscripciones s
       WHERE lower(s.suscripcion) = lower(i_suscripcion)
         AND (s.fecha_expiracion IS NULL OR s.fecha_expiracion > SYSDATE);
  BEGIN
    FOR c IN cr_dispositivos(i_suscripcion) LOOP
      p_suscribir_notificacion(c.id_dispositivo, i_suscripcion_alta);
    END LOOP;
  END;

  PROCEDURE p_desuscribir_notificacion(i_id_dispositivo   IN NUMBER,
                                       i_suscripcion_baja IN VARCHAR2) IS
  BEGIN
    DELETE t_dispositivo_suscripciones s
     WHERE s.id_dispositivo = i_id_dispositivo
       AND lower(s.suscripcion) = lower(i_suscripcion_baja);
  END;

  PROCEDURE p_desuscribir_notificacion_s(i_suscripcion      IN VARCHAR2,
                                         i_suscripcion_baja IN VARCHAR2) IS
    CURSOR cr_dispositivos(i_suscripcion IN VARCHAR2) IS
      SELECT s.id_dispositivo
        FROM t_dispositivo_suscripciones s
       WHERE lower(s.suscripcion) = lower(i_suscripcion)
         AND (s.fecha_expiracion IS NULL OR s.fecha_expiracion > SYSDATE);
  BEGIN
    FOR c IN cr_dispositivos(i_suscripcion) LOOP
      p_desuscribir_notificacion(c.id_dispositivo, i_suscripcion_baja);
    END LOOP;
  END;

  PROCEDURE p_registrar_ubicacion(i_id_dispositivo IN NUMBER,
                                  i_latitud        IN NUMBER,
                                  i_longitud       IN NUMBER) IS
  BEGIN
    -- Inserta ubicaci�n
    INSERT INTO t_dispositivo_ubicaciones
      (id_dispositivo, fecha, latitud, longitud)
    VALUES
      (i_id_dispositivo, SYSDATE, i_latitud, i_longitud);
  END;

END;
/
