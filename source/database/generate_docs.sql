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

set feedback off
set define off

prompt ###################################
prompt #   _____   _____   _____  _  __  #
prompt #  |  __ \ |_   _| / ____|| |/ /  #
prompt #  | |__) |  | |  | (___  | ' /   #
prompt #  |  _  /   | |   \___ \ |  <    #
prompt #  | | \ \  _| |_  ____) || . \   #
prompt #  |_|  \_\|_____||_____/ |_|\_\  #
prompt #                                 #
prompt #          Proyecto RISK          #
prompt #            jtsoya539            #
prompt ###################################

prompt
prompt ===================================
prompt Generacion de docs iniciada
prompt ===================================
prompt

prompt
prompt Eliminando docs...
prompt -----------------------------------
prompt
plugin plsqldoc delete;

prompt
prompt Generando docs de secuencias...
prompt -----------------------------------
prompt

prompt
prompt Generando docs de tablas...
prompt -----------------------------------
prompt
plugin plsqldoc generate t_aplicaciones;
plugin plsqldoc generate t_archivo_definiciones;
plugin plsqldoc generate t_archivos;
plugin plsqldoc generate t_archivos_hist;
plugin plsqldoc generate t_barrios;
plugin plsqldoc generate t_ciudades;
plugin plsqldoc generate t_correo_adjuntos;
plugin plsqldoc generate t_correos;
plugin plsqldoc generate t_dato_definiciones;
plugin plsqldoc generate t_datos;
plugin plsqldoc generate t_departamentos;
plugin plsqldoc generate t_dispositivos;
plugin plsqldoc generate t_dispositivo_suscripciones;
plugin plsqldoc generate t_dispositivo_ubicaciones;
plugin plsqldoc generate t_dominios;
plugin plsqldoc generate t_errores;
plugin plsqldoc generate t_idiomas;
plugin plsqldoc generate t_mensajes;
plugin plsqldoc generate t_migraciones;
plugin plsqldoc generate t_modulos;
plugin plsqldoc generate t_monedas;
plugin plsqldoc generate t_notificaciones;
plugin plsqldoc generate t_notificacion_plantillas;
plugin plsqldoc generate t_operaciones;
plugin plsqldoc generate t_operacion_logs;
plugin plsqldoc generate t_operacion_parametros;
plugin plsqldoc generate t_paises;
plugin plsqldoc generate t_parametros;
plugin plsqldoc generate t_permisos;
plugin plsqldoc generate t_personas;
plugin plsqldoc generate t_reportes;
plugin plsqldoc generate t_roles;
plugin plsqldoc generate t_rol_permisos;
plugin plsqldoc generate t_rol_usuarios;
plugin plsqldoc generate t_servicios;
plugin plsqldoc generate t_sesiones;
plugin plsqldoc generate t_significado_dominios;
plugin plsqldoc generate t_significados;
plugin plsqldoc generate t_trabajos;
plugin plsqldoc generate t_usuario_claves;
plugin plsqldoc generate t_usuarios;
plugin plsqldoc generate t_usuario_suscripciones;

prompt
prompt Generando docs de vistas...
prompt -----------------------------------
prompt

prompt
prompt Generando docs de types...
prompt -----------------------------------
prompt
plugin plsqldoc generate y_archivo;
plugin plsqldoc generate y_archivos;
plugin plsqldoc generate y_barrio;
plugin plsqldoc generate y_cadenas;
plugin plsqldoc generate y_ciudad;
plugin plsqldoc generate y_correo;
plugin plsqldoc generate y_dato;
plugin plsqldoc generate y_datos;
plugin plsqldoc generate y_departamento;
plugin plsqldoc generate y_dispositivo;
plugin plsqldoc generate y_error;
plugin plsqldoc generate y_mensaje;
plugin plsqldoc generate y_notificacion;
plugin plsqldoc generate y_objeto;
plugin plsqldoc generate y_objetos;
plugin plsqldoc generate y_pagina;
plugin plsqldoc generate y_pagina_parametros;
plugin plsqldoc generate y_pais;
plugin plsqldoc generate y_parametro;
plugin plsqldoc generate y_parametros;
plugin plsqldoc generate y_plantilla;
plugin plsqldoc generate y_respuesta;
plugin plsqldoc generate y_rol;
plugin plsqldoc generate y_sesion;
plugin plsqldoc generate y_significado;
plugin plsqldoc generate y_usuario;

prompt
prompt Generando docs de paquetes...
prompt -----------------------------------
prompt
plugin plsqldoc generate k_aplicacion;
plugin plsqldoc generate k_archivo;
plugin plsqldoc generate k_auditoria;
plugin plsqldoc generate k_autenticacion;
plugin plsqldoc generate k_autorizacion;
plugin plsqldoc generate k_clave;
plugin plsqldoc generate k_dato;
plugin plsqldoc generate k_dispositivo;
plugin plsqldoc generate k_dominio;
plugin plsqldoc generate k_error;
plugin plsqldoc generate k_html;
plugin plsqldoc generate k_mensajeria;
plugin plsqldoc generate k_modulo;
plugin plsqldoc generate k_operacion;
plugin plsqldoc generate k_reporte;
plugin plsqldoc generate k_reporte_gen;
plugin plsqldoc generate k_servicio;
plugin plsqldoc generate k_servicio_aut;
plugin plsqldoc generate k_servicio_gen;
plugin plsqldoc generate k_servicio_glo;
plugin plsqldoc generate k_servicio_msj;
plugin plsqldoc generate k_sesion;
plugin plsqldoc generate k_significado;
plugin plsqldoc generate k_sistema;
plugin plsqldoc generate k_trabajo;
plugin plsqldoc generate k_usuario;
plugin plsqldoc generate k_util;

prompt
prompt Generando docs de triggers...
prompt -----------------------------------
prompt
plugin plsqldoc generate gb_archivos;
plugin plsqldoc generate gb_datos;
plugin plsqldoc generate gb_mensajes;
plugin plsqldoc generate gb_operaciones;
plugin plsqldoc generate gb_operacion_parametros;
plugin plsqldoc generate gb_personas;
plugin plsqldoc generate gb_reportes;
plugin plsqldoc generate gb_servicios;
plugin plsqldoc generate gb_sesiones;
plugin plsqldoc generate gb_trabajos;
plugin plsqldoc generate gb_usuarios;
plugin plsqldoc generate gf_archivos;
plugin plsqldoc generate gf_operaciones;
plugin plsqldoc generate gs_barrios;
plugin plsqldoc generate gs_ciudades;
plugin plsqldoc generate gs_correo_adjuntos;
plugin plsqldoc generate gs_correos;
plugin plsqldoc generate gs_departamentos;
plugin plsqldoc generate gs_dispositivos;
plugin plsqldoc generate gs_idiomas;
plugin plsqldoc generate gs_mensajes;
plugin plsqldoc generate gs_notificaciones;
plugin plsqldoc generate gs_operaciones;
plugin plsqldoc generate gs_operacion_logs;
plugin plsqldoc generate gs_paises;
plugin plsqldoc generate gs_personas;
plugin plsqldoc generate gs_roles;
plugin plsqldoc generate gs_sesiones;
plugin plsqldoc generate gs_usuarios;

prompt
prompt Generando index...
prompt -----------------------------------
prompt
plugin plsqldoc rebuild;

prompt
prompt ===================================
prompt Generacion de docs finalizada
prompt ===================================
prompt
