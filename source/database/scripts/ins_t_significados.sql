prompt Importing table t_significados...
set feedback off
set define off

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_ACCESO', 'LONGITUD_MINIMA', '8', 'A', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_ACCESO', 'CAN_MAX_CARACTERES_IGUALES', '2', 'A', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_ACCESO', 'CAN_MIN_LETRAS_ABECEDARIO', '3', 'A', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_ACCESO', 'CAN_MIN_MAYUSCULAS', '1', 'A', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_ACCESO', 'CAN_MIN_MINUSCULAS', '1', 'A', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_ACCESO', 'CAN_MIN_CARACTERES_ESPECIALES', '1', 'A', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_ACCESO', 'VAL_ALIAS_IGUAL', 'S', 'A', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_ACCESO', 'VAL_ALIAS_CONTENIDO', 'S', 'A', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_ACCESO', 'CAN_MIN_NUMEROS', '1', 'A', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_TRANSACCIONAL', 'CAN_MAX_CARACTERES_IGUALES', '2', 'T', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_TRANSACCIONAL', 'CAN_MIN_CARACTERES_ESPECIALES', '1', 'T', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_TRANSACCIONAL', 'CAN_MIN_LETRAS_ABECEDARIO', '3', 'T', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_TRANSACCIONAL', 'CAN_MIN_MAYUSCULAS', '1', 'T', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_TRANSACCIONAL', 'CAN_MIN_MINUSCULAS', '1', 'T', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_TRANSACCIONAL', 'CAN_MIN_NUMEROS', '1', 'T', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_TRANSACCIONAL', 'LONGITUD_MINIMA', '6', 'T', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_TRANSACCIONAL', 'VAL_ALIAS_CONTENIDO', 'S', 'T', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_TRANSACCIONAL', 'VAL_ALIAS_IGUAL', 'S', 'T', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_ACCESO', 'CARACTERES_PROHIBIDOS', '&:@', 'A', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('POLITICA_VALIDACION_CLAVE_TRANSACCIONAL', 'CARACTERES_PROHIBIDOS', '&:@', 'T', 'S');

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
values ('ORIGEN_SESION', 'R', 'RISK', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ORIGEN_SESION', 'G', 'GOOGLE', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ORIGEN_SESION', 'F', 'FACEBOOK', null, 'S');

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
values ('ESTADO_USUARIO', 'A', 'ACTIVO', 'USUARIO', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_USUARIO', 'I', 'INACTIVO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_USUARIO', 'B', 'BLOQUEADO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ORIGEN_USUARIO', 'R', 'RISK', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ORIGEN_USUARIO', 'G', 'GOOGLE', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ORIGEN_USUARIO', 'F', 'FACEBOOK', null, 'S');

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
values ('ESTADO_MENSAJERIA', 'A', 'ANULADO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DATO_PARAMETRO', 'O', 'OBJECT', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_SERVICIO', 'C', 'CONSULTA', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_FUENTE', 'TTF', 'FUENTE TRUETYPE', 'font/ttf', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_FUENTE', 'OTF', 'FUENTE OPENTYPE', 'font/otf', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_IMAGEN', 'JPG', 'IMAGEN JPG', 'image/jpeg', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_REPORTE', 'DOCX', 'REPORTE DOCX', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_REPORTE', 'PDF', 'REPORTE PDF', 'application/pdf', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_REPORTE', 'XLSX', 'REPORTE XLSX', 'application/octet-stream', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('ESTADO_USUARIO', 'P', 'PENDIENTE DE ACTIVACIÓN', 'USUARIO_NUEVO', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_OPERACION', 'S', 'SERVICIO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_OPERACION', 'R', 'REPORTE', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_OPERACION', 'T', 'TRABAJO', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DISPOSITIVO', 'M', 'MOBILE', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DISPOSITIVO', 'T', 'TABLET', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DISPOSITIVO', 'D', 'DESKTOP', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DISPOSITIVO', 'V', 'TV', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_DISPOSITIVO', 'W', 'WATCH', null, 'S');

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

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_REPORTE', 'H', 'AD HOC', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('TIPO_REPORTE', 'C', 'CONSULTA', null, 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_REPORTE', 'HTML', 'REPORTE HTML', 'text/html', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_REPORTE', 'CSV', 'REPORTE CSV', 'text/csv', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_FUENTE', 'WOFF', 'FUENTE WEB OPEN FONT FORMAT', 'font/woff', 'S');

insert into t_significados (DOMINIO, CODIGO, SIGNIFICADO, REFERENCIA, ACTIVO)
values ('EXTENSION_FUENTE', 'WOFF2', 'FUENTE WEB OPEN FONT FORMAT 2', 'font/woff2', 'S');

prompt Done.
