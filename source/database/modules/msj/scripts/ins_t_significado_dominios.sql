prompt Importing table t_significado_dominios...
set feedback off
set define off
insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('ESTADO_MENSAJERIA', 'ESTADO_MENSAJERIA', null, 'S', 'MSJ');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('EXTENSION_ADJUNTO', 'EXTENSION_ADJUNTO', null, 'S', 'MSJ');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('TIPO_MENSAJERIA', 'TIPO_MENSAJERIA', null, 'S', 'MSJ');

prompt Done.
