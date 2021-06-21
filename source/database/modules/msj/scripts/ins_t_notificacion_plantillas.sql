prompt Importing table t_notificacion_plantillas...
set feedback off
set define off
insert into t_notificacion_plantillas (ID_APLICACION, ID_PLANTILLA, NOMBRE, ACTIVO, DETALLE, PLANTILLA)
values ('AND', 'GEN', 'GENERAL', 'S', 'Notificaciones generales para la plataforma Android', '{"notification":{"title":"$(titulo)","body":"$(contenido)"}}');

insert into t_notificacion_plantillas (ID_APLICACION, ID_PLANTILLA, NOMBRE, ACTIVO, DETALLE, PLANTILLA)
values ('IOS', 'GEN', 'GENERAL', 'S', 'Notificaciones generales para la plataforma iOS', '{"aps":{"alert":"$(contenido)"}}');

prompt Done.
