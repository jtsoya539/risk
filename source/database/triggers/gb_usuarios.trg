CREATE OR REPLACE TRIGGER gb_usuarios
  BEFORE INSERT OR UPDATE OR DELETE ON t_usuarios
  FOR EACH ROW
BEGIN
  /*
  --------------------------------- MIT License ---------------------------------
  Copyright (c) 2019 jtsoya539
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  -------------------------------------------------------------------------------
  */

  -- Valida alias de usuario
  IF inserting OR
     (updating AND nvl(:new.alias, 'X') <> nvl(:old.alias, 'X')) THEN
    IF NOT k_usuario.f_validar_alias(:new.alias) THEN
      IF nvl(:new.origen, k_autenticacion.c_origen_risk) =
         k_autenticacion.c_origen_risk THEN
        raise_application_error(-20000,
                                'Caracteres no permitidos en el Usuario: ' ||
                                regexp_replace(:new.alias,
                                               TRIM(translate(k_util.f_valor_parametro('REGEXP_VALIDAR_ALIAS_USUARIO'),
                                                              '^$',
                                                              '  ')),
                                               ''));
      ELSE
        raise_application_error(-20000, 'Alias de usuario inválido');
      END IF;
    END IF;
  END IF;

  $if k_modulo.c_instalado_msj $then
  -- Valida dirección de correo
  IF inserting OR (updating AND nvl(:new.direccion_correo, 'X') <>
     nvl(:old.direccion_correo, 'X')) THEN
    IF NOT k_mensajeria.f_validar_direccion_correo(:new.direccion_correo) THEN
      raise_application_error(-20000,
                              'Dirección de correo electrónico inválida');
    END IF;
  END IF;
  $end

  $if k_modulo.c_instalado_msj $then
  -- Valida número de teléfono
  IF inserting OR (updating AND nvl(:new.numero_telefono, 'X') <>
     nvl(:old.numero_telefono, 'X')) THEN
    IF NOT k_mensajeria.f_validar_numero_telefono(:new.numero_telefono) THEN
      raise_application_error(-20000, 'Número de teléfono inválido');
    END IF;
  END IF;
  $end
END;
/
