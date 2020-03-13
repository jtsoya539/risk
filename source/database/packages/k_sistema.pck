CREATE OR REPLACE PACKAGE k_sistema IS

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

  -- Agrupa operaciones relacionadas con los parametros de sistema
  --
  -- %author jmeza 5/1/2019 19:48:32

  FUNCTION f_es_produccion RETURN BOOLEAN;

  FUNCTION f_fecha_actual RETURN DATE;

  -- Retorna el valor de un parametro de sistema, si no existe retorna null
  --
  -- %param i_parametro Nombre del parametro de sistema
  -- %return Valor del parametro de sistema
  -- %raises <exception> 
  FUNCTION f_valor_parametro(i_parametro IN VARCHAR2) RETURN VARCHAR2;

  -- Define el valor de un parametro de sistema
  --
  -- %param i_parametro Nombre del parametro de sistema
  -- %param i_valor Valor del parametro de sistema
  -- %raises <exception> 
  PROCEDURE p_definir_parametro(i_parametro IN VARCHAR2,
                                i_valor     IN VARCHAR2);

  -- Define el valor de todos los parametros de sistema a null
  --
  -- %raises <exception> 
  PROCEDURE p_limpiar_parametros;

  -- Elimina todos los parametros de sistema definidos
  --
  -- %raises <exception> 
  PROCEDURE p_eliminar_parametros;

  -- Imprime todos los parametros de sistema definidos
  --
  -- %raises <exception> 
  PROCEDURE p_imprimir_parametros;

END;
/
CREATE OR REPLACE PACKAGE BODY k_sistema IS

  TYPE ly_parametros IS TABLE OF VARCHAR2(50) INDEX BY VARCHAR2(30);

  g_parametros ly_parametros;
  g_indice     VARCHAR2(30);

  FUNCTION f_es_produccion RETURN BOOLEAN IS
  BEGIN
    RETURN upper(k_util.f_valor_parametro('BASE_DATOS_PRODUCCION')) = upper(k_util.f_base_datos);
  END;

  FUNCTION f_fecha_actual RETURN DATE IS
  BEGIN
    RETURN to_date(f_valor_parametro('FECHA') || ' ' ||
                   to_char(SYSDATE, 'HH24:MI:SS'),
                   'YYYY-MM-DD HH24:MI:SS');
  END;

  FUNCTION f_valor_parametro(i_parametro IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF g_parametros.exists(i_parametro) THEN
      RETURN g_parametros(i_parametro);
    ELSE
      RETURN NULL;
    END IF;
  END;

  PROCEDURE p_definir_parametro(i_parametro IN VARCHAR2,
                                i_valor     IN VARCHAR2) IS
  BEGIN
    g_parametros(i_parametro) := substr(i_valor, 1, 50);
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
  BEGIN
    g_indice := g_parametros.first;
    WHILE g_indice IS NOT NULL LOOP
      dbms_output.put_line(g_indice || ': ' || g_parametros(g_indice));
      g_indice := g_parametros.next(g_indice);
    END LOOP;
  END;

BEGIN
  -- Inicializar parametros
  DECLARE
    l_nombre         t_sistemas.nombre%TYPE;
    l_version_actual t_sistemas.version_actual%TYPE;
    l_fecha_actual   t_sistemas.fecha_actual%TYPE;
  BEGIN
    SELECT nombre, version_actual, fecha_actual
      INTO l_nombre, l_version_actual, l_fecha_actual
      FROM t_sistemas
     WHERE id_sistema = 'RISK';
    p_definir_parametro('SISTEMA', l_nombre);
    p_definir_parametro('VERSION', l_version_actual);
    p_definir_parametro('FECHA', to_char(l_fecha_actual, 'YYYY-MM-DD'));
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  p_definir_parametro('USUARIO', USER);
END;
/
