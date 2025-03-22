CREATE OR REPLACE TYPE y_significado UNDER y_objeto
(
/**
Agrupa datos de Significados.

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

/** Dominio */
  dominio VARCHAR2(50),
/** Codigo */
  codigo VARCHAR2(50),
/** Significado */
  significado VARCHAR2(500),
/** Referencia adicional */
  referencia VARCHAR2(500),
/** El significado esta activo? (S/N) */
  activo VARCHAR2(1),

  CONSTRUCTOR FUNCTION y_significado RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/

CREATE OR REPLACE TYPE BODY y_significado IS

  CONSTRUCTOR FUNCTION y_significado RETURN SELF AS RESULT AS
  BEGIN
    self.dominio     := NULL;
    self.codigo      := NULL;
    self.significado := NULL;
    self.referencia  := NULL;
    self.activo      := NULL;
  
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_objeto      y_significado;
    l_json_object json_object_t;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_objeto             := NEW y_significado();
    l_objeto.dominio     := l_json_object.get_string('dominio');
    l_objeto.codigo      := l_json_object.get_string('codigo');
    l_objeto.significado := l_json_object.get_string('significado');
    l_objeto.referencia  := l_json_object.get_string('referencia');
    l_objeto.activo      := l_json_object.get_string('activo');
  
    RETURN l_objeto;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('dominio', self.dominio);
    l_json_object.put('codigo', self.codigo);
    l_json_object.put('significado', self.significado);
    l_json_object.put('referencia', self.referencia);
    l_json_object.put('activo', self.activo);
  
    RETURN l_json_object.to_clob;
  END;

END;
/

