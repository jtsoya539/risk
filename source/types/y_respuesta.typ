CREATE OR REPLACE TYPE y_respuesta AS OBJECT
(
-- Agrupa datos de respuesta de un proceso
--
-- %author jmeza 9/3/2019 16:28:00

  codigo     VARCHAR2(10), -- Codigo de la respuesta
  mensaje    VARCHAR2(2000), -- Mensaje de la respuesta
  mensaje_bd VARCHAR2(2000), -- Mensaje de Base de Datos
  origen     VARCHAR2(500), -- Origen de la respuesta

  CONSTRUCTOR FUNCTION y_respuesta RETURN SELF AS RESULT,
  MEMBER FUNCTION to_json RETURN VARCHAR2
)
/
CREATE OR REPLACE TYPE BODY y_respuesta IS
  CONSTRUCTOR FUNCTION y_respuesta RETURN SELF AS RESULT AS
  BEGIN
    self.codigo     := '0';
    self.mensaje    := '';
    self.mensaje_bd := '';
    self.origen     := '';
    RETURN;
  END;

  MEMBER FUNCTION to_json RETURN VARCHAR2 IS
  BEGIN
    RETURN '{"codigo":"' || codigo || '", "mensaje":"' || mensaje || '", "mensaje_bd":"' || mensaje_bd || '", "origen":"' || origen || '"}';
  END;
END;
/
