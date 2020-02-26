CREATE OR REPLACE TRIGGER gb_usuarios
  BEFORE INSERT OR UPDATE OR DELETE ON t_usuarios
  FOR EACH ROW
BEGIN
  -- Valida direccion de correo
  IF inserting OR (updating AND nvl(:new.direccion_correo, 'X') <>
     nvl(:old.direccion_correo, 'X')) THEN
    IF NOT k_mensajeria.f_validar_direccion_correo(:new.direccion_correo) THEN
      raise_application_error(-20000,
                              'Direccion de correo electronico invalida');
    END IF;
  END IF;

  -- Valida numero de telefono
  IF inserting OR (updating AND nvl(:new.numero_telefono, 'X') <>
     nvl(:old.numero_telefono, 'X')) THEN
    IF NOT k_mensajeria.f_validar_numero_telefono(:new.numero_telefono) THEN
      raise_application_error(-20000, 'Numero de telefono invalido');
    END IF;
  END IF;
END;
/
