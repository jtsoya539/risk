CREATE OR REPLACE TYPE y_pagina_parametros UNDER y_objeto
(
/**
Parámetros para paginación de elementos.

%author jtsoya539 30/3/2020 10:57:43
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

/** Número de la página */
  pagina INTEGER,
/** Cantidad de elementos por página */
  por_pagina INTEGER,
/** No paginar? (S/N) */
  no_paginar VARCHAR2(1),

/**
Constructor del objeto sin parámetros.

%author jtsoya539 30/3/2020 10:08:08
%return Objeto del tipo y_pagina_parametros.
*/
  CONSTRUCTOR FUNCTION y_pagina_parametros RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

/**
Retorna el objeto serializado en formato JSON.
  
%author jtsoya539 30/3/2020 09:42:09
%return JSON con los atributos del objeto.
*/
  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_pagina_parametros IS

  CONSTRUCTOR FUNCTION y_pagina_parametros RETURN SELF AS RESULT AS
  BEGIN
    self.pagina     := NULL;
    self.por_pagina := NULL;
    self.no_paginar := NULL;
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_objeto      y_pagina_parametros;
    l_json_object json_object_t;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_objeto            := NEW y_pagina_parametros();
    l_objeto.pagina     := l_json_object.get_number('pagina');
    l_objeto.por_pagina := l_json_object.get_number('por_pagina');
    l_objeto.no_paginar := l_json_object.get_string('no_paginar');
  
    RETURN l_objeto;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('pagina', self.pagina);
    l_json_object.put('por_pagina', self.por_pagina);
    l_json_object.put('no_paginar', self.no_paginar);
    RETURN l_json_object.to_clob;
  END;

END;
/
