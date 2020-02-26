set serveroutput on size unlimited

BEGIN
  dbms_output.put_line('Compilando objetos invalidos para el esquema ' ||
                       upper(sys_context('USERENV', 'CURRENT_SCHEMA')) ||
                       '...');
  dbms_output.put_line('-----------------------------------');
  dbms_utility.compile_schema(SCHEMA      => sys_context('USERENV',
                                                         'CURRENT_SCHEMA'),
                              compile_all => FALSE);
END;
/

set serveroutput off
