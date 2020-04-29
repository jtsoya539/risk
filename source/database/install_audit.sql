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

accept v_generar_auditoria char default 'N' prompt 'Generar campos y triggers de auditoria? (S/N)'

DECLARE
  CURSOR cr_tablas IS
    SELECT lower(table_name) AS tabla
      FROM user_tables
     WHERE lower(table_name) LIKE 't\_%' ESCAPE '\';
BEGIN
  IF upper('&v_generar_auditoria') = 'S' THEN
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
