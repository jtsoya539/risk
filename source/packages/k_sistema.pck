CREATE OR REPLACE PACKAGE k_sistema IS

  -- Agrupa operaciones relacionadas con los parametros de sistema
  --
  -- %author jmeza 5/1/2019 19:48:32

  -- Retorna el valor de un parametro de sistema, si no existe retorna null
  --
  -- %param p_parametro Nombre del parametro de sistema
  -- %return Valor del parametro de sistema
  -- %raises <exception> 
  FUNCTION f_valor_parametro(p_parametro IN VARCHAR2) RETURN VARCHAR2;

  -- Define el valor de un parametro de sistema
  --
  -- %param p_parametro Nombre del parametro de sistema
  -- %param p_valor Valor del parametro de sistema
  -- %raises <exception> 
  PROCEDURE p_definir_parametro(p_parametro IN VARCHAR2,
                                p_valor     IN VARCHAR2);

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

  TYPE t_parametros IS TABLE OF VARCHAR2(50) INDEX BY VARCHAR2(30);

  g_parametros t_parametros;
  g_indice     VARCHAR2(30);

  FUNCTION f_valor_parametro(p_parametro IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF g_parametros.exists(p_parametro) THEN
      RETURN g_parametros(p_parametro);
    ELSE
      RETURN NULL;
    END IF;
  END;

  PROCEDURE p_definir_parametro(p_parametro IN VARCHAR2,
                                p_valor     IN VARCHAR2) IS
  BEGIN
    g_parametros(p_parametro) := substr(p_valor, 1, 50);
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
  p_definir_parametro('SISTEMA', 'RISK');
  p_definir_parametro('VERSION', '0.1');
  p_definir_parametro('USUARIO', USER);
  p_definir_parametro('FECHA', to_char(SYSDATE, 'YYYY-MM-DD'));
END;
/
