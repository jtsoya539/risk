PL/SQL Developer Test script 3.0
16
DECLARE
  l_file_collection plex.tab_export_files;
BEGIN
  l_file_collection := plex.backapp(p_include_object_ddl => TRUE,
                                    p_include_data       => TRUE,
                                    p_data_format        => 'insert',
                                    p_include_templates  => TRUE);

  -- do something with the file collection
  FOR i IN 1 .. l_file_collection.count LOOP
    dbms_output.put_line(i || ' | ' || lpad(round(length(l_file_collection(i).contents) / 1024),
                                            3) || ' kB' || ' | ' || l_file_collection(i).name);
  END LOOP;

  :RESULT := plex.to_zip(p_file_collection => l_file_collection);
END;
1
result
1
<BLOB>
4209
0
