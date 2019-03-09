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

  -- Retorna el mensaje de un error de BD
  --
  -- %param i_error Error de BD
  -- %return Mensaje de error
  FUNCTION f_mensaje_error(i_error IN VARCHAR2) RETURN VARCHAR2;

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

  FUNCTION f_mensaje_error(i_error IN VARCHAR2) RETURN VARCHAR2 IS
    l_posicion NUMBER := instr(i_error, 'ORA-', 1, 2);
  BEGIN
    IF l_posicion > 12 THEN
      RETURN REPLACE(substr(REPLACE(i_error, '"', ' '), 1, l_posicion - 2),
                     'ORA-20000:',
                     '');
    ELSE
      RETURN TRIM(REPLACE(REPLACE(i_error, '"', ' '), 'ORA-20000:'));
    END IF;
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

BEGIN
  -- Initialization
  NULL;
END;
/
