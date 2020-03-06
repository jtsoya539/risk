CREATE OR REPLACE TYPE y_usuario UNDER y_serializable
(
  id_usuario       NUMBER(10), -- Identificador del usuario
  alias            VARCHAR2(300), -- Alias del usuario (identificador para autenticacion)
  nombre           VARCHAR2(100), -- Nombre de la persona
  apellido         VARCHAR2(100), -- Apellido de la persona
  tipo_persona     CHAR(1), -- Tipo de la persona
  estado           CHAR(1), -- Estado del usuario
  direccion_correo VARCHAR2(320), -- Direccion de correo electronico principal del usuario
  numero_telefono  VARCHAR2(160), -- Numero de telefono principal del usuario
  roles            y_roles, -- Roles del usuario

  CONSTRUCTOR FUNCTION y_usuario RETURN SELF AS RESULT,
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
    self.roles            := NEW y_roles();
    RETURN;
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
  
    l_json_array := NEW json_array_t();
    i            := self.roles.first;
    WHILE i IS NOT NULL LOOP
      l_json_array.append(json_object_t.parse(self.roles(i).to_json));
      i := self.roles.next(i);
    END LOOP;
    l_json_object.put('roles', l_json_array);
  
    RETURN l_json_object.to_clob;
  END;

END;
/
