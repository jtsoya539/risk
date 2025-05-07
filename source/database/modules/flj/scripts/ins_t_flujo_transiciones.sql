prompt Importing table t_flujo_transiciones...
set feedback off
set define off

insert into t_flujo_transiciones (ID_TRANSICION, ID_PASO_ORIGEN, ID_PASO_DESTINO, CONDICION, ACCION)
values (1, 1, 2, null, 'APROBAR');

insert into t_flujo_transiciones (ID_TRANSICION, ID_PASO_ORIGEN, ID_PASO_DESTINO, CONDICION, ACCION)
values (2, 2, 3, null, 'VERIFICAR');

insert into t_flujo_transiciones (ID_TRANSICION, ID_PASO_ORIGEN, ID_PASO_DESTINO, CONDICION, ACCION)
values (3, 3, 4, null, 'APROBAR');

insert into t_flujo_transiciones (ID_TRANSICION, ID_PASO_ORIGEN, ID_PASO_DESTINO, CONDICION, ACCION)
values (4, 4, 5, ':monto > 10000', 'APROBAR');

insert into t_flujo_transiciones (ID_TRANSICION, ID_PASO_ORIGEN, ID_PASO_DESTINO, CONDICION, ACCION)
values (5, 4, 6, ':monto <= 10000', 'APROBAR');

insert into t_flujo_transiciones (ID_TRANSICION, ID_PASO_ORIGEN, ID_PASO_DESTINO, CONDICION, ACCION)
values (6, 5, 6, null, 'APROBAR');

insert into t_flujo_transiciones (ID_TRANSICION, ID_PASO_ORIGEN, ID_PASO_DESTINO, CONDICION, ACCION)
values (7, 2, 6, null, 'RECHAZAR');

insert into t_flujo_transiciones (ID_TRANSICION, ID_PASO_ORIGEN, ID_PASO_DESTINO, CONDICION, ACCION)
values (24, 10, 3, null, 'LEVANTAR');

insert into t_flujo_transiciones (ID_TRANSICION, ID_PASO_ORIGEN, ID_PASO_DESTINO, CONDICION, ACCION)
values (25, 10, 6, null, 'RECHAZAR');

insert into t_flujo_transiciones (ID_TRANSICION, ID_PASO_ORIGEN, ID_PASO_DESTINO, CONDICION, ACCION)
values (26, 3, 10, null, 'CONDICIONAR');

prompt Done.
