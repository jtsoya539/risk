CREATE OR REPLACE VIEW V_HISTORIAL_APROBACIONES AS
SELECT ap.id_aprobacion,
       i.id_instancia,
       ap.id_paso_instancia,
       f.nombre             AS nombre_flujo,
       p.nombre             AS nombre_paso,
       ap.aprobado,
       ap.usuario_aprobador,
       ap.rol_aprobador,
       ap.comentario,
       ap.fecha_aprobacion
  FROM t_flujo_instancia_aprobaciones ap
  JOIN t_flujo_instancia_pasos i
    ON ap.id_paso_instancia = i.id_paso_instancia
  JOIN t_flujo_instancias j
    ON i.id_instancia = j.id_instancia
  JOIN t_flujos f
    ON j.id_flujo = f.id_flujo
  JOIN t_flujo_pasos p
    ON i.id_paso = p.id_paso
   AND i.id_paso = p.id_paso
 ORDER BY ap.fecha_aprobacion;
