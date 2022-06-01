SELECT l.id_monitoreo_ejecucion id_ejecucion,
       l.id_monitoreo,
       --s.nombre,
       s.detalle,
       CAST(l.fecha_ejecucion at TIME ZONE 'America/Asuncion' AS DATE) fecha,
       dbms_lob.substr(l.datos, 4000) datos
  FROM t_monitoreo_ejecuciones l, t_operaciones s
 WHERE l.id_monitoreo = s.id_operacion
   AND l.id_monitoreo_ejecucion =
       nvl(to_number('&id_ejecucion'), l.id_monitoreo_ejecucion)
   AND l.id_monitoreo = nvl('&id_monitoreo', l.id_monitoreo)
 ORDER BY l.id_monitoreo_ejecucion DESC, l.id_monitoreo ASC;
