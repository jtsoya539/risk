CREATE OR REPLACE VIEW V_FLUJO_APROBADOR AS
SELECT s.id_paso, s.nombre, jt.posicion, jt.valor grupo_aprobador
  FROM t_flujo_pasos s,
       json_table(s.roles_responsables,
                  '$[*]' columns(posicion FOR ordinality,
                          valor VARCHAR2(100) path '$')) jt
 WHERE s.tipo = 'APROBACION';
