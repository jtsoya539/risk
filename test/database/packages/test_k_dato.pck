CREATE OR REPLACE PACKAGE test_k_dato IS

  --%suite(Tests unitarios del paquete k_dato)
  --%tags(package)

  --%test(Guarda un dato adicional de tipo string)
  PROCEDURE p_guardar_dato_string_uso_basico;

  --%test(Guarda un dato adicional de tipo number)
  PROCEDURE p_guardar_dato_number_uso_basico;

  --%test(Guarda un dato adicional de tipo boolean)
  PROCEDURE p_guardar_dato_boolean_uso_basico;

  --%test(Guarda un dato adicional de tipo date)
  PROCEDURE p_guardar_dato_date_uso_basico;

  --%test(Guarda un dato adicional de tipo object)
  --%disabled
  PROCEDURE p_guardar_dato_object_uso_basico;

END;
/
CREATE OR REPLACE PACKAGE BODY test_k_dato IS

  PROCEDURE lp_insertar_sistema IS
  BEGIN
    INSERT INTO t_modulos
      (id_modulo, nombre, activo)
    VALUES
      ('TEST', 'SISTEMA DE PRUEBA', 'S');
  END;

  PROCEDURE p_guardar_dato_string_uso_basico IS
    l_cantidad INTEGER;
  BEGIN
    -- Arrange
    INSERT INTO t_dato_definiciones
      (tabla, campo, descripcion, orden, nombre_referencia, tipo_dato)
    VALUES
      ('T_SISTEMAS',
       'MI_STRING',
       'Dato adicional de tipo string',
       1,
       'ID_SISTEMA',
       'S');
    lp_insertar_sistema;
    -- Act
    k_dato.p_guardar_dato_string('T_SISTEMAS',
                                 'MI_STRING',
                                 'TEST',
                                 'qwerty');
    -- Assert
    SELECT COUNT(*)
      INTO l_cantidad
      FROM t_datos
     WHERE tabla = 'T_SISTEMAS'
       AND campo = 'MI_STRING'
       AND referencia = 'TEST';
    ut.expect(l_cantidad).to_be_greater_than(0);
  END;

  PROCEDURE p_guardar_dato_number_uso_basico IS
    l_cantidad INTEGER;
  BEGIN
    -- Arrange
    INSERT INTO t_dato_definiciones
      (tabla, campo, descripcion, orden, nombre_referencia, tipo_dato)
    VALUES
      ('T_SISTEMAS',
       'MI_NUMBER',
       'Dato adicional de tipo number',
       2,
       'ID_SISTEMA',
       'N');
    lp_insertar_sistema;
    -- Act
    k_dato.p_guardar_dato_number('T_SISTEMAS', 'MI_NUMBER', 'TEST', 123);
    -- Assert
    SELECT COUNT(*)
      INTO l_cantidad
      FROM t_datos
     WHERE tabla = 'T_SISTEMAS'
       AND campo = 'MI_NUMBER'
       AND referencia = 'TEST';
    ut.expect(l_cantidad).to_be_greater_than(0);
  END;

  PROCEDURE p_guardar_dato_boolean_uso_basico IS
    l_cantidad INTEGER;
  BEGIN
    -- Arrange
    INSERT INTO t_dato_definiciones
      (tabla, campo, descripcion, orden, nombre_referencia, tipo_dato)
    VALUES
      ('T_SISTEMAS',
       'MI_BOOLEAN',
       'Dato adicional de tipo boolean',
       3,
       'ID_SISTEMA',
       'B');
    lp_insertar_sistema;
    -- Act
    k_dato.p_guardar_dato_boolean('T_SISTEMAS', 'MI_BOOLEAN', 'TEST', TRUE);
    -- Assert
    SELECT COUNT(*)
      INTO l_cantidad
      FROM t_datos
     WHERE tabla = 'T_SISTEMAS'
       AND campo = 'MI_BOOLEAN'
       AND referencia = 'TEST';
    ut.expect(l_cantidad).to_be_greater_than(0);
  END;

  PROCEDURE p_guardar_dato_date_uso_basico IS
    l_cantidad INTEGER;
  BEGIN
    -- Arrange
    INSERT INTO t_dato_definiciones
      (tabla, campo, descripcion, orden, nombre_referencia, tipo_dato)
    VALUES
      ('T_SISTEMAS',
       'MI_DATE',
       'Dato adicional de tipo date',
       4,
       'ID_SISTEMA',
       'D');
    lp_insertar_sistema;
    -- Act
    k_dato.p_guardar_dato_date('T_SISTEMAS',
                               'MI_DATE',
                               'TEST',
                               trunc(SYSDATE));
    -- Assert
    SELECT COUNT(*)
      INTO l_cantidad
      FROM t_datos
     WHERE tabla = 'T_SISTEMAS'
       AND campo = 'MI_DATE'
       AND referencia = 'TEST';
    ut.expect(l_cantidad).to_be_greater_than(0);
  END;

  PROCEDURE p_guardar_dato_object_uso_basico IS
    l_cantidad INTEGER;
    l_dato     y_rol;
  BEGIN
    -- Arrange
    INSERT INTO t_dato_definiciones
      (tabla, campo, descripcion, orden, nombre_referencia, tipo_dato)
    VALUES
      ('T_SISTEMAS',
       'MI_OBJECT',
       'Dato adicional de tipo object',
       5,
       'ID_SISTEMA',
       'O');
    lp_insertar_sistema;
    -- Act
    l_dato        := NEW y_rol();
    l_dato.id_rol := 123;
    l_dato.nombre := 'qwerty';
    k_dato.p_guardar_dato_object('T_SISTEMAS', 'MI_OBJECT', 'TEST', l_dato);
    -- Assert
    SELECT COUNT(*)
      INTO l_cantidad
      FROM t_datos
     WHERE tabla = 'T_SISTEMAS'
       AND campo = 'MI_OBJECT'
       AND referencia = 'TEST';
    ut.expect(l_cantidad).to_be_greater_than(0);
  END;

END;
/
