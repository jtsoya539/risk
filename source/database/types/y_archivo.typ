CREATE OR REPLACE TYPE y_archivo UNDER y_serializable
(
/**
Agrupa datos de un archivo.

%author jtsoya539 30/3/2020 10:35:55
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

/** Nombre del archivo */
  nombre VARCHAR2(4000),
/** Extensión del archivo */
  extension VARCHAR2(100),
/** Contenido del archivo */
  contenido BLOB,

/**
Constructor del objeto sin parámetros.

%author jtsoya539 30/3/2020 10:08:08
%return Objeto del tipo y_archivo.
*/
  CONSTRUCTOR FUNCTION y_archivo RETURN SELF AS RESULT,

/**
Retorna el objeto serializado en formato JSON.
  
%author jtsoya539 30/3/2020 09:42:09
%return JSON con los atributos del objeto.
*/
  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_archivo IS

  CONSTRUCTOR FUNCTION y_archivo RETURN SELF AS RESULT AS
  BEGIN
    self.nombre    := NULL;
    self.extension := NULL;
    self.contenido := NULL;
    RETURN;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('nombre', self.nombre);
    l_json_object.put('extension', self.extension);
    l_json_object.put('contenido', k_util.base64encode(self.contenido));
    RETURN l_json_object.to_clob;
  END;

END;
/
