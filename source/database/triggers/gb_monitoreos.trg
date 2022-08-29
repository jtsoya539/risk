CREATE OR REPLACE TRIGGER gb_monitoreos
  BEFORE INSERT OR UPDATE OR DELETE ON t_monitoreos
  FOR EACH ROW
DECLARE
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
  
    -- Valida registro relacionado
    IF :new.bloque_plsql IS NOT NULL THEN
    
      DECLARE
        l_rsp          y_respuesta;
        l_parametros   y_parametros := NEW y_parametros();
        l_bloque_plsql CLOB := :new.bloque_plsql;
      BEGIN
        l_bloque_plsql := 'DECLARE' || chr(10) ||
                          '  l_rsp        y_respuesta := NEW y_respuesta();' ||
                          chr(10) || '  l_parametros y_parametros := :1;' ||
                          chr(10) || 'BEGIN' || chr(10) ||
                          '  IF l_parametros.count > 0 THEN' || chr(10) ||
                          '    ' || l_bloque_plsql || ' ' || chr(10) ||
                          '  ELSE' || chr(10) ||
                          '    l_rsp.lugar := ''SIN PARÁMETROS'';' ||
                          chr(10) || '  END IF;' || chr(10) ||
                          '  :2 := l_rsp;' || chr(10) || 'END;';
        EXECUTE IMMEDIATE l_bloque_plsql
          USING IN l_parametros, OUT l_rsp;
        dbms_output.put_line(l_rsp.lugar);
      END;
    
    END IF;
  
  END IF;

END;
/
