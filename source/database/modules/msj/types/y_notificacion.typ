CREATE OR REPLACE TYPE y_notificacion UNDER y_objeto
(
/**
Agrupa datos de Notificaciones push.

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

/** Identificador de la notificación push */
  id_notificacion NUMBER,
/** Tag o expresión destino de la notificación push */
  suscripcion VARCHAR2(500),
/** Título de la notificación push */
  titulo VARCHAR2(160),
/** Contenido de la notificación push */
  contenido VARCHAR2(500),
/** Datos extra de la notificación push */
  datos_extra CLOB,

  CONSTRUCTOR FUNCTION y_notificacion RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_notificacion IS

  CONSTRUCTOR FUNCTION y_notificacion RETURN SELF AS RESULT AS
  BEGIN
    self.id_notificacion := NULL;
    self.suscripcion     := NULL;
    self.titulo          := NULL;
    self.contenido       := NULL;
    self.datos_extra     := NULL;
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_objeto      y_notificacion;
    l_json_object json_object_t;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_objeto                 := NEW y_notificacion();
    l_objeto.id_notificacion := l_json_object.get_number('id_notificacion');
    l_objeto.suscripcion     := l_json_object.get_string('suscripcion');
    l_objeto.titulo          := l_json_object.get_string('titulo');
    l_objeto.contenido       := l_json_object.get_string('contenido');
    l_objeto.datos_extra     := l_json_object.get_clob('datos_extra');
  
    RETURN l_objeto;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('id_notificacion', self.id_notificacion);
    l_json_object.put('suscripcion', self.suscripcion);
    l_json_object.put('titulo', self.titulo);
    l_json_object.put('contenido', self.contenido);
    l_json_object.put('datos_extra', self.datos_extra);
  
    RETURN l_json_object.to_clob;
  END;

END;
/
