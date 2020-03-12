CREATE OR REPLACE TYPE y_rol UNDER y_serializable
(
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

  id_rol  NUMBER(3), -- Identificador del rol
  nombre  VARCHAR2(100), -- Nombre del rol
  activo  CHAR(1), -- El rol esta activo? (S/N)
  detalle VARCHAR2(2000), -- Detalles adicionales del rol

  CONSTRUCTOR FUNCTION y_rol RETURN SELF AS RESULT,
  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_rol IS

  CONSTRUCTOR FUNCTION y_rol RETURN SELF AS RESULT AS
  BEGIN
    self.id_rol  := NULL;
    self.nombre  := NULL;
    self.activo  := NULL;
    self.detalle := NULL;
    RETURN;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('id_rol', self.id_rol);
    l_json_object.put('nombre', self.nombre);
    l_json_object.put('activo', self.activo);
    l_json_object.put('detalle', self.detalle);
    RETURN l_json_object.to_clob;
  END;

END;
/
