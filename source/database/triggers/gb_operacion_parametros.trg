CREATE OR REPLACE TRIGGER gb_operacion_parametros
  BEFORE INSERT OR UPDATE OR DELETE ON t_operacion_parametros
  FOR EACH ROW
DECLARE
  l_existe VARCHAR2(1);
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
  
    IF :new.valores_posibles IS NOT NULL THEN
      -- Valida dominio
      BEGIN
        SELECT 'S'
          INTO l_existe
          FROM t_significados a
         WHERE upper(a.dominio) = upper(:new.valores_posibles);
      EXCEPTION
        WHEN no_data_found THEN
          l_existe := 'N';
        WHEN too_many_rows THEN
          l_existe := 'S';
      END;
    
      IF l_existe = 'N' THEN
        raise_application_error(-20000,
                                'Dominio no definido en tabla de significados');
      END IF;
    END IF;
  
  END IF;

END;
/
