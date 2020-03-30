SELECT o.*
  FROM user_objects o
 WHERE ((o.object_type = 'TYPE' AND lower(o.object_name) LIKE 'y\_%' ESCAPE '\') OR
       (o.object_type = 'TABLE' AND lower(o.object_name) LIKE 't\_%' ESCAPE '\') OR
       (o.object_type = 'PACKAGE' AND lower(o.object_name) LIKE 'k\_%'
        ESCAPE '\') OR (o.object_type = 'SEQUENCE' AND
       lower(o.object_name) LIKE 's\_%' ESCAPE '\') OR
       (o.object_type = 'TRIGGER' AND lower(o.object_name) LIKE 'g%\_%'
        ESCAPE '\'))
   AND o.object_type = 'TABLE'
 ORDER BY o.object_name;
