CREATE OR REPLACE TYPE y_rol UNDER y_serializable
(
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

