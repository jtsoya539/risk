CREATE OR REPLACE TYPE y_mensaje UNDER y_objeto
(
/**
Agrupa datos de un mensaje de texto (SMS).

%author jtsoya539 30/3/2020 11:13:53
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

/** Identificador del mensaje de texto */
  id_mensaje NUMBER,
/** N�mero de tel�fono destino del mensaje de texto */
  numero_telefono VARCHAR2(160),
/** Contenido del mensaje de texto */
  contenido VARCHAR2(160),

/**
Constructor del objeto sin par�metros.

%author jtsoya539 30/3/2020 10:08:08
%return Objeto del tipo y_mensaje.
*/
  CONSTRUCTOR FUNCTION y_mensaje RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

/**
Retorna el objeto serializado en formato JSON.
  
%author jtsoya539 30/3/2020 09:42:09
%return JSON con los atributos del objeto.
*/
  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_mensaje IS

  CONSTRUCTOR FUNCTION y_mensaje RETURN SELF AS RESULT AS
  BEGIN
    self.id_mensaje      := NULL;
    self.numero_telefono := NULL;
    self.contenido       := NULL;
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_objeto      y_mensaje;
    l_json_object json_object_t;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_objeto                 := NEW y_mensaje();
    l_objeto.id_mensaje      := l_json_object.get_number('id_mensaje');
    l_objeto.numero_telefono := l_json_object.get_string('numero_telefono');
    l_objeto.contenido       := l_json_object.get_string('contenido');
  
    RETURN l_objeto;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('id_mensaje', self.id_mensaje);
    l_json_object.put('numero_telefono', self.numero_telefono);
    l_json_object.put('contenido', self.contenido);
    RETURN l_json_object.to_clob;
  END;

END;
/
