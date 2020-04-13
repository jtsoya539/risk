CREATE OR REPLACE TYPE y_archivo UNDER y_objeto
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
/** Hash del archivo calculado con el algoritmo SHA-1 */
  checksum VARCHAR2(100),
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
Calcula las propiedades del archivo.

%author jtsoya539 1/4/2020 10:10:10
*/
  MEMBER PROCEDURE calcular_propiedades,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

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
    self.checksum  := NULL;
    self.tamano    := NULL;
    self.nombre    := NULL;
    self.extension := NULL;
    RETURN;
  END;

  MEMBER PROCEDURE calcular_propiedades IS
  BEGIN
    IF self.contenido IS NULL OR dbms_lob.getlength(self.contenido) = 0 THEN
      self.checksum := NULL;
      self.tamano   := NULL;
    ELSE
      self.checksum := to_char(rawtohex(dbms_crypto.hash(self.contenido,
                                                         dbms_crypto.hash_sh1)));
      self.tamano   := dbms_lob.getlength(self.contenido);
    END IF;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_archivo     y_archivo;
    l_json_object json_object_t;
    l_gzip_base64 CLOB;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_archivo     := NEW y_archivo();
    l_gzip_base64 := l_json_object.get_clob('contenido');
    IF l_gzip_base64 IS NULL OR dbms_lob.getlength(l_gzip_base64) = 0 THEN
      l_archivo.contenido := NULL;
    ELSE
      -- Decodifica en formato Base64 y descomprime con gzip
      l_archivo.contenido := utl_compress.lz_uncompress(k_util.base64decode(l_gzip_base64));
    END IF;
    l_archivo.checksum  := l_json_object.get_string('checksum');
    l_archivo.tamano    := l_json_object.get_number('tamano');
    l_archivo.nombre    := l_json_object.get_string('nombre');
    l_archivo.extension := l_json_object.get_string('extension');
  
    RETURN l_archivo;
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
    l_json_object.put('checksum', self.checksum);
    l_json_object.put('tamano', self.tamano);
    l_json_object.put('nombre', self.nombre);
    l_json_object.put('extension', self.extension);
    RETURN l_json_object.to_clob;
  END;

END;
/
