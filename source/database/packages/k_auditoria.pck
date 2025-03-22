CREATE OR REPLACE PACKAGE k_auditoria IS

  /**
  Agrupa operaciones relacionadas con la auditoria de tablas
  
  %author jtsoya539 27/3/2020 16:14:30
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

  -- Nombres de campos de auditoria
  g_nombre_campo_created_by VARCHAR2(30) := 'USUARIO_INSERCION';
  g_nombre_campo_created    VARCHAR2(30) := 'FECHA_INSERCION';
  g_nombre_campo_updated_by VARCHAR2(30) := 'USUARIO_MODIFICACION';
  g_nombre_campo_updated    VARCHAR2(30) := 'FECHA_MODIFICACION';

  -- Prefijos
  g_prefijo_tabla             VARCHAR2(30) := 't_';
  g_prefijo_trigger_auditoria VARCHAR2(30) := 'ga_';

  /**
  Genera campos de auditoria para una tabla
  
  %param i_tabla Tabla
  %param i_ejecutar Ejecutar la(s) sentencia(s)?
  */
  PROCEDURE p_generar_campos_auditoria(i_tabla    IN VARCHAR2,
                                       i_ejecutar IN BOOLEAN DEFAULT TRUE);

  /**
  Genera trigger de auditoria para una tabla
  
  %param i_tabla Tabla
  %param i_trigger Trigger
  %param i_ejecutar Ejecutar la(s) sentencia(s)?
  */
  PROCEDURE p_generar_trigger_auditoria(i_tabla    IN VARCHAR2,
                                        i_trigger  IN VARCHAR2 DEFAULT NULL,
                                        i_ejecutar IN BOOLEAN DEFAULT TRUE);

  /**
  Elimina campos de auditoria para una tabla
  
  %param i_tabla Tabla
  %param i_ejecutar Ejecutar la(s) sentencia(s)?
  */
  PROCEDURE p_eliminar_campos_auditoria(i_tabla    IN VARCHAR2,
                                        i_ejecutar IN BOOLEAN DEFAULT TRUE);

  /**
  Elimina trigger de auditoria para una tabla
  
  %param i_tabla Tabla
  %param i_trigger Trigger
  %param i_ejecutar Ejecutar la(s) sentencia(s)?
  */
  PROCEDURE p_eliminar_trigger_auditoria(i_tabla    IN VARCHAR2,
                                         i_trigger  IN VARCHAR2 DEFAULT NULL,
                                         i_ejecutar IN BOOLEAN DEFAULT TRUE);

END;
/
CREATE OR REPLACE PACKAGE BODY k_auditoria IS

  PROCEDURE p_generar_campos_auditoria(i_tabla    IN VARCHAR2,
                                       i_ejecutar IN BOOLEAN DEFAULT TRUE) IS
    l_sentencia VARCHAR2(4000);
  BEGIN
    -- Genera campos
    l_sentencia := 'alter table ' || i_tabla || ' add
(
  ' || g_nombre_campo_created_by || ' VARCHAR2(300) DEFAULT SUBSTR(USER, 1, 300),
  ' || g_nombre_campo_created || ' TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ' || g_nombre_campo_updated_by || ' VARCHAR2(300) DEFAULT SUBSTR(USER, 1, 300),
  ' || g_nombre_campo_updated || ' TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)';
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
    -- Genera comentarios
    l_sentencia := 'comment on column ' || i_tabla || '.' ||
                   g_nombre_campo_created_by ||
                   ' is ''Usuario que realizó la inserción del registro''';
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
    l_sentencia := 'comment on column ' || i_tabla || '.' ||
                   g_nombre_campo_created ||
                   ' is ''Fecha en que se realizó la inserción del registro''';
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
    l_sentencia := 'comment on column ' || i_tabla || '.' ||
                   g_nombre_campo_updated_by ||
                   ' is ''Usuario que realizó la última modificación en el registro''';
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
    l_sentencia := 'comment on column ' || i_tabla || '.' ||
                   g_nombre_campo_updated ||
                   ' is ''Fecha en que se realizó la última modificación en el registro''';
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  END;

  PROCEDURE p_generar_trigger_auditoria(i_tabla    IN VARCHAR2,
                                        i_trigger  IN VARCHAR2 DEFAULT NULL,
                                        i_ejecutar IN BOOLEAN DEFAULT TRUE) IS
    l_sentencia VARCHAR2(4000);
    l_trigger   VARCHAR2(30);
  BEGIN
    l_trigger := lower(nvl(i_trigger,
                           g_prefijo_trigger_auditoria ||
                           substr(i_tabla, length(g_prefijo_tabla) + 1)));
  
    -- Genera trigger
    l_sentencia := 'CREATE OR REPLACE TRIGGER ' || l_trigger || '
  BEFORE INSERT OR UPDATE ON ' || lower(i_tabla) || '
  FOR EACH ROW
BEGIN
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

  IF inserting THEN
    -- Auditoría para inserción de registros
    :new.' || lower(g_nombre_campo_created_by) ||
                   ' := substr(coalesce(k_sistema.f_usuario, USER), 1, 300);
    :new.' || lower(g_nombre_campo_created) || ' := CURRENT_TIMESTAMP;
  END IF;

  -- Auditoría para modificación de registros
  :new.' || lower(g_nombre_campo_updated_by) || ' := substr(coalesce(k_sistema.f_usuario, USER), 1, 300);
  :new.' || lower(g_nombre_campo_updated) || ' := CURRENT_TIMESTAMP;
END;';
  
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  END;

  PROCEDURE p_eliminar_campos_auditoria(i_tabla    IN VARCHAR2,
                                        i_ejecutar IN BOOLEAN DEFAULT TRUE) IS
    l_sentencia VARCHAR2(4000);
  BEGIN
    -- Elimina campos
    l_sentencia := 'alter table ' || i_tabla || ' drop column ' ||
                   g_nombre_campo_created_by;
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
    l_sentencia := 'alter table ' || i_tabla || ' drop column ' ||
                   g_nombre_campo_created;
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
    l_sentencia := 'alter table ' || i_tabla || ' drop column ' ||
                   g_nombre_campo_updated_by;
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
    l_sentencia := 'alter table ' || i_tabla || ' drop column ' ||
                   g_nombre_campo_updated;
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  END;

  PROCEDURE p_eliminar_trigger_auditoria(i_tabla    IN VARCHAR2,
                                         i_trigger  IN VARCHAR2 DEFAULT NULL,
                                         i_ejecutar IN BOOLEAN DEFAULT TRUE) IS
    l_sentencia VARCHAR2(4000);
    l_trigger   VARCHAR2(30);
  BEGIN
    l_trigger := lower(nvl(i_trigger,
                           g_prefijo_trigger_auditoria ||
                           substr(i_tabla, length(g_prefijo_tabla) + 1)));
  
    -- Genera trigger
    l_sentencia := 'drop trigger ' || l_trigger;
  
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  END;

END;
/
