CREATE OR REPLACE TRIGGER gb_personas
  BEFORE INSERT OR UPDATE OR DELETE ON t_personas
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

  IF inserting OR
     (updating AND nvl(:new.nombre, 'X') <> nvl(:old.nombre, 'X')) THEN
    :new.nombre := upper(:new.nombre);
  END IF;

  IF inserting OR
     (updating AND nvl(:new.apellido, 'X') <> nvl(:old.apellido, 'X')) THEN
    :new.apellido := upper(:new.apellido);
  END IF;

  IF inserting OR (updating AND nvl(:new.nombre_completo, 'X') <>
     nvl(:old.nombre_completo, 'X')) THEN
    :new.nombre_completo := upper(:new.nombre_completo);
  END IF;
END;
/

