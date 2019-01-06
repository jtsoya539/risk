CREATE OR REPLACE PACKAGE k_herramientas IS

  -- Agrupa herramientas para facilitar el desarrollo
  --
  -- %author jmeza 5/1/2019 21:42:37

  -- Genera campos de auditoria para una tabla
  --
  -- %param p_tabla Tabla
  PROCEDURE p_generar_campos_auditoria(p_tabla IN VARCHAR2);

  -- Genera trigger de auditoria para una tabla
  --
  -- %param p_tabla Tabla
  -- %param p_trigger Trigger
  PROCEDURE p_generar_trigger_auditoria(p_tabla   IN VARCHAR2,
                                        p_trigger IN VARCHAR2 DEFAULT NULL);

  -- Genera trigger de secuencia para un campo de una tabla
  --
  -- %param p_tabla Tabla
  -- %param p_campo Campo
  -- %param p_trigger Trigger
  PROCEDURE p_generar_trigger_secuencia(p_tabla   IN VARCHAR2,
                                        p_campo   IN VARCHAR2,
                                        p_trigger IN VARCHAR2 DEFAULT NULL);

  -- Retorna el mensaje de un error de BD
  --
  -- %param p_error Error de BD
  -- %return Mensaje de error
  FUNCTION f_mensaje_error(p_error IN VARCHAR2) RETURN VARCHAR2;

  -- Retorna el valor que se encuenta en la posicion indicada dentro de una cadena
  -- Si la posicion se encuentra fuera de rango retorna el valor mas cercano (primer valor o ultimo valor)
  --
  -- %param p_cadena Cadena
  -- %param p_posicion Posicion dentro de la cadena
  -- %param p_separador Caracter separador. Por defecto '~'
  -- %return Valor que se encuenta en la posicion indicada
  FUNCTION f_valor_posicion(p_cadena    IN VARCHAR2,
                            p_posicion  IN NUMBER,
                            p_separador IN VARCHAR2 DEFAULT '~')
    RETURN VARCHAR2;

END;
/
CREATE OR REPLACE PACKAGE BODY k_herramientas IS

  PROCEDURE p_generar_campos_auditoria(p_tabla IN VARCHAR2) IS
    l_sentencia VARCHAR2(1000) := '';
  BEGIN
    -- Genera campos
    l_sentencia := 'alter table ' || p_tabla || ' add
(
  usuario_insercion    VARCHAR2(10) DEFAULT SUBSTR(USER, 1, 10),
  fecha_insercion      DATE DEFAULT SYSDATE,
  usuario_modificacion VARCHAR2(10) DEFAULT SUBSTR(USER, 1, 10),
  fecha_modificacion   DATE DEFAULT SYSDATE
)';
    EXECUTE IMMEDIATE l_sentencia;
  
    -- Genera comentarios
    l_sentencia := 'comment on column ' || p_tabla ||
                   '.usuario_insercion is ''Usuario que realizo la insercion del registro.''';
    EXECUTE IMMEDIATE l_sentencia;
  
    l_sentencia := 'comment on column ' || p_tabla ||
                   '.fecha_insercion is ''Fecha en que se realizo la insercion del registro.''';
    EXECUTE IMMEDIATE l_sentencia;
  
    l_sentencia := 'comment on column ' || p_tabla ||
                   '.usuario_modificacion is ''Usuario que realizo la ultima modificacion en el registro.''';
    EXECUTE IMMEDIATE l_sentencia;
  
    l_sentencia := 'comment on column ' || p_tabla ||
                   '.fecha_modificacion is ''Fecha en que se realizo la ultima modificacion en el registro.''';
    EXECUTE IMMEDIATE l_sentencia;
  END;

  PROCEDURE p_generar_trigger_auditoria(p_tabla   IN VARCHAR2,
                                        p_trigger IN VARCHAR2 DEFAULT NULL) IS
    l_sentencia VARCHAR2(1000) := '';
    l_trigger   VARCHAR2(30);
  BEGIN
    l_trigger := lower(nvl(p_trigger, 'ga_' || substr(p_tabla, 3)));
  
    -- Genera trigger
    l_sentencia := 'CREATE OR REPLACE TRIGGER ' || l_trigger || '
  BEFORE DELETE OR INSERT OR UPDATE ON ' ||
                   lower(p_tabla) || '
  FOR EACH ROW

DECLARE

  PROCEDURE lp_insercion;
  PROCEDURE lp_modificacion;

  -- Auditoria para insercion de registros
  PROCEDURE lp_insercion IS
  BEGIN
    :new.usuario_insercion := substr(USER, 1, 10);
    :new.fecha_insercion   := SYSDATE;
  END;

  -- Auditoria para modificacion de registros
  PROCEDURE lp_modificacion IS
  BEGIN
    :new.usuario_modificacion := substr(USER, 1, 10);
    :new.fecha_modificacion   := SYSDATE;
  END;

BEGIN

  -- Registrar campos de auditoria
  IF inserting THEN
    lp_insercion;
    lp_modificacion;
  ELSIF updating THEN
    lp_modificacion;
  END IF;

END;';
  
    EXECUTE IMMEDIATE l_sentencia;
  END;

  PROCEDURE p_generar_trigger_secuencia(p_tabla   IN VARCHAR2,
                                        p_campo   IN VARCHAR2,
                                        p_trigger IN VARCHAR2 DEFAULT NULL) IS
    l_sentencia VARCHAR2(1000) := '';
    l_trigger   VARCHAR2(30);
  BEGIN
    l_trigger := lower(nvl(p_trigger, 'gs_' || substr(p_tabla, 3)));
  
    -- Genera secuencia
    l_sentencia := 'CREATE SEQUENCE s_' || lower(p_campo);
    EXECUTE IMMEDIATE l_sentencia;
  
    -- Genera trigger
    l_sentencia := 'CREATE OR REPLACE TRIGGER ' || l_trigger || '
  BEFORE INSERT ON ' || lower(p_tabla) || '
  FOR EACH ROW

BEGIN
  SELECT s_' || lower(p_campo) || '.nextval INTO :new.' ||
                   lower(p_campo) || ' FROM dual;
END;';
  
    EXECUTE IMMEDIATE l_sentencia;
  END;

  FUNCTION f_mensaje_error(p_error IN VARCHAR2) RETURN VARCHAR2 IS
    l_posicion NUMBER := instr(p_error, 'ORA-', 1, 2);
  BEGIN
    IF l_posicion > 12 THEN
      RETURN REPLACE(substr(REPLACE(p_error, '"', ' '), 1, l_posicion - 2),
                     'ORA-20000:',
                     '');
    ELSE
      RETURN TRIM(REPLACE(REPLACE(p_error, '"', ' '), 'ORA-20000:'));
    END IF;
  END;

  FUNCTION f_valor_posicion(p_cadena    IN VARCHAR2,
                            p_posicion  IN NUMBER,
                            p_separador IN VARCHAR2 DEFAULT '~')
    RETURN VARCHAR2 IS
  
    l_valor           VARCHAR2(1000);
    l_posicion        NUMBER;
    l_separador       VARCHAR2(10);
    l_longitud_valor  NUMBER;
    l_posicion_inicio NUMBER;
    l_posicion_fin    NUMBER;
  
  BEGIN
  
    l_separador := p_separador;
  
    IF p_posicion > 0 THEN
      l_posicion := p_posicion;
    ELSE
      l_posicion := 1;
    END IF;
  
    -- Posicion del inicio del valor dentro de la cadena
    IF l_posicion > 1 THEN
      l_posicion_inicio := instr(p_cadena, l_separador, 1, l_posicion - 1);
      IF l_posicion_inicio = 0 THEN
        l_posicion_inicio := instr(p_cadena, l_separador, -1, 1);
      END IF;
      l_posicion_inicio := l_posicion_inicio + 1;
    ELSE
      l_posicion_inicio := 1;
    END IF;
  
    -- Posicion del fin del valor dentro de la cadena
    l_posicion_fin := instr(p_cadena, l_separador, 1, l_posicion);
  
    IF l_posicion_fin = 0 THEN
      l_valor := substr(p_cadena, l_posicion_inicio);
    ELSE
      l_longitud_valor := l_posicion_fin - l_posicion_inicio;
      l_valor          := substr(p_cadena,
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
