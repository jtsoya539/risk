En este directorio se almacenarán los scripts de las migraciones para realizar cambios en la estructura, programas o datos de la Base de Datos luego de que haya sido implementada la versión inicial en producción.

Para una mejor organización, se recomienda que los scripts de cada migración se almacenen en un sub-directorio con el nombre del identificador de la migración.

Cada migración debe obligatoriamente contar con los siguientes scripts:

* ins_t_migraciones.sql
* install.sql