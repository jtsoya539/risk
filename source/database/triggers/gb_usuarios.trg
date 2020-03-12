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
