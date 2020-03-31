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

/** Contenido del archivo */
  contenido BLOB,
/** Tamaño del archivo en bytes */
  tamano NUMBER,
/** Nombre del archivo */
  nombre VARCHAR2(4000),
/** Extensión del archivo */
  extension VARCHAR2(100),

/**
Constructor del objeto sin parámetros.

%author jtsoya539 30/3/2020 10:08:08
%return Objeto del tipo y_archivo.
*/
  CONSTRUCTOR FUNCTION y_archivo RETURN SELF AS RESULT,

/**
Retorna el objeto serializado en formato JSON.
El contenido del archivo se comprime con gzip y se codifica en formato Base64.
  
%author jtsoya539 30/3/2020 09:42:09
%return JSON con los atributos del objeto.
*/
  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_archivo IS

  CONSTRUCTOR FUNCTION y_archivo RETURN SELF AS RESULT AS
  BEGIN
    self.contenido := NULL;
    self.tamano    := NULL;
    self.nombre    := NULL;
    self.extension := NULL;
    RETURN;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
    l_gzip_base64 CLOB;
  BEGIN
    IF self.contenido IS NULL OR dbms_lob.getlength(self.contenido) = 0 THEN
      l_json_object := json_object_t.parse('{"contenido":null}');
    ELSE
      -- Comprime con gzip y codifica en formato Base64
      l_gzip_base64 := k_util.base64encode(utl_compress.lz_compress(self.contenido));
      -- Elimina caracteres de nueva línea para evitar error de sintaxis JSON
      l_gzip_base64 := REPLACE(l_gzip_base64, utl_tcp.crlf);
      l_json_object := json_object_t.parse('{"contenido":"' ||
                                           l_gzip_base64 || '"}');
    END IF;
    l_json_object.put('tamano', self.tamano);
    l_json_object.put('nombre', self.nombre);
    l_json_object.put('extension', self.extension);
    RETURN l_json_object.to_clob;
  END;

END;
/
