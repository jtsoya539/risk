prompt Importing table t_parametros...
set feedback off
set define off
insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('REGEXP_VALIDAR_DIRECCION_CORREO', 'Expresión Regular para validación de direcciones de correo electrónico', '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');

insert into t_parametros (ID_PARAMETRO, DESCRIPCION, VALOR)
values ('REGEXP_VALIDAR_NUMERO_TELEFONO', 'Expresión Regular para validación de números de teléfono', '^(\+595|0)9[6-9][1-9][0-9]{6}$');

prompt Done.
