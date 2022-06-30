CREATE OR REPLACE PACKAGE k_archivo IS

  /**
  Agrupa operaciones relacionadas con archivos
  
  %author jtsoya539 27/3/2020 16:22:16
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

  -- Carpetas de archivos
  c_carpeta_fuentes  CONSTANT VARCHAR2(30) := 'FUENTES';
  c_carpeta_imagenes CONSTANT VARCHAR2(30) := 'IMAGENES';
  c_carpeta_textos   CONSTANT VARCHAR2(30) := 'TEXTOS';

  FUNCTION f_tipo_mime(i_dominio   IN VARCHAR2,
                       i_extension IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION f_recuperar_archivo(i_tabla      IN VARCHAR2,
                               i_campo      IN VARCHAR2,
                               i_referencia IN VARCHAR2,
                               i_version    IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo;

  PROCEDURE p_guardar_archivo(i_tabla      IN VARCHAR2,
                              i_campo      IN VARCHAR2,
                              i_referencia IN VARCHAR2,
                              i_archivo    IN y_archivo);

  PROCEDURE p_calcular_propiedades(i_contenido IN BLOB,
                                   o_checksum  OUT VARCHAR2,
                                   o_tamano    OUT NUMBER);

  FUNCTION f_version_archivo(i_tabla      IN VARCHAR2,
                             i_campo      IN VARCHAR2,
                             i_referencia IN VARCHAR2) RETURN NUMBER;

  FUNCTION f_data_url(i_contenido IN BLOB,
                      i_tipo_mime IN VARCHAR2) RETURN CLOB;

  FUNCTION f_data_url(i_tabla      IN VARCHAR2,
                      i_campo      IN VARCHAR2,
                      i_referencia IN VARCHAR2,
                      i_version    IN VARCHAR2 DEFAULT NULL) RETURN CLOB;

END;
/
CREATE OR REPLACE PACKAGE BODY k_archivo IS

  FUNCTION f_tipo_mime(i_dominio   IN VARCHAR2,
                       i_extension IN VARCHAR2) RETURN VARCHAR2 IS
    l_referencia t_significados.referencia%TYPE;
  BEGIN
    BEGIN
      SELECT a.referencia
        INTO l_referencia
        FROM t_significados a
       WHERE a.activo = 'S'
         AND a.dominio = i_dominio
         AND upper(a.codigo) = upper(i_extension);
    EXCEPTION
      WHEN OTHERS THEN
        l_referencia := NULL;
    END;
    RETURN l_referencia;
  END;

  FUNCTION f_recuperar_archivo(i_tabla      IN VARCHAR2,
                               i_campo      IN VARCHAR2,
                               i_referencia IN VARCHAR2,
                               i_version    IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo IS
    l_archivo y_archivo;
  BEGIN
    l_archivo := NEW y_archivo();
  
    BEGIN
      SELECT a.contenido,
             a.url,
             a.checksum,
             a.tamano,
             a.nombre,
             a.extension,
             f_tipo_mime(d.extensiones_permitidas, a.extension)
        INTO l_archivo.contenido,
             l_archivo.url,
             l_archivo.checksum,
             l_archivo.tamano,
             l_archivo.nombre,
             l_archivo.extension,
             l_archivo.tipo_mime
        FROM t_archivos a, t_archivo_definiciones d
       WHERE d.tabla = a.tabla
         AND d.campo = a.campo
         AND upper(a.tabla) = upper(i_tabla)
         AND upper(a.campo) = upper(i_campo)
         AND a.referencia = i_referencia
         AND nvl(a.version_actual, 0) =
             nvl(i_version, nvl(a.version_actual, 0));
    EXCEPTION
      WHEN no_data_found THEN
        -- Busca versión en tabla histórica
        BEGIN
          SELECT h.contenido,
                 h.url,
                 h.checksum,
                 h.tamano,
                 h.nombre,
                 h.extension,
                 f_tipo_mime(d.extensiones_permitidas, h.extension)
            INTO l_archivo.contenido,
                 l_archivo.url,
                 l_archivo.checksum,
                 l_archivo.tamano,
                 l_archivo.nombre,
                 l_archivo.extension,
                 l_archivo.tipo_mime
            FROM t_archivos_hist h, t_archivo_definiciones d
           WHERE d.tabla = h.tabla
             AND d.campo = h.campo
             AND upper(h.tabla) = upper(i_tabla)
             AND upper(h.campo) = upper(i_campo)
             AND h.referencia = i_referencia
             AND h.version = nvl(i_version, -1);
        EXCEPTION
          WHEN no_data_found THEN
            raise_application_error(-20000, 'Archivo inexistente');
          WHEN OTHERS THEN
            raise_application_error(-20000, 'Error al recuperar archivo');
        END;
      WHEN OTHERS THEN
        raise_application_error(-20000, 'Error al recuperar archivo');
    END;
  
    RETURN l_archivo;
  END;

  PROCEDURE p_guardar_archivo(i_tabla      IN VARCHAR2,
                              i_campo      IN VARCHAR2,
                              i_referencia IN VARCHAR2,
                              i_archivo    IN y_archivo) IS
    l_version_actual t_archivos.version_actual%TYPE;
  BEGIN
    UPDATE t_archivos a
       SET a.contenido      = i_archivo.contenido,
           a.url            = i_archivo.url,
           a.nombre         = i_archivo.nombre,
           a.extension      = i_archivo.extension,
           a.version_actual = nvl(a.version_actual, 0) + 1
     WHERE upper(a.tabla) = upper(i_tabla)
       AND upper(a.campo) = upper(i_campo)
       AND a.referencia = i_referencia;
  
    IF SQL%NOTFOUND THEN
      SELECT nvl(MAX(h.version), 0) + 1
        INTO l_version_actual
        FROM t_archivos_hist h
       WHERE upper(h.tabla) = upper(i_tabla)
         AND upper(h.campo) = upper(i_campo)
         AND h.referencia = i_referencia;
    
      INSERT INTO t_archivos
        (tabla,
         campo,
         referencia,
         contenido,
         url,
         nombre,
         extension,
         version_actual)
      VALUES
        (upper(i_tabla),
         upper(i_campo),
         i_referencia,
         i_archivo.contenido,
         i_archivo.url,
         i_archivo.nombre,
         i_archivo.extension,
         l_version_actual);
    END IF;
  END;

  PROCEDURE p_calcular_propiedades(i_contenido IN BLOB,
                                   o_checksum  OUT VARCHAR2,
                                   o_tamano    OUT NUMBER) IS
  BEGIN
    IF i_contenido IS NOT NULL THEN
      BEGIN
        o_checksum := rawtohex(as_crypto.hash(i_contenido,
                                              as_crypto.hash_sh1));
      EXCEPTION
        WHEN OTHERS THEN
          o_checksum := NULL;
      END;
    
      BEGIN
        o_tamano := dbms_lob.getlength(i_contenido);
      EXCEPTION
        WHEN OTHERS THEN
          o_tamano := NULL;
      END;
    END IF;
  END;

  FUNCTION f_version_archivo(i_tabla      IN VARCHAR2,
                             i_campo      IN VARCHAR2,
                             i_referencia IN VARCHAR2) RETURN NUMBER IS
    l_version t_archivos.version_actual%TYPE;
  BEGIN
  
    SELECT nvl(a.version_actual, 0)
      INTO l_version
      FROM t_archivos a, t_archivo_definiciones d
     WHERE d.tabla = a.tabla
       AND d.campo = a.campo
       AND upper(a.tabla) = upper(i_tabla)
       AND upper(a.campo) = upper(i_campo)
       AND a.referencia = i_referencia;
  
    RETURN l_version;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  -- https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Data_URIs
  FUNCTION f_data_url(i_contenido IN BLOB,
                      i_tipo_mime IN VARCHAR2) RETURN CLOB IS
    l_data_url CLOB;
    l_base64   CLOB;
  BEGIN
    -- Codifica en formato Base64
    l_base64 := k_util.base64encode(i_contenido);
    -- Elimina caracteres de nueva línea
    l_base64 := REPLACE(l_base64, utl_tcp.crlf);
  
    l_data_url := 'data:' || i_tipo_mime || ';charset=' || k_util.f_charset ||
                  ';base64,' || l_base64;
  
    RETURN l_data_url;
  END;

  FUNCTION f_data_url(i_tabla      IN VARCHAR2,
                      i_campo      IN VARCHAR2,
                      i_referencia IN VARCHAR2,
                      i_version    IN VARCHAR2 DEFAULT NULL) RETURN CLOB IS
    l_archivo y_archivo;
  BEGIN
    -- Recupera el archivo
    l_archivo := f_recuperar_archivo(i_tabla,
                                     i_campo,
                                     i_referencia,
                                     i_version);
  
    RETURN f_data_url(l_archivo.contenido, l_archivo.tipo_mime);
  END;

END;
/
