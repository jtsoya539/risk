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
    self.datos      := anydata.convertobject(NEW y_dato());
    RETURN;
  END;

  MEMBER FUNCTION to_json RETURN CLOB IS
    l_json_object  json_object_t;
    l_json_element json_element_t;
  
    FUNCTION lf_datos_json(i_datos IN anydata) RETURN CLOB IS
      l_datos_json CLOB;
    BEGIN
      EXECUTE IMMEDIATE 'DECLARE
  l_retorno       PLS_INTEGER;
  l_datos_anydata anydata := :l_datos_anydata;
  l_datos_object  ' || i_datos.gettypename || ';
  l_datos_clob    CLOB;
BEGIN
  l_retorno     := l_datos_anydata.getobject(obj => l_datos_object);
  :l_datos_clob := l_datos_object.to_json();
END;'
        USING IN i_datos, OUT l_datos_json;
      RETURN l_datos_json;
    END;
  BEGIN
    l_json_element := json_element_t.parse(lf_datos_json(self.datos));
  
    l_json_object := NEW json_object_t();
    l_json_object.put('codigo', self.codigo);
    l_json_object.put('mensaje', self.mensaje);
    l_json_object.put('mensaje_bd', self.mensaje_bd);
    l_json_object.put('lugar', self.lugar);
    l_json_object.put('datos', l_json_element);
    RETURN l_json_object.to_clob;
  END;

END;
/
