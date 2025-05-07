prompt Importing table t_flujo_pasos...
set feedback off
set define off

insert into t_flujo_pasos (ID_PASO, ID_FLUJO, NOMBRE, TIPO, ORDEN, ACCIONES_POSIBLES, BLOQUE_PLSQL, ROLES_RESPONSABLES, USUARIOS_RESPONSABLES)
values (1, 1, 'Inicio', 'INICIO', 1, '["APROBAR"]', null, null, null);

insert into t_flujo_pasos (ID_PASO, ID_FLUJO, NOMBRE, TIPO, ORDEN, ACCIONES_POSIBLES, BLOQUE_PLSQL, ROLES_RESPONSABLES, USUARIOS_RESPONSABLES)
values (2, 1, 'Verificación Documental', 'MANUAL', 2, '["VERIFICAR","RECHAZAR"]', null, null, '[":usuario_ingreso"]');

insert into t_flujo_pasos (ID_PASO, ID_FLUJO, NOMBRE, TIPO, ORDEN, ACCIONES_POSIBLES, BLOQUE_PLSQL, ROLES_RESPONSABLES, USUARIOS_RESPONSABLES)
values (3, 1, 'Aprobación Supervisores', 'APROBACION', 3, '["APROBAR","RECHAZAR","CONDICIONAR"]', null, '["MENSAJERIA","USUARIO","USUARIO","ADMINISTRADOR"]', null);

insert into t_flujo_pasos (ID_PASO, ID_FLUJO, NOMBRE, TIPO, ORDEN, ACCIONES_POSIBLES, BLOQUE_PLSQL, ROLES_RESPONSABLES, USUARIOS_RESPONSABLES)
values (4, 1, 'Evaluación Interna', 'MANUAL', 4, '["APROBAR","RECHAZAR"]', null, null, '[":usuario_oficial"]');

insert into t_flujo_pasos (ID_PASO, ID_FLUJO, NOMBRE, TIPO, ORDEN, ACCIONES_POSIBLES, BLOQUE_PLSQL, ROLES_RESPONSABLES, USUARIOS_RESPONSABLES)
values (5, 1, 'Aprobación Gerente', 'APROBACION', 5, '["APROBAR","RECHAZAR"]', null, '["ADMINISTRADOR"]', null);

insert into t_flujo_pasos (ID_PASO, ID_FLUJO, NOMBRE, TIPO, ORDEN, ACCIONES_POSIBLES, BLOQUE_PLSQL, ROLES_RESPONSABLES, USUARIOS_RESPONSABLES)
values (6, 1, 'Notificación Cliente', 'AUTOMATICO', 6, '["APROBAR"]', 'DBMS_OUTPUT.PUT_LINE( ''Notifico al cliente: '' || :cliente_id || '' que su operacion fue procesada con monto :monto.'');', null, null);

insert into t_flujo_pasos (ID_PASO, ID_FLUJO, NOMBRE, TIPO, ORDEN, ACCIONES_POSIBLES, BLOQUE_PLSQL, ROLES_RESPONSABLES, USUARIOS_RESPONSABLES)
values (10, 1, 'Verificación Condicionado', 'MANUAL', 7, '["LEVANTAR","RECHAZAR"]', null, null, null);

prompt Done.
