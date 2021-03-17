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
  usuario_insercion    VARCHAR2(30) DEFAULT SUBSTR(USER, 1, 30),
  fecha_insercion      DATE DEFAULT SYSDATE,
  usuario_modificacion VARCHAR2(30) DEFAULT SUBSTR(USER, 1, 30),
  fecha_modificacion   DATE DEFAULT SYSDATE
)';
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
    -- Genera comentarios
    l_sentencia := 'comment on column ' || i_tabla ||
                   '.usuario_insercion is ''Usuario que realizo la insercion del registro''';
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
    l_sentencia := 'comment on column ' || i_tabla ||
                   '.fecha_insercion is ''Fecha en que se realizo la insercion del registro''';
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
    l_sentencia := 'comment on column ' || i_tabla ||
                   '.usuario_modificacion is ''Usuario que realizo la ultima modificacion en el registro''';
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  
    l_sentencia := 'comment on column ' || i_tabla ||
                   '.fecha_modificacion is ''Fecha en que se realizo la ultima modificacion en el registro''';
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
    l_trigger := lower(nvl(i_trigger, 'ga_' || substr(i_tabla, 3)));
  
    -- Genera trigger
    l_sentencia := 'CREATE OR REPLACE TRIGGER ' || l_trigger || '
  BEFORE DELETE OR INSERT OR UPDATE ON ' ||
                   lower(i_tabla) || '
  FOR EACH ROW
DECLARE
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

  -- Auditoria para insercion de registros
  PROCEDURE lp_insercion IS
  BEGIN
    :new.usuario_insercion := substr(USER, 1, 30);
    :new.fecha_insercion   := SYSDATE;
  END;

  -- Auditoria para modificacion de registros
  PROCEDURE lp_modificacion IS
  BEGIN
    :new.usuario_modificacion := substr(USER, 1, 30);
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
  
    IF i_ejecutar THEN
      EXECUTE IMMEDIATE l_sentencia;
    ELSE
      dbms_output.put_line(l_sentencia);
    END IF;
  END;

END;
/
