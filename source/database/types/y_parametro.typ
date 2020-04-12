CREATE OR REPLACE TYPE y_parametro UNDER y_objeto
(
/**
Agrupa datos de un parámetro de servicio o proceso.

%author jtsoya539 30/3/2020 10:03:16
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

/** Nombre del parametro */
  nombre VARCHAR2(100),
/** Valor del parametro */
  valor anydata,

/**
Constructor del objeto sin parámetros.

%author jtsoya539 30/3/2020 10:08:08
%return Objeto del tipo y_parametro.
*/
  CONSTRUCTOR FUNCTION y_parametro RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

/**
Retorna el objeto serializado en formato JSON.
  
%author jtsoya539 30/3/2020 09:42:09
%return JSON con los atributos del objeto.
*/
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

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_parametro   y_parametro;
    l_json_object json_object_t;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_parametro        := NEW y_parametro();
    l_parametro.nombre := l_json_object.get_string('nombre');
    l_parametro.valor  := NULL; -- TODO
  
    RETURN l_parametro;
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
