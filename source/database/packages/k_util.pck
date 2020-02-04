CREATE OR REPLACE PACKAGE k_util IS

  -- Agrupa herramientas para facilitar el desarrollo
  --
  -- %author jmeza 5/1/2019 21:42:37

  -- Genera trigger de secuencia para un campo de una tabla
  --
  -- %param i_tabla Tabla
  -- %param i_campo Campo
  -- %param i_trigger Trigger
  PROCEDURE p_generar_trigger_secuencia(i_tabla   IN VARCHAR2,
                                        i_campo   IN VARCHAR2,
                                        i_trigger IN VARCHAR2 DEFAULT NULL);

  -- Retorna el valor que se encuenta en la posicion indicada dentro de una cadena
  -- Si la posicion se encuentra fuera de rango retorna el valor mas cercano (primer valor o ultimo valor)
  --
  -- %param i_cadena Cadena
  -- %param i_posicion Posicion dentro de la cadena
  -- %param i_separador Caracter separador. Por defecto '~'
  -- %return Valor que se encuenta en la posicion indicada
  FUNCTION f_valor_posicion(i_cadena    IN VARCHAR2,
                            i_posicion  IN NUMBER,
                            i_separador IN VARCHAR2 DEFAULT '~')
    RETURN VARCHAR2;

  FUNCTION f_validar_email(i_email VARCHAR2) RETURN BOOLEAN;

  FUNCTION f_reemplazar_acentos(i_cadena IN VARCHAR2) RETURN VARCHAR2;

  -- Retorna el significado de un codigo dentro de un dominio 
  --
  -- %param i_dominio Dominio
  -- %param i_codigo Codigo
  -- %return Significado
  FUNCTION f_significado_codigo(i_dominio IN VARCHAR2,
                                i_codigo  IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_valor_parametro(i_id_parametro IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_base_datos RETURN VARCHAR2;

  FUNCTION f_terminal RETURN VARCHAR2;

  FUNCTION f_host RETURN VARCHAR2;

  FUNCTION f_direccion_ip RETURN VARCHAR2;

  FUNCTION f_esquema_actual RETURN VARCHAR2;

END;
/
CREATE OR REPLACE PACKAGE BODY k_util IS

  PROCEDURE p_generar_trigger_secuencia(i_tabla   IN VARCHAR2,
                                        i_campo   IN VARCHAR2,
                                        i_trigger IN VARCHAR2 DEFAULT NULL) IS
    l_sentencia VARCHAR2(1000) := '';
    l_trigger   VARCHAR2(30);
  BEGIN
    l_trigger := lower(nvl(i_trigger, 'gs_' || substr(i_tabla, 3)));
  
    -- Genera secuencia
    l_sentencia := 'CREATE SEQUENCE s_' || lower(i_campo);
    EXECUTE IMMEDIATE l_sentencia;
  
    -- Genera trigger
    l_sentencia := 'CREATE OR REPLACE TRIGGER ' || l_trigger || '
  BEFORE INSERT ON ' || lower(i_tabla) || '
  FOR EACH ROW
BEGIN
  SELECT s_' || lower(i_campo) || '.nextval INTO :new.' ||
                   lower(i_campo) || ' FROM dual;
END;';
  
    EXECUTE IMMEDIATE l_sentencia;
  END;

  FUNCTION f_valor_posicion(i_cadena    IN VARCHAR2,
                            i_posicion  IN NUMBER,
                            i_separador IN VARCHAR2 DEFAULT '~')
    RETURN VARCHAR2 IS
    l_valor           VARCHAR2(1000);
    l_posicion        NUMBER;
    l_separador       VARCHAR2(10);
    l_longitud_valor  NUMBER;
    l_posicion_inicio NUMBER;
    l_posicion_fin    NUMBER;
  BEGIN
    l_separador := i_separador;
  
    IF i_posicion > 0 THEN
      l_posicion := i_posicion;
    ELSE
      l_posicion := 1;
    END IF;
  
    -- Posicion del inicio del valor dentro de la cadena
    IF l_posicion > 1 THEN
      l_posicion_inicio := instr(i_cadena, l_separador, 1, l_posicion - 1);
      IF l_posicion_inicio = 0 THEN
        l_posicion_inicio := instr(i_cadena, l_separador, -1, 1);
      END IF;
      l_posicion_inicio := l_posicion_inicio + 1;
    ELSE
      l_posicion_inicio := 1;
    END IF;
  
    -- Posicion del fin del valor dentro de la cadena
    l_posicion_fin := instr(i_cadena, l_separador, 1, l_posicion);
  
    IF l_posicion_fin = 0 THEN
      l_valor := substr(i_cadena, l_posicion_inicio);
    ELSE
      l_longitud_valor := l_posicion_fin - l_posicion_inicio;
      l_valor          := substr(i_cadena,
                                 l_posicion_inicio,
                                 l_longitud_valor);
    END IF;
    RETURN l_valor;
  END;

  FUNCTION f_validar_email(i_email VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN regexp_like(i_email,
                       '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');
  END;

  FUNCTION f_reemplazar_acentos(i_cadena IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN translate(i_cadena,
                     '·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚‰ÎÔˆ¸Á„ı¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€ƒÀœ÷‹«√’',
                     'aeiouaeiouaeiouaeioucaoAEIOUAEIOUAEIOUAEIOUCAO');
  END;

  FUNCTION f_significado_codigo(i_dominio IN VARCHAR2,
                                i_codigo  IN VARCHAR2) RETURN VARCHAR2 IS
    l_significado t_significados.significado%TYPE;
  BEGIN
    BEGIN
      SELECT a.significado
        INTO l_significado
        FROM t_significados a
       WHERE a.dominio = i_dominio
         AND a.codigo = i_codigo;
    EXCEPTION
      WHEN OTHERS THEN
        l_significado := NULL;
    END;
    RETURN l_significado;
  END;

  FUNCTION f_valor_parametro(i_id_parametro IN VARCHAR2) RETURN VARCHAR2 IS
    l_valor t_parametros.valor%TYPE;
  BEGIN
    BEGIN
      SELECT a.valor
        INTO l_valor
        FROM t_parametros a
       WHERE a.id_parametro = i_id_parametro;
    EXCEPTION
      WHEN OTHERS THEN
        l_valor := NULL;
    END;
    RETURN l_valor;
  END;

  FUNCTION f_base_datos RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV', 'DB_NAME');
  END;

  FUNCTION f_terminal RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV', 'TERMINAL');
  END;

  FUNCTION f_host RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV', 'HOST');
  END;

  FUNCTION f_direccion_ip RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV', 'IP_ADDRESS');
  END;

  FUNCTION f_esquema_actual RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV', 'CURRENT_SCHEMA');
  END;

BEGIN
  -- Initialization
  NULL;
END;
/
