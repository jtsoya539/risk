CREATE OR REPLACE TRIGGER gb_servicios
  BEFORE INSERT OR UPDATE OR DELETE ON t_servicios
  FOR EACH ROW
DECLARE
  l_tipo_operacion t_operaciones.tipo%TYPE;
  l_cursor         PLS_INTEGER;
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

  IF inserting OR updating THEN
  
    -- Valida operación
    BEGIN
      SELECT o.tipo
        INTO l_tipo_operacion
        FROM t_operaciones o
       WHERE o.id_operacion = :new.id_servicio;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000, 'Operación inexistente');
    END;
  
    -- Valida tipo de operación
    IF l_tipo_operacion <> 'S' THEN
      raise_application_error(-20000, 'Operación no es de tipo Servicio');
    END IF;
  
    -- Valida consulta SQL
    IF :new.consulta_sql IS NOT NULL AND :new.tipo = 'C' THEN
      BEGIN
        l_cursor := dbms_sql.open_cursor;
        dbms_sql.parse(l_cursor, :new.consulta_sql, dbms_sql.native);
        dbms_sql.close_cursor(l_cursor);
      EXCEPTION
        WHEN OTHERS THEN
          raise_application_error(-20000,
                                  'Consulta SQL no válida: ' || SQLERRM);
      END;
    END IF;
  
  END IF;

END;
/
