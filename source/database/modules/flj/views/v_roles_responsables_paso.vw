CREATE OR REPLACE VIEW V_ROLES_RESPONSABLES_PASO AS
SELECT s.id_paso_instancia,
       s.id_instancia,
       s.id_paso,
       jt.posicion,
       jt.valor id_rol
  FROM t_flujo_instancia_pasos s,
       json_table(s.roles_responsables,
                  '$[*]' columns(posicion FOR ordinality,
                          valor VARCHAR2(100) path '$')) jt;
