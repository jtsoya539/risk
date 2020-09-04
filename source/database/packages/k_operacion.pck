CREATE OR REPLACE PACKAGE k_operacion IS

  /**
  Agrupa operaciones relacionadas con las Operaciones
  
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

  FUNCTION f_procesar_parametros(i_id_servicio IN NUMBER,
                                 i_parametros  IN CLOB) RETURN y_parametros;

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

END;
/
CREATE OR REPLACE PACKAGE BODY k_operacion IS

  FUNCTION f_procesar_parametros(i_id_servicio IN NUMBER,
                                 i_parametros  IN CLOB) RETURN y_parametros IS
    l_parametros   y_parametros;
    l_parametro    y_parametro;
    l_json_object  json_object_t;
    l_json_element json_element_t;
  
    CURSOR cr_servicio_parametros IS
      SELECT id_servicio,
             lower(nombre) nombre,
             direccion,
             tipo_dato,
             formato,
             obligatorio,
             valor_defecto,
             etiqueta,
             longitud_maxima
        FROM t_servicio_parametros
       WHERE activo = 'S'
         AND id_servicio = i_id_servicio
       ORDER BY orden;
  BEGIN
    -- Inicializa respuesta
    l_parametros := NEW y_parametros();
  
    IF i_parametros IS NULL OR dbms_lob.getlength(i_parametros) = 0 THEN
      l_json_object := json_object_t.parse('{}');
    ELSE
      l_json_object := json_object_t.parse(i_parametros);
    END IF;
  
    FOR par IN cr_servicio_parametros LOOP
      l_parametro        := NEW y_parametro();
      l_parametro.nombre := par.nombre;
    
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

END;
/
