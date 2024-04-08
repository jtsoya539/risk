SELECT l.id_operacion_log,
       l.id_operacion,
       s.nombre nombre_operacion,
       l.version,
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
-- AND s.id_operacion = &id_operacion
 ORDER BY l.id_operacion_log DESC;
