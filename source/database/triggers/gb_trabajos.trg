CREATE OR REPLACE TRIGGER gb_trabajos
  BEFORE INSERT OR UPDATE OR DELETE ON t_trabajos
  FOR EACH ROW
DECLARE
  l_tipo_operacion t_operaciones.tipo%TYPE;
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
       WHERE o.id_operacion = :new.id_trabajo;
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000, 'Operación inexistente');
    END;
  
    -- Valida tipo de operación
    IF l_tipo_operacion <> 'T' THEN
      raise_application_error(-20000, 'Operación no es de tipo Trabajo');
    END IF;
  
  END IF;

END;
/
