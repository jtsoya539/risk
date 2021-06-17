En este directorio se almacenarán los scripts de los objetos de Base de Datos de los módulos que añaden funcionalidades adicionales al Proyecto RISK.

Para una mejor organización, se recomienda que los scripts de cada módulo se almacenen en un sub-directorio con el nombre del identificador del módulo.

Cada módulo debe obligatoriamente contar con los siguientes scripts:

* install.sql
* install_dependencies.sql
* uninstall.sql
* uninstall_dependencies.sql