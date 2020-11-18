CREATE OR REPLACE PACKAGE k_reporte IS

  /**
  Agrupa operaciones relacionadas con los Reportes del sistema
  
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

  PROCEDURE p_limpiar_historial;

  FUNCTION f_archivo_ok(i_contenido IN BLOB,
                        i_formato   IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo;

  FUNCTION f_archivo_error(i_respuesta IN y_respuesta,
                           i_formato   IN VARCHAR2 DEFAULT NULL)
    RETURN y_archivo;

  FUNCTION f_procesar_reporte(i_id_reporte IN NUMBER,
                              i_parametros IN CLOB,
                              i_contexto   IN CLOB DEFAULT NULL) RETURN CLOB;

  FUNCTION f_procesar_reporte(i_nombre     IN VARCHAR2,
                              i_dominio    IN VARCHAR2,
                              i_parametros IN CLOB,
                              i_contexto   IN CLOB DEFAULT NULL) RETURN CLOB;

END;
/
CREATE OR REPLACE PACKAGE BODY k_reporte IS

  PROCEDURE lp_registrar_ejecucion(i_id_reporte IN NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE t_reportes
       SET cantidad_ejecuciones   = nvl(cantidad_ejecuciones, 0) + 1,
           fecha_ultima_ejecucion = SYSDATE
     WHERE id_reporte = i_id_reporte;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  FUNCTION lf_procesar_reporte(i_id_reporte IN NUMBER,
                               i_parametros IN CLOB,
                               i_contexto   IN CLOB DEFAULT NULL)
    RETURN y_respuesta IS
    l_rsp             y_respuesta;
    l_prms            y_parametros;
    l_ctx             y_parametros;
    l_archivo         y_archivo;
    l_nombre_reporte  t_operaciones.nombre%TYPE;
    l_dominio_reporte t_operaciones.dominio%TYPE;
    l_sentencia       VARCHAR2(4000);
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Buscando datos del reporte';
    BEGIN
      SELECT upper(o.nombre), upper(o.dominio)
        INTO l_nombre_reporte, l_dominio_reporte
        FROM t_reportes r, t_operaciones o
       WHERE o.id_operacion = r.id_reporte
         AND o.activo = 'S'
         AND r.id_reporte = i_id_reporte;
    EXCEPTION
      WHEN no_data_found THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     k_servicio.c_servicio_no_implementado,
                                     'Servicio inexistente o inactivo');
        RAISE k_servicio.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Procesando parámetros del reporte';
    BEGIN
      l_prms := k_operacion.f_procesar_parametros(i_id_reporte,
                                                  i_parametros);
    EXCEPTION
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     k_servicio.c_error_parametro,
                                     CASE
                                     k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                                     k_error.c_user_defined_error THEN
                                     utl_call_stack.error_msg(1) WHEN
                                     k_error.c_oracle_predefined_error THEN
                                     k_error.f_mensaje_error(k_servicio.c_error_parametro) END,
                                     dbms_utility.format_error_stack);
        RAISE k_servicio.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Procesando contexto';
    BEGIN
      l_ctx := k_operacion.f_procesar_parametros(k_operacion.c_id_operacion_contexto,
                                                 i_contexto);
    EXCEPTION
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     k_servicio.c_error_parametro,
                                     CASE
                                     k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                                     k_error.c_user_defined_error THEN
                                     utl_call_stack.error_msg(1) WHEN
                                     k_error.c_oracle_predefined_error THEN
                                     k_error.f_mensaje_error(k_servicio.c_error_parametro) END,
                                     dbms_utility.format_error_stack);
        RAISE k_servicio.ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Definiendo parámetros en la sesión';
    k_sistema.p_inicializar_parametros;
    k_sistema.p_definir_parametro_string(k_sistema.c_direccion_ip,
                                         k_operacion.f_valor_parametro_string(l_ctx,
                                                                              'direccion_ip'));
    k_sistema.p_definir_parametro_number(k_sistema.c_id_servicio,
                                         i_id_reporte);
    k_sistema.p_definir_parametro_string(k_sistema.c_nombre_servicio,
                                         l_nombre_reporte);
    k_sistema.p_definir_parametro_string(k_sistema.c_id_aplicacion,
                                         k_aplicacion.f_id_aplicacion(k_operacion.f_valor_parametro_string(l_ctx,
                                                                                                           'clave_aplicacion'),
                                                                      'S'));
    k_sistema.p_definir_parametro_number(k_sistema.c_id_sesion,
                                         k_sesion.f_id_sesion(k_operacion.f_valor_parametro_string(l_ctx,
                                                                                                   'access_token')));
    k_sistema.p_definir_parametro_number(k_sistema.c_id_usuario,
                                         k_usuario.f_id_usuario(k_operacion.f_valor_parametro_string(l_ctx,
                                                                                                     'usuario')));
    k_sistema.p_definir_parametro_string(k_sistema.c_usuario,
                                         k_operacion.f_valor_parametro_string(l_ctx,
                                                                              'usuario'));
  
    l_rsp.lugar := 'Validando permiso';
    IF k_sistema.f_valor_parametro_number(k_sistema.c_id_usuario) IS NOT NULL THEN
      IF NOT
          k_autorizacion.f_validar_permiso(k_sistema.f_valor_parametro_number(k_sistema.c_id_usuario),
                                           k_operacion.f_id_permiso(i_id_reporte)) THEN
        k_servicio. p_respuesta_error(l_rsp,
                                      k_servicio.c_error_permiso,
                                      k_error.f_mensaje_error(k_servicio.c_error_permiso));
        RAISE k_servicio.ex_error_general;
      END IF;
    END IF;
  
    l_rsp.lugar := 'Construyendo sentencia';
    l_sentencia := 'BEGIN :1 := K_REPORTE_' || l_dominio_reporte || '.' ||
                   l_nombre_reporte || '(:2); END;';
  
    l_rsp.lugar := 'Procesando reporte';
    BEGIN
      EXECUTE IMMEDIATE l_sentencia
        USING OUT l_archivo, IN l_prms;
    EXCEPTION
      WHEN k_servicio.ex_servicio_no_implementado THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     k_servicio.c_servicio_no_implementado,
                                     'Servicio no implementado',
                                     dbms_utility.format_error_stack);
        RAISE k_servicio.ex_error_general;
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'api0004',
                                     CASE
                                     k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                                     k_error.c_user_defined_error THEN
                                     utl_call_stack.error_msg(1) WHEN
                                     k_error.c_oracle_predefined_error THEN
                                     'Error al procesar servicio' END,
                                     dbms_utility.format_error_stack);
        RAISE k_servicio.ex_error_general;
    END;
  
    l_rsp.datos := l_archivo;
  
    IF l_rsp.codigo = k_servicio.c_ok THEN
      COMMIT;
    ELSE
      RAISE k_servicio.ex_error_general;
    END IF;
  
    k_servicio.p_respuesta_ok(l_rsp, l_rsp.datos);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      ROLLBACK;
      RETURN l_rsp;
    WHEN OTHERS THEN
      ROLLBACK;
      k_servicio.p_respuesta_error(l_rsp,
                                   k_servicio.c_error_inesperado,
                                   k_error.f_mensaje_error(k_servicio.c_error_inesperado),
                                   dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  PROCEDURE p_limpiar_historial IS
  BEGIN
    UPDATE t_reportes
       SET cantidad_ejecuciones = NULL, fecha_ultima_ejecucion = NULL;
  END;

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
      
        as_pdf3_v5.put_image(p_img    => k_archivo.f_recuperar_archivo(k_archivo.c_carpeta_imagenes,'ARCHIVO','x-mark-5-256.jpg').contenido,
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

  FUNCTION f_procesar_reporte(i_id_reporte IN NUMBER,
                              i_parametros IN CLOB,
                              i_contexto   IN CLOB DEFAULT NULL) RETURN CLOB IS
    l_rsp CLOB;
  BEGIN
    -- Registra ejecución
    lp_registrar_ejecucion(i_id_reporte);
    -- Procesa reporte
    l_rsp := lf_procesar_reporte(i_id_reporte, i_parametros, i_contexto).to_json;
    -- Registra log con datos de entrada y salida
    k_operacion.p_registrar_log(i_id_reporte,
                                i_parametros,
                                l_rsp,
                                i_contexto);
    RETURN l_rsp;
  END;

  FUNCTION f_procesar_reporte(i_nombre     IN VARCHAR2,
                              i_dominio    IN VARCHAR2,
                              i_parametros IN CLOB,
                              i_contexto   IN CLOB DEFAULT NULL) RETURN CLOB IS
    l_rsp        CLOB;
    l_id_reporte t_reportes.id_reporte%TYPE;
  BEGIN
    -- Busca reporte
    l_id_reporte := k_operacion.f_id_operacion(k_operacion.c_tipo_reporte,
                                               i_nombre,
                                               i_dominio);
    -- Registra ejecución
    lp_registrar_ejecucion(l_id_reporte);
    -- Procesa reporte
    l_rsp := lf_procesar_reporte(l_id_reporte, i_parametros, i_contexto).to_json;
    -- Registra log con datos de entrada y salida
    k_operacion.p_registrar_log(l_id_reporte,
                                i_parametros,
                                l_rsp,
                                i_contexto);
    RETURN l_rsp;
  END;

END;
/
