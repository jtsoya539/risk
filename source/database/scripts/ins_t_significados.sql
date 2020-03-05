prompt Importing table t_significados...
set feedback off
set define off
insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_CLAVE', 'A', 'ACCESO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_CLAVE', 'T', 'TRANSACCIONAL', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_SESION', 'A', 'ACTIVO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_SESION', 'X', 'EXPIRADO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_SESION', 'F', 'FINALIZADO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_PERSONA', 'F', 'FÍSICA', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_PERSONA', 'J', 'JURÍDICA', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_APLICACION', 'W', 'WEB', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_APLICACION', 'M', 'MOBILE', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_APLICACION', 'D', 'DESKTOP', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_USUARIO', 'A', 'ACTIVO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_USUARIO', 'I', 'INACTIVO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_USUARIO', 'B', 'BLOQUEADO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_SERVICIO', 'S', 'SOAP', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_SERVICIO', 'R', 'REST', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_CLAVE', 'N', 'NUEVO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_CLAVE', 'A', 'ACTIVO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_CLAVE', 'B', 'BLOQUEADO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('DIRECCION_PARAMETRO', 'I', 'ENTRADA', 'IN', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('DIRECCION_PARAMETRO', 'O', 'SALIDA', 'OUT', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('DIRECCION_PARAMETRO', 'A', 'AMBOS', 'IN OUT', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DATO_PARAMETRO', 'S', 'STRING', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DATO_PARAMETRO', 'N', 'NUMBER', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DATO_PARAMETRO', 'B', 'BOOLEAN', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DATO_PARAMETRO', 'D', 'DATE', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('DOMINIO_SERVICIO', 'GEN', 'GENERAL', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('DOMINIO_SERVICIO', 'AUT', 'AUTENTICACION', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('DOMINIO_SERVICIO', 'API', 'SERVICIO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_SESION', 'I', 'INACTIVO', null, 'S');

prompt Done.
