CREATE OR REPLACE TRIGGER gf_operaciones
  AFTER INSERT OR UPDATE OR DELETE ON t_operaciones
  FOR EACH ROW
DECLARE
  l_id_permiso_old t_permisos.id_permiso%TYPE;
  l_id_permiso_new t_permisos.id_permiso%TYPE;
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

  l_id_permiso_old := upper(k_significado.f_significado_codigo('TIPO_OPERACION',
                                                               :old.tipo) || ':' ||
                            :old.dominio || ':' || :old.nombre);
  l_id_permiso_new := upper(k_significado.f_significado_codigo('TIPO_OPERACION',
                                                               :new.tipo) || ':' ||
                            :new.dominio || ':' || :new.nombre);

  IF inserting THEN
  
    IF :new.tipo IN ('S', 'R') THEN
      -- SERVICIO, REPORTE
      INSERT INTO t_permisos
        (id_permiso, descripcion, detalle)
      VALUES
        (l_id_permiso_new, NULL, NULL);
    END IF;
  
  ELSIF updating AND (nvl(:new.tipo, 'X') <> nvl(:old.tipo, 'X') OR
        nvl(:new.nombre, 'X') <> nvl(:old.nombre, 'X') OR
        nvl(:new.dominio, 'X') <> nvl(:old.dominio, 'X')) THEN
  
    IF :old.tipo IN ('S', 'R') THEN
      -- SERVICIO, REPORTE
      DELETE t_rol_permisos WHERE id_permiso = l_id_permiso_old;
      DELETE t_permisos WHERE id_permiso = l_id_permiso_old;
    END IF;
  
    IF :new.tipo IN ('S', 'R') THEN
      -- SERVICIO, REPORTE
      INSERT INTO t_permisos
        (id_permiso, descripcion, detalle)
      VALUES
        (l_id_permiso_new, NULL, NULL);
    END IF;
  
  ELSIF deleting THEN
  
    IF :old.tipo IN ('S', 'R') THEN
      -- SERVICIO, REPORTE
      DELETE t_rol_permisos WHERE id_permiso = l_id_permiso_old;
      DELETE t_permisos WHERE id_permiso = l_id_permiso_old;
    END IF;
  
  END IF;
END;
/
