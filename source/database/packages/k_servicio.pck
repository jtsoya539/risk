CREATE OR REPLACE PACKAGE k_servicio IS

  /**
  Agrupa operaciones relacionadas con los Servicios Web del sistema
  
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

  -- Códigos de respuesta
  c_ok                       CONSTANT VARCHAR2(10) := '0';
  c_servicio_no_implementado CONSTANT VARCHAR2(10) := 'api0001';
  c_error_parametro          CONSTANT VARCHAR2(10) := 'api0002';
  c_error_permiso            CONSTANT VARCHAR2(10) := 'api0003';
  c_error_general            CONSTANT VARCHAR2(10) := 'api0099';
  c_error_inesperado         CONSTANT VARCHAR2(10) := 'api9999';

  -- Excepciones
  ex_servicio_no_implementado EXCEPTION;
  ex_error_parametro          EXCEPTION;
  ex_error_general            EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_servicio_no_implementado, -6550);

  PROCEDURE p_limpiar_historial;

  PROCEDURE p_validar_parametro(io_respuesta IN OUT NOCOPY y_respuesta,
                                i_expresion  IN BOOLEAN,
                                i_mensaje    IN VARCHAR2);

  PROCEDURE p_respuesta_ok(io_respuesta IN OUT NOCOPY y_respuesta,
                           i_datos      IN y_objeto DEFAULT NULL);

  PROCEDURE p_respuesta_error(io_respuesta IN OUT NOCOPY y_respuesta,
                              i_codigo     IN VARCHAR2,
                              i_mensaje    IN VARCHAR2,
                              i_mensaje_bd IN VARCHAR2 DEFAULT NULL);

  PROCEDURE p_respuesta_excepcion(io_respuesta   IN OUT NOCOPY y_respuesta,
                                  i_error_number IN NUMBER,
                                  i_error_msg    IN VARCHAR2,
                                  i_error_stack  IN VARCHAR2);

  FUNCTION f_paginar_elementos(i_elementos           IN y_objetos,
                               i_numero_pagina       IN INTEGER DEFAULT NULL,
                               i_cantidad_por_pagina IN INTEGER DEFAULT NULL,
                               i_no_paginar          IN VARCHAR2 DEFAULT NULL)
    RETURN y_pagina;

  FUNCTION f_procesar_servicio(i_id_servicio IN NUMBER,
                               i_parametros  IN CLOB,
                               i_contexto    IN CLOB DEFAULT NULL)
    RETURN CLOB;

  FUNCTION f_procesar_servicio(i_nombre     IN VARCHAR2,
                               i_dominio    IN VARCHAR2,
                               i_parametros IN CLOB,
                               i_contexto   IN CLOB DEFAULT NULL) RETURN CLOB;

END;
/
CREATE OR REPLACE PACKAGE BODY k_servicio IS

  PROCEDURE lp_registrar_ejecucion(i_id_servicio IN NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE t_servicios
       SET cantidad_ejecuciones   = nvl(cantidad_ejecuciones, 0) + 1,
           fecha_ultima_ejecucion = SYSDATE
     WHERE id_servicio = i_id_servicio;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END;

  FUNCTION lf_procesar_servicio(i_id_servicio IN NUMBER,
                                i_parametros  IN CLOB,
                                i_contexto    IN CLOB DEFAULT NULL)
    RETURN y_respuesta IS
    l_rsp              y_respuesta;
    l_prms             y_parametros;
    l_ctx              y_parametros;
    l_nombre_servicio  t_operaciones.nombre%TYPE;
    l_dominio_servicio t_operaciones.dominio%TYPE;
    l_sentencia        VARCHAR2(4000);
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Buscando datos del servicio';
    BEGIN
      SELECT upper(o.nombre), upper(o.dominio)
        INTO l_nombre_servicio, l_dominio_servicio
        FROM t_servicios s, t_operaciones o
       WHERE o.id_operacion = s.id_servicio
         AND o.activo = 'S'
         AND s.id_servicio = i_id_servicio;
    EXCEPTION
      WHEN no_data_found THEN
        p_respuesta_error(l_rsp,
                          c_servicio_no_implementado,
                          'Servicio inexistente o inactivo');
        RAISE ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Procesando parámetros del servicio';
    BEGIN
      l_prms := k_operacion.f_procesar_parametros(i_id_servicio,
                                                  i_parametros);
    EXCEPTION
      WHEN OTHERS THEN
        p_respuesta_error(l_rsp,
                          c_error_parametro,
                          CASE
                          k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                          k_error.c_user_defined_error THEN
                          utl_call_stack.error_msg(1) WHEN
                          k_error.c_oracle_predefined_error THEN
                          k_error.f_mensaje_error(c_error_parametro) END,
                          dbms_utility.format_error_stack);
        RAISE ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Procesando contexto';
    BEGIN
      l_ctx := k_operacion.f_procesar_parametros(k_operacion.c_id_operacion_contexto,
                                                 i_contexto);
    EXCEPTION
      WHEN OTHERS THEN
        p_respuesta_error(l_rsp,
                          c_error_parametro,
                          CASE
                          k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                          k_error.c_user_defined_error THEN
                          utl_call_stack.error_msg(1) WHEN
                          k_error.c_oracle_predefined_error THEN
                          k_error.f_mensaje_error(c_error_parametro) END,
                          dbms_utility.format_error_stack);
        RAISE ex_error_parametro;
    END;
  
    l_rsp.lugar := 'Definiendo parámetros en la sesión';
    k_sistema.p_inicializar_parametros;
    k_sistema.p_definir_parametro_string(k_sistema.c_direccion_ip,
                                         k_operacion.f_valor_parametro_string(l_ctx,
                                                                              'direccion_ip'));
    k_sistema.p_definir_parametro_number(k_sistema.c_id_operacion,
                                         i_id_servicio);
    k_sistema.p_definir_parametro_string(k_sistema.c_nombre_operacion,
                                         l_nombre_servicio);
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
                                           k_operacion.f_id_permiso(i_id_servicio)) THEN
        p_respuesta_error(l_rsp,
                          c_error_permiso,
                          k_error.f_mensaje_error(c_error_permiso));
        RAISE ex_error_general;
      END IF;
    END IF;
  
    l_rsp.lugar := 'Construyendo sentencia';
    l_sentencia := 'BEGIN :1 := K_SERVICIO_' || l_dominio_servicio || '.' ||
                   l_nombre_servicio || '(:2); END;';
  
    l_rsp.lugar := 'Procesando servicio';
    BEGIN
      EXECUTE IMMEDIATE l_sentencia
        USING OUT l_rsp, IN l_prms;
    EXCEPTION
      WHEN ex_servicio_no_implementado THEN
        p_respuesta_error(l_rsp,
                          c_servicio_no_implementado,
                          'Servicio no implementado',
                          dbms_utility.format_error_stack);
        RAISE ex_error_general;
      WHEN OTHERS THEN
        p_respuesta_error(l_rsp,
                          'api0004',
                          CASE
                          k_error.f_tipo_excepcion(utl_call_stack.error_number(1)) WHEN
                          k_error.c_user_defined_error THEN
                          utl_call_stack.error_msg(1) WHEN
                          k_error.c_oracle_predefined_error THEN
                          'Error al procesar servicio' END,
                          dbms_utility.format_error_stack);
        RAISE ex_error_general;
    END;
  
    IF l_rsp.codigo = c_ok THEN
      COMMIT;
    ELSE
      RAISE ex_error_general;
    END IF;
  
    p_respuesta_ok(l_rsp, l_rsp.datos);
    RETURN l_rsp;
  EXCEPTION
    WHEN ex_error_parametro THEN
      RETURN l_rsp;
    WHEN ex_error_general THEN
      ROLLBACK;
      RETURN l_rsp;
    WHEN OTHERS THEN
      ROLLBACK;
      p_respuesta_error(l_rsp,
                        c_error_inesperado,
                        k_error.f_mensaje_error(c_error_inesperado),
                        dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  PROCEDURE p_limpiar_historial IS
  BEGIN
    UPDATE t_servicios
       SET cantidad_ejecuciones = NULL, fecha_ultima_ejecucion = NULL;
  END;

  PROCEDURE p_validar_parametro(io_respuesta IN OUT NOCOPY y_respuesta,
                                i_expresion  IN BOOLEAN,
                                i_mensaje    IN VARCHAR2) IS
  BEGIN
    IF NOT nvl(i_expresion, FALSE) THEN
      p_respuesta_error(io_respuesta,
                        c_error_parametro,
                        nvl(i_mensaje,
                            k_error.f_mensaje_error(c_error_parametro)));
      RAISE ex_error_parametro;
    END IF;
  END;

  PROCEDURE p_respuesta_ok(io_respuesta IN OUT NOCOPY y_respuesta,
                           i_datos      IN y_objeto DEFAULT NULL) IS
  BEGIN
    io_respuesta.codigo     := c_ok;
    io_respuesta.mensaje    := 'OK';
    io_respuesta.mensaje_bd := NULL;
    io_respuesta.lugar      := NULL;
    io_respuesta.datos      := i_datos;
  END;

  PROCEDURE p_respuesta_error(io_respuesta IN OUT NOCOPY y_respuesta,
                              i_codigo     IN VARCHAR2,
                              i_mensaje    IN VARCHAR2,
                              i_mensaje_bd IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    IF i_codigo = c_ok THEN
      io_respuesta.codigo  := c_error_inesperado;
      io_respuesta.mensaje := k_error.f_mensaje_error(io_respuesta.codigo);
    ELSE
      io_respuesta.codigo  := substr(i_codigo, 1, 10);
      io_respuesta.mensaje := substr(i_mensaje, 1, 4000);
    END IF;
    io_respuesta.mensaje_bd := substr(i_mensaje_bd, 1, 4000);
    io_respuesta.datos      := NULL;
  END;

  PROCEDURE p_respuesta_excepcion(io_respuesta   IN OUT NOCOPY y_respuesta,
                                  i_error_number IN NUMBER,
                                  i_error_msg    IN VARCHAR2,
                                  i_error_stack  IN VARCHAR2) IS
  BEGIN
    IF k_error.f_tipo_excepcion(i_error_number) =
       k_error.c_user_defined_error THEN
      p_respuesta_error(io_respuesta,
                        c_error_general,
                        i_error_msg,
                        i_error_stack);
    ELSIF k_error.f_tipo_excepcion(i_error_number) =
          k_error.c_oracle_predefined_error THEN
      p_respuesta_error(io_respuesta,
                        c_error_inesperado,
                        k_error.f_mensaje_error(c_error_inesperado),
                        i_error_stack);
    END IF;
  END;

  FUNCTION f_paginar_elementos(i_elementos           IN y_objetos,
                               i_numero_pagina       IN INTEGER DEFAULT NULL,
                               i_cantidad_por_pagina IN INTEGER DEFAULT NULL,
                               i_no_paginar          IN VARCHAR2 DEFAULT NULL)
    RETURN y_pagina IS
    l_pagina              y_pagina;
    l_objetos             y_objetos;
    l_numero_pagina       INTEGER;
    l_cantidad_por_pagina INTEGER;
    l_rango_i             INTEGER;
    l_rango_j             INTEGER;
    l_no_paginar          BOOLEAN;
  BEGIN
    -- Inicializa respuesta
    l_pagina                    := NEW y_pagina();
    l_pagina.numero_actual      := 0;
    l_pagina.numero_siguiente   := 0;
    l_pagina.numero_ultima      := 0;
    l_pagina.numero_primera     := 0;
    l_pagina.numero_anterior    := 0;
    l_pagina.cantidad_elementos := 0;
  
    l_no_paginar := nvl(i_no_paginar, 'N') = 'S';
  
    -- Carga la cantidad total de elementos
    l_pagina.cantidad_elementos := i_elementos.count;
    --
  
    -- Valida parámetro de cantidad por página
    IF l_no_paginar THEN
      l_cantidad_por_pagina := l_pagina.cantidad_elementos;
    ELSE
      l_cantidad_por_pagina := nvl(i_cantidad_por_pagina,
                                   to_number(k_util.f_valor_parametro('PAGINACION_CANTIDAD_DEFECTO_POR_PAGINA')));
    END IF;
  
    IF l_cantidad_por_pagina <= 0 THEN
      l_cantidad_por_pagina := to_number(k_util.f_valor_parametro('PAGINACION_CANTIDAD_DEFECTO_POR_PAGINA'));
    END IF;
  
    IF NOT l_no_paginar AND
       l_cantidad_por_pagina >
       to_number(k_util.f_valor_parametro('PAGINACION_CANTIDAD_MAXIMA_POR_PAGINA')) THEN
      l_cantidad_por_pagina := to_number(k_util.f_valor_parametro('PAGINACION_CANTIDAD_MAXIMA_POR_PAGINA'));
    END IF;
    --
  
    -- Calcula primera página y última página
    l_pagina.numero_ultima := ceil(l_pagina.cantidad_elementos /
                                   l_cantidad_por_pagina);
  
    IF l_pagina.numero_ultima > 0 THEN
      l_pagina.numero_primera := 1;
    END IF;
    --
  
    -- Valida parámetro de número de página
    l_numero_pagina := nvl(i_numero_pagina, 1);
  
    IF l_numero_pagina < l_pagina.numero_primera THEN
      l_numero_pagina := l_pagina.numero_primera;
    END IF;
  
    IF l_numero_pagina > l_pagina.numero_ultima THEN
      l_numero_pagina := l_pagina.numero_ultima;
    END IF;
    --
  
    -- Carga página actual
    l_pagina.numero_actual := l_numero_pagina;
    --
  
    -- Calcula página anterior y página siguiente
    l_pagina.numero_anterior  := l_pagina.numero_actual - 1;
    l_pagina.numero_siguiente := l_pagina.numero_actual + 1;
  
    IF l_pagina.numero_anterior < l_pagina.numero_primera THEN
      l_pagina.numero_anterior := l_pagina.numero_primera;
    END IF;
  
    IF l_pagina.numero_siguiente > l_pagina.numero_ultima THEN
      l_pagina.numero_siguiente := l_pagina.numero_ultima;
    END IF;
    --
  
    -- Calcula el rango de elementos
    l_rango_i := ((l_pagina.numero_actual - 1) * l_cantidad_por_pagina) + 1;
    l_rango_j := l_pagina.numero_actual * l_cantidad_por_pagina;
  
    IF l_rango_i < 0 THEN
      l_rango_i := 0;
    END IF;
  
    IF l_rango_j > l_pagina.cantidad_elementos THEN
      l_rango_j := l_pagina.cantidad_elementos;
    END IF;
    --
  
    -- Carga elementos dentro del rango
    l_objetos := NEW y_objetos();
    IF l_pagina.cantidad_elementos > 0 THEN
      FOR i IN l_rango_i .. l_rango_j LOOP
        l_objetos.extend;
        l_objetos(l_objetos.count) := i_elementos(i);
      END LOOP;
    END IF;
    l_pagina.elementos := l_objetos;
    --
  
    RETURN l_pagina;
  END;

  FUNCTION f_procesar_servicio(i_id_servicio IN NUMBER,
                               i_parametros  IN CLOB,
                               i_contexto    IN CLOB DEFAULT NULL)
    RETURN CLOB IS
    l_rsp CLOB;
  BEGIN
    -- Registra ejecución
    lp_registrar_ejecucion(i_id_servicio);
    -- Procesa servicio
    l_rsp := lf_procesar_servicio(i_id_servicio, i_parametros, i_contexto).to_json;
    -- Registra log con datos de entrada y salida
    k_operacion.p_registrar_log(i_id_servicio,
                                i_parametros,
                                l_rsp,
                                i_contexto);
    RETURN l_rsp;
  END;

  FUNCTION f_procesar_servicio(i_nombre     IN VARCHAR2,
                               i_dominio    IN VARCHAR2,
                               i_parametros IN CLOB,
                               i_contexto   IN CLOB DEFAULT NULL) RETURN CLOB IS
    l_rsp         CLOB;
    l_id_servicio t_servicios.id_servicio%TYPE;
  BEGIN
    -- Busca servicio
    l_id_servicio := k_operacion.f_id_operacion(k_operacion.c_tipo_servicio,
                                                i_nombre,
                                                i_dominio);
    -- Registra ejecución
    lp_registrar_ejecucion(l_id_servicio);
    -- Procesa servicio
    l_rsp := lf_procesar_servicio(l_id_servicio, i_parametros, i_contexto).to_json;
    -- Registra log con datos de entrada y salida
    k_operacion.p_registrar_log(l_id_servicio,
                                i_parametros,
                                l_rsp,
                                i_contexto);
    RETURN l_rsp;
  END;

END;
/
