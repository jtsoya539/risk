CREATE OR REPLACE VIEW V_HISTORIAL_INSTANCIA AS
SELECT h.id_historial,
       h.id_instancia,
       f.nombre       AS nombre_flujo,
       p.nombre       AS nombre_paso,
       h.accion,
       h.usuario,
       h.comentario,
       h.fecha
  FROM t_flujo_instancia_historial h
  JOIN t_flujo_instancias i
    ON h.id_instancia = i.id_instancia
  JOIN t_flujos f
    ON i.id_flujo = f.id_flujo
  JOIN t_flujo_pasos p
    ON h.id_paso = p.id_paso
 ORDER BY h.fecha;
