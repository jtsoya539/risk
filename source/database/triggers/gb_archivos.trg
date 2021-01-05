CREATE OR REPLACE TRIGGER gb_archivos
  BEFORE INSERT OR UPDATE OR DELETE ON t_archivos
  FOR EACH ROW
DECLARE
  l_existe_registro        VARCHAR2(1);
  l_nombre_referencia      t_archivo_definiciones.nombre_referencia%TYPE;
  l_tamano_maximo          t_archivo_definiciones.tamano_maximo%TYPE;
  l_extensiones_permitidas t_archivo_definiciones.extensiones_permitidas%TYPE;
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

  IF inserting OR updating THEN
  
    -- Valida definición
    BEGIN
      SELECT d.nombre_referencia, d.tamano_maximo, d.extensiones_permitidas
        INTO l_nombre_referencia, l_tamano_maximo, l_extensiones_permitidas
        FROM t_archivo_definiciones d
       WHERE upper(d.tabla) = upper(:new.tabla)
         AND upper(d.campo) = upper(:new.campo);
    EXCEPTION
      WHEN no_data_found THEN
        raise_application_error(-20000,
                                'Definición de archivo inexistente');
    END;
  
    -- Valida registro relacionado
    IF l_nombre_referencia IS NOT NULL THEN
      EXECUTE IMMEDIATE 'DECLARE
  l_existe VARCHAR2(1) := ''N'';
BEGIN
  BEGIN
    SELECT ''S''
      INTO l_existe
      FROM ' || :new.tabla || '
     WHERE to_char(' || l_nombre_referencia || ') = :1;
  EXCEPTION
    WHEN no_data_found THEN
      l_existe := ''N'';
    WHEN too_many_rows THEN
      l_existe := ''S'';
    WHEN OTHERS THEN
      l_existe := ''N'';
  END;
  :2 := l_existe;
END;'
        USING IN :new.referencia, OUT l_existe_registro;
    
      IF l_existe_registro = 'N' THEN
        raise_application_error(-20000, 'Registro relacionado inexistente');
      END IF;
    END IF;
  
    IF :new.contenido IS NOT NULL OR :new.url IS NOT NULL THEN
      -- Valida nombre del archivo
      IF :new.nombre IS NULL THEN
        raise_application_error(-20000, 'Nombre del archivo obligatorio');
      END IF;
    
      -- Valida extensión del archivo
      IF :new.extension IS NULL THEN
        raise_application_error(-20000,
                                'Extensión del archivo obligatorio');
      END IF;
    
      IF l_extensiones_permitidas IS NOT NULL THEN
        IF k_archivo.f_tipo_mime(l_extensiones_permitidas, :new.extension) IS NULL THEN
          raise_application_error(-20000,
                                  'Extensión de archivo no permitida');
        END IF;
      END IF;
    END IF;
  
    IF :new.contenido IS NULL OR dbms_lob.getlength(:new.contenido) = 0 THEN
      :new.checksum := NULL;
      :new.tamano   := NULL;
    ELSE
      -- Calcula propiedades del archivo
      IF :old.contenido IS NULL OR
         dbms_lob.compare(:old.contenido, :new.contenido) <> 0 THEN
        k_archivo.p_calcular_propiedades(:new.contenido,
                                         :new.checksum,
                                         :new.tamano);
      END IF;
    
      -- Valida tamaño del archivo
      IF nvl(:new.tamano, 0) > nvl(l_tamano_maximo, 0) THEN
        raise_application_error(-20000,
                                'Archivo supera el tamaño máximo (' ||
                                TRIM(to_char(l_tamano_maximo / 1000000,
                                             '999G999G999D99')) || ' MB)');
      END IF;
    END IF;
  
  END IF;

END;
/
