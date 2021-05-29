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

  c_tabla             CONSTANT VARCHAR2(30) := 'T_MODULOS';
  c_nombre_referencia CONSTANT VARCHAR2(30) := 'ID_MODULO';

  PROCEDURE lp_insertar_modulo IS
  BEGIN
    INSERT INTO t_modulos
      (id_modulo, nombre, activo)
    VALUES
      ('TEST', 'MÓDULO DE PRUEBA', 'S');
  END;

  PROCEDURE p_guardar_dato_string_uso_basico IS
    l_cantidad INTEGER;
  BEGIN
    -- Arrange
    INSERT INTO t_dato_definiciones
      (tabla, campo, descripcion, orden, nombre_referencia, tipo_dato)
    VALUES
      (c_tabla,
       'MI_STRING',
       'Dato adicional de tipo string',
       1,
       c_nombre_referencia,
       'S');
    lp_insertar_modulo;
    -- Act
    k_dato.p_guardar_dato_string(c_tabla, 'MI_STRING', 'TEST', 'qwerty');
    -- Assert
    SELECT COUNT(*)
      INTO l_cantidad
      FROM t_datos
     WHERE tabla = c_tabla
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
      (c_tabla,
       'MI_NUMBER',
       'Dato adicional de tipo number',
       2,
       c_nombre_referencia,
       'N');
    lp_insertar_modulo;
    -- Act
    k_dato.p_guardar_dato_number(c_tabla, 'MI_NUMBER', 'TEST', 123);
    -- Assert
    SELECT COUNT(*)
      INTO l_cantidad
      FROM t_datos
     WHERE tabla = c_tabla
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
      (c_tabla,
       'MI_BOOLEAN',
       'Dato adicional de tipo boolean',
       3,
       c_nombre_referencia,
       'B');
    lp_insertar_modulo;
    -- Act
    k_dato.p_guardar_dato_boolean(c_tabla, 'MI_BOOLEAN', 'TEST', TRUE);
    -- Assert
    SELECT COUNT(*)
      INTO l_cantidad
      FROM t_datos
     WHERE tabla = c_tabla
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
      (c_tabla,
       'MI_DATE',
       'Dato adicional de tipo date',
       4,
       c_nombre_referencia,
       'D');
    lp_insertar_modulo;
    -- Act
    k_dato.p_guardar_dato_date(c_tabla, 'MI_DATE', 'TEST', trunc(SYSDATE));
    -- Assert
    SELECT COUNT(*)
      INTO l_cantidad
      FROM t_datos
     WHERE tabla = c_tabla
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
      (c_tabla,
       'MI_OBJECT',
       'Dato adicional de tipo object',
       5,
       c_nombre_referencia,
       'O');
    lp_insertar_modulo;
    -- Act
    l_dato        := NEW y_rol();
    l_dato.id_rol := 123;
    l_dato.nombre := 'qwerty';
    k_dato.p_guardar_dato_object(c_tabla, 'MI_OBJECT', 'TEST', l_dato);
    -- Assert
    SELECT COUNT(*)
      INTO l_cantidad
      FROM t_datos
     WHERE tabla = c_tabla
       AND campo = 'MI_OBJECT'
       AND referencia = 'TEST';
    ut.expect(l_cantidad).to_be_greater_than(0);
  END;

END;
/
