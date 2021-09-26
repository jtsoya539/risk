CREATE OR REPLACE TYPE y_ciudad UNDER y_objeto
(
/**
Agrupa datos de Ciudades.

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

/** Identificador de la ciudad */
  id_ciudad NUMBER(10),
/** Nombre de la ciudad */
  nombre VARCHAR2(100),
/** País de la ciudad */
  id_pais NUMBER(10),
/** Departamento, estado o provincia de la ciudad */
  id_departamento NUMBER(10),

  CONSTRUCTOR FUNCTION y_ciudad RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_ciudad IS

  CONSTRUCTOR FUNCTION y_ciudad RETURN SELF AS RESULT AS
  BEGIN
    self.id_ciudad       := NULL;
    self.nombre          := NULL;
    self.id_pais         := NULL;
    self.id_departamento := NULL;
  
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_objeto      y_ciudad;
    l_json_object json_object_t;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_objeto                 := NEW y_ciudad();
    l_objeto.id_ciudad       := l_json_object.get_number('id_ciudad');
    l_objeto.nombre          := l_json_object.get_string('nombre');
    l_objeto.id_pais         := l_json_object.get_number('id_pais');
    l_objeto.id_departamento := l_json_object.get_number('id_departamento');
  
    RETURN l_objeto;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('id_ciudad', self.id_ciudad);
    l_json_object.put('nombre', self.nombre);
    l_json_object.put('id_pais', self.id_pais);
    l_json_object.put('id_departamento', self.id_departamento);
  
    RETURN l_json_object.to_clob;
  END;

END;
/
