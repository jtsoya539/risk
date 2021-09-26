CREATE OR REPLACE TYPE y_sesion UNDER y_objeto
(
/**
Agrupa datos de una sesi�n.

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

/** Identificador de la sesion */
  id_sesion NUMBER,
/** Estado de la sesion */
  estado CHAR(1),
/** Access Token de la sesion */
  access_token VARCHAR2(4000),
/** Refresh Token de la sesion */
  refresh_token VARCHAR2(4000),
/** Tiempo de expiraci�n del Access Token en segundos */
  tiempo_expiracion_access_token NUMBER(6),
/** Tiempo de expiraci�n del Refresh Token en horas */
  tiempo_expiracion_refresh_token NUMBER(6),

/**
Constructor del objeto sin par�metros.

%author jtsoya539 30/3/2020 10:08:08
%return Objeto del tipo y_sesion.
*/
  CONSTRUCTOR FUNCTION y_sesion RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

/**
Retorna el objeto serializado en formato JSON.
  
%author jtsoya539 30/3/2020 09:42:09
%return JSON con los atributos del objeto.
*/
  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_sesion IS

  CONSTRUCTOR FUNCTION y_sesion RETURN SELF AS RESULT AS
  BEGIN
    self.id_sesion                       := NULL;
    self.estado                          := NULL;
    self.access_token                    := NULL;
    self.refresh_token                   := NULL;
    self.tiempo_expiracion_access_token  := NULL;
    self.tiempo_expiracion_refresh_token := NULL;
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_sesion      y_sesion;
    l_json_object json_object_t;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_sesion                                 := NEW y_sesion();
    l_sesion.id_sesion                       := l_json_object.get_number('id_sesion');
    l_sesion.estado                          := l_json_object.get_string('estado');
    l_sesion.access_token                    := l_json_object.get_string('access_token');
    l_sesion.refresh_token                   := l_json_object.get_string('refresh_token');
    l_sesion.tiempo_expiracion_access_token  := l_json_object.get_number('tiempo_expiracion_access_token');
    l_sesion.tiempo_expiracion_refresh_token := l_json_object.get_number('tiempo_expiracion_refresh_token');
  
    RETURN l_sesion;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('id_sesion', self.id_sesion);
    l_json_object.put('estado', self.estado);
    l_json_object.put('access_token', self.access_token);
    l_json_object.put('refresh_token', self.refresh_token);
    l_json_object.put('tiempo_expiracion_access_token',
                      self.tiempo_expiracion_access_token);
    l_json_object.put('tiempo_expiracion_refresh_token',
                      self.tiempo_expiracion_refresh_token);
    RETURN l_json_object.to_clob;
  END;

END;
/
