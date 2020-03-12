CREATE OR REPLACE TYPE y_parametro UNDER y_serializable
(
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

  nombre VARCHAR2(100), -- Nombre del parametro
  valor  anydata, -- Valor del parametro

  CONSTRUCTOR FUNCTION y_parametro RETURN SELF AS RESULT,
  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_parametro IS

  CONSTRUCTOR FUNCTION y_parametro RETURN SELF AS RESULT AS
  BEGIN
    self.nombre := NULL;
    self.valor  := NULL;
    RETURN;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('nombre', self.nombre);
    IF k_util.f_json_objeto(self.valor) IS NOT NULL THEN
      l_json_object.put('valor',
                        json_element_t.parse(k_util.f_json_objeto(self.valor)));
    ELSE
      l_json_object.put_null('valor');
    END IF;
    RETURN l_json_object.to_clob;
  END;

END;
/
