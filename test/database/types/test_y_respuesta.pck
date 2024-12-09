CREATE OR REPLACE PACKAGE test_y_respuesta IS

  --%suite(Tests unitarios del type y_respuesta)
  --%tags(type)

  --%test()
  PROCEDURE parse_json_generico;

END;
/
CREATE OR REPLACE PACKAGE BODY test_y_respuesta IS

  PROCEDURE parse_json_generico IS
    l_respuesta y_respuesta;
    l_error     y_error;
    l_resultado y_objeto;
  BEGIN
    -- Arrange
    l_respuesta       := NEW y_respuesta();
    l_error           := NEW y_error();
    l_error.clave     := '0001';
    l_error.mensaje   := 'Este es un mensaje';
    l_respuesta.datos := l_error;
    --
    k_sistema.p_inicializar_cola;
    k_sistema.p_encolar('Y_ERROR');
    -- Act
    l_resultado := y_respuesta.parse_json(l_respuesta.to_json);
    -- Assert
    ut.expect(l_resultado.to_json).to_equal(l_respuesta.to_json);
  END;

END;
/
