CREATE OR REPLACE PACKAGE k_auditoria IS

  -- Agrupa operaciones relacionadas con la auditoria de tablas
  --
  -- %author jmeza 5/1/2019 21:42:37

  -- Genera campos de auditoria para una tabla
  --
  -- %param i_tabla Tabla
  PROCEDURE p_generar_campos_auditoria(i_tabla IN VARCHAR2);

  -- Genera trigger de auditoria para una tabla
  --
  -- %param i_tabla Tabla
  -- %param i_trigger Trigger
  PROCEDURE p_generar_trigger_auditoria(i_tabla   IN VARCHAR2,
                                        i_trigger IN VARCHAR2 DEFAULT NULL);

END;
/

CREATE OR REPLACE PACKAGE BODY k_auditoria IS

  PROCEDURE p_generar_campos_auditoria(i_tabla IN VARCHAR2) IS
    l_sentencia VARCHAR2(1000) := '';
  BEGIN
    -- Genera campos
    l_sentencia := 'alter table ' || i_tabla || ' add
(
  usuario_insercion    VARCHAR2(10) DEFAULT SUBSTR(USER, 1, 10),
  fecha_insercion      DATE DEFAULT SYSDATE,
  usuario_modificacion VARCHAR2(10) DEFAULT SUBSTR(USER, 1, 10),
  fecha_modificacion   DATE DEFAULT SYSDATE
)';
    EXECUTE IMMEDIATE l_sentencia;
  
    -- Genera comentarios
    l_sentencia := 'comment on column ' || i_tabla ||
                   '.usuario_insercion is ''Usuario que realizo la insercion del registro''';
    EXECUTE IMMEDIATE l_sentencia;
  
    l_sentencia := 'comment on column ' || i_tabla ||
                   '.fecha_insercion is ''Fecha en que se realizo la insercion del registro''';
    EXECUTE IMMEDIATE l_sentencia;
  
    l_sentencia := 'comment on column ' || i_tabla ||
                   '.usuario_modificacion is ''Usuario que realizo la ultima modificacion en el registro''';
    EXECUTE IMMEDIATE l_sentencia;
  
    l_sentencia := 'comment on column ' || i_tabla ||
                   '.fecha_modificacion is ''Fecha en que se realizo la ultima modificacion en el registro''';
    EXECUTE IMMEDIATE l_sentencia;
  END;

  PROCEDURE p_generar_trigger_auditoria(i_tabla   IN VARCHAR2,
                                        i_trigger IN VARCHAR2 DEFAULT NULL) IS
    l_sentencia VARCHAR2(1000) := '';
    l_trigger   VARCHAR2(30);
  BEGIN
    l_trigger := lower(nvl(i_trigger, 'ga_' || substr(i_tabla, 3)));
  
    -- Genera trigger
    l_sentencia := 'CREATE OR REPLACE TRIGGER ' || l_trigger || '
  BEFORE DELETE OR INSERT OR UPDATE ON ' ||
                   lower(i_tabla) || '
  FOR EACH ROW
DECLARE
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

