# Base de Datos

## Contenido
* [Introducción](#introducción)
* [Instalación](#instalación)
* [Operaciones](#operaciones)
* [Configuraciones](#configuraciones)
* [API PL/SQL](plsqldoc/index.html)
* [Guía de estilo para Desarrollo](styleguide.md)

## Introducción
Este componente consiste en una instancia de Base de Datos Oracle con un esquema central en el que se encuentra instalada una colección de objetos (paquetes, types, tablas, entre otros), que se encarga de persistir los datos e implementar la mayor parte de la lógica de negocio del sistema.

## Instalación
En la carpeta *source/database* está disponible una serie de scripts para la instalación y manejo del esquema de Base de Datos:

Script|Descripción
------|-----------
compile_schema.sql|Compila objetos inválidos del esquema actual.
create_access_user.sql|Crea usuario y otorga permisos necesarios para llamar a los servicios del Proyecto RISK. Se debe ejecutar con SYS o SYSTEM.
create_code_user.sql|Crea usuario y otorga permisos necesarios para instalar los objetos de Base de Datos del Proyecto RISK. Se debe ejecutar con SYS o SYSTEM. (Desarrollo)
create_code_user_production.sql|Crea usuario y otorga permisos necesarios para instalar los objetos de Base de Datos del Proyecto RISK. Se debe ejecutar con SYS o SYSTEM. (Producción)
generate_docs.sql|Genera archivos de documentación de objetos de Base de Datos con la herramienta *plsqldoc*. Se debe ejecutar desde un Command Window de PL/SQL Developer con el plug-in *plsqldoc* instalado (Ver [Configuración de PL/SQL Documentation (plsqldoc)](#configuración-de-plsql-documentation-plsqldoc)).
install.sql|Instala en el esquema actual los objetos de Base de Datos del Proyecto RISK.
install_audit.sql|Genera campos y triggers de auditoría para tablas del esquema actual.
install_dependencies.sql|Instala en el esquema actual las dependencias de terceros (Ver [Dependencias](#dependencias)).
install_tapi.sql|Genera API's para tablas del esquema actual.
uninstall.sql|Desinstala del esquema actual los objetos de Base de Datos del Proyecto RISK.
uninstall_audit.sql|Elimina campos y triggers de auditoría para tablas del esquema actual.
uninstall_dependencies.sql|Desinstala del esquema actual las dependencias de terceros.
uninstall_tapi.sql|Elimina API's para tablas del esquema actual.

### Dependencias

Dependencia|Descripción
-----------|-----------
[as_crypto](https://github.com/antonscheffer/as_crypto)|Contiene funciones/procedimientos básicos de criptografía (alternativa a dbms_crypto)
[as_pdf](https://github.com/jtsoya539/as_pdf)|Genera archivos en formato PDF
[as_xlsx](https://github.com/antonscheffer/as_xlsx)|Genera archivos en formato XLSX
[as_zip](https://github.com/antonscheffer/as_zip)|Comprime y descomprime archivos en formato ZIP
[csv](https://oracle-base.com/dba/script?category=miscellaneous&file=csv.sql)|Genera archivos en formato CSV
[oos_util_totp](https://github.com/OraOpenSource/oos-utils)|Genera y valida códigos con el algoritmo TOTP
[zt_qr](https://github.com/zorantica/plsql-qr-code)|Genera códigos QR
[zt_word](https://github.com/zorantica/plsql-word)|Genera archivos en formato DOCX
[fn_gen_inserts](https://github.com/teopost/oracle-scripts)|Genera script para insertar registros en una tabla
[console](https://github.com/ogobrecht/console)|Herramienta para logging
[om_tapigen](https://github.com/OraMUC/table-api-generator)|Generador de API's para tablas
[plex](https://github.com/ogobrecht/plex)|Herramienta para exportación de objetos

### Configuración de PL/SQL Documentation (plsqldoc)

Para configurar el Plug-In PL/SQL Documentation (plsqldoc) en PL/SQL Developer seguir estos pasos:

1. Ir al menú *Plug-Ins* y en el apartado *plsqldoc* dar click en *Configure...*

![](plugins_configure.png)

2. Usar la siguiente configuración:

![](plsqldoc_config.png)

## Operaciones

El corazón de RISK está en las operaciones y el procesamiento de sus parámetros.

Una operación es cualquier programa o proceso que recibe parámetros de entrada y retorna una salida como resultado.

El resultado de una operación puede variar desde un simple indicador de éxito/error a datos complejos con propiedades y listas, o incluso archivos, como en el caso de los reportes.

Existen 5 tipos de operaciones:

Tipo|Descripción
----|-----------
Parámetros|Es un tipo de operación que sirve para agrupar ciertos parámetros especiales y no tiene una implementación
Servicio|Es un proceso que recibe datos de entrada y retorna datos de salida. Sirve de comunicación entre el Back-End y la Base de Datos
Reporte|Es un proceso que recibe datos de entrada y retorna como salida un archivo de reporte, que puede ser en formatos PDF, DOCX, XLSX, CSV, HTML. Sirve de comunicación entre el Back-End y la Base de Datos
Trabajo|Es un proceso que se ejecuta automáticamente en un intérvalo de repetición configurado
Monitoreo|TO-DO

### Parámetros

### Logs
TO-DO

## Configuraciones

### Parámetros
TO-DO

### Diccionario
TO-DO