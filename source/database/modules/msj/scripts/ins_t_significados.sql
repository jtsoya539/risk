prompt Importing table t_significados...
set feedback off
set define off
insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_MENSAJERIA', 'M', 'MAIL', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_MENSAJERIA', 'S', 'SMS', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_MENSAJERIA', 'P', 'PUSH', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'BMP', 'ADJUNTO BMP', 'image/bmp', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'GIF', 'ADJUNTO GIF', 'image/gif', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'JPEG', 'ADJUNTO JPEG', 'image/jpeg', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'PNG', 'ADJUNTO PNG', 'image/png', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'SVG', 'ADJUNTO SVG', 'image/svg+xml', 'N');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'DOC', 'ADJUNTO DOC', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'DOCX', 'ADJUNTO DOCX', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'PDF', 'ADJUNTO PDF', 'application/pdf', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_MENSAJERIA', 'P', 'PENDIENTE DE ENVÍO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_MENSAJERIA', 'N', 'EN PROCESO DE ENVÍO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_MENSAJERIA', 'E', 'ENVIADO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_MENSAJERIA', 'R', 'PROCESADO CON ERROR', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_MENSAJERIA', 'A', 'ANULADO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'JPG', 'ADJUNTO JPG', 'image/jpeg', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'WEBP', 'ADJUNTO WEBP', 'image/webp', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'XLS', 'ADJUNTO XLS', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'XLSX', 'ADJUNTO XLSX', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'PPT', 'ADJUNTO PPT', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'PPTX', 'ADJUNTO PPTX', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'ZIP', 'ADJUNTO ZIP', 'application/zip', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'RAR', 'ADJUNTO RAR', 'application/vnd.rar', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', '7Z', 'ADJUNTO 7Z', 'application/x-7z-compressed', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'TAR', 'ADJUNTO TAR', 'application/x-tar', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'TXT', 'ADJUNTO TXT', 'text/plain', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'CSV', 'ADJUNTO CSV', 'text/csv', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_ADJUNTO', 'EPUB', 'ADJUNTO EPUB', 'application/epub+zip', 'S');

prompt Done.
