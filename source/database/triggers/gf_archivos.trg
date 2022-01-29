CREATE OR REPLACE TRIGGER gf_archivos
  AFTER INSERT OR UPDATE OR DELETE ON t_archivos
  FOR EACH ROW
DECLARE
  l_historico_activo t_archivo_definiciones.historico_activo%TYPE;
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

  IF (updating AND
     nvl(:new.version_actual, 0) <> nvl(:old.version_actual, 0)) OR
     deleting THEN
  
    -- Verifica si el histórico de versiones está activo
    BEGIN
      SELECT d.historico_activo
        INTO l_historico_activo
        FROM t_archivo_definiciones d
       WHERE upper(d.tabla) = upper(:old.tabla)
         AND upper(d.campo) = upper(:old.campo);
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000,
                                'Definición de archivo inexistente');
    END;
  
    IF l_historico_activo = 'S' THEN
      -- Guarda versión anterior en tabla histórica
      INSERT INTO t_archivos_hist
        (tabla,
         campo,
         referencia,
         version,
         contenido,
         url,
         checksum,
         tamano,
         nombre,
         extension)
      VALUES
        (:old.tabla,
         :old.campo,
         :old.referencia,
         nvl(:old.version_actual, 0),
         :old.contenido,
         :old.url,
         :old.checksum,
         :old.tamano,
         :old.nombre,
         :old.extension);
    END IF;
  
  END IF;
END;
/
