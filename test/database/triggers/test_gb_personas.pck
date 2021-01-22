CREATE OR REPLACE PACKAGE test_gb_personas IS

  --%suite(Tests unitarios del trigger gb_personas)
  --%tags(trigger)

  --%test(Guarda el nombre en mayúsculas al insertar)
  PROCEDURE nombre_mayusculas_al_insertar;

  --%test(Guarda el apellido en mayúsculas al insertar)
  PROCEDURE apellido_mayusculas_al_insertar;

  --%test(Guarda el nombre completo en mayúsculas al insertar)
  PROCEDURE nombre_completo_mayusculas_al_insertar;

  --%test(Guarda el nombre en mayúsculas al actualizar)
  PROCEDURE nombre_mayusculas_al_actualizar;

  --%test(Guarda el apellido en mayúsculas al actualizar)
  PROCEDURE apellido_mayusculas_al_actualizar;

  --%test(Guarda el nombre completo en mayúsculas al actualizar)
  PROCEDURE nombre_completo_mayusculas_al_actualizar;

END;
/
CREATE OR REPLACE PACKAGE BODY test_gb_personas IS

  PROCEDURE nombre_mayusculas_al_insertar IS
    l_id_persona t_personas.id_persona%TYPE;
    l_nombre     t_personas.nombre%TYPE;
  BEGIN
    -- Arrange
    SELECT MAX(id_persona) + 1 INTO l_id_persona FROM t_personas;
    -- Act
    INSERT INTO t_personas
      (id_persona, nombre)
    VALUES
      (l_id_persona, 'John')
    RETURNING nombre INTO l_nombre;
    -- Assert
    ut.expect(l_nombre).to_equal('JOHN');
  END;

  PROCEDURE apellido_mayusculas_al_insertar IS
    l_id_persona t_personas.id_persona%TYPE;
    l_apellido   t_personas.apellido%TYPE;
  BEGIN
    -- Arrange
    SELECT MAX(id_persona) + 1 INTO l_id_persona FROM t_personas;
    -- Act
    INSERT INTO t_personas
      (id_persona, apellido)
    VALUES
      (l_id_persona, 'Doe')
    RETURNING apellido INTO l_apellido;
    -- Assert
    ut.expect(l_apellido).to_equal('DOE');
  END;

  PROCEDURE nombre_completo_mayusculas_al_insertar IS
    l_id_persona      t_personas.id_persona%TYPE;
    l_nombre_completo t_personas.nombre_completo%TYPE;
  BEGIN
    -- Arrange
    SELECT MAX(id_persona) + 1 INTO l_id_persona FROM t_personas;
    -- Act
    INSERT INTO t_personas
      (id_persona, nombre_completo)
    VALUES
      (l_id_persona, 'John Doe')
    RETURNING nombre_completo INTO l_nombre_completo;
    -- Assert
    ut.expect(l_nombre_completo).to_equal('JOHN DOE');
  END;

  PROCEDURE nombre_mayusculas_al_actualizar IS
    l_id_persona t_personas.id_persona%TYPE;
    l_nombre     t_personas.nombre%TYPE;
  BEGIN
    -- Arrange
    SELECT MAX(id_persona) + 1 INTO l_id_persona FROM t_personas;
    INSERT INTO t_personas
      (id_persona, nombre)
    VALUES
      (l_id_persona, 'Nombre')
    RETURNING id_persona INTO l_id_persona;
    -- Act
    UPDATE t_personas
       SET nombre = 'John'
     WHERE id_persona = l_id_persona
    RETURNING nombre INTO l_nombre;
    -- Assert
    ut.expect(l_nombre).to_equal('JOHN');
  END;

  PROCEDURE apellido_mayusculas_al_actualizar IS
    l_id_persona t_personas.id_persona%TYPE;
    l_apellido   t_personas.apellido%TYPE;
  BEGIN
    -- Arrange
    SELECT MAX(id_persona) + 1 INTO l_id_persona FROM t_personas;
    INSERT INTO t_personas
      (id_persona, apellido)
    VALUES
      (l_id_persona, 'Apellido')
    RETURNING id_persona INTO l_id_persona;
    -- Act
    UPDATE t_personas
       SET apellido = 'Doe'
     WHERE id_persona = l_id_persona
    RETURNING apellido INTO l_apellido;
    -- Assert
    ut.expect(l_apellido).to_equal('DOE');
  END;

  PROCEDURE nombre_completo_mayusculas_al_actualizar IS
    l_id_persona      t_personas.id_persona%TYPE;
    l_nombre_completo t_personas.nombre_completo%TYPE;
  BEGIN
    -- Arrange
    SELECT MAX(id_persona) + 1 INTO l_id_persona FROM t_personas;
    INSERT INTO t_personas
      (id_persona, nombre_completo)
    VALUES
      (l_id_persona, 'Nombre Apellido')
    RETURNING id_persona INTO l_id_persona;
    -- Act
    UPDATE t_personas
       SET nombre_completo = 'John Doe'
     WHERE id_persona = l_id_persona
    RETURNING nombre_completo INTO l_nombre_completo;
    -- Assert
    ut.expect(l_nombre_completo).to_equal('JOHN DOE');
  END;

END;
/
