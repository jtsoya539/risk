PL/SQL Developer Test script 3.0
20
BEGIN
  FOR tab IN (SELECT t.table_name, tc.comments
                FROM user_tables t, user_tab_comments tc
               WHERE tc.table_name = t.table_name
                 AND lower(t.table_name) LIKE 't\_%' ESCAPE '\'
               ORDER BY t.table_name) LOOP
    dbms_output.put_line(rpad('-', 80, '-'));
    dbms_output.put_line(tab.table_name || ' - ' || tab.comments);
    dbms_output.put_line(rpad('-', 80, '-'));
  
    FOR col IN (SELECT c.column_name, c.data_type, cc.comments
                  FROM user_tab_cols c, user_col_comments cc
                 WHERE cc.table_name = c.table_name
                   AND cc.column_name = c.column_name
                   AND c.table_name = tab.table_name
                 ORDER BY c.column_id) LOOP
      dbms_output.put_line(col.column_name || ' - ' || col.comments);
    END LOOP;
  END LOOP;
END;
0
0
