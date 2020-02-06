CREATE OR REPLACE TYPE y_respuesta AS OBJECT
(
-- Agrupa datos de respuesta de un proceso
--
-- %author jmeza 9/3/2019 16:28:00

  codigo     VARCHAR2(10), -- Codigo de la respuesta
  mensaje    VARCHAR2(4000), -- Mensaje de la respuesta
  mensaje_bd VARCHAR2(4000), -- Mensaje de Base de Datos
  lugar      VARCHAR2(1000), -- Lugar en el proceso
  datos      anydata, -- Datos adicionales

  CONSTRUCTOR FUNCTION y_respuesta RETURN SELF AS RESULT,
  MEMBER FUNCTION to_json RETURN CLOB
)
/
CREATE OR REPLACE TYPE BODY y_respuesta IS

  CONSTRUCTOR FUNCTION y_respuesta RETURN SELF AS RESULT AS
  BEGIN
    self.codigo     := '0';
    self.mensaje    := 'OK';
    self.mensaje_bd := NULL;
    self.lugar      := NULL;
    self.datos      := NULL;
    RETURN;
  END;

  MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object json_object_t;
  BEGIN
    l_json_object := NEW json_object_t();
    l_json_object.put('codigo', self.codigo);
    l_json_object.put('mensaje', self.mensaje);
    l_json_object.put('mensaje_bd', self.mensaje_bd);
    l_json_object.put('lugar', self.lugar);
    IF k_util.f_json_objeto(self.datos) IS NOT NULL THEN
      l_json_object.put('datos',
                        json_element_t.parse(k_util.f_json_objeto(self.datos)));
    ELSE
      l_json_object.put_null('datos');
    END IF;
    RETURN l_json_object.to_clob;
  END;

END;
/
