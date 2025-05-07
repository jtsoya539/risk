CREATE OR REPLACE VIEW V_USUARIOS_RESPONSABLES_PASO AS
SELECT s.id_paso_instancia,
       s.id_instancia,
       s.id_paso,
       jt.posicion,
       jt.valor id_usuario
  FROM t_flujo_instancia_pasos s,
       json_table(s.usuarios_responsables,
                  '$[*]' columns(posicion FOR ordinality,
                          valor VARCHAR2(100) path '$')) jt;
