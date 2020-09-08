prompt Importing table t_significados...
set feedback off
set define off
insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_OPERACION', 'P', 'PARÁMETROS', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_MENSAJERIA', 'M', 'MAIL', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_MENSAJERIA', 'S', 'SMS', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_MENSAJERIA', 'P', 'PUSH', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_APLICACION', 'S', 'SERVICIO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_IMAGEN', 'WEBP', 'IMAGEN WEBP', 'image/webp', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_IMAGEN', 'BMP', 'IMAGEN BMP', 'image/bmp', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_IMAGEN', 'GIF', 'IMAGEN GIF', 'image/gif', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_IMAGEN', 'JPEG', 'IMAGEN JPEG', 'image/jpeg', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_IMAGEN', 'PNG', 'IMAGEN PNG', 'image/png', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_IMAGEN', 'SVG', 'IMAGEN SVG', 'image/svg+xml', 'N');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_DOCUMENTO', 'BMP', 'DOCUMENTO BMP', 'image/bmp', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_DOCUMENTO', 'GIF', 'DOCUMENTO GIF', 'image/gif', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_DOCUMENTO', 'JPEG', 'DOCUMENTO JPEG', 'image/jpeg', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_DOCUMENTO', 'PNG', 'DOCUMENTO PNG', 'image/png', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_DOCUMENTO', 'SVG', 'DOCUMENTO SVG', 'image/svg+xml', 'N');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_DOCUMENTO', 'DOC', 'DOCUMENTO DOC', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_DOCUMENTO', 'DOCX', 'DOCUMENTO DOCX', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_DOCUMENTO', 'PDF', 'DOCUMENTO PDF', 'application/pdf', 'S');

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
values ('TIPO_SERVICIO', 'T', 'TRANSACCIÓN', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_SERVICIO', 'P', 'PROCESO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_CLAVE', 'N', 'NUEVO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_CLAVE', 'A', 'ACTIVO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_CLAVE', 'B', 'BLOQUEADO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DATO_PARAMETRO', 'S', 'STRING', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DATO_PARAMETRO', 'N', 'NUMBER', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DATO_PARAMETRO', 'B', 'BOOLEAN', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DATO_PARAMETRO', 'D', 'DATE', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('DOMINIO_OPERACION', 'GEN', 'GENERAL', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('DOMINIO_OPERACION', 'AUT', 'AUTENTICACIÓN', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('DOMINIO_OPERACION', 'API', 'SERVICIO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_SESION', 'I', 'INVÁLIDO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_MENSAJERIA', 'P', 'PENDIENTE DE ENVÍO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_MENSAJERIA', 'N', 'EN PROCESO DE ENVÍO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_MENSAJERIA', 'E', 'ENVIADO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_MENSAJERIA', 'R', 'PROCESADO CON ERROR', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('DOMINIO_OPERACION', 'MSJ', 'MENSAJERÍA', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_MENSAJERIA', 'A', 'ANULADO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DATO_PARAMETRO', 'O', 'OBJECT', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_SERVICIO', 'R', 'REPORTE', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_SERVICIO', 'C', 'CONSULTA', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_FUENTE', 'TTF', 'FUENTE TRUETYPE', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_FUENTE', 'OTF', 'FUENTE OPENTYPE', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_IMAGEN', 'JPG', 'IMAGEN JPG', 'image/jpeg', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_REPORTE', 'DOCX', 'REPORTE DOCX', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_REPORTE', 'PDF', 'REPORTE PDF', 'application/pdf', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_REPORTE', 'XLSX', 'REPORTE XLSX', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_REPORTE', 'TXT', 'REPORTE TXT', 'text/plain', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_USUARIO', 'P', 'PENDIENTE DE ACTIVACIÓN', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_OPERACION', 'S', 'SERVICIO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_OPERACION', 'R', 'REPORTE', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_OPERACION', 'T', 'TRABAJO', null, 'S');

prompt Done.
