CREATE OR REPLACE PACKAGE k_trabajo IS

  /**
  Agrupa operaciones relacionadas con los Trabajos del sistema
  
  %author dmezac 4/9/2020 07:30:15
  */

  /*
  --------------------------------- MIT License ---------------------------------
  Copyright (c) 2020 dmezac
  
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

  -- Códigos de respuesta
  c_ok                      CONSTANT VARCHAR2(10) := '0';
  c_trabajo_no_implementado CONSTANT VARCHAR2(10) := 'tra0001';
  c_error_parametro         CONSTANT VARCHAR2(10) := 'tra0002';
  c_error_general           CONSTANT VARCHAR2(10) := 'tra0099';
  c_error_inesperado        CONSTANT VARCHAR2(10) := 'tra9999';

  -- Excepciones
  ex_trabajo_no_implementado EXCEPTION;
  ex_trabajo_ya_existe       EXCEPTION;
  ex_trabajo_no_existe       EXCEPTION;
  ex_error_parametro         EXCEPTION;
  ex_error_general           EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_trabajo_no_existe, -27475);
  PRAGMA EXCEPTION_INIT(ex_trabajo_no_existe, -27476);
  PRAGMA EXCEPTION_INIT(ex_trabajo_ya_existe, -27477);

  -- Crea un trabajo en el sistema
  -- Para crear un trabajo el usuario debe tener permiso de CREATE JOB
  -- GRANT CREATE JOB TO &user;
  -- %param
  PROCEDURE p_crear_trabajo(i_id_trabajo           IN NUMBER,
                            i_parametros           IN CLOB DEFAULT NULL,
                            i_fecha_inicio         IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
                            i_intervalo_repeticion IN VARCHAR2 DEFAULT NULL,
                            i_fecha_fin            IN TIMESTAMP WITH TIME ZONE DEFAULT NULL);

  -- Edita un trabajo en el sistema
  -- Edición de la acción del trabajo no implementada
  -- %param
  PROCEDURE p_editar_trabajo(i_id_trabajo           IN NUMBER,
                             i_parametros           IN CLOB DEFAULT NULL,
                             i_fecha_inicio         IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
                             i_intervalo_repeticion IN VARCHAR2 DEFAULT NULL,
                             i_fecha_fin            IN TIMESTAMP WITH TIME ZONE DEFAULT NULL);

  -- Crea o edita un trabajo en el sistema
  -- Edición de la acción del trabajo no implementada
  -- %param
  PROCEDURE p_crear_o_editar_trabajo(i_id_trabajo           IN NUMBER,
                                     i_parametros           IN CLOB DEFAULT NULL,
                                     i_fecha_inicio         IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
                                     i_intervalo_repeticion IN VARCHAR2 DEFAULT NULL,
                                     i_fecha_fin            IN TIMESTAMP WITH TIME ZONE DEFAULT NULL);

  -- Elimina un trabajo en el sistema
  -- %param
  PROCEDURE p_eliminar_trabajo(i_id_trabajo IN NUMBER,
                               i_parametros IN CLOB DEFAULT NULL);

END;
/
CREATE OR REPLACE PACKAGE BODY k_trabajo IS

  -- Crea un trabajo en el sistema
  PROCEDURE p_crear_trabajo(i_id_trabajo           IN NUMBER,
                            i_parametros           IN CLOB DEFAULT NULL,
                            i_fecha_inicio         IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
                            i_intervalo_repeticion IN VARCHAR2 DEFAULT NULL,
                            i_fecha_fin            IN TIMESTAMP WITH TIME ZONE DEFAULT NULL) IS
    l_prms y_parametros;
    --
    l_tipo_trabajo         t_trabajos.tipo%TYPE;
    l_nombre_trabajo       t_operaciones.nombre%TYPE;
    l_dominio_trabajo      t_operaciones.dominio%TYPE;
    l_accion_trabajo       t_trabajos.accion%TYPE;
    l_fecha_inicio         t_trabajos.fecha_inicio%TYPE;
    l_intervalo_repeticion t_trabajos.intervalo_repeticion%TYPE;
    l_fecha_fin            t_trabajos.fecha_fin%TYPE;
    l_comentarios          t_trabajos.comentarios%TYPE;
  BEGIN
    -- Buscar datos del trabajo
    BEGIN
      SELECT t.tipo,
             upper(o.nombre),
             upper(o.dominio),
             t.accion,
             nvl(i_fecha_inicio, nvl(t.fecha_inicio, current_timestamp)) +
             (nvl(t.tiempo_inicio, 0) / 86400),
             nvl(i_intervalo_repeticion, t.intervalo_repeticion),
             nvl(i_fecha_fin, t.fecha_fin),
             t.comentarios
        INTO l_tipo_trabajo,
             l_nombre_trabajo,
             l_dominio_trabajo,
             l_accion_trabajo,
             l_fecha_inicio,
             l_intervalo_repeticion,
             l_fecha_fin,
             l_comentarios
        FROM t_trabajos t, t_operaciones o
       WHERE o.id_operacion = t.id_trabajo
         AND o.activo = 'S'
         AND t.id_trabajo = i_id_trabajo;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE ex_trabajo_no_implementado;
    END;
  
    -- Obtener parámetros del trabajo
    BEGIN
      l_prms := k_operacion.f_procesar_parametros(i_id_trabajo,
                                                  i_parametros);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE ex_error_parametro;
    END;
  
    -- Procesar parámetros del trabajo
    DECLARE
      i PLS_INTEGER;
    BEGIN
      i := l_prms.first;
      WHILE i IS NOT NULL LOOP
        l_nombre_trabajo := REPLACE(l_nombre_trabajo,
                                    '{' || upper(l_prms(i).nombre) || '}',
                                    k_operacion.f_valor_parametro_string(l_prms,
                                                                         l_prms(i).nombre));
        l_accion_trabajo := REPLACE(l_accion_trabajo,
                                    '&' || upper(l_prms(i).nombre),
                                    k_operacion.f_valor_parametro_string(l_prms,
                                                                         l_prms(i).nombre));
        i                := l_prms.next(i);
      END LOOP;
    END;
  
    -- Registrar el trabajo
    BEGIN
      --dbms_output.put_line(l_nombre_trabajo);
      --dbms_output.put_line(l_accion_trabajo);
      dbms_scheduler.create_job(job_name        => l_nombre_trabajo,
                                job_type        => l_tipo_trabajo,
                                job_action      => l_accion_trabajo,
                                start_date      => l_fecha_inicio,
                                repeat_interval => l_intervalo_repeticion,
                                end_date        => l_fecha_fin,
                                enabled         => TRUE,
                                comments        => l_comentarios);
    END;
  END;

  -- Edita un trabajo en el sistema
  PROCEDURE p_editar_trabajo(i_id_trabajo           IN NUMBER,
                             i_parametros           IN CLOB DEFAULT NULL,
                             i_fecha_inicio         IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
                             i_intervalo_repeticion IN VARCHAR2 DEFAULT NULL,
                             i_fecha_fin            IN TIMESTAMP WITH TIME ZONE DEFAULT NULL) IS
    l_prms y_parametros;
    --
    l_tipo_trabajo         t_trabajos.tipo%TYPE;
    l_nombre_trabajo       t_operaciones.nombre%TYPE;
    l_dominio_trabajo      t_operaciones.dominio%TYPE;
    l_accion_trabajo       t_trabajos.accion%TYPE;
    l_fecha_inicio         t_trabajos.fecha_inicio%TYPE;
    l_intervalo_repeticion t_trabajos.intervalo_repeticion%TYPE;
    l_fecha_fin            t_trabajos.fecha_fin%TYPE;
    l_comentarios          t_trabajos.comentarios%TYPE;
  BEGIN
    -- Buscar datos del trabajo
    BEGIN
      SELECT t.tipo,
             upper(o.nombre),
             upper(o.dominio),
             t.accion,
             i_fecha_inicio + (nvl(t.tiempo_inicio, 0) / 86400),
             i_intervalo_repeticion,
             i_fecha_fin,
             t.comentarios
        INTO l_tipo_trabajo,
             l_nombre_trabajo,
             l_dominio_trabajo,
             l_accion_trabajo,
             l_fecha_inicio,
             l_intervalo_repeticion,
             l_fecha_fin,
             l_comentarios
        FROM t_trabajos t, t_operaciones o
       WHERE o.id_operacion = t.id_trabajo
         AND o.activo = 'S'
         AND t.id_trabajo = i_id_trabajo;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE ex_trabajo_no_implementado;
    END;
  
    IF i_parametros IS NOT NULL THEN
      -- Obtener parámetros del trabajo
      BEGIN
        l_prms := k_operacion.f_procesar_parametros(i_id_trabajo,
                                                    i_parametros);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE ex_error_parametro;
      END;
    
      -- Procesar parámetros del trabajo
      DECLARE
        i PLS_INTEGER;
      BEGIN
        i := l_prms.first;
        WHILE i IS NOT NULL LOOP
          l_nombre_trabajo := REPLACE(l_nombre_trabajo,
                                      '{' || upper(l_prms(i).nombre) || '}',
                                      k_operacion.f_valor_parametro_string(l_prms,
                                                                           l_prms(i).nombre));
          i                := l_prms.next(i);
        END LOOP;
      END;
    END IF;
  
    -- Verificar si el trabajo existe
    BEGIN
      dbms_scheduler.get_attribute(NAME      => l_nombre_trabajo,
                                   attribute => 'job_type',
                                   VALUE     => l_tipo_trabajo);
    END;
  
    -- Editar fecha de inicio del trabajo
    IF i_fecha_inicio IS NOT NULL THEN
      dbms_scheduler.set_attribute(NAME      => l_nombre_trabajo,
                                   attribute => 'start_date',
                                   VALUE     => l_fecha_inicio);
    END IF;
  
    -- Editar intérvalo de repetición del trabajo
    IF i_intervalo_repeticion IS NOT NULL THEN
      dbms_scheduler.set_attribute(NAME      => l_nombre_trabajo,
                                   attribute => 'repeat_interval',
                                   VALUE     => l_intervalo_repeticion);
    END IF;
  
    -- Editar fecha de fin del trabajo
    IF i_fecha_fin IS NOT NULL THEN
      dbms_scheduler.set_attribute(NAME      => l_nombre_trabajo,
                                   attribute => 'end_date',
                                   VALUE     => l_fecha_fin);
    END IF;
  END;

  -- Crea o edita un trabajo en el sistema
  PROCEDURE p_crear_o_editar_trabajo(i_id_trabajo           IN NUMBER,
                                     i_parametros           IN CLOB DEFAULT NULL,
                                     i_fecha_inicio         IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
                                     i_intervalo_repeticion IN VARCHAR2 DEFAULT NULL,
                                     i_fecha_fin            IN TIMESTAMP WITH TIME ZONE DEFAULT NULL) IS
  BEGIN
    BEGIN
      p_editar_trabajo(i_id_trabajo           => i_id_trabajo,
                       i_parametros           => i_parametros,
                       i_fecha_inicio         => i_fecha_inicio,
                       i_intervalo_repeticion => i_intervalo_repeticion,
                       i_fecha_fin            => i_fecha_fin);
    EXCEPTION
      WHEN ex_trabajo_no_existe THEN
        -- Crea el trabajo si no existe
        p_crear_trabajo(i_id_trabajo           => i_id_trabajo,
                        i_parametros           => i_parametros,
                        i_fecha_inicio         => i_fecha_inicio,
                        i_intervalo_repeticion => i_intervalo_repeticion,
                        i_fecha_fin            => i_fecha_fin);
    END;
  END;

  -- Elimina un trabajo en el sistema
  PROCEDURE p_eliminar_trabajo(i_id_trabajo IN NUMBER,
                               i_parametros IN CLOB DEFAULT NULL) IS
    l_prms y_parametros;
    --
    l_tipo_trabajo    t_trabajos.tipo%TYPE;
    l_nombre_trabajo  t_operaciones.nombre%TYPE;
    l_dominio_trabajo t_operaciones.dominio%TYPE;
  BEGIN
    -- Buscar datos del trabajo
    BEGIN
      SELECT t.tipo, upper(o.nombre), upper(o.dominio)
        INTO l_tipo_trabajo, l_nombre_trabajo, l_dominio_trabajo
        FROM t_trabajos t, t_operaciones o
       WHERE o.id_operacion = t.id_trabajo
         AND o.activo = 'S'
         AND t.id_trabajo = i_id_trabajo;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE ex_trabajo_no_implementado;
    END;
  
    IF i_parametros IS NOT NULL THEN
      -- Obtener parámetros del trabajo
      BEGIN
        l_prms := k_operacion.f_procesar_parametros(i_id_trabajo,
                                                    i_parametros);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE ex_error_parametro;
      END;
    
      -- Procesar parámetros del trabajo
      DECLARE
        i PLS_INTEGER;
      BEGIN
        i := l_prms.first;
        WHILE i IS NOT NULL LOOP
          l_nombre_trabajo := REPLACE(l_nombre_trabajo,
                                      '{' || upper(l_prms(i).nombre) || '}',
                                      k_operacion.f_valor_parametro_string(l_prms,
                                                                           l_prms(i).nombre));
          i                := l_prms.next(i);
        END LOOP;
      END;
    END IF;
  
    -- Elimina el trabajo
    dbms_scheduler.drop_job(l_nombre_trabajo);
  
  END;

END;
/
