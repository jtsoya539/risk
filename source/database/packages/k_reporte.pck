CREATE OR REPLACE PACKAGE k_reporte IS

  /**
  Agrupa operaciones relacionadas con los reportes del sistema
  
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

  -- Formatos de salida
  c_formato_pdf  CONSTANT VARCHAR2(10) := 'PDF';
  c_formato_docx CONSTANT VARCHAR2(10) := 'DOCX';
  c_formato_xlsx CONSTANT VARCHAR2(10) := 'XLSX';
  c_formato_txt  CONSTANT VARCHAR2(10) := 'TXT';

  FUNCTION f_archivo_ok(i_contenido IN BLOB,
                        i_formato   IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo;

  FUNCTION f_archivo_error(i_respuesta IN y_respuesta,
                           i_formato   IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo;

END;
/
CREATE OR REPLACE PACKAGE BODY k_reporte IS

  FUNCTION f_archivo_ok(i_contenido IN BLOB,
                        i_formato   IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo IS
    l_archivo y_archivo;
    l_formato VARCHAR2(10);
  BEGIN
    -- Inicializa archivo
    l_archivo := NEW y_archivo();
  
    l_formato := upper(nvl(i_formato,
                           k_util.f_valor_parametro('REPORTE_FORMATO_SALIDA_DEFECTO')));
  
    l_archivo.contenido := i_contenido;
    k_archivo.p_calcular_propiedades(l_archivo.contenido,
                                     l_archivo.checksum,
                                     l_archivo.tamano);
    l_archivo.nombre    := lower(k_sistema.f_valor_parametro_string(k_sistema.c_nombre_servicio) ||
                                 to_char(SYSDATE, '_YYYYMMDD_HH24MISS'));
    l_archivo.extension := lower(l_formato);
    l_archivo.tipo_mime := k_archivo.f_tipo_mime('EXTENSION_REPORTE',
                                                 l_formato);
  
    RETURN l_archivo;
  END;

  FUNCTION f_archivo_error(i_respuesta IN y_respuesta,
                           i_formato   IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo IS
    l_archivo y_archivo;
    l_formato VARCHAR2(10);
  BEGIN
    -- Inicializa archivo
    l_archivo := NEW y_archivo();
  
    l_formato := upper(nvl(i_formato,
                           k_util.f_valor_parametro('REPORTE_FORMATO_SALIDA_DEFECTO')));
  
    CASE l_formato
      WHEN c_formato_pdf THEN
        -- PDF
        as_pdf3_v5.init;
        as_pdf3_v5.set_page_format('A4');
        as_pdf3_v5.set_page_orientation('PORTRAIT');
        as_pdf3_v5.set_margins(25, 30, 25, 30, 'mm');
      
        as_pdf3_v5.put_image(p_img    => k_archivo.f_recuperar_archivo('T_IMAGENES','ARCHIVO','x-mark-5-256.jpg').contenido,
                             p_x      => 30,
                             p_y      => 272,
                             p_width  => 10,
                             p_height => 10,
                             p_um     => 'mm');
      
        as_pdf3_v5.write('Código: ' || i_respuesta.codigo, 'mm', 45);
        as_pdf3_v5.write(utl_tcp.crlf);
        as_pdf3_v5.write('Mensaje: ' || i_respuesta.mensaje, 'mm', 45);
        l_archivo.contenido := as_pdf3_v5.get_pdf;
      
      ELSE
        raise_application_error(-20000, 'Formato de salida no soportado');
    END CASE;
  
    k_archivo.p_calcular_propiedades(l_archivo.contenido,
                                     l_archivo.checksum,
                                     l_archivo.tamano);
    l_archivo.nombre    := lower(k_sistema.f_valor_parametro_string(k_sistema.c_nombre_servicio) ||
                                 to_char(SYSDATE, '_YYYYMMDD_HH24MISS'));
    l_archivo.extension := lower(l_formato);
    l_archivo.tipo_mime := k_archivo.f_tipo_mime('EXTENSION_REPORTE',
                                                 l_formato);
  
    RETURN l_archivo;
  END;

END;
/
