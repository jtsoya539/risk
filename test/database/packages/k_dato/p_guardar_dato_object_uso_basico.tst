PL/SQL Developer Test script 3.0
45
DECLARE
  l_cantidad INTEGER;
  l_dato     y_rol;

  c_tabla             CONSTANT VARCHAR2(30) := 'T_MODULOS';
  c_nombre_referencia CONSTANT VARCHAR2(30) := 'ID_MODULO';

  PROCEDURE lp_insertar_modulo IS
  BEGIN
    INSERT INTO t_modulos
      (id_modulo, nombre, activo)
    VALUES
      ('TEST', 'MÓDULO DE PRUEBA', 'S');
  END;
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

  IF l_cantidad > 0 THEN
    :RESULT := 'OK';
  END IF;

  ROLLBACK;
END;
1
result
0
5
0
