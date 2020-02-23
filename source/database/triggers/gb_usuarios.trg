CREATE OR REPLACE TRIGGER gb_usuarios
  BEFORE INSERT OR UPDATE OR DELETE ON t_usuarios
  FOR EACH ROW
BEGIN
  -- Valida direccion de correo
  IF inserting OR
     (updating AND :new.direccion_correo <> :old.direccion_correo) THEN
    IF NOT k_mensajeria.f_validar_direccion_correo(:new.direccion_correo) THEN
      raise_application_error(-20000,
                              'Direccion de correo electronico invalida');
    END IF;
  END IF;

  -- Valida numero de telefono
  IF inserting OR
     (updating AND :new.numero_telefono <> :old.numero_telefono) THEN
    IF NOT k_mensajeria.f_validar_numero_telefono(:new.numero_telefono) THEN
      raise_application_error(-20000, 'Numero de telefono invalido');
    END IF;
  END IF;
END;
/
