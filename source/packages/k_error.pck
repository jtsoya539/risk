CREATE OR REPLACE PACKAGE k_error IS

  -- Agrupa operaciones relacionadas con los errores del sistema
  --
  -- %author jmeza 25/3/2019 21:04:47

  -- Tipos de error
  oracle_predefined_error CONSTANT VARCHAR2(3) := 'OPE';
  user_defined_error      CONSTANT VARCHAR2(3) := 'UDE';

  FUNCTION f_tipo_error(i_sqlcode IN NUMBER) RETURN VARCHAR2;

  -- Retorna el mensaje de un error de BD
  --
  -- %param i_sqlerrm Mensaje de error de BD
  -- %param i_sqlcode Codigo de error de BD
  -- %return Mensaje de error
  FUNCTION f_mensaje_error(i_sqlerrm IN VARCHAR2,
                           i_sqlcode IN NUMBER DEFAULT NULL) RETURN VARCHAR2;

END;
/

CREATE OR REPLACE PACKAGE BODY k_error IS

  FUNCTION f_tipo_error(i_sqlcode IN NUMBER) RETURN VARCHAR2 IS
    l_tipo_error VARCHAR2(3);
  BEGIN
    IF i_sqlcode >= -20999 AND i_sqlcode <= -20000 THEN
      l_tipo_error := user_defined_error;
    ELSE
      l_tipo_error := oracle_predefined_error;
    END IF;
    RETURN l_tipo_error;
  END;

  FUNCTION f_mensaje_error(i_sqlerrm IN VARCHAR2,
                           i_sqlcode IN NUMBER DEFAULT NULL) RETURN VARCHAR2 IS
    l_posicion NUMBER := instr(i_sqlerrm, 'ORA-', 1, 2);
  BEGIN
    IF l_posicion > 12 THEN
      RETURN REPLACE(substr(REPLACE(i_sqlerrm, '"', ' '),
                            1,
                            l_posicion - 2),
                     'ORA' || to_char(nvl(i_sqlcode, -20000)) || ':',
                     '');
    ELSE
      RETURN TRIM(REPLACE(REPLACE(i_sqlerrm, '"', ' '),
                          'ORA' || to_char(nvl(i_sqlcode, -20000)) || ':'));
    END IF;
  END;

BEGIN
  -- Initialization
  NULL;
END;
/

