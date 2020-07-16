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

  FUNCTION tiempo_expiracion_token(i_parametros IN y_parametros)
    RETURN y_respuesta;

  FUNCTION editar_usuario(i_parametros IN y_parametros) RETURN y_respuesta;

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
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'usuario')) IS NOT NULL,
                                   'Debe ingresar usuario');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'clave')) IS NOT NULL,
                                   'Debe ingresar clave');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'nombre')) IS NOT NULL,
                                   'Debe ingresar nombre');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'apellido')) IS NOT NULL,
                                   'Debe ingresar apellido');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'direccion_correo')) IS NOT NULL,
                                   'Debe ingresar direccion_correo');
  
    l_rsp.lugar := 'Registrando usuario';
    k_autenticacion.p_registrar_usuario(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                            'usuario')),
                                        anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                            'clave')),
                                        anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                            'nombre')),
                                        anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                            'apellido')),
                                        anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                            'direccion_correo')),
                                        anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                            'numero_telefono')));
  
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
    k_autenticacion.p_registrar_clave(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                          'usuario')),
                                      anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                          'clave')),
                                      anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                          'tipo_clave')));
  
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
    k_autenticacion.p_cambiar_clave(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                        'usuario')),
                                    anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                        'clave_antigua')),
                                    anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                        'clave_nueva')),
                                    anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                        'tipo_clave')));
  
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
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'usuario')) IS NOT NULL,
                                   'Debe ingresar usuario');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'clave')) IS NOT NULL,
                                   'Debe ingresar clave');
  
    l_rsp.lugar := 'Validando credenciales';
    IF NOT
        k_autenticacion.f_validar_credenciales(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                   'usuario')),
                                               anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                   'clave')),
                                               anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                   'tipo_clave'))) THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'aut0003',
                                   'Credenciales invalidas');
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
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'clave_aplicacion')) IS NOT NULL,
                                   'Debe ingresar clave_aplicacion');
  
    l_rsp.lugar := 'Validando clave de aplicacion';
    IF NOT
        k_autenticacion.f_validar_clave_aplicacion(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                       'clave_aplicacion'))) THEN
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
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'access_token')) IS NOT NULL,
                                   'Debe ingresar access_token');
  
    l_rsp.lugar := 'Validando sesion';
    IF NOT
        k_autenticacion.f_sesion_activa(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                            'access_token'))) THEN
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
    l_rsp    := NEW y_respuesta();
    l_sesion := NEW y_sesion();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_servicio.f_valor_parametro_string(i_parametros,
                                                                       'clave_aplicacion') IS NOT NULL,
                                   'Debe ingresar clave_aplicacion');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_servicio.f_valor_parametro_string(i_parametros,
                                                                       'usuario') IS NOT NULL,
                                   'Debe ingresar usuario');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_servicio.f_valor_parametro_string(i_parametros,
                                                                       'access_token') IS NOT NULL,
                                   'Debe ingresar access_token');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_servicio.f_valor_parametro_string(i_parametros,
                                                                       'refresh_token') IS NOT NULL,
                                   'Debe ingresar refresh_token');
  
    l_rsp.lugar := 'Iniciando sesion';
    l_id_sesion := k_autenticacion.f_iniciar_sesion(k_servicio.f_valor_parametro_string(i_parametros,
                                                                                        'clave_aplicacion'),
                                                    k_servicio.f_valor_parametro_string(i_parametros,
                                                                                        'usuario'),
                                                    k_servicio.f_valor_parametro_string(i_parametros,
                                                                                        'access_token'),
                                                    k_servicio.f_valor_parametro_string(i_parametros,
                                                                                        'refresh_token'),
                                                    k_servicio.f_valor_parametro_string(i_parametros,
                                                                                        'token_dispositivo'));
  
    l_rsp.lugar := 'Buscando datos de la sesion';
    BEGIN
      SELECT id_sesion,
             estado,
             access_token,
             refresh_token,
             k_autenticacion.f_tiempo_expiracion_token(id_aplicacion,
                                                       k_autenticacion.c_access_token)
        INTO l_sesion.id_sesion,
             l_sesion.estado,
             l_sesion.access_token,
             l_sesion.refresh_token,
             l_sesion.tiempo_expiracion
        FROM t_sesiones
       WHERE id_sesion = l_id_sesion;
    EXCEPTION
      WHEN no_data_found THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'aut0001',
                                     'Sesión inexistente');
        RAISE k_servicio.ex_error_general;
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'aut0002',
                                     'Error al buscar datos de la sesión');
        RAISE k_servicio.ex_error_general;
    END;
  
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
    l_rsp    := NEW y_respuesta();
    l_sesion := NEW y_sesion();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'clave_aplicacion')) IS NOT NULL,
                                   'Debe ingresar clave_aplicacion');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'access_token_antiguo')) IS NOT NULL,
                                   'Debe ingresar antiguo Access Token');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'refresh_token_antiguo')) IS NOT NULL,
                                   'Debe ingresar antiguo Refresh Token');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'access_token_nuevo')) IS NOT NULL,
                                   'Debe ingresar nuevo Access Token');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'refresh_token_nuevo')) IS NOT NULL,
                                   'Debe ingresar nuevo Refresh Token');
  
    l_rsp.lugar := 'Refrescando sesion';
    l_id_sesion := k_autenticacion.f_refrescar_sesion(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                          'clave_aplicacion')),
                                                      anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                          'access_token_antiguo')),
                                                      anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                          'refresh_token_antiguo')),
                                                      anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                          'access_token_nuevo')),
                                                      anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                          'refresh_token_nuevo')));
  
    l_rsp.lugar := 'Buscando datos de la sesion';
    BEGIN
      SELECT id_sesion,
             estado,
             access_token,
             refresh_token,
             k_autenticacion.f_tiempo_expiracion_token(id_aplicacion,
                                                       k_autenticacion.c_access_token)
        INTO l_sesion.id_sesion,
             l_sesion.estado,
             l_sesion.access_token,
             l_sesion.refresh_token,
             l_sesion.tiempo_expiracion
        FROM t_sesiones
       WHERE id_sesion = l_id_sesion;
    EXCEPTION
      WHEN no_data_found THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'aut0005',
                                     'Sesion inexistente');
        RAISE k_servicio.ex_error_general;
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'aut0006',
                                     'Error al buscar datos de la sesion');
        RAISE k_servicio.ex_error_general;
    END;
  
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
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'access_token')) IS NOT NULL,
                                   'Debe ingresar access_token');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'estado')) IS NOT NULL,
                                   'Debe ingresar estado');
  
    l_rsp.lugar := 'Cambiando estado de sesion';
    k_autenticacion.p_cambiar_estado_sesion(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                'access_token')),
                                            anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                'estado')));
  
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
    l_roles   y_roles;
    l_rol     y_rol;
  
    i_usuario VARCHAR2(4000);
  
    CURSOR cr_roles(i_id_usuario IN NUMBER) IS
      SELECT r.id_rol, r.nombre, r.activo, r.detalle
        FROM t_rol_usuarios ru, t_roles r
       WHERE r.id_rol = ru.id_rol
         AND r.activo = 'S'
         AND ru.id_usuario = i_id_usuario;
  BEGIN
    -- Inicializa respuesta
    l_rsp     := NEW y_respuesta();
    l_usuario := NEW y_usuario();
    l_roles   := NEW y_roles();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'usuario')) IS NOT NULL,
                                   'Debe ingresar usuario');
  
    i_usuario := anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                     'usuario'));
  
    l_rsp.lugar := 'Buscando datos del usuario';
    BEGIN
      SELECT u.id_usuario,
             u.alias,
             p.nombre,
             p.apellido,
             p.tipo_persona,
             u.estado,
             u.direccion_correo,
             u.numero_telefono
        INTO l_usuario.id_usuario,
             l_usuario.alias,
             l_usuario.nombre,
             l_usuario.apellido,
             l_usuario.tipo_persona,
             l_usuario.estado,
             l_usuario.direccion_correo,
             l_usuario.numero_telefono
        FROM t_usuarios u, t_personas p
       WHERE p.id_persona(+) = u.id_persona
         AND u.alias = i_usuario;
    EXCEPTION
      WHEN no_data_found THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'aut0002',
                                     'Usuario inexistente');
        RAISE k_servicio.ex_error_general;
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'aut0003',
                                     'Error al buscar datos del usuario');
        RAISE k_servicio.ex_error_general;
    END;
  
    l_rsp.lugar := 'Buscando roles del usuario';
    FOR c IN cr_roles(l_usuario.id_usuario) LOOP
      l_rol         := NEW y_rol();
      l_rol.id_rol  := c.id_rol;
      l_rol.nombre  := c.nombre;
      l_rol.activo  := c.activo;
      l_rol.detalle := c.detalle;
    
      l_roles.extend;
      l_roles(l_roles.count) := l_rol;
    END LOOP;
    l_usuario.roles := l_roles;
  
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
    l_dispositivo    y_dispositivo;
    l_id_dispositivo t_dispositivos.id_dispositivo%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp         := NEW y_respuesta();
    l_dispositivo := NEW y_dispositivo();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   k_servicio.f_valor_parametro_string(i_parametros,
                                                                       'clave_aplicacion') IS NOT NULL,
                                   'Debe ingresar clave_aplicacion');
  
    k_servicio.p_validar_parametro(l_rsp,
                                   k_servicio.f_valor_parametro_object(i_parametros,
                                                                       'dispositivo') IS NOT NULL,
                                   'Debe ingresar dispositivo');
    l_dispositivo := treat(k_servicio.f_valor_parametro_object(i_parametros,
                                                               'dispositivo') AS
                           y_dispositivo);
  
    l_rsp.lugar      := 'Registrando dispositivo';
    l_id_dispositivo := k_autenticacion.f_registrar_dispositivo(k_servicio.f_valor_parametro_string(i_parametros,
                                                                                                    'clave_aplicacion'),
                                                                l_dispositivo.token_dispositivo,
                                                                l_dispositivo.token_notificacion,
                                                                l_dispositivo.nombre_sistema_operativo,
                                                                l_dispositivo.version_sistema_operativo,
                                                                l_dispositivo.tipo,
                                                                l_dispositivo.nombre_navegador,
                                                                l_dispositivo.version_navegador);
  
    l_dispositivo := NEW y_dispositivo();
  
    l_rsp.lugar := 'Buscando datos del dispositivo';
    BEGIN
      SELECT d.id_dispositivo,
             d.token_dispositivo,
             d.nombre_sistema_operativo,
             d.version_sistema_operativo,
             d.tipo,
             d.nombre_navegador,
             d.version_navegador,
             d.token_notificacion
        INTO l_dispositivo.id_dispositivo,
             l_dispositivo.token_dispositivo,
             l_dispositivo.nombre_sistema_operativo,
             l_dispositivo.version_sistema_operativo,
             l_dispositivo.tipo,
             l_dispositivo.nombre_navegador,
             l_dispositivo.version_navegador,
             l_dispositivo.token_notificacion
        FROM t_dispositivos d
       WHERE d.id_dispositivo = l_id_dispositivo;
    EXCEPTION
      WHEN no_data_found THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'aut0001',
                                     'Dispositivo inexistente');
        RAISE k_servicio.ex_error_general;
      WHEN OTHERS THEN
        k_servicio.p_respuesta_error(l_rsp,
                                     'aut0002',
                                     'Error al buscar datos del dispositivo');
        RAISE k_servicio.ex_error_general;
    END;
  
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

  FUNCTION tiempo_expiracion_token(i_parametros IN y_parametros)
    RETURN y_respuesta IS
    l_rsp           y_respuesta;
    l_dato          y_dato;
    l_id_aplicacion t_aplicaciones.id_aplicacion%TYPE;
  BEGIN
    -- Inicializa respuesta
    l_rsp  := NEW y_respuesta();
    l_dato := NEW y_dato();
  
    l_rsp.lugar := 'Validando parametros';
    k_servicio.p_validar_parametro(l_rsp,
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'clave_aplicacion')) IS NOT NULL,
                                   'Debe ingresar clave_aplicacion');
  
    l_rsp.lugar     := 'Buscando aplicación';
    l_id_aplicacion := k_autenticacion.f_id_aplicacion(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                           'clave_aplicacion')),
                                                       'S');
    IF l_id_aplicacion IS NULL THEN
      k_servicio.p_respuesta_error(l_rsp,
                                   'aut0002',
                                   'Aplicacion inexistente o inactiva');
      RAISE k_servicio.ex_error_general;
    END IF;
  
    l_rsp.lugar      := 'Obteniendo tiempo de expiración';
    l_dato.contenido := to_char(k_autenticacion.f_tiempo_expiracion_token(l_id_aplicacion,
                                                                          anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                                                              'tipo_token'))));
  
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
                                   anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                       'usuario_antiguo')) IS NOT NULL,
                                   'Debe ingresar usuario_antiguo');
  
    l_rsp.lugar := 'Editando usuario';
    k_autenticacion.p_editar_usuario(anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                         'usuario_antiguo')),
                                     anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                         'usuario_nuevo')),
                                     anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                         'nombre')),
                                     anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                         'apellido')),
                                     anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                         'direccion_correo')),
                                     anydata.accessvarchar2(k_servicio.f_valor_parametro(i_parametros,
                                                                                         'numero_telefono')));
  
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

END;
/
