CREATE OR REPLACE PACKAGE k_sistema IS

  /**
  Agrupa operaciones relacionadas con parámetros de la sesión
  
  %author jtsoya539 27/3/2020 16:58:36
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

  -- Parámetros
  c_sistema CONSTANT VARCHAR2(50) := 'SISTEMA';
  c_version CONSTANT VARCHAR2(50) := 'VERSION';
  c_fecha   CONSTANT VARCHAR2(50) := 'FECHA';
  c_usuario CONSTANT VARCHAR2(50) := 'USUARIO';
  --
  c_nombre_tipo CONSTANT VARCHAR2(50) := 'NOMBRE_TIPO';
  --
  c_direccion_ip     CONSTANT VARCHAR2(50) := 'DIRECCION_IP';
  c_id_operacion     CONSTANT VARCHAR2(50) := 'ID_OPERACION';
  c_nombre_operacion CONSTANT VARCHAR2(50) := 'NOMBRE_OPERACION';
  c_id_aplicacion    CONSTANT VARCHAR2(50) := 'ID_APLICACION';
  c_id_sesion        CONSTANT VARCHAR2(50) := 'ID_SESION';
  c_id_usuario       CONSTANT VARCHAR2(50) := 'ID_USUARIO';

  /**
  Indica si el ambiente de Base de Datos es de producción
  
  %author jtsoya539 4/2/2021 08:56:25
  %return Indicador de si el ambiente de Base de Datos es de producción
  */
  FUNCTION f_es_produccion RETURN BOOLEAN;

  /**
  Retorna el valor del parámetro FECHA en la sesión
  
  %author jtsoya539 4/2/2021 08:54:38
  %return Valor del parámetro FECHA
  */
  FUNCTION f_fecha RETURN DATE;

  /**
  Retorna el valor del parámetro USUARIO en la sesión
  
  %author jtsoya539 4/2/2021 08:54:38
  %return Valor del parámetro USUARIO
  */
  FUNCTION f_usuario RETURN VARCHAR2;

  /**
  Retorna el valor de un parámetro en la sesión
  
  %author jtsoya539 27/3/2020 16:59:44
  %param i_parametro Nombre del parámetro
  %return Valor del parámetro, si no existe retorna null
  */
  FUNCTION f_valor_parametro(i_parametro IN VARCHAR2) RETURN anydata;

  /**
  Retorna el valor de un parámetro de tipo string en la sesión
  
  %author jtsoya539 4/2/2021 08:36:10
  %param i_parametro Nombre del parámetro
  %return Valor del parámetro de tipo string, si no existe retorna null
  */
  FUNCTION f_valor_parametro_string(i_parametro IN VARCHAR2) RETURN VARCHAR2;

  /**
  Retorna el valor de un parámetro de tipo number en la sesión
  
  %author jtsoya539 4/2/2021 08:36:10
  %param i_parametro Nombre del parámetro
  %return Valor del parámetro de tipo number, si no existe retorna null
  */
  FUNCTION f_valor_parametro_number(i_parametro IN VARCHAR2) RETURN NUMBER;

  /**
  Retorna el valor de un parámetro de tipo boolean en la sesión
  
  %author jtsoya539 4/2/2021 08:36:10
  %param i_parametro Nombre del parámetro
  %return Valor del parámetro de tipo boolean, si no existe retorna null
  */
  FUNCTION f_valor_parametro_boolean(i_parametro IN VARCHAR2) RETURN BOOLEAN;

  /**
  Retorna el valor de un parámetro de tipo date en la sesión
  
  %author jtsoya539 4/2/2021 08:36:10
  %param i_parametro Nombre del parámetro
  %return Valor del parámetro de tipo date, si no existe retorna null
  */
  FUNCTION f_valor_parametro_date(i_parametro IN VARCHAR2) RETURN DATE;

  /**
  Define el valor de un parámetro en la sesión
  
  %author jtsoya539 27/3/2020 17:00:28
  %param i_parametro Nombre del parámetro
  %param i_valor Valor del parámetro
  */
  PROCEDURE p_definir_parametro(i_parametro IN VARCHAR2,
                                i_valor     IN anydata);

  /**
  Define el valor de un parámetro de tipo string en la sesión
  
  %author jtsoya539 4/2/2021 08:42:00
  %param i_parametro Nombre del parámetro de tipo string
  %param i_valor Valor del parámetro de tipo string
  */
  PROCEDURE p_definir_parametro_string(i_parametro IN VARCHAR2,
                                       i_valor     IN VARCHAR2);

  /**
  Define el valor de un parámetro de tipo number en la sesión
  
  %author jtsoya539 4/2/2021 08:42:00
  %param i_parametro Nombre del parámetro de tipo number
  %param i_valor Valor del parámetro de tipo number
  */
  PROCEDURE p_definir_parametro_number(i_parametro IN VARCHAR2,
                                       i_valor     IN NUMBER);

  /**
  Define el valor de un parámetro de tipo boolean en la sesión
  
  %author jtsoya539 4/2/2021 08:42:00
  %param i_parametro Nombre del parámetro de tipo boolean
  %param i_valor Valor del parámetro de tipo boolean
  */
  PROCEDURE p_definir_parametro_boolean(i_parametro IN VARCHAR2,
                                        i_valor     IN BOOLEAN);

  /**
  Define el valor de un parámetro de tipo date en la sesión
  
  %author jtsoya539 4/2/2021 08:42:00
  %param i_parametro Nombre del parámetro de tipo date
  %param i_valor Valor del parámetro de tipo date
  */
  PROCEDURE p_definir_parametro_date(i_parametro IN VARCHAR2,
                                     i_valor     IN DATE);

  /**
  Define el valor de los parámetros por defecto de la sesión
  
  %author jtsoya539 4/2/2021 08:48:40
  */
  PROCEDURE p_inicializar_parametros;

  /**
  Define el valor de todos los parámetros de la sesión a null
  
  %author jtsoya539 27/3/2020 17:01:24
  */
  PROCEDURE p_limpiar_parametros;

  /**
  Elimina todos los parámetros definidos en la sesión
  
  %author jtsoya539 27/3/2020 17:02:14
  */
  PROCEDURE p_eliminar_parametros;

  /**
  Imprime todos los parámetros definidos en la sesión
  
  %author jtsoya539 27/3/2020 17:02:58
  */
  PROCEDURE p_imprimir_parametros;

  --
  PROCEDURE p_iniciar_cola;
  PROCEDURE p_encolar(i_valor IN VARCHAR2);
  FUNCTION f_desencolar RETURN VARCHAR2;
  --

END;
/
CREATE OR REPLACE PACKAGE BODY k_sistema IS

  TYPE ly_parametros IS TABLE OF anydata INDEX BY VARCHAR2(50);
  TYPE ly_cola IS TABLE OF VARCHAR2(32767);

  g_indice     VARCHAR2(50);
  g_parametros ly_parametros;
  g_cola       ly_cola;

  FUNCTION f_es_produccion RETURN BOOLEAN IS
  BEGIN
    RETURN upper(k_util.f_valor_parametro('BASE_DATOS_PRODUCCION')) = upper(k_util.f_base_datos);
  END;

  FUNCTION f_fecha RETURN DATE IS
  BEGIN
    RETURN f_valor_parametro_date(c_fecha);
  END;

  FUNCTION f_usuario RETURN VARCHAR2 IS
  BEGIN
    RETURN f_valor_parametro_string(c_usuario);
  END;

  FUNCTION f_valor_parametro(i_parametro IN VARCHAR2) RETURN anydata IS
    l_valor anydata;
  BEGIN
    IF g_parametros.exists(i_parametro) THEN
      l_valor := g_parametros(i_parametro);
    END IF;
  
    -- Si el parámetro no se encuentra en la lista carga un valor nulo de tipo
    -- VARCHAR2 para evitar el error ORA-30625 al acceder al valor a través de
    -- AnyData.Access*
    IF l_valor IS NULL THEN
      l_valor := anydata.convertvarchar2(NULL);
    END IF;
  
    RETURN l_valor;
  END;

  FUNCTION f_valor_parametro_string(i_parametro IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN anydata.accessvarchar2(f_valor_parametro(i_parametro));
  END;

  FUNCTION f_valor_parametro_number(i_parametro IN VARCHAR2) RETURN NUMBER IS
  BEGIN
    RETURN anydata.accessnumber(f_valor_parametro(i_parametro));
  END;

  FUNCTION f_valor_parametro_boolean(i_parametro IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN sys.diutil.int_to_bool(anydata.accessnumber(f_valor_parametro(i_parametro)));
  END;

  FUNCTION f_valor_parametro_date(i_parametro IN VARCHAR2) RETURN DATE IS
  BEGIN
    RETURN anydata.accessdate(f_valor_parametro(i_parametro));
  END;

  PROCEDURE p_definir_parametro(i_parametro IN VARCHAR2,
                                i_valor     IN anydata) IS
  BEGIN
    g_parametros(i_parametro) := i_valor;
  END;

  PROCEDURE p_definir_parametro_string(i_parametro IN VARCHAR2,
                                       i_valor     IN VARCHAR2) IS
  BEGIN
    p_definir_parametro(i_parametro, anydata.convertvarchar2(i_valor));
  END;

  PROCEDURE p_definir_parametro_number(i_parametro IN VARCHAR2,
                                       i_valor     IN NUMBER) IS
  BEGIN
    p_definir_parametro(i_parametro, anydata.convertnumber(i_valor));
  END;

  PROCEDURE p_definir_parametro_boolean(i_parametro IN VARCHAR2,
                                        i_valor     IN BOOLEAN) IS
  BEGIN
    p_definir_parametro(i_parametro,
                        anydata.convertnumber(sys.diutil.bool_to_int(i_valor)));
  END;

  PROCEDURE p_definir_parametro_date(i_parametro IN VARCHAR2,
                                     i_valor     IN DATE) IS
  BEGIN
    p_definir_parametro(i_parametro, anydata.convertdate(i_valor));
  END;

  PROCEDURE p_inicializar_parametros IS
  BEGIN
    -- Elimina parámetros
    p_eliminar_parametros;
  
    -- Define parámetros por defecto
    DECLARE
      l_nombre         t_sistemas.nombre%TYPE;
      l_version_actual t_sistemas.version_actual%TYPE;
      l_fecha_actual   t_sistemas.fecha_actual%TYPE;
    BEGIN
      SELECT nombre, version_actual, fecha_actual
        INTO l_nombre, l_version_actual, l_fecha_actual
        FROM t_sistemas
       WHERE id_sistema = 'RISK';
      p_definir_parametro_string(c_sistema, l_nombre);
      p_definir_parametro_string(c_version, l_version_actual);
      p_definir_parametro_date(c_fecha, l_fecha_actual);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    p_definir_parametro_string(c_usuario, USER);
  END;

  PROCEDURE p_limpiar_parametros IS
  BEGIN
    g_indice := g_parametros.first;
    WHILE g_indice IS NOT NULL LOOP
      g_parametros(g_indice) := NULL;
      g_indice := g_parametros.next(g_indice);
    END LOOP;
  END;

  PROCEDURE p_eliminar_parametros IS
  BEGIN
    g_parametros.delete;
  END;

  PROCEDURE p_imprimir_parametros IS
    l_typeinfo anytype;
    l_typecode PLS_INTEGER;
  BEGIN
    g_indice := g_parametros.first;
    WHILE g_indice IS NOT NULL LOOP
      dbms_output.put(g_indice || ': ');
      IF g_parametros(g_indice) IS NOT NULL THEN
        l_typecode := g_parametros(g_indice).gettype(l_typeinfo);
        IF l_typecode = dbms_types.typecode_varchar2 THEN
          dbms_output.put(anydata.accessvarchar2(g_parametros(g_indice)));
        ELSIF l_typecode = dbms_types.typecode_number THEN
          dbms_output.put(to_char(anydata.accessnumber(g_parametros(g_indice))));
        ELSIF l_typecode = dbms_types.typecode_date THEN
          dbms_output.put(to_char(anydata.accessdate(g_parametros(g_indice)),
                                  'YYYY-MM-DD'));
        ELSE
          dbms_output.put('Tipo de dato no soportado');
        END IF;
      END IF;
      dbms_output.new_line;
      g_indice := g_parametros.next(g_indice);
    END LOOP;
  END;

  --
  PROCEDURE p_iniciar_cola IS
  BEGIN
    NULL;
  END;

  PROCEDURE p_encolar(i_valor IN VARCHAR2) IS
  BEGIN
    NULL;
  END;

  FUNCTION f_desencolar RETURN VARCHAR2 IS
  BEGIN
    RETURN NULL;
  END;
  --

BEGIN
  -- Define parámetros por defecto
  p_inicializar_parametros;
END;
/
