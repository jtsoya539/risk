SELECT l.id_operacion_log,
       l.id_operacion,
       s.nombre,
       dbms_lob.substr(l.contexto, 4000) contexto,
       dbms_lob.substr(l.parametros, 4000) parametros,
       dbms_lob.substr(l.respuesta, 4000) respuesta,
       l.contexto,
       l.parametros,
       l.respuesta
  FROM t_operacion_logs l, t_operaciones s
 WHERE s.id_operacion = l.id_operacion
-- AND s.id_operacion = &id_operacion
 ORDER BY l.id_operacion_log DESC;
