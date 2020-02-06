CREATE OR REPLACE TYPE y_parametro AS OBJECT
(
  nombre VARCHAR2(100), -- Nombre del parametro
  valor  anydata,

  CONSTRUCTOR FUNCTION y_parametro RETURN SELF AS RESULT,
  MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_parametro IS

  CONSTRUCTOR FUNCTION y_parametro RETURN SELF AS RESULT AS
  BEGIN
    self.nombre := NULL;
    self.valor  := NULL;
    RETURN;
  END;

  MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('nombre', self.nombre);
    IF k_util.f_json_objeto(self.valor) IS NOT NULL THEN
      l_json_object.put('valor',
                        json_element_t.parse(k_util.f_json_objeto(self.valor)));
    ELSE
      l_json_object.put_null('valor');
    END IF;
    RETURN l_json_object.to_clob;
  END;

END;
/
