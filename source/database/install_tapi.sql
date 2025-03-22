/*
--------------------------------- MIT License ---------------------------------
Copyright (c) 2019 jtsoya539

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-------------------------------------------------------------------------------
*/

set define on
set serveroutput on size unlimited

accept v_generate_tapi char default 'N' prompt 'Generate TAPI? (Y/N)'

DECLARE
  l_audit_column_mappings VARCHAR2(4000);
  l_audit_user_expression VARCHAR2(4000);

  CURSOR cr_tablas IS
    SELECT lower(table_name) AS tabla
      FROM user_tables
     WHERE lower(table_name) LIKE 't\_%' ESCAPE '\';
BEGIN
  IF upper('&v_generate_tapi') = 'Y' THEN
    l_audit_column_mappings := 'created=' ||
                               k_auditoria.g_nombre_campo_created ||
                               ', created_by=' ||
                               k_auditoria.g_nombre_campo_created_by ||
                               ', updated=' ||
                               k_auditoria.g_nombre_campo_updated ||
                               ', updated_by=' ||
                               k_auditoria.g_nombre_campo_updated_by;
    l_audit_user_expression := 'substr(coalesce(k_sistema.f_usuario, user), 1, 300)';
    FOR t IN cr_tablas LOOP
      dbms_output.put_line('Generating TAPI for table ' || upper(t.tabla) ||
                           '...');
      dbms_output.put_line('-----------------------------------');
      BEGIN
        om_tapigen.compile_api(p_table_name               => upper(t.tabla),
                               p_enable_insertion_of_rows => TRUE,
                               p_enable_update_of_rows    => TRUE,
                               p_enable_deletion_of_rows  => TRUE,
                               p_double_quote_names       => FALSE,
                               p_enable_dml_view          => TRUE,
                               p_enable_one_to_one_view   => TRUE,
                               p_audit_column_mappings    => l_audit_column_mappings,
                               p_audit_user_expression    => l_audit_user_expression);
      EXCEPTION
        WHEN OTHERS THEN
          dbms_output.put_line(SQLERRM);
      END;
    END LOOP;
  END IF;
END;
/

set serveroutput off
set define off

@@compile_schema.sql
