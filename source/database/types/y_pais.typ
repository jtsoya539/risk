CREATE OR REPLACE TYPE y_pais UNDER y_objeto
(
/**
Agrupa datos de Paises.

%author jtsoya539 30/3/2020 10:54:26
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

/** Identificador del pais */
  id_pais NUMBER(10),
/** Nombre del pais */
  nombre VARCHAR2(100),
/** Codigo del pais segun estandar ISO 3166-1 alpha-2 */
  iso_alpha_2 VARCHAR2(2),
/** Codigo del pais segun estandar ISO 3166-1 alpha-3 */
  iso_alpha_3 VARCHAR2(3),
/** Codigo del pais segun estandar ISO 3166-1 numeric */
  iso_numeric NUMBER(3),

  CONSTRUCTOR FUNCTION y_pais RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_pais IS

  CONSTRUCTOR FUNCTION y_pais RETURN SELF AS RESULT AS
  BEGIN
    self.id_pais     := NULL;
    self.nombre      := NULL;
    self.iso_alpha_2 := NULL;
    self.iso_alpha_3 := NULL;
    self.iso_numeric := NULL;
  
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_objeto      y_pais;
    l_json_object json_object_t;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_objeto             := NEW y_pais();
    l_objeto.id_pais     := l_json_object.get_number('id_pais');
    l_objeto.nombre      := l_json_object.get_string('nombre');
    l_objeto.iso_alpha_2 := l_json_object.get_string('iso_alpha_2');
    l_objeto.iso_alpha_3 := l_json_object.get_string('iso_alpha_3');
    l_objeto.iso_numeric := l_json_object.get_number('iso_numeric');
  
    RETURN l_objeto;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('id_pais', self.id_pais);
    l_json_object.put('nombre', self.nombre);
    l_json_object.put('iso_alpha_2', self.iso_alpha_2);
    l_json_object.put('iso_alpha_3', self.iso_alpha_3);
    l_json_object.put('iso_numeric', self.iso_numeric);
  
    RETURN l_json_object.to_clob;
  END;

END;
/
