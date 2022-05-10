prompt Importing table t_significado_dominios...
set feedback off
set define off
insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('ESTADO_MENSAJERIA', 'Estados de mensajer�as', null, 'S', 'MSJ');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('EXTENSION_ADJUNTO', 'Extensiones permitidas para archivos adjuntos de Correos electr�nicos (E-mail)', 'El valor de la referencia indica el tipo MIME relacionado a la extensi�n', 'S', 'MSJ');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('TIPO_MENSAJERIA', 'Tipos de mensajer�as', null, 'S', 'MSJ');

prompt Done.
