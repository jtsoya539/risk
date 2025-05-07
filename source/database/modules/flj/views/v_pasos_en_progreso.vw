CREATE OR REPLACE VIEW V_PASOS_EN_PROGRESO AS
SELECT i.id_instancia,
       pi.id_paso_instancia,
       f.nombre AS nombre_flujo,
       p.id_paso,
       p.tipo,
       p.nombre AS nombre_paso,
       pi.fecha_inicio,
       dbms_lob.substr(i.variables, 4000) variables,
       p.acciones_posibles,
       pi.roles_responsables,
       pi.usuarios_responsables
  FROM t_flujo_instancia_pasos pi
  JOIN t_flujo_instancias i
    ON pi.id_instancia = i.id_instancia
  JOIN t_flujos f
    ON i.id_flujo = f.id_flujo
  JOIN t_flujo_pasos p
    ON pi.id_paso = p.id_paso
 WHERE pi.estado = 'EN_PROGRESO';
