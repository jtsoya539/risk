SELECT l.id_servicio_log,
       l.id_servicio,
       s.nombre,
       dbms_lob.substr(l.parametros, 4000) parametros,
       dbms_lob.substr(l.respuesta, 4000) respuesta,
       l.parametros,
       l.respuesta
  FROM t_servicio_logs l, t_servicios s
 WHERE s.id_servicio = l.id_servicio
-- AND s.id_servicio = &id_servicio
 ORDER BY l.id_servicio_log DESC;
