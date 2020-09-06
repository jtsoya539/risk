CREATE OR REPLACE PACKAGE k_planificador IS

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

  FUNCTION f_procesar_parametros(i_id_trabajo IN NUMBER,
                                 i_parametros IN CLOB) RETURN y_parametros;

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
CREATE OR REPLACE PACKAGE BODY k_planificador IS

  FUNCTION f_procesar_parametros(i_id_trabajo IN NUMBER,
                                 i_parametros IN CLOB) RETURN y_parametros IS
    l_parametros   y_parametros;
    l_parametro    y_parametro;
    l_json_object  json_object_t;
    l_json_element json_element_t;
  
    CURSOR cr_trabajo_parametros IS
      SELECT id_trabajo,
             lower(nombre) nombre,
             direccion,
             tipo_dato,
             formato,
             obligatorio,
             valor_defecto,
             etiqueta,
             longitud_maxima
        FROM t_trabajo_parametros
       WHERE activo = 'S'
         AND id_trabajo = i_id_trabajo
       ORDER BY orden;
  BEGIN
    -- Inicializa respuesta
    l_parametros := NEW y_parametros();
  
    IF i_parametros IS NULL OR dbms_lob.getlength(i_parametros) = 0 THEN
      l_json_object := json_object_t.parse('{}');
    ELSE
      l_json_object := json_object_t.parse(i_parametros);
    END IF;
  
    FOR par IN cr_trabajo_parametros LOOP
      l_parametro        := NEW y_parametro();
      l_parametro.nombre := upper(par.nombre);
    
      l_json_element := l_json_object.get(par.nombre);
    
      IF par.obligatorio = 'S' THEN
        IF NOT l_json_object.has(par.nombre) THEN
          raise_application_error(-20000,
                                  'Parámetro ' ||
                                  nvl(par.etiqueta, par.nombre) ||
                                  ' obligatorio');
        ELSE
          IF l_json_element.is_null THEN
            raise_application_error(-20000,
                                    'Parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' debe tener valor');
          END IF;
        END IF;
      END IF;
    
      CASE par.tipo_dato
      
        WHEN 'S' THEN
          -- String
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_string THEN
            raise_application_error(-20000,
                                    'Parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' de tipo incorrecto');
          END IF;
        
          l_parametro.valor := anydata.convertvarchar2(l_json_object.get_string(par.nombre));
          IF l_parametro.valor.accessvarchar2 IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertvarchar2(par.valor_defecto);
          END IF;
          IF l_parametro.valor.accessvarchar2 IS NULL AND
             par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    'Parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' debe tener valor');
          END IF;
          IF par.longitud_maxima IS NOT NULL AND
             nvl(length(l_parametro.valor.accessvarchar2), 0) >
             par.longitud_maxima THEN
            raise_application_error(-20000,
                                    'Longitud del parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' no debe ser superior a ' ||
                                    to_char(par.longitud_maxima));
          END IF;
        
        WHEN 'N' THEN
          -- Number
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_number THEN
            raise_application_error(-20000,
                                    'Parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' de tipo incorrecto');
          END IF;
        
          l_parametro.valor := anydata.convertnumber(l_json_object.get_number(par.nombre));
          IF l_parametro.valor.accessnumber IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertnumber(to_number(par.valor_defecto));
          END IF;
          IF l_parametro.valor.accessnumber IS NULL AND
             par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    'Parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' debe tener valor');
          END IF;
          IF par.longitud_maxima IS NOT NULL AND
             nvl(length(to_char(abs(trunc(l_parametro.valor.accessnumber)))),
                 0) > par.longitud_maxima THEN
            raise_application_error(-20000,
                                    'Longitud del parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' no debe ser superior a ' ||
                                    to_char(par.longitud_maxima));
          END IF;
        
        WHEN 'B' THEN
          -- Boolean
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_boolean THEN
            raise_application_error(-20000,
                                    'Parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' de tipo incorrecto');
          END IF;
        
          l_parametro.valor := anydata.convertnumber(sys.diutil.bool_to_int(l_json_object.get_boolean(par.nombre)));
          IF l_parametro.valor.accessnumber IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertnumber(to_number(par.valor_defecto));
          END IF;
          IF l_parametro.valor.accessnumber IS NULL AND
             par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    'Parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' debe tener valor');
          END IF;
        
        WHEN 'D' THEN
          -- Date
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_date THEN
            raise_application_error(-20000,
                                    'Parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' de tipo incorrecto');
          END IF;
        
          l_parametro.valor := anydata.convertdate(l_json_object.get_date(par.nombre));
          IF l_parametro.valor.accessdate IS NULL AND
             par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := anydata.convertdate(to_date(par.valor_defecto,
                                                             par.formato));
          END IF;
          IF l_parametro.valor.accessdate IS NULL AND par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    'Parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' debe tener valor');
          END IF;
        
        WHEN 'O' THEN
          -- Object
          IF l_json_element IS NOT NULL AND NOT l_json_element.is_null AND
             NOT l_json_element.is_object THEN
            raise_application_error(-20000,
                                    'Parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' de tipo incorrecto');
          END IF;
        
          IF l_json_element IS NOT NULL THEN
            l_parametro.valor := k_util.json_to_objeto(l_json_element.to_clob,
                                                       par.formato);
          END IF;
        
          IF l_parametro.valor IS NULL AND par.valor_defecto IS NOT NULL THEN
            l_parametro.valor := k_util.json_to_objeto(par.valor_defecto,
                                                       par.formato);
          END IF;
          IF l_parametro.valor IS NULL AND par.obligatorio = 'S' THEN
            raise_application_error(-20000,
                                    'Parámetro ' ||
                                    nvl(par.etiqueta, par.nombre) ||
                                    ' debe tener valor');
          END IF;
        
        ELSE
          raise_application_error(-20000,
                                  'Tipo de dato de parámetro ' ||
                                  nvl(par.etiqueta, par.nombre) ||
                                  ' no soportado');
        
      END CASE;
    
      l_parametros.extend;
      l_parametros(l_parametros.count) := l_parametro;
    END LOOP;
    RETURN l_parametros;
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

  -- Crea un trabajo en el sistema
  PROCEDURE p_crear_trabajo(i_id_trabajo           IN NUMBER,
                            i_parametros           IN CLOB DEFAULT NULL,
                            i_fecha_inicio         IN TIMESTAMP WITH TIME ZONE DEFAULT NULL,
                            i_intervalo_repeticion IN VARCHAR2 DEFAULT NULL,
                            i_fecha_fin            IN TIMESTAMP WITH TIME ZONE DEFAULT NULL) IS
    l_prms y_parametros;
    --
    l_tipo_trabajo         t_trabajos.tipo%TYPE;
    l_nombre_trabajo       t_trabajos.nombre%TYPE;
    l_dominio_trabajo      t_trabajos.dominio%TYPE;
    l_accion_trabajo       t_trabajos.accion%TYPE;
    l_fecha_inicio         t_trabajos.fecha_inicio%TYPE;
    l_intervalo_repeticion t_trabajos.intervalo_repeticion%TYPE;
    l_fecha_fin            t_trabajos.fecha_fin%TYPE;
    l_comentarios          t_trabajos.comentarios%TYPE;
  BEGIN
    -- Buscar datos del trabajo
    BEGIN
      SELECT tipo,
             upper(nombre),
             upper(dominio),
             accion,
             nvl(i_fecha_inicio, nvl(fecha_inicio, current_timestamp)) +
             (tiempo_inicio / 86400),
             nvl(i_intervalo_repeticion, intervalo_repeticion),
             nvl(i_fecha_fin, fecha_fin),
             comentarios
        INTO l_tipo_trabajo,
             l_nombre_trabajo,
             l_dominio_trabajo,
             l_accion_trabajo,
             l_fecha_inicio,
             l_intervalo_repeticion,
             l_fecha_fin,
             l_comentarios
        FROM t_trabajos
       WHERE activo = 'S'
         AND id_trabajo = i_id_trabajo;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE ex_trabajo_no_implementado;
    END;
  
    -- Obtener parámetros del trabajo
    BEGIN
      l_prms := f_procesar_parametros(i_id_trabajo, i_parametros);
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
                                    '{' || l_prms(i).nombre || '}',
                                    f_valor_parametro_string(l_prms,
                                                             l_prms(i).nombre));
        l_accion_trabajo := REPLACE(l_accion_trabajo,
                                    '&' || l_prms(i).nombre,
                                    f_valor_parametro_string(l_prms,
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
    l_nombre_trabajo       t_trabajos.nombre%TYPE;
    l_dominio_trabajo      t_trabajos.dominio%TYPE;
    l_accion_trabajo       t_trabajos.accion%TYPE;
    l_fecha_inicio         t_trabajos.fecha_inicio%TYPE;
    l_intervalo_repeticion t_trabajos.intervalo_repeticion%TYPE;
    l_fecha_fin            t_trabajos.fecha_fin%TYPE;
    l_comentarios          t_trabajos.comentarios%TYPE;
  BEGIN
    -- Buscar datos del trabajo
    BEGIN
      SELECT tipo,
             upper(nombre),
             upper(dominio),
             accion,
             i_fecha_inicio + (tiempo_inicio / 86400),
             i_intervalo_repeticion,
             i_fecha_fin,
             comentarios
        INTO l_tipo_trabajo,
             l_nombre_trabajo,
             l_dominio_trabajo,
             l_accion_trabajo,
             l_fecha_inicio,
             l_intervalo_repeticion,
             l_fecha_fin,
             l_comentarios
        FROM t_trabajos
       WHERE activo = 'S'
         AND id_trabajo = i_id_trabajo;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE ex_trabajo_no_implementado;
    END;
  
    IF i_parametros IS NOT NULL THEN
      -- Obtener parámetros del trabajo
      BEGIN
        l_prms := f_procesar_parametros(i_id_trabajo, i_parametros);
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
                                      '{' || l_prms(i).nombre || '}',
                                      f_valor_parametro_string(l_prms,
                                                               l_prms(i)
                                                               .nombre));
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
    l_nombre_trabajo  t_trabajos.nombre%TYPE;
    l_dominio_trabajo t_trabajos.dominio%TYPE;
  BEGIN
    -- Buscar datos del trabajo
    BEGIN
      SELECT tipo, upper(nombre), upper(dominio)
        INTO l_tipo_trabajo, l_nombre_trabajo, l_dominio_trabajo
        FROM t_trabajos
       WHERE activo = 'S'
         AND id_trabajo = i_id_trabajo;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE ex_trabajo_no_implementado;
    END;
  
    IF i_parametros IS NOT NULL THEN
      -- Obtener parámetros del trabajo
      BEGIN
        l_prms := f_procesar_parametros(i_id_trabajo, i_parametros);
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
                                      '{' || l_prms(i).nombre || '}',
                                      f_valor_parametro_string(l_prms,
                                                               l_prms(i)
                                                               .nombre));
          i                := l_prms.next(i);
        END LOOP;
      END;
    END IF;
  
    -- Elimina el trabajo
    dbms_scheduler.drop_job(l_nombre_trabajo);
  
  END;

END;
/
