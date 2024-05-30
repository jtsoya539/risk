# Base de Datos

## Contenido
* [Operaciones](#operaciones)
* [Configuraciones](#configuraciones)
* [API PL/SQL](plsqldoc/index.html)
* [Guía de estilo para Desarrollo](styleguide.md)
* [Dependencias](#dependencias)
* [Configuración de PL/SQL Documentation (plsqldoc)](#configuración-de-plsql-documentation-plsqldoc)

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
Monitoreo|

### Parámetros

### Logs

## Configuraciones

### Parámetros

### Diccionario

## Dependencias

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

## Configuración de PL/SQL Documentation (plsqldoc)

Para configurar el Plug-In PL/SQL Documentation (plsqldoc) en PL/SQL Developer seguir estos pasos:

1. Ir al menú *Plug-Ins* y en el apartado *plsqldoc* dar click en *Configure...*

![](plugins_configure.png)

2. Usar la siguiente configuración:

![](plsqldoc_config.png)