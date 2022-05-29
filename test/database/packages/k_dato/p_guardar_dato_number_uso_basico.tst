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
