CREATE OR REPLACE PACKAGE k_reporte IS

  /**
  Agrupa operaciones relacionadas con reportes del sistema
  
  %author jtsoya539 27/3/2020 16:42:26
  */

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

  FUNCTION f_archivo_ok(i_contenido IN BLOB) RETURN y_archivo;

  FUNCTION f_archivo_error(i_respuesta IN y_respuesta) RETURN y_archivo;

END;
/
CREATE OR REPLACE PACKAGE BODY k_reporte IS

  FUNCTION f_archivo_ok(i_contenido IN BLOB) RETURN y_archivo IS
    l_archivo y_archivo;
  BEGIN
    -- Inicializa archivo
    l_archivo           := NEW y_archivo();
    l_archivo.contenido := i_contenido;
    k_archivo.p_calcular_propiedades(i_contenido,
                                     l_archivo.checksum,
                                     l_archivo.tamano);
    RETURN l_archivo;
  END;

  FUNCTION f_archivo_error(i_respuesta IN y_respuesta) RETURN y_archivo IS
    l_archivo y_archivo;
  BEGIN
    -- Inicializa archivo
    l_archivo := NEW y_archivo();
  
    as_pdf3_v5.init;
    as_pdf3_v5.write('Código: ' || i_respuesta.codigo);
    as_pdf3_v5.write('Mensaje: ' || i_respuesta.mensaje);
    l_archivo.contenido := as_pdf3_v5.get_pdf;
  
    RETURN l_archivo;
  END;

END;
/
