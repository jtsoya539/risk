CREATE OR REPLACE VIEW V_PROXIMOS_PASOS AS
SELECT pi.id_instancia,
       pi.id_paso        AS id_paso_actual,
       p.nombre          AS nombre_paso_actual,
       t.id_paso_destino,
       pd.nombre         AS nombre_paso_destino,
       t.condicion,
       t.accion
  FROM t_flujo_instancia_pasos pi
  JOIN t_flujo_pasos p
    ON pi.id_paso = p.id_paso
  JOIN t_flujo_transiciones t
    ON pi.id_paso = t.id_paso_origen
  JOIN t_flujo_pasos pd
    ON t.id_paso_destino = pd.id_paso
 WHERE pi.estado = 'EN_PROGRESO';
