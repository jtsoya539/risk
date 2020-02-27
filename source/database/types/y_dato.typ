CREATE OR REPLACE TYPE y_dato AS OBJECT
(
-- Contiene un dato simple en formato de texto
--
-- %author jmeza 9/3/2019 16:28:00

  dato CLOB,

  CONSTRUCTOR FUNCTION y_dato RETURN SELF AS RESULT,
  MEMBER FUNCTION to_json RETURN CLOB
)
/

CREATE OR REPLACE TYPE BODY y_dato IS

  CONSTRUCTOR FUNCTION y_dato RETURN SELF AS RESULT AS
  BEGIN
    self.dato := NULL;
    RETURN;
  END;

  MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('dato', self.dato);
    RETURN l_json_object.to_clob;
  END;

END;
/

