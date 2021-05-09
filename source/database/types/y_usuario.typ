CREATE OR REPLACE TYPE y_usuario UNDER y_objeto
(
/**
Agrupa datos de un usuario.

%author jtsoya539 30/3/2020 10:57:43
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

/** Identificador del usuario */
  id_usuario NUMBER(10),
/** Alias del usuario (identificador para autenticacion) */
  alias VARCHAR2(300),
/** Nombre de la persona */
  nombre VARCHAR2(100),
/** Apellido de la persona */
  apellido VARCHAR2(100),
/** Tipo de la persona */
  tipo_persona CHAR(1),
/** Estado del usuario */
  estado CHAR(1),
/** Direccion de correo electronico principal del usuario */
  direccion_correo VARCHAR2(320),
/** Numero de telefono principal del usuario */
  numero_telefono VARCHAR2(160),
/** Version del avatar del usuario */
  version_avatar NUMBER(10),
/** Origen del usuario */
  origen CHAR(1),
/** Roles del usuario */
  roles y_objetos,

/**
Constructor del objeto sin parámetros.

%author jtsoya539 30/3/2020 10:08:08
%return Objeto del tipo y_usuario.
*/
  CONSTRUCTOR FUNCTION y_usuario RETURN SELF AS RESULT,

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto,

/**
Retorna el objeto serializado en formato JSON.
  
%author jtsoya539 30/3/2020 09:42:09
%return JSON con los atributos del objeto.
*/
  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_usuario IS

  CONSTRUCTOR FUNCTION y_usuario RETURN SELF AS RESULT AS
  BEGIN
    self.id_usuario       := NULL;
    self.alias            := NULL;
    self.nombre           := NULL;
    self.apellido         := NULL;
    self.tipo_persona     := NULL;
    self.estado           := NULL;
    self.direccion_correo := NULL;
    self.numero_telefono  := NULL;
    self.version_avatar   := NULL;
    self.origen           := NULL;
    self.roles            := NEW y_objetos();
    RETURN;
  END;

  STATIC FUNCTION parse_json(i_json IN CLOB) RETURN y_objeto IS
    l_usuario     y_usuario;
    l_json_object json_object_t;
    l_rol         y_rol;
    l_roles       y_objetos;
    l_json_array  json_array_t;
  BEGIN
    l_json_object := json_object_t.parse(i_json);
  
    l_usuario                  := NEW y_usuario();
    l_usuario.id_usuario       := l_json_object.get_number('id_usuario');
    l_usuario.alias            := l_json_object.get_string('alias');
    l_usuario.nombre           := l_json_object.get_string('nombre');
    l_usuario.apellido         := l_json_object.get_string('apellido');
    l_usuario.tipo_persona     := l_json_object.get_string('tipo_persona');
    l_usuario.estado           := l_json_object.get_string('estado');
    l_usuario.direccion_correo := l_json_object.get_string('direccion_correo');
    l_usuario.numero_telefono  := l_json_object.get_string('numero_telefono');
    l_usuario.version_avatar   := l_json_object.get_string('version_avatar');
    l_usuario.origen           := l_json_object.get_string('origen');
  
    l_json_array := l_json_object.get_array('roles');
  
    IF l_json_array IS NULL THEN
      l_usuario.roles := NEW y_objetos();
    ELSE
      l_roles := NEW y_objetos();
      FOR i IN 0 .. l_json_array.get_size - 1 LOOP
        l_rol := NEW y_rol();
        l_rol := treat(y_rol.parse_json(l_json_array.get(i).to_clob) AS
                       y_rol);
        l_roles.extend;
        l_roles(l_roles.count) := l_rol;
      END LOOP;
      l_usuario.roles := l_roles;
    END IF;
  
    RETURN l_usuario;
  END;

  OVERRIDING MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
    l_json_array  json_array_t;
    i             INTEGER;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('id_usuario', self.id_usuario);
    l_json_object.put('alias', self.alias);
    l_json_object.put('nombre', self.nombre);
    l_json_object.put('apellido', self.apellido);
    l_json_object.put('tipo_persona', self.tipo_persona);
    l_json_object.put('estado', self.estado);
    l_json_object.put('direccion_correo', self.direccion_correo);
    l_json_object.put('numero_telefono', self.numero_telefono);
    l_json_object.put('version_avatar', self.version_avatar);
    l_json_object.put('origen', self.origen);
  
    IF self.roles IS NULL THEN
      l_json_object.put_null('roles');
    ELSE
      l_json_array := NEW json_array_t();
      i            := self.roles.first;
      WHILE i IS NOT NULL LOOP
        l_json_array.append(json_object_t.parse(self.roles(i).to_json));
        i := self.roles.next(i);
      END LOOP;
      l_json_object.put('roles', l_json_array);
    END IF;
  
    RETURN l_json_object.to_clob;
  END;

END;
/
