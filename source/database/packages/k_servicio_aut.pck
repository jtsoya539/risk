CREATE OR REPLACE PACKAGE k_servicio_aut IS

  /**
  Agrupa operaciones relacionadas con los Servicios Web del dominio AUT
  
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

  FUNCTION registrar_usuario(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION cambiar_estado_usuario(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION registrar_clave(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION cambiar_clave(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION validar_credenciales(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION validar_clave_aplicacion(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION validar_sesion(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION iniciar_sesion(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION refrescar_sesion(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION cambiar_estado_sesion(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION datos_usuario(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION registrar_dispositivo(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION datos_dispositivo(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION registrar_ubicacion(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION tiempo_expiracion_token(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION editar_usuario(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION generar_otp(i_parametros IN y_parametros) RETURN y_respuesta;

  FUNCTION validar_otp(i_parametros IN y_parametros) RETURN y_respuesta;

END;
/
CREATE OR REPLACE PACKAGE BODY k_servicio_aut IS

  FUNCTION registrar_usuario(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'usuario') IS NOT NULL,
                                   'Debe ingresar usuario');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'clave') IS NOT NULL,
                                   'Debe ingresar clave');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'nombre') IS NOT NULL,
                                   'Debe ingresar nombre');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'apellido') IS NOT NULL,
                                   'Debe ingresar apellido');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'direccion_correo') IS NOT NULL,
                                   'Debe ingresar direccion_correo');
  
    l_rsp.lugar := 'Registrando usuario';
    k_autenticacion.p_registrar_usuario(k_operacion.f_valor_parametro_string(i_parametros,
                                                                             'usuario'),
                                        k_operacion.f_valor_parametro_string(i_parametros,
                                                                             'clave'),
                                        k_operacion.f_valor_parametro_string(i_parametros,
                                                                             'nombre'),
                                        k_operacion.f_valor_parametro_string(i_parametros,
                                                                             'apellido'),
                                        k_operacion.f_valor_parametro_string(i_parametros,
                                                                             'direccion_correo'),
                                        k_operacion.f_valor_parametro_string(i_parametros,
                                                                             'numero_telefono'));
  
    k_servicio.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION cambiar_estado_usuario(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'usuario') IS NOT NULL,
                                   'Debe ingresar usuario');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'estado') IS NOT NULL,
                                   'Debe ingresar estado');
  
    l_rsp.lugar := 'Cambiando estado de usuario';
    k_usuario.p_cambiar_estado(k_usuario.f_buscar_id(k_operacion.f_valor_parametro_string(i_parametros,
                                                                                          'usuario')),
                               k_operacion.f_valor_parametro_string(i_parametros,
                                                                    'estado'));
  
    k_servicio.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION registrar_clave(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    -- l_rsp.lugar := 'Validando parametros';
  
    l_rsp.lugar := 'Registrando clave';
    k_autenticacion.p_registrar_clave(k_operacion.f_valor_parametro_string(i_parametros,
                                                                           'usuario'),
                                      k_operacion.f_valor_parametro_string(i_parametros,
                                                                           'clave'),
                                      k_operacion.f_valor_parametro_string(i_parametros,
                                                                           'tipo_clave'));
  
    k_servicio.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION cambiar_clave(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    -- l_rsp.lugar := 'Validando parametros';
  
    l_rsp.lugar := 'Cambiando clave';
    k_autenticacion.p_cambiar_clave(k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'usuario'),
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'clave_antigua'),
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'clave_nueva'),
                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'tipo_clave'));
  
    k_servicio.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION validar_credenciales(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'usuario') IS NOT NULL,
                                   'Debe ingresar usuario');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'clave') IS NOT NULL,
                                   'Debe ingresar clave');
  
    l_rsp.lugar := 'Validando credenciales';
    IF NOT
        k_autenticacion.f_validar_credenciales(k_operacion.f_valor_parametro_string(i_parametros,
                                                                                    'usuario'),
                                               k_operacion.f_valor_parametro_string(i_parametros,
                                                                                    'clave'),
                                               k_operacion.f_valor_parametro_string(i_parametros,
                                                                                    'tipo_clave')) THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'aut0003',
                                   'Credenciales inválidas');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    k_servicio.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION validar_clave_aplicacion(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'clave_aplicacion') IS NOT NULL,
                                   'Debe ingresar clave_aplicacion');
  
    l_rsp.lugar := 'Validando clave de aplicacion';
    IF NOT
        k_aplicacion.f_validar_clave(k_operacion.f_valor_parametro_string(i_parametros,
                                                                          'clave_aplicacion')) THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'aut0002',
                                   'Clave de aplicacion invalida');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    k_servicio.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION validar_sesion(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'access_token') IS NOT NULL,
                                   'Debe ingresar access_token');
  
    l_rsp.lugar := 'Validando sesion';
    IF NOT
        k_sesion.f_validar_sesion(k_operacion.f_valor_parametro_string(i_parametros,
                                                                       'access_token')) THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'aut0002',
                                   'Sesion finalizada o expirada');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    k_servicio.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION iniciar_sesion(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_sesion    y_sesion;
    l_id_sesion t_sesiones.id_sesion%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'usuario') IS NOT NULL,
                                   'Debe ingresar usuario');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'access_token') IS NOT NULL,
                                   'Debe ingresar access_token');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'refresh_token') IS NOT NULL,
                                   'Debe ingresar refresh_token');
  
    l_rsp.lugar := 'Iniciando sesion';
    l_id_sesion := k_autenticacion.f_iniciar_sesion(k_sistema.f_valor_parametro_string(k_sistema.c_id_aplicacion),
                                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                                         'usuario'),
                                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                                         'access_token'),
                                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                                         'refresh_token'),
                                                    k_operacion.f_valor_parametro_string(i_parametros,
                                                                                         'token_dispositivo'));
  
    l_rsp.lugar := 'Cargando datos de la sesion';
    l_sesion    := k_sesion.f_datos_sesion(l_id_sesion);
  
    k_servicio.p_respuesta_ok(l_rsp, l_sesion);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION refrescar_sesion(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp       y_respuesta;
    l_sesion    y_sesion;
    l_id_sesion t_sesiones.id_sesion%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'access_token_antiguo') IS NOT NULL,
                                   'Debe ingresar antiguo Access Token');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'refresh_token_antiguo') IS NOT NULL,
                                   'Debe ingresar antiguo Refresh Token');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'access_token_nuevo') IS NOT NULL,
                                   'Debe ingresar nuevo Access Token');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'refresh_token_nuevo') IS NOT NULL,
                                   'Debe ingresar nuevo Refresh Token');
  
    l_rsp.lugar := 'Refrescando sesion';
    l_id_sesion := k_autenticacion.f_refrescar_sesion(k_sistema.f_valor_parametro_string(k_sistema.c_id_aplicacion),
                                                      k_operacion.f_valor_parametro_string(i_parametros,
                                                                                           'access_token_antiguo'),
                                                      k_operacion.f_valor_parametro_string(i_parametros,
                                                                                           'refresh_token_antiguo'),
                                                      k_operacion.f_valor_parametro_string(i_parametros,
                                                                                           'access_token_nuevo'),
                                                      k_operacion.f_valor_parametro_string(i_parametros,
                                                                                           'refresh_token_nuevo'));
  
    l_rsp.lugar := 'Cargando datos de la sesion';
    l_sesion    := k_sesion.f_datos_sesion(l_id_sesion);
  
    k_servicio.p_respuesta_ok(l_rsp, l_sesion);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION cambiar_estado_sesion(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'access_token') IS NOT NULL,
                                   'Debe ingresar access_token');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'estado') IS NOT NULL,
                                   'Debe ingresar estado');
  
    l_rsp.lugar := 'Cambiando estado de sesion';
    k_sesion.p_cambiar_estado(k_operacion.f_valor_parametro_string(i_parametros,
                                                                   'access_token'),
                              k_operacion.f_valor_parametro_string(i_parametros,
                                                                   'estado'));
  
    k_servicio.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION datos_usuario(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp     y_respuesta;
    l_usuario y_usuario;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'usuario') IS NOT NULL,
                                   'Debe ingresar usuario');
  
    l_rsp.lugar := 'Cargando datos del usuario';
    l_usuario   := k_usuario.f_datos_usuario(k_usuario.f_buscar_id(k_operacion.f_valor_parametro_string(i_parametros,
                                                                                                        'usuario')));
  
    k_servicio.p_respuesta_ok(l_rsp, l_usuario);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION registrar_dispositivo(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp            y_respuesta;
    l_dato           y_dato;
    l_dispositivo    y_dispositivo;
    l_id_dispositivo t_dispositivos.id_dispositivo%TYPE;
    i                INTEGER;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_object(i_parametros,
                                                                        'dispositivo') IS NOT NULL,
                                   'Debe ingresar dispositivo');
    l_dispositivo := treat(k_operacion.f_valor_parametro_object(i_parametros,
                                                                'dispositivo') AS
                           y_dispositivo);
  
    l_rsp.lugar      := 'Registrando dispositivo';
    l_id_dispositivo := k_dispositivo.f_registrar_dispositivo(k_sistema.f_valor_parametro_string(k_sistema.c_id_aplicacion),
                                                              l_dispositivo.token_dispositivo,
                                                              l_dispositivo.token_notificacion,
                                                              l_dispositivo.nombre_sistema_operativo,
                                                              l_dispositivo.version_sistema_operativo,
                                                              l_dispositivo.tipo,
                                                              l_dispositivo.nombre_navegador,
                                                              l_dispositivo.version_navegador);
  
    l_rsp.lugar := 'Agregando suscripciones';
    i           := l_dispositivo.suscripciones.first;
    WHILE i IS NOT NULL LOOP
      l_dato := treat(l_dispositivo.suscripciones(i) AS y_dato);
      k_dispositivo.p_suscribir_notificacion(l_id_dispositivo,
                                             l_dato.contenido);
      i := l_dispositivo.suscripciones.next(i);
    END LOOP;
  
    l_rsp.lugar := 'Buscando token del dispositivo';
    BEGIN
      SELECT token_dispositivo
        INTO l_dato.contenido
        FROM t_dispositivos
       WHERE id_dispositivo = l_id_dispositivo;
    EXCEPTION
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'aut0001',
                                     'Error al obtener token del dispositivo');
        RAISE k_servicio.ex_error_general;
    END;
  
    k_servicio.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION datos_dispositivo(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp         y_respuesta;
    l_dispositivo y_dispositivo;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parámetros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'token_dispositivo') IS NOT NULL,
                                   'Debe ingresar token_dispositivo');
  
    l_rsp.lugar   := 'Cargando datos del dispositivo';
    l_dispositivo := k_dispositivo.f_datos_dispositivo(k_dispositivo.f_id_dispositivo(k_operacion.f_valor_parametro_string(i_parametros,
                                                                                                                           'token_dispositivo')));
  
    k_servicio.p_respuesta_ok(l_rsp, l_dispositivo);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION registrar_ubicacion(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parámetros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'token_dispositivo') IS NOT NULL,
                                   'Debe ingresar token_dispositivo');
  
    l_rsp.lugar := 'Registrando ubicación del dispositivo';
    k_dispositivo.p_registrar_ubicacion(k_dispositivo.f_id_dispositivo(k_operacion.f_valor_parametro_string(i_parametros,
                                                                                                            'token_dispositivo')),
                                        k_operacion.f_valor_parametro_number(i_parametros,
                                                                             'latitud'),
                                        k_operacion.f_valor_parametro_number(i_parametros,
                                                                             'longitud'));
  
    k_servicio.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION tiempo_expiracion_token(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp  y_respuesta;
    l_dato y_dato;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'tipo_token') IS NOT NULL,
                                   'Debe ingresar tipo_token');
  
    l_rsp.lugar      := 'Obteniendo tiempo de expiración';
    l_dato.contenido := to_char(k_sesion.f_tiempo_expiracion_token(k_sistema.f_valor_parametro_string(k_sistema.c_id_aplicacion),
                                                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                                                        'tipo_token')));
  
    IF l_dato.contenido IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'aut0003',
                                   'Error al obtener tiempo de expiración');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    k_servicio.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION editar_usuario(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp  y_respuesta;
    l_dato y_dato;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Validando parámetros';
    /* TODO: text="Implementar validación de parámetros" */
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'usuario_antiguo') IS NOT NULL,
                                   'Debe ingresar usuario_antiguo');
  
    l_rsp.lugar := 'Editando usuario';
    k_autenticacion.p_editar_usuario(k_operacion.f_valor_parametro_string(i_parametros,
                                                                          'usuario_antiguo'),
                                     k_operacion.f_valor_parametro_string(i_parametros,
                                                                          'usuario_nuevo'),
                                     k_operacion.f_valor_parametro_string(i_parametros,
                                                                          'nombre'),
                                     k_operacion.f_valor_parametro_string(i_parametros,
                                                                          'apellido'),
                                     k_operacion.f_valor_parametro_string(i_parametros,
                                                                          'direccion_correo'),
                                     k_operacion.f_valor_parametro_string(i_parametros,
                                                                          'numero_telefono'));
  
    k_servicio.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION generar_otp(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp    y_respuesta;
    l_dato   y_dato;
    l_secret VARCHAR2(100);
    l_otp    VARCHAR2(100);
    l_body   CLOB;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'tipo_mensajeria') IS NOT NULL,
                                   'Debe ingresar tipo_mensajeria');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'tipo_mensajeria') IN
                                   ('M', 'S', 'P'),
                                   'Valor no válido para tipo_mensajeria');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'destino') IS NOT NULL,
                                   'Debe ingresar destino');
  
    l_rsp.lugar := 'Generando secret';
    l_secret    := oos_util_totp.generate_secret;
  
    l_rsp.lugar := 'Generando OTP';
    l_otp       := oos_util_totp.generate_otp(l_secret);
  
    l_rsp.lugar := 'Enviando mensajería';
    CASE
     k_operacion.f_valor_parametro_string(i_parametros, 'tipo_mensajeria')
    
      WHEN 'M' THEN
        -- Mail
        l_body := k_mensajeria.f_correo_html('Tu clave de validación es ' ||
                                             l_otp,
                                             'Clave de validación',
                                             'Clave de validación');
      
        IF k_mensajeria.f_enviar_correo('Clave de validación',
                                        l_body,
                                        NULL,
                                        k_operacion.f_valor_parametro_string(i_parametros,
                                                                             'destino'),
                                        NULL,
                                        NULL,
                                        NULL,
                                        k_mensajeria.c_prioridad_urgente) <>
           k_mensajeria.c_ok THEN
          k_servicio.p_respuesta_error(l_rsp,
                                       'aut0001',
                                       'Error al enviar Mail');
          RAISE k_servicio.ex_error_general;
        END IF;
      
      WHEN 'S' THEN
        -- SMS
        IF k_mensajeria.f_enviar_mensaje('Tu clave de validación es ' ||
                                         l_otp,
                                         NULL,
                                         k_operacion.f_valor_parametro_string(i_parametros,
                                                                              'destino'),
                                         k_mensajeria.c_prioridad_urgente) <>
           k_mensajeria.c_ok THEN
          k_servicio.p_respuesta_error(l_rsp,
                                       'aut0002',
                                       'Error al enviar SMS');
          RAISE k_servicio.ex_error_general;
        END IF;
      
      WHEN 'P' THEN
        -- Push
        NULL;
      
    END CASE;
  
    l_dato.contenido := l_secret;
  
    k_servicio.p_respuesta_ok(l_rsp, l_dato);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

  FUNCTION validar_otp(i_parametros IN y_parametros) RETURN y_respuesta IS
    l_rsp y_respuesta;
  BEGIN
    -- Inicializa respuesta
    l_rsp := NEW y_respuesta();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_string(i_parametros,
                                                                        'secret') IS NOT NULL,
                                   'Debe ingresar secret');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_operacion.f_valor_parametro_number(i_parametros,
                                                                        'otp') IS NOT NULL,
                                   'Debe ingresar otp');
  
    l_rsp.lugar := 'Validando OTP';
    BEGIN
      IF oos_util_totp.validate_otp(k_operacion.f_valor_parametro_string(i_parametros,
                                                                         'secret'),
                                    k_operacion.f_valor_parametro_number(i_parametros,
                                                                         'otp'),
                                    to_number(k_util.f_valor_parametro('TIEMPO_TOLERANCIA_VALIDAR_OTP'))) <> 1 THEN
        k_servicio.p_respuesta_error(l_rsp, 'aut0001', 'OTP inválido');
        RAISE k_servicio.ex_error_general;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp, 'aut0002', 'OTP inválido');
        RAISE k_servicio.ex_error_general;
    END;
  
    k_servicio.p_respuesta_ok(l_rsp);
    RETURN l_rsp;
  EXCEPTION
    WHEN k_servicio.ex_error_parametro THEN
      RETURN l_rsp;
    WHEN k_servicio.ex_error_general THEN
      RETURN l_rsp;
    WHEN OTHERS THEN
      k_servicio.p_respuesta_excepcion(l_rsp,
                                       utl_call_stack.error_number(1),
                                       utl_call_stack.error_msg(1),
                                       dbms_utility.format_error_stack);
      RETURN l_rsp;
  END;

END;
/
