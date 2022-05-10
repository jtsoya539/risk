CREATE OR REPLACE PACKAGE k_operacion IS

  /**
  Agrupa operaciones relacionadas con las Operaciones (Servicios Web, Reportes, Trabajos)
  
  %author jtsoya539 27/3/2020 16:42:26
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

  -- Tipos de Operaciones
  c_tipo_servicio   CONSTANT CHAR(1) := 'S';
  c_tipo_reporte    CONSTANT CHAR(1) := 'R';
  c_tipo_trabajo    CONSTANT CHAR(1) := 'T';
  c_tipo_parametros CONSTANT CHAR(1) := 'P';

  -- Tipos de Implementaciones
  c_tipo_implementacion_paquete CONSTANT CHAR(1) := 'K';
  c_tipo_implementacion_funcion CONSTANT CHAR(1) := 'F';

  -- Códigos de respuesta
  c_ok                       CONSTANT VARCHAR2(10) := '0';
  c_servicio_no_implementado CONSTANT VARCHAR2(10) := 'ser0001';
  c_error_parametro          CONSTANT VARCHAR2(10) := 'ser0002';
  c_error_permiso            CONSTANT VARCHAR2(10) := 'ser0003';
  c_error_general            CONSTANT VARCHAR2(10) := 'ser0099';
  c_error_inesperado         CONSTANT VARCHAR2(10) := 'ser9999';

  -- Otras constantes
  c_id_log                 CONSTANT VARCHAR2(50) := 'ID_LOG';
  c_id_ope_par_automaticos CONSTANT PLS_INTEGER := 1000;
  c_id_operacion_contexto  CONSTANT PLS_INTEGER := 1001;

  -- Excepciones
  ex_servicio_no_implementado EXCEPTION;
  ex_error_parametro          EXCEPTION;
  ex_error_general            EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_servicio_no_implementado, -6550);

  PROCEDURE p_reservar_id_log(i_id_operacion IN NUMBER);

  PROCEDURE p_registrar_log(i_id_operacion     IN NUMBER,
                            i_parametros       IN CLOB,
                            i_codigo_respuesta IN VARCHAR2,
                            i_respuesta        IN CLOB,
                            i_contexto         IN CLOB DEFAULT NULL,
                            i_version          IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_respuesta_ok(io_respuesta IN OUT NOCOPY y_respuesta,
                           i_datos      IN y_objeto DEFAULT NULL);

  PROCEDURE p_respuesta_error(io_respuesta IN OUT NOCOPY y_respuesta,
                              i_codigo     IN VARCHAR2,
                              i_mensaje    IN VARCHAR2 DEFAULT NULL,
                              i_mensaje_bd IN VARCHAR2 DEFAULT NULL,
                              i_datos      IN y_objeto DEFAULT NULL);

  PROCEDURE p_respuesta_excepcion(io_respuesta   IN OUT NOCOPY y_respuesta,
                                  i_error_number IN NUMBER,
                                  i_error_msg    IN VARCHAR2,
                                  i_error_stack  IN VARCHAR2);

  PROCEDURE p_validar_parametro(io_respuesta IN OUT NOCOPY y_respuesta,
                                i_expresion  IN BOOLEAN,
                                i_mensaje    IN VARCHAR2);

  PROCEDURE p_definir_parametros(i_id_operacion     IN NUMBER,
                                 i_nombre_operacion IN VARCHAR2,
                                 i_contexto         IN y_parametros);

  FUNCTION f_operacion(i_id_operacion IN NUMBER) RETURN t_operaciones%ROWTYPE;

  FUNCTION f_id_operacion(i_tipo    IN VARCHAR2,
                          i_nombre  IN VARCHAR2,
                          i_dominio IN VARCHAR2) RETURN NUMBER;

  FUNCTION f_id_permiso(i_id_operacion IN NUMBER) RETURN VARCHAR2;

  FUNCTION f_id_modulo(i_id_operacion IN NUMBER) RETURN VARCHAR2;

  FUNCTION f_procesar_parametros(i_id_operacion IN NUMBER,
                                 i_parametros   IN CLOB,
                                 i_version      IN VARCHAR2 DEFAULT NULL)
    RETURN y_parametros;

  FUNCTION f_nombre_programa(i_id_operacion IN NUMBER,
                             i_version      IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2;

  FUNCTION f_filtros_sql(i_parametros      IN y_parametros,
                         i_nombres_excluir IN y_cadenas DEFAULT NULL)
    RETURN CLOB;

  FUNCTION f_valor_parametro(i_parametros IN y_parametros,
                             i_nombre     IN VARCHAR2) RETURN anydata;

  FUNCTION f_valor_parametro_string(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_valor_parametro_number(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN NUMBER;

  FUNCTION f_valor_parametro_boolean(i_parametros IN y_parametros,
                                     i_nombre     IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION f_valor_parametro_date(i_parametros IN y_parametros,
                                  i_nombre     IN VARCHAR2) RETURN DATE;

  FUNCTION f_valor_parametro_object(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN y_objeto;

  FUNCTION f_inserts_operacion(i_operacion IN t_operaciones%ROWTYPE)
    RETURN CLOB;

  FUNCTION f_inserts_operacion(i_id_operacion IN NUMBER) RETURN CLOB;

  FUNCTION f_inserts_operacion(i_tipo    IN VARCHAR2,
                               i_nombre  IN VARCHAR2,
                               i_dominio IN VARCHAR2) RETURN CLOB;

  FUNCTION f_deletes_operacion(i_operacion IN t_operaciones%ROWTYPE)
    RETURN CLOB;

  FUNCTION f_deletes_operacion(i_id_operacion IN NUMBER) RETURN CLOB;

  FUNCTION f_deletes_operacion(i_tipo    IN VARCHAR2,
                               i_nombre  IN VARCHAR2,
                               i_dominio IN VARCHAR2) RETURN CLOB;

  FUNCTION f_scripts_operaciones(i_id_modulo IN VARCHAR2 DEFAULT NULL)
    RETURN BLOB;

END;
/
CREATE OR REPLACE PACKAGE BODY k_operacion IS

  PROCEDURE p_reservar_id_log(i_id_operacion IN NUMBER) IS
    l_nivel_log t_operaciones.nivel_log%TYPE;
  BEGIN
    BEGIN
      SELECT nivel_log
        INTO l_nivel_log
        FROM t_operaciones
       WHERE id_operacion = i_id_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        l_nivel_log := 0;
    END;
  
    IF l_nivel_log > 0 THEN
      k_sistema.p_definir_parametro_number(c_id_log,
                                           s_id_operacion_log.nextval);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE p_registrar_log(i_id_operacion     IN NUMBER,
                            i_parametros       IN CLOB,
                            i_codigo_respuesta IN VARCHAR2,
                            i_respuesta        IN CLOB,
                            i_contexto         IN CLOB DEFAULT NULL,
                            i_version          IN VARCHAR2 DEFAULT NULL) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_nivel_log t_operaciones.nivel_log%TYPE;
  BEGIN
    BEGIN
      SELECT nivel_log
        INTO l_nivel_log
        FROM t_operaciones
       WHERE id_operacion = i_id_operacion;
    EXCEPTION
      WHEN OTHERS THEN
        l_nivel_log := 0;
    END;
  
    IF (l_nivel_log > 1 AND i_codigo_respuesta = c_ok) OR
       (l_nivel_log > 0 AND i_codigo_respuesta <> c_ok) THEN
      INSERT INTO t_operacion_logs
        (id_operacion_log,
         id_operacion,
         contexto,
         version,
         parametros,
         respuesta)
      VALUES
        (k_sistema.f_valor_parametro_number(c_id_log),
         i_id_operacion,
         i_contexto,
         substr(i_version, 1, 100),
         i_parametros,
         i_respuesta);
    END IF;
  
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  PROCEDURE p_respuesta_ok(io_respuesta IN OUT NOCOPY y_respuesta,
                           i_datos      IN y_objeto DEFAULT NULL) IS
  BEGIN
    io_respuesta.codigo     := c_ok;
    io_respuesta.mensaje    := 'OK';
    io_respuesta.mensaje_bd := NULL;
    io_respuesta.lugar      := NULL;
    io_respuesta.datos      := i_datos;
  END;

  PROCEDURE p_respuesta_error(io_respuesta IN OUT NOCOPY y_respuesta,
                              i_codigo     IN VARCHAR2,
                              i_mensaje    IN VARCHAR2 DEFAULT NULL,
                              i_mensaje_bd IN VARCHAR2 DEFAULT NULL,
                              i_datos      IN y_objeto DEFAULT NULL) IS
    l_mensaje VARCHAR2(32767) := substr(i_mensaje, 1, 32767);
  BEGIN
    IF i_codigo = c_ok THEN
      io_respuesta.codigo := c_error_general;
    ELSE
      io_respuesta.codigo := substr(i_codigo, 1, 10);
    END IF;
    io_respuesta.mensaje    := substr(k_error.f_mensaje_excepcion(nvl(l_mensaje,
                                                                      k_error.f_mensaje_error(i_codigo))),
                                      1,
                                      4000);
    io_respuesta.mensaje_bd := substr(i_mensaje_bd, 1, 4000);
    io_respuesta.datos      := i_datos;
  END;

  PROCEDURE p_respuesta_excepcion(io_respuesta   IN OUT NOCOPY y_respuesta,
                                  i_error_number IN NUMBER,
                                  i_error_msg    IN VARCHAR2,
                                  i_error_stack  IN VARCHAR2) IS
  BEGIN
    IF k_error.f_tipo_excepcion(i_error_number) =
       k_error.c_user_defined_error THEN
      p_respuesta_error(io_respuesta,
                        c_error_general,
                        i_error_msg,
                        i_error_stack);
    ELSIF k_error.f_tipo_excepcion(i_error_number) =
          k_error.c_oracle_predefined_error THEN
      p_respuesta_error(io_respuesta,
                        c_error_inesperado,
                        k_error.f_mensaje_error(c_error_inesperado,
                                                to_char(nvl(k_sistema.f_valor_parametro_number(c_id_log),
                                                            0))),
                        i_error_stack);
    END IF;
  END;

  PROCEDURE p_validar_parametro(io_respuesta IN OUT NOCOPY y_respuesta,
                                i_expresion  IN BOOLEAN,
                                i_mensaje    IN VARCHAR2) IS
  BEGIN
    IF NOT nvl(i_expresion, FALSE) THEN
      p_respuesta_error(io_respuesta,
                        c_error_parametro,
                        nvl(i_mensaje,
                            k_error.f_mensaje_error(c_error_parametro)));
      RAISE ex_error_parametro;
    END IF;
  END;

  PROCEDURE p_definir_parametros(i_id_operacion     IN NUMBER,
                                 i_nombre_operacion IN VARCHAR2,
                                 i_contexto         IN y_parametros) IS
    l_id_sesion      t_sesiones.id_sesion%TYPE;
    l_id_dispositivo t_dispositivos.id_dispositivo%TYPE;
    l_dispositivo    y_dispositivo;
  BEGIN
    k_sistema.p_definir_parametro_number(k_sistema.c_id_operacion,
                                         i_id_operacion);
    k_sistema.p_definir_parametro_string(k_sistema.c_nombre_operacion,
                                         i_nombre_operacion);
    --
    k_sistema.p_definir_parametro_string(k_sistema.c_direccion_ip,
                                         k_operacion.f_valor_parametro_string(i_contexto,
                                                                              'direccion_ip'));
    k_sistema.p_definir_parametro_string(k_sistema.c_id_aplicacion,
                                         k_aplicacion.f_id_aplicacion(k_operacion.f_valor_parametro_string(i_contexto,
                                                                                                           'clave_aplicacion')));
    k_sistema.p_definir_parametro_string(k_sistema.c_usuario,
                                         k_operacion.f_valor_parametro_string(i_contexto,
                                                                              'usuario'));
    k_sistema.p_definir_parametro_number(k_sistema.c_id_usuario,
                                         k_usuario.f_id_usuario(k_operacion.f_valor_parametro_string(i_contexto,
                                                                                                     'usuario')));
    --
    l_id_sesion := k_sesion.f_id_sesion(k_operacion.f_valor_parametro_string(i_contexto,
                                                                             'access_token'));
    k_sistema.p_definir_parametro_number(k_sistema.c_id_sesion,
                                         l_id_sesion);
    --
    l_id_dispositivo := k_dispositivo.f_id_dispositivo(k_operacion.f_valor_parametro_string(i_contexto,
                                                                                            'token_dispositivo'));
  
    IF l_id_dispositivo IS NULL AND l_id_sesion IS NOT NULL THEN
      l_id_dispositivo := k_sesion.f_dispositivo_sesion(l_id_sesion);
    END IF;
  
    IF l_id_dispositivo IS NOT NULL THEN
      l_dispositivo := k_dispositivo.f_datos_dispositivo(l_id_dispositivo);
    
      DECLARE
        l_id_pais t_paises.id_pais%TYPE;
      BEGIN
        IF l_dispositivo.id_pais_iso2 IS NOT NULL THEN
          SELECT p.id_pais
            INTO l_id_pais
            FROM t_paises p
           WHERE p.iso_alpha_2 = l_dispositivo.id_pais_iso2;
          k_sistema.p_definir_parametro_number(k_sistema.c_id_pais,
                                               l_id_pais);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      IF l_dispositivo.zona_horaria IS NOT NULL THEN
        k_sistema.p_definir_parametro_string(k_sistema.c_zona_horaria,
                                             l_dispositivo.zona_horaria);
      END IF;
    
      DECLARE
        l_id_idioma t_idiomas.id_idioma%TYPE;
      BEGIN
        IF l_dispositivo.id_idioma_iso369_1 IS NOT NULL THEN
          SELECT i.id_idioma
            INTO l_id_idioma
            FROM t_idiomas i
           WHERE i.iso_639_1 = l_dispositivo.id_idioma_iso369_1;
          k_sistema.p_definir_parametro_number(k_sistema.c_id_idioma,
                                               l_id_idioma);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  END;

  FUNCTION f_operacion(i_id_operacion IN NUMBER) RETURN t_operaciones%ROWTYPE IS
    rw_operacion t_operaciones%ROWTYPE;
  BEGIN
    BEGIN
      SELECT a.*
        INTO rw_operacion
        FROM t_operaciones a
       WHERE a.id_operacion = i_id_operacion;
    EXCEPTION
      WHEN no_data_found THEN
        rw_operacion := NULL;
      WHEN OTHERS THEN
        rw_operacion := NULL;
    END;
    RETURN rw_operacion;
  END;

  FUNCTION f_id_operacion(i_tipo    IN VARCHAR2,
                          i_nombre  IN VARCHAR2,
                          i_dominio IN VARCHAR2) RETURN NUMBER IS
    l_id_operacion t_operaciones.id_operacion%TYPE;
  BEGIN
    BEGIN
      SELECT a.id_operacion
        INTO l_id_operacion
        FROM t_operaciones a
       WHERE a.tipo = i_tipo
         AND a.nombre = i_nombre
         AND a.dominio = i_dominio;
    EXCEPTION
      WHEN no_data_found THEN
        l_id_operacion := NULL;
      WHEN OTHERS THEN
        l_id_operacion := NULL;
    END;
    RETURN l_id_operacion;
  END;

  FUNCTION f_id_permiso(i_id_operacion IN NUMBER) RETURN VARCHAR2 IS
    l_id_permiso t_permisos.id_permiso%TYPE;
  BEGIN
    BEGIN
      SELECT p.id_permiso
        INTO l_id_permiso
        FROM t_permisos p, t_operaciones a
       WHERE upper(p.id_permiso) =
             upper(k_util.f_significado_codigo('TIPO_OPERACION', a.tipo) || ':' ||
                   a.dominio || ':' || a.nombre)
         AND a.id_operacion = i_id_operacion;
    EXCEPTION
      WHEN no_data_found THEN
        l_id_permiso := NULL;
      WHEN OTHERS THEN
        l_id_permiso := NULL;
    END;
    RETURN l_id_permiso;
  END;

  FUNCTION f_id_modulo(i_id_operacion IN NUMBER) RETURN VARCHAR2 IS
    l_id_modulo t_modulos.id_modulo%TYPE;
  BEGIN
    BEGIN
      SELECT m.id_modulo
        INTO l_id_modulo
        FROM t_operaciones a, t_dominios d, t_modulos m
       WHERE d.id_dominio = nvl(a.dominio, 'API')
         AND m.id_modulo = d.id_modulo
         AND a.id_operacion = i_id_operacion;
    EXCEPTION
      WHEN no_data_found THEN
        l_id_modulo := NULL;
      WHEN OTHERS THEN
        l_id_modulo := NULL;
    END;
    RETURN l_id_modulo;
  END;

  FUNCTION f_procesar_parametros(i_id_operacion IN NUMBER,
                                 i_parametros   IN CLOB,
                                 i_version      IN VARCHAR2 DEFAULT NULL)
    RETURN y_parametros IS
    l_parametros   y_parametros;
    l_parametro    y_parametro;
    l_json_object  json_object_t;
    l_json_element json_element_t;
  
    CURSOR cr_parametros IS
      SELECT op.id_operacion,
             lower(op.nombre) nombre,
             op.orden,
             op.activo,
             op.tipo_dato,
             op.formato,
             op.longitud_maxima,
             op.obligatorio,
             op.valor_defecto,
             op.etiqueta,
             op.detalle,
             op.valores_posibles,
             op.encriptado
        FROM t_operacion_parametros op, t_operaciones o
       WHERE o.id_operacion = op.id_operacion
         AND op.activo = 'S'
         AND op.id_operacion = i_id_operacion
         AND op.version = nvl(i_version, o.version_actual)
      UNION
      -- Parámetros automáticos
      SELECT op.id_operacion,
             lower(op.nombre) nombre,
             op.orden,
             op.activo,
             op.tipo_dato,
             op.formato,
             op.longitud_maxima,
             op.obligatorio,
             op.valor_defecto,
             op.etiqueta,
             op.detalle,
             op.valores_posibles,
             op.encriptado
        FROM t_operacion_parametros op
       WHERE op.activo = 'S'
         AND op.id_operacion = c_id_ope_par_automaticos
         AND EXISTS (SELECT 1
                FROM t_operaciones o
               WHERE lower(op.nombre) IN
                     (SELECT lower(TRIM(column_value))
                        FROM k_util.f_separar_cadenas(o.parametros_automaticos,
                                                      ','))
                 AND o.id_operacion = i_id_operacion)
       ORDER BY orden;
  BEGIN
    -- Inicializa respuesta
    l_parametros := NEW y_parametros();
  
    IF i_parametros IS NULL OR dbms_lob.getlength(i_parametros) = 0 THEN
      l_json_object := json_object_t.parse('{}');
    ELSE
      l_json_object := json_object_t.parse(i_parametros);
    END IF;
  
    FOR par IN cr_parametros LOOP
      l_parametro        := NEW y_parametro();
      l_parametro.nombre := par.nombre;
    
      l_json_element := l_json_object.get(par.nombre);
    
      IF par.obligatorio = 'S' THEN
        IF NOT l_json_object.has(par.nombre) THEN
          raise_application_error(-20000,
                                  k_error.f_mensaje_error('ora0003',
                                                          nvl(par.etiqueta,
                                                              par.nombre)));
        ELSE
          IF l_json_element.is_null THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        END IF;
      END IF;
    
      CASE par.tipo_dato
      
        WHEN 'S' THEN
          -- String
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_string THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0005',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
          IF par.encriptado = 'S' THEN
            BEGIN
              l_parametro.valor := anydata.convertvarchar2(k_util.decrypt(l_json_object.get_string(par.nombre)));
            EXCEPTION
              WHEN value_error THEN
                raise_application_error(-20000,
                                        k_error.f_mensaje_error('ora0008',
                                                                nvl(par.etiqueta,
                                                                    par.nombre)));
              WHEN OTHERS THEN
                raise_application_error(-20000,
                                        k_error.f_mensaje_error('ora0009',
                                                                nvl(par.etiqueta,
                                                                    par.nombre)));
            END;
          ELSE
            l_parametro.valor := anydata.convertvarchar2(l_json_object.get_string(par.nombre));
          END IF;
          IF l_parametro.valor.accessvarchar2 IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertvarchar2(par.valor_defecto);
          END IF;
          IF l_parametro.valor.accessvarchar2 IS NULL AND
             par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
          IF par.longitud_maxima IS NOT NULL AND
             nvl(length(l_parametro.valor.accessvarchar2), 0) >
             par.longitud_maxima THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0006',
                                                            nvl(par.etiqueta,
                                                                par.nombre),
                                                            to_char(par.longitud_maxima)));
          END IF;
          IF par.valores_posibles IS NOT NULL AND
             l_parametro.valor.accessvarchar2 IS NOT NULL AND NOT
              k_significado.f_existe_codigo(par.valores_posibles,
                                                                                             l_parametro.valor.accessvarchar2) THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0007',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
        WHEN 'N' THEN
          -- Number
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_number THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0005',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
          l_parametro.valor := anydata.convertnumber(l_json_object.get_number(par.nombre));
          IF l_parametro.valor.accessnumber IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertnumber(to_number(par.valor_defecto));
          END IF;
          IF l_parametro.valor.accessnumber IS NULL AND
             par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
          IF par.longitud_maxima IS NOT NULL AND
             nvl(length(to_char(abs(trunc(l_parametro.valor.accessnumber)))),
                 0) > par.longitud_maxima THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0006',
                                                            nvl(par.etiqueta,
                                                                par.nombre),
                                                            to_char(par.longitud_maxima)));
          END IF;
          IF par.valores_posibles IS NOT NULL AND
             l_parametro.valor.accessnumber IS NOT NULL AND NOT
              k_significado.f_existe_codigo(par.valores_posibles,
                                                                                           to_char(l_parametro.valor.accessnumber)) THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0007',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
        WHEN 'B' THEN
          -- Boolean
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_boolean THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0005',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
          l_parametro.valor := anydata.convertnumber(sys.diutil.bool_to_int(l_json_object.get_boolean(par.nombre)));
          IF l_parametro.valor.accessnumber IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertnumber(to_number(par.valor_defecto));
          END IF;
          IF l_parametro.valor.accessnumber IS NULL AND
             par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
        WHEN 'D' THEN
          -- Date
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_string /*l_json_element.is_date*/
           THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0005',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
          l_parametro.valor := anydata.convertdate(l_json_object.get_date(par.nombre));
          IF l_parametro.valor.accessdate IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertdate(to_date(par.valor_defecto,
                                                             par.formato));
          END IF;
          IF l_parametro.valor.accessdate IS NULL AND par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
        WHEN 'O' THEN
          -- Object
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_object THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0005',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
          IF l_json_element IS NOT NULL AND l_json_element.is_object THEN
            l_parametro.valor := k_util.json_to_objeto(l_json_element.to_clob,
                                                       par.formato);
          END IF;
        
          IF l_parametro.valor IS NULL AND par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := k_util.json_to_objeto(par.valor_defecto,
                                                       par.formato);
          END IF;
          IF l_parametro.valor IS NULL AND par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    k_error.f_mensaje_error('ora0004',
                                                            nvl(par.etiqueta,
                                                                par.nombre)));
          END IF;
        
        ELSE
          raise_application_error(-20000,
                                  k_error.f_mensaje_error('ora0002',
                                                          'parámetro',
                                                          nvl(par.etiqueta,
                                                              par.nombre)));
        
      END CASE;
    
      l_parametros.extend;
      l_parametros(l_parametros.count) := l_parametro;
    END LOOP;
    RETURN l_parametros;
  END;

  FUNCTION f_nombre_programa(i_id_operacion IN NUMBER,
                             i_version      IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2 IS
    l_nombre_programa     VARCHAR2(4000);
    l_tipo_operacion      t_operaciones.tipo%TYPE;
    l_nombre_operacion    t_operaciones.nombre%TYPE;
    l_dominio_operacion   t_operaciones.dominio%TYPE;
    l_version_actual      t_operaciones.version_actual%TYPE;
    l_tipo_implementacion t_operaciones.tipo_implementacion%TYPE;
  BEGIN
  
    BEGIN
      SELECT o.tipo,
             upper(o.nombre),
             upper(o.dominio),
             o.version_actual,
             nvl(o.tipo_implementacion, 'K')
        INTO l_tipo_operacion,
             l_nombre_operacion,
             l_dominio_operacion,
             l_version_actual,
             l_tipo_implementacion
        FROM t_operaciones o
       WHERE o.id_operacion = i_id_operacion;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000, 'Operación inexistente');
    END;
  
    l_nombre_programa := k_util.f_referencia_codigo('TIPO_IMPLEMENTACION',
                                                    l_tipo_implementacion) || '_' ||
                         k_util.f_significado_codigo('TIPO_OPERACION',
                                                     l_tipo_operacion) || '_' ||
                         l_dominio_operacion || CASE l_tipo_implementacion
                           WHEN 'K' THEN
                            '.'
                           ELSE
                            '_'
                         END || l_nombre_operacion;
  
    IF nvl(i_version, l_version_actual) <> l_version_actual THEN
      l_nombre_programa := l_nombre_programa || '_' ||
                           REPLACE(i_version, '.', '_');
    END IF;
  
    RETURN l_nombre_programa;
  END;

  FUNCTION f_filtros_sql(i_parametros      IN y_parametros,
                         i_nombres_excluir IN y_cadenas DEFAULT NULL)
    RETURN CLOB IS
    l_filtros_sql     CLOB;
    i                 INTEGER;
    l_typeinfo        anytype;
    l_typecode        PLS_INTEGER;
    l_seen_one        BOOLEAN := FALSE;
    l_existe          VARCHAR2(1);
    l_nombres_excluir y_cadenas;
  BEGIN
    IF i_parametros IS NOT NULL THEN
    
      IF i_nombres_excluir IS NOT NULL THEN
        l_nombres_excluir := i_nombres_excluir;
      ELSE
        l_nombres_excluir := NEW y_cadenas();
      END IF;
    
      -- Carga la lista de nombres a excluir
      SELECT x.nombre
        BULK COLLECT
        INTO l_nombres_excluir
        FROM (SELECT lower(p.nombre) nombre
                FROM t_operacion_parametros p
               WHERE p.id_operacion = c_id_ope_par_automaticos
              UNION
              SELECT lower(column_value)
                FROM TABLE(l_nombres_excluir)) x;
    
      i := i_parametros.first;
      WHILE i IS NOT NULL LOOP
      
        -- Busca si existe en la lista de nombres a excluir
        BEGIN
          SELECT 'S'
            INTO l_existe
            FROM TABLE(l_nombres_excluir)
           WHERE lower(column_value) = lower(i_parametros(i).nombre);
        EXCEPTION
          WHEN no_data_found THEN
            l_existe := 'N';
          WHEN too_many_rows THEN
            l_existe := 'S';
        END;
      
        -- Sólo si no existe en la lista de nombres a excluir
        IF l_existe = 'N' THEN
          IF i_parametros(i).valor IS NOT NULL THEN
            l_typecode := i_parametros(i).valor.gettype(l_typeinfo);
          
            IF l_typecode = dbms_types.typecode_varchar2 THEN
              IF anydata.accessvarchar2(i_parametros(i).valor) IS NOT NULL THEN
                l_filtros_sql := l_filtros_sql || CASE l_seen_one
                                   WHEN TRUE THEN
                                    ' AND '
                                   ELSE
                                    ' WHERE '
                                 END || i_parametros(i).nombre || ' = ' ||
                                 dbms_assert.enquote_literal('''' ||
                                                             REPLACE(anydata.accessvarchar2(i_parametros(i)
                                                                                            .valor),
                                                                     '''',
                                                                     '''''') || '''');
                l_seen_one    := TRUE;
              END IF;
            ELSIF l_typecode = dbms_types.typecode_number THEN
              IF anydata.accessnumber(i_parametros(i).valor) IS NOT NULL THEN
                l_filtros_sql := l_filtros_sql || CASE l_seen_one
                                   WHEN TRUE THEN
                                    ' AND '
                                   ELSE
                                    ' WHERE '
                                 END || 'to_char(' || i_parametros(i)
                                .nombre ||
                                 ', ''TM'', ''NLS_NUMERIC_CHARACTERS = ''''.,'''''') = ' ||
                                 dbms_assert.enquote_literal('''' ||
                                                             to_char(anydata.accessnumber(i_parametros(i)
                                                                                          .valor),
                                                                     'TM',
                                                                     'NLS_NUMERIC_CHARACTERS = ''.,''') || '''');
                l_seen_one    := TRUE;
              END IF;
            ELSIF l_typecode = dbms_types.typecode_date THEN
              IF anydata.accessdate(i_parametros(i).valor) IS NOT NULL THEN
                l_filtros_sql := l_filtros_sql || CASE l_seen_one
                                   WHEN TRUE THEN
                                    ' AND '
                                   ELSE
                                    ' WHERE '
                                 END || 'to_char(' || i_parametros(i)
                                .nombre || ', ''YYYY-MM-DD'') = ' ||
                                 dbms_assert.enquote_literal('''' ||
                                                             to_char(anydata.accessdate(i_parametros(i)
                                                                                        .valor),
                                                                     'YYYY-MM-DD') || '''');
                l_seen_one    := TRUE;
              END IF;
            ELSE
              raise_application_error(-20000,
                                      k_error.f_mensaje_error('ora0002',
                                                              'filtro',
                                                              i_parametros(i)
                                                              .nombre));
            END IF;
          END IF;
        END IF;
      
        i := i_parametros.next(i);
      END LOOP;
    END IF;
  
    RETURN l_filtros_sql;
  EXCEPTION
    WHEN value_error THEN
      raise_application_error(-20000, k_error.f_mensaje_error('ora0001'));
  END;

  FUNCTION f_valor_parametro(i_parametros IN y_parametros,
                             i_nombre     IN VARCHAR2) RETURN anydata IS
    l_valor anydata;
    i       INTEGER;
  BEGIN
    IF i_parametros IS NOT NULL THEN
      -- Busca el parámetro en la lista
      i := i_parametros.first;
      WHILE i IS NOT NULL AND l_valor IS NULL LOOP
        IF lower(i_parametros(i).nombre) = lower(i_nombre) THEN
          l_valor := i_parametros(i).valor;
        END IF;
        i := i_parametros.next(i);
      END LOOP;
    END IF;
  
    -- Si el parámetro no se encuentra en la lista carga un valor nulo de tipo
    -- VARCHAR2 para evitar el error ORA-30625 al acceder al valor a través de
    -- AnyData.Access*
    IF l_valor IS NULL THEN
      l_valor := anydata.convertvarchar2(NULL);
    END IF;
  
    RETURN l_valor;
  END;

  FUNCTION f_valor_parametro_string(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN anydata.accessvarchar2(f_valor_parametro(i_parametros, i_nombre));
  END;

  FUNCTION f_valor_parametro_number(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN NUMBER IS
  BEGIN
    RETURN anydata.accessnumber(f_valor_parametro(i_parametros, i_nombre));
  END;

  FUNCTION f_valor_parametro_boolean(i_parametros IN y_parametros,
                                     i_nombre     IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN sys.diutil.int_to_bool(anydata.accessnumber(f_valor_parametro(i_parametros,
                                                                         i_nombre)));
  END;

  FUNCTION f_valor_parametro_date(i_parametros IN y_parametros,
                                  i_nombre     IN VARCHAR2) RETURN DATE IS
  BEGIN
    RETURN anydata.accessdate(f_valor_parametro(i_parametros, i_nombre));
  END;

  FUNCTION f_valor_parametro_object(i_parametros IN y_parametros,
                                    i_nombre     IN VARCHAR2) RETURN y_objeto IS
    l_objeto   y_objeto;
    l_anydata  anydata;
    l_result   PLS_INTEGER;
    l_typeinfo anytype;
    l_typecode PLS_INTEGER;
  BEGIN
    l_anydata := f_valor_parametro(i_parametros, i_nombre);
  
    l_typecode := l_anydata.gettype(l_typeinfo);
    IF l_typecode = dbms_types.typecode_object THEN
      l_result := l_anydata.getobject(l_objeto);
    END IF;
  
    RETURN l_objeto;
  END;

  FUNCTION f_inserts_operacion(i_operacion IN t_operaciones%ROWTYPE)
    RETURN CLOB IS
    l_inserts CLOB;
    l_insert  CLOB;
  
    PROCEDURE lp_comentar(i_comentario IN VARCHAR2) IS
    BEGIN
      l_inserts := l_inserts || '/* ' || lpad('=', 20, '=') || ' ' ||
                   upper(i_comentario) || ' ' || lpad('=', 20, '=') ||
                   ' */' || utl_tcp.crlf;
    END;
  BEGIN
    lp_comentar('T_OPERACIONES');
    l_insert  := fn_gen_inserts('SELECT * FROM t_operaciones WHERE id_operacion = ' ||
                                to_char(i_operacion.id_operacion),
                                't_operaciones');
    l_inserts := l_inserts || l_insert;
    --
    lp_comentar('T_OPERACION_PARAMETROS');
    l_insert  := fn_gen_inserts('SELECT * FROM t_operacion_parametros WHERE id_operacion = ' ||
                                to_char(i_operacion.id_operacion) ||
                                ' ORDER BY version, orden',
                                't_operacion_parametros');
    l_inserts := l_inserts || l_insert;
    --
    lp_comentar('T_SERVICIOS');
    l_insert  := fn_gen_inserts('SELECT id_servicio, tipo, consulta_sql FROM t_servicios WHERE id_servicio = ' ||
                                to_char(i_operacion.id_operacion),
                                't_servicios');
    l_inserts := l_inserts || l_insert;
    --
    lp_comentar('T_REPORTES');
    l_insert  := fn_gen_inserts('SELECT id_reporte, tipo, consulta_sql FROM t_reportes WHERE id_reporte = ' ||
                                to_char(i_operacion.id_operacion),
                                't_reportes');
    l_inserts := l_inserts || l_insert;
    --
    lp_comentar('T_TRABAJOS');
    l_insert  := fn_gen_inserts('SELECT id_trabajo, tipo, accion, fecha_inicio, tiempo_inicio, intervalo_repeticion, fecha_fin, comentarios FROM t_trabajos WHERE id_trabajo = ' ||
                                to_char(i_operacion.id_operacion),
                                't_trabajos');
    l_inserts := l_inserts || l_insert;
    --
    lp_comentar('T_ROL_PERMISOS');
    l_insert  := fn_gen_inserts('SELECT * FROM t_rol_permisos WHERE id_permiso = k_operacion.f_id_permiso(' ||
                                to_char(i_operacion.id_operacion) ||
                                ') ORDER BY id_rol',
                                't_rol_permisos');
    l_inserts := l_inserts || l_insert;
    --
    IF i_operacion.tipo_implementacion = c_tipo_implementacion_funcion THEN
      lp_comentar('FUNCTION');
      l_insert  := dbms_metadata.get_ddl('FUNCTION',
                                         upper(f_nombre_programa(i_operacion.id_operacion)));
      l_insert  := TRIM(utl_tcp.crlf FROM l_insert);
      l_insert  := TRIM(' ' FROM l_insert);
      l_insert  := l_insert || utl_tcp.crlf || '/';
      l_inserts := l_inserts || l_insert;
    END IF;
  
    RETURN l_inserts;
  END;

  FUNCTION f_inserts_operacion(i_id_operacion IN NUMBER) RETURN CLOB IS
  BEGIN
    RETURN f_inserts_operacion(f_operacion(i_id_operacion));
  END;

  FUNCTION f_inserts_operacion(i_tipo    IN VARCHAR2,
                               i_nombre  IN VARCHAR2,
                               i_dominio IN VARCHAR2) RETURN CLOB IS
  BEGIN
    RETURN f_inserts_operacion(f_id_operacion(i_tipo, i_nombre, i_dominio));
  END;

  FUNCTION f_deletes_operacion(i_operacion IN t_operaciones%ROWTYPE)
    RETURN CLOB IS
    l_deletes CLOB;
  
    PROCEDURE lp_comentar(i_comentario IN VARCHAR2) IS
    BEGIN
      l_deletes := l_deletes || '/* ' || lpad('=', 20, '=') || ' ' ||
                   upper(i_comentario) || ' ' || lpad('=', 20, '=') ||
                   ' */' || utl_tcp.crlf;
    END;
  BEGIN
    lp_comentar('ID_OPERACION = ' || to_char(i_operacion.id_operacion));
    --
    l_deletes := l_deletes ||
                 'DELETE t_rol_permisos WHERE id_permiso = k_operacion.f_id_permiso(' ||
                 to_char(i_operacion.id_operacion) || ');' || utl_tcp.crlf;
    l_deletes := l_deletes || 'DELETE t_trabajos WHERE id_trabajo = ' ||
                 to_char(i_operacion.id_operacion) || ';' || utl_tcp.crlf;
    l_deletes := l_deletes || 'DELETE t_reportes WHERE id_reporte = ' ||
                 to_char(i_operacion.id_operacion) || ';' || utl_tcp.crlf;
    l_deletes := l_deletes || 'DELETE t_servicios WHERE id_servicio = ' ||
                 to_char(i_operacion.id_operacion) || ';' || utl_tcp.crlf;
    l_deletes := l_deletes ||
                 'DELETE t_operacion_parametros WHERE id_operacion = ' ||
                 to_char(i_operacion.id_operacion) || ';' || utl_tcp.crlf;
    l_deletes := l_deletes || 'DELETE t_operaciones WHERE id_operacion = ' ||
                 to_char(i_operacion.id_operacion) || ';' || utl_tcp.crlf;
    --
    IF i_operacion.tipo_implementacion = c_tipo_implementacion_funcion THEN
      l_deletes := l_deletes || 'DROP FUNCTION ' ||
                   lower(f_nombre_programa(i_operacion.id_operacion)) || ';' ||
                   utl_tcp.crlf;
    END IF;
  
    RETURN l_deletes;
  END;

  FUNCTION f_deletes_operacion(i_id_operacion IN NUMBER) RETURN CLOB IS
  BEGIN
    RETURN f_deletes_operacion(f_operacion(i_id_operacion));
  END;

  FUNCTION f_deletes_operacion(i_tipo    IN VARCHAR2,
                               i_nombre  IN VARCHAR2,
                               i_dominio IN VARCHAR2) RETURN CLOB IS
  BEGIN
    RETURN f_deletes_operacion(f_id_operacion(i_tipo, i_nombre, i_dominio));
  END;

  FUNCTION f_scripts_operaciones(i_id_modulo IN VARCHAR2 DEFAULT NULL)
    RETURN BLOB IS
    l_zip       BLOB;
    l_inserts   CLOB;
    l_deletes   CLOB;
    l_install   CLOB;
    l_uninstall CLOB;
  
    CURSOR c_modulos IS
      SELECT m.id_modulo
        FROM t_modulos m
       WHERE m.id_modulo = nvl(i_id_modulo, m.id_modulo);
  
    CURSOR c_operaciones(i_id_modulo IN VARCHAR2) IS
      SELECT a.id_operacion,
             lower(f_id_modulo(a.id_operacion)) id_modulo,
             lower(k_util.f_reemplazar_acentos(k_util.f_significado_codigo('TIPO_OPERACION',
                                                                           a.tipo) || '/' ||
                                               nvl(a.dominio, '_') || '/' ||
                                               a.nombre)) || '.sql' nombre_archivo
        FROM t_operaciones a
       WHERE f_id_modulo(a.id_operacion) = i_id_modulo
       ORDER BY 3;
  BEGIN
    FOR m IN c_modulos LOOP
      l_install := '';
      l_install := l_install || 'prompt' || utl_tcp.crlf;
      l_install := l_install || 'prompt Instalando operaciones...' ||
                   utl_tcp.crlf;
      l_install := l_install ||
                   'prompt -----------------------------------' ||
                   utl_tcp.crlf;
      l_install := l_install || 'prompt' || utl_tcp.crlf;
      --
      l_uninstall := '';
      l_uninstall := l_uninstall || 'prompt' || utl_tcp.crlf;
      l_uninstall := l_uninstall || 'prompt Desinstalando operaciones...' ||
                     utl_tcp.crlf;
      l_uninstall := l_uninstall ||
                     'prompt -----------------------------------' ||
                     utl_tcp.crlf;
      l_uninstall := l_uninstall || 'prompt' || utl_tcp.crlf;
    
      FOR ope IN c_operaciones(m.id_modulo) LOOP
        l_inserts := f_inserts_operacion(ope.id_operacion);
        l_deletes := f_deletes_operacion(ope.id_operacion);
        --
        l_install   := l_install || '@@scripts/operations/' ||
                       ope.nombre_archivo || utl_tcp.crlf;
        l_uninstall := l_uninstall || l_deletes || utl_tcp.crlf;
        --
        as_zip.add1file(l_zip,
                        ope.id_modulo || '/' || ope.nombre_archivo,
                        k_util.clob_to_blob(l_inserts));
      END LOOP;
    
      as_zip.add1file(l_zip,
                      lower(m.id_modulo) || '/' || 'install.sql',
                      k_util.clob_to_blob(l_install));
      as_zip.add1file(l_zip,
                      lower(m.id_modulo) || '/' || 'uninstall.sql',
                      k_util.clob_to_blob(l_uninstall));
    END LOOP;
  
    IF l_zip IS NOT NULL AND dbms_lob.getlength(l_zip) > 0 THEN
      as_zip.finish_zip(l_zip);
    END IF;
  
    RETURN l_zip;
  END;

END;
/
