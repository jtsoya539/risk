PL/SQL Developer Test script 3.0
41
DECLARE
  l_cantidad INTEGER;

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

  IF l_cantidad > 0 THEN
    :RESULT := 'OK';
  END IF;

  ROLLBACK;
END;
1
result
1
OK
5
0
