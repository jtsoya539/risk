prompt Importing table t_migraciones...
set feedback off
set define off
insert into t_migraciones (ID_MIGRACION, DESCRIPCION)
values ('mig_000001', 'Actualiza fecha del sistema a SYSDATE');

prompt Done.
