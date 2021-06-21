CREATE OR REPLACE TYPE y_plantilla UNDER y_dato
(
/**
Contiene una plantilla de notificaci�n push.

%author dmezac 20/6/2021 20:35:55
*/

/*
--------------------------------- MIT License ---------------------------------
Copyright (c) 2019 dmezac

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

/** Contenido en formato de texto. */
  nombre VARCHAR2(100),

/**
Constructor del objeto sin par�metros.

%author dmezac 20/6/2021 20:08:08
%return Objeto del tipo y_plantilla.
*/
  CONSTRUCTOR FUNCTION y_plantilla RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

/**
Retorna el objeto serializado en formato JSON.
  
%author dmezac 20/6/2021 19:42:09
%return JSON con los atributos del objeto.
*/
  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_plantilla IS

  CONSTRUCTOR FUNCTION y_plantilla RETURN SELF AS RESULT AS
  BEGIN
    self.contenido := NULL;
    self.nombre    := NULL;
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_dato        y_plantilla;
    l_json_object json_object_t;
  BEGIN
    l_json_object    := json_object_t.parse(i_json);
    l_dato           := NEW y_plantilla();
    l_dato.contenido := l_json_object.get_clob('contenido');
    l_dato.nombre    := l_json_object.get_clob('nombre');
    RETURN l_dato;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('contenido', self.contenido);
    l_json_object.put('nombre', self.nombre);
    RETURN l_json_object.to_clob;
  END;

END;
/
