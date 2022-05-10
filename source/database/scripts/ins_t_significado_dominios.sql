prompt Importing table t_significado_dominios...
set feedback off
set define off
insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('ACCION_PERMISO', 'Acciones que pueden realizarse sobre un permiso', null, 'S', 'AUT');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('ESTADO_CLAVE', 'Estados de claves', null, 'S', 'AUT');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('ESTADO_SESION', 'Estados de sesiones', null, 'S', 'AUT');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('ESTADO_USUARIO', 'Estados de usuarios', 'El valor de la referencia indica el nombre del rol que se agrega por defecto a un usuario cuando se registra', 'S', 'GEN');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('EXTENSION_FUENTE', 'Extensiones permitidas para archivos de fuentes', 'El valor de la referencia indica el tipo MIME relacionado a la extensi�n', 'S', 'GEN');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('EXTENSION_IMAGEN', 'Extensiones permitidas para archivos de im�genes', 'El valor de la referencia indica el tipo MIME relacionado a la extensi�n', 'S', 'GEN');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('EXTENSION_REPORTE', 'Extensiones permitidas para archivos de reportes', 'El valor de la referencia indica el tipo MIME relacionado a la extensi�n', 'S', 'GEN');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('ORIGEN_SESION', 'Or�genes de sesiones', null, 'S', 'AUT');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('ORIGEN_USUARIO', 'Or�genes de usuarios', null, 'S', 'GEN');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('POLITICA_VALIDACION_CLAVE_ACCESO', 'Pol�ticas para validaci�n de claves de acceso', 'El valor de la referencia indica el tipo de clave', 'S', 'AUT');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('POLITICA_VALIDACION_CLAVE_TRANSACCIONAL', 'Pol�ticas para validaci�n de claves transaccionales', 'El valor de la referencia indica el tipo de clave', 'S', 'AUT');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('TIPO_APLICACION', 'Tipos de aplicaciones', null, 'S', 'GEN');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('TIPO_CLAVE', 'Tipos de claves', null, 'S', 'AUT');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('TIPO_DATO_PARAMETRO', 'Tipos de dato de par�metros', null, 'S', 'API');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('TIPO_DISPOSITIVO', 'Tipos de dispositivos', null, 'S', 'GEN');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('TIPO_OPERACION', 'Tipos de operaciones', null, 'S', 'API');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('TIPO_PERSONA', 'Tipos de personas', null, 'S', 'GEN');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('TIPO_REPORTE', 'Tipos de reportes', null, 'S', 'API');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('TIPO_SERVICIO', 'Tipos de servicios', null, 'S', 'API');

insert into t_significado_dominios (DOMINIO, DESCRIPCION, DETALLE, ACTIVO, ID_DOMINIO)
values ('TIPO_IMPLEMENTACION', 'Tipos de implementaci�n de operaciones', 'El valor de la referencia se utiliza para armar el nombre del programa a ejecutar para la operaci�n. Ver la funci�n k_operacion.f_nombre_programa', 'S', 'API');

prompt Done.
