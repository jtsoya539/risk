DECLARE
  CURSOR cr_tablas IS
    SELECT lower(table_name) tabla
      FROM user_tables
     WHERE lower(table_name) LIKE 't_%';
BEGIN
  FOR t IN cr_tablas LOOP
    k_auditoria.p_generar_campos_auditoria(i_tabla => t.tabla);
    k_auditoria.p_generar_trigger_auditoria(i_tabla => t.tabla);
  END LOOP;
END;
