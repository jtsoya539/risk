CREATE OR REPLACE VIEW V_ESTADO_FLUJO AS
SELECT i.id_instancia,
       pi.id_paso_instancia,
       f.nombre             AS nombre_flujo,
       i.estado             AS estado_instancia,
       i.usuario_ingreso,
       i.fecha_inicio,
       i.fecha_fin,
       p.id_paso,
       p.nombre             AS nombre_paso,
       pi.estado            AS estado_paso,
       pi.resultado,
       pi.fecha_inicio      AS inicio_paso,
       pi.fecha_fin         AS fin_paso
  FROM t_flujo_instancias i
  JOIN t_flujos f
    ON i.id_flujo = f.id_flujo
  LEFT JOIN t_flujo_instancia_pasos pi
    ON i.id_instancia = pi.id_instancia
  LEFT JOIN t_flujo_pasos p
    ON pi.id_paso = p.id_paso;
