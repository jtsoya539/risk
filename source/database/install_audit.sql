set define on
set serveroutput on size unlimited

accept v_generar_auditoria char prompt 'Generar campos y triggers de auditoria? (S/N)'

DECLARE
  CURSOR cr_tablas IS
    SELECT lower(table_name) tabla
      FROM user_tables
     WHERE lower(table_name) LIKE 't\_%' ESCAPE '\';
BEGIN
  IF lower('&v_generar_auditoria') = 's' THEN
    FOR t IN cr_tablas LOOP
      dbms_output.put_line('Generando campos de auditoria para tabla ' ||
                           upper(t.tabla) || '...');
      dbms_output.put_line('-----------------------------------');
      k_auditoria.p_generar_campos_auditoria(i_tabla => t.tabla);
      dbms_output.put_line('Generando triggers de auditoria para tabla ' ||
                           upper(t.tabla) || '...');
      dbms_output.put_line('-----------------------------------');
      k_auditoria.p_generar_trigger_auditoria(i_tabla => t.tabla);
    END LOOP;
  END IF;
END;
/

set serveroutput off
set define off
