SELECT l.id_servicio_log,
       l.id_servicio,
       s.nombre,
       to_char(l.parametros) parametros,
       to_char(l.respuesta) respuesta
  FROM t_servicio_logs l, t_servicios s
 WHERE s.id_servicio = l.id_servicio
   AND s.id_servicio = &id_servicio
 ORDER BY l.id_servicio_log DESC;
