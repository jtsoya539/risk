CREATE OR REPLACE PACKAGE k_auditoria IS

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

END;
/
CREATE OR REPLACE PACKAGE BODY k_auditoria IS

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

BEGIN
  -- Initialization
  NULL;
END;
/
