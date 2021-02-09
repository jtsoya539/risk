CREATE OR REPLACE TYPE y_pagina UNDER y_objeto
(
/**
Agrupa datos de una página con resultados para una consulta.

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

/** Número de la página actual */
  numero_actual INTEGER,
/** Número de la página siguiente */
  numero_siguiente INTEGER,
/** Número de la última página */
  numero_ultima INTEGER,
/** Número de la primera página */
  numero_primera INTEGER,
/** Número de la página anterior */
  numero_anterior INTEGER,
/** Cantidad de elementos en la página actual */
  cantidad_elementos INTEGER,
/** Elementos */
  elementos y_objetos,

/**
Constructor del objeto sin parámetros.

%author jtsoya539 30/3/2020 10:08:08
%return Objeto del tipo y_pagina.
*/
  CONSTRUCTOR FUNCTION y_pagina RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

/**
Retorna el objeto serializado en formato JSON.
  
%author jtsoya539 30/3/2020 09:42:09
%return JSON con los atributos del objeto.
*/
  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_pagina IS

  CONSTRUCTOR FUNCTION y_pagina RETURN SELF AS RESULT AS
  BEGIN
    self.numero_actual      := NULL;
    self.numero_siguiente   := NULL;
    self.numero_ultima      := NULL;
    self.numero_primera     := NULL;
    self.numero_anterior    := NULL;
    self.cantidad_elementos := NULL;
    self.elementos          := NEW y_objetos();
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_pagina      y_pagina;
    l_json_object json_object_t;
    l_objeto      y_objeto;
    l_objetos     y_objetos;
    l_json_array  json_array_t;
    l_anydata     anydata;
    l_result      PLS_INTEGER;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_pagina                    := NEW y_pagina();
    l_pagina.numero_actual      := l_json_object.get_number('numero_actual');
    l_pagina.numero_siguiente   := l_json_object.get_number('numero_siguiente');
    l_pagina.numero_ultima      := l_json_object.get_number('numero_ultima');
    l_pagina.numero_primera     := l_json_object.get_number('numero_primera');
    l_pagina.numero_anterior    := l_json_object.get_number('numero_anterior');
    l_pagina.cantidad_elementos := l_json_object.get_number('cantidad_elementos');
  
    l_json_array := l_json_object.get_array('elementos');
  
    IF l_json_array IS NULL THEN
      l_pagina.elementos := NEW y_objetos();
    ELSE
      l_objetos := NEW y_objetos();
      FOR i IN 0 .. l_json_array.get_size - 1 LOOP
        l_objeto  := NULL;
        l_anydata := k_util.json_to_objeto(l_json_array.get(i).to_clob,
                                           k_sistema.f_valor_parametro_string(k_sistema.c_nombre_tipo));
        l_result  := l_anydata.getobject(l_objeto);
        l_objetos.extend;
        l_objetos(l_objetos.count) := l_objeto;
      END LOOP;
      l_pagina.elementos := l_objetos;
    END IF;
  
    RETURN l_pagina;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
    l_json_array  json_array_t;
    i             INTEGER;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('numero_actual', self.numero_actual);
    l_json_object.put('numero_siguiente', self.numero_siguiente);
    l_json_object.put('numero_ultima', self.numero_ultima);
    l_json_object.put('numero_primera', self.numero_primera);
    l_json_object.put('numero_anterior', self.numero_anterior);
    l_json_object.put('cantidad_elementos', self.cantidad_elementos);
  
    IF self.elementos IS NULL THEN
      l_json_object.put_null('elementos');
    ELSE
      l_json_array := NEW json_array_t();
      i            := self.elementos.first;
      WHILE i IS NOT NULL LOOP
        l_json_array.append(json_object_t.parse(nvl(self.elementos(i).json,
                                                    self.elementos(i)
                                                    .to_json)));
        i := self.elementos.next(i);
      END LOOP;
      l_json_object.put('elementos', l_json_array);
    END IF;
  
    RETURN l_json_object.to_clob;
  END;

END;
/
