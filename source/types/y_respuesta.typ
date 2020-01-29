CREATE OR REPLACE TYPE y_respuesta AS OBJECT
(
-- Agrupa datos de respuesta de un proceso
--
-- %author jmeza 9/3/2019 16:28:00

  codigo     VARCHAR2(10), -- Codigo de la respuesta
  mensaje    VARCHAR2(2000), -- Mensaje de la respuesta
  mensaje_bd VARCHAR2(2000), -- Mensaje de Base de Datos
  origen     VARCHAR2(500), -- Origen de la respuesta
  datos      CLOB, -- Datos

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
    self.origen     := NULL;
    self.datos      := NULL;
    RETURN;
  END;

  MEMBER FUNCTION to_json RETURN CLOB IS
    l_json json_object_t;
  BEGIN
    l_json := json_object_t;
    l_json.put('codigo', self.codigo);
    l_json.put('mensaje', self.mensaje);
    l_json.put('mensaje_bd', self.mensaje_bd);
    l_json.put('origen', self.origen);
    l_json.put('datos', self.datos);
    RETURN l_json.to_clob;
  END;
END;
/

