CREATE OR REPLACE FORCE VIEW V_OPERACION_LOGS AS
SELECT l.id_operacion_log,
       l.id_operacion,
       s.nombre nombre_operacion,
       l.version,
       l.fecha_hora_inicio,
       l.fecha_hora_fin,
       l.duracion,
       -- contexto
       l.contexto,
       json_value(l.contexto, '$.direccion_ip') ctx_direccion_ip,
       json_value(l.contexto, '$.clave_aplicacion') ctx_clave_aplicacion,
       json_value(l.contexto, '$.access_token') ctx_access_token,
       json_value(l.contexto, '$.usuario') ctx_usuario,
       json_value(l.contexto, '$.token_dispositivo') ctx_token_dispositivo,
       json_value(l.contexto, '$.id_ejecucion') ctx_id_ejecucion,
       -- parametros
       l.parametros,
       json_query(l.parametros, '$') prms,
       -- respuesta
       l.respuesta,
       json_value(l.respuesta, '$.codigo') rsp_codigo,
       json_value(l.respuesta, '$.mensaje') rsp_mensaje,
       json_value(l.respuesta, '$.mensaje_bd') rsp_mensaje_bd,
       json_value(l.respuesta, '$.lugar') rsp_lugar,
       json_query(l.respuesta, '$.datos') rsp_datos
  FROM t_operacion_logs l, t_operaciones s
 WHERE s.id_operacion = l.id_operacion
;
comment on table V_OPERACION_LOGS is 'Logs de Operaciones';
comment on column V_OPERACION_LOGS.ID_OPERACION_LOG is 'Identificador del log';
comment on column V_OPERACION_LOGS.ID_OPERACION is 'Identificador de la operación';
comment on column V_OPERACION_LOGS.NOMBRE_OPERACION is 'Nombre de la operación';
comment on column V_OPERACION_LOGS.VERSION is 'Versión de la operación';
comment on column V_OPERACION_LOGS.FECHA_HORA_INICIO is 'Fecha/hora de inicio de la ejecución de la operación';
comment on column V_OPERACION_LOGS.FECHA_HORA_FIN is 'Fecha/hora de fin de la ejecución de la operación';
comment on column V_OPERACION_LOGS.DURACION is 'Duración de la ejecución de la operación';
comment on column V_OPERACION_LOGS.CONTEXTO is 'Contexto de la operación';
comment on column V_OPERACION_LOGS.CTX_DIRECCION_IP is 'Contexto de la operación: direccion_ip';
comment on column V_OPERACION_LOGS.CTX_CLAVE_APLICACION is 'Contexto de la operación: clave_aplicacion';
comment on column V_OPERACION_LOGS.CTX_ACCESS_TOKEN is 'Contexto de la operación: access_token';
comment on column V_OPERACION_LOGS.CTX_USUARIO is 'Contexto de la operación: usuario';
comment on column V_OPERACION_LOGS.CTX_TOKEN_DISPOSITIVO is 'Contexto de la operación: token_dispositivo';
comment on column V_OPERACION_LOGS.CTX_ID_EJECUCION is 'Contexto de la operación: id_ejecucion';
comment on column V_OPERACION_LOGS.PARAMETROS is 'Parámetros recibidos';
comment on column V_OPERACION_LOGS.PRMS is 'Parámetros recibidos: ';
comment on column V_OPERACION_LOGS.RESPUESTA is 'Respuesta enviada';
comment on column V_OPERACION_LOGS.RSP_CODIGO is 'Respuesta enviada: codigo';
comment on column V_OPERACION_LOGS.RSP_MENSAJE is 'Respuesta enviada: mensaje';
comment on column V_OPERACION_LOGS.RSP_MENSAJE_BD is 'Respuesta enviada: mensaje_bd';
comment on column V_OPERACION_LOGS.RSP_LUGAR is 'Respuesta enviada: lugar';
comment on column V_OPERACION_LOGS.RSP_DATOS is 'Respuesta enviada: datos';
/
