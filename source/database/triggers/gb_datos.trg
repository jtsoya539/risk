CREATE OR REPLACE TRIGGER gb_datos
  BEFORE INSERT OR UPDATE OR DELETE ON t_datos
  FOR EACH ROW
DECLARE
  l_existe_registro   VARCHAR2(1);
  l_nombre_referencia t_dato_definiciones.nombre_referencia%TYPE;
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
  
    -- Valida definición
    BEGIN
      SELECT d.nombre_referencia
        INTO l_nombre_referencia
        FROM t_dato_definiciones d
       WHERE upper(d.tabla) = upper(:new.tabla)
         AND upper(d.campo) = upper(:new.campo);
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000,
                                'Definición de dato adicional inexistente');
    END;
  
    -- Valida registro relacionado
    IF l_nombre_referencia IS NOT NULL THEN
      EXECUTE IMMEDIATE 'DECLARE
  l_existe VARCHAR2(1) := ''N'';
BEGIN
  BEGIN
    SELECT ''S''
      INTO l_existe
      FROM ' || :new.tabla || '
     WHERE to_char(' || l_nombre_referencia || ') = :1;
  EXCEPTION
    WHEN no_data_found THEN
      l_existe := ''N'';
    WHEN too_many_rows THEN
      l_existe := ''S'';
    WHEN OTHERS THEN
      l_existe := ''N'';
  END;
  :2 := l_existe;
END;'
        USING IN :new.referencia, OUT l_existe_registro;
    
      IF l_existe_registro = 'N' THEN
        raise_application_error(-20000, 'Registro relacionado inexistente');
      END IF;
    END IF;
  
    IF :new.contenido IS NULL THEN
      NULL;
    ELSE
      -- Valida tipo de dato
      NULL;
    END IF;
  
  END IF;

END;
/
