CREATE OR REPLACE TYPE y_barrio UNDER y_objeto
(
/**
Agrupa datos de Barrios.

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

/** Identificador del barrio */
  id_barrio NUMBER(10),
/** Nombre del barrio */
  nombre VARCHAR2(100),
/** País del barrio */
  id_pais NUMBER(10),
/** Departamento, estado o provincia del barrio */
  id_departamento NUMBER(10),
/** Ciudad del barrio */
  id_ciudad NUMBER(10),

  CONSTRUCTOR FUNCTION y_barrio RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_barrio IS

  CONSTRUCTOR FUNCTION y_barrio RETURN SELF AS RESULT AS
  BEGIN
    self.id_barrio       := NULL;
    self.nombre          := NULL;
    self.id_pais         := NULL;
    self.id_departamento := NULL;
    self.id_ciudad       := NULL;
  
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_objeto      y_barrio;
    l_json_object json_object_t;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_objeto                 := NEW y_barrio();
    l_objeto.id_barrio       := l_json_object.get_number('id_barrio');
    l_objeto.nombre          := l_json_object.get_string('nombre');
    l_objeto.id_pais         := l_json_object.get_number('id_pais');
    l_objeto.id_departamento := l_json_object.get_number('id_departamento');
    l_objeto.id_ciudad       := l_json_object.get_number('id_ciudad');
  
    RETURN l_objeto;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('id_barrio', self.id_barrio);
    l_json_object.put('nombre', self.nombre);
    l_json_object.put('id_pais', self.id_pais);
    l_json_object.put('id_departamento', self.id_departamento);
    l_json_object.put('id_ciudad', self.id_ciudad);
  
    RETURN l_json_object.to_clob;
  END;

END;
/
