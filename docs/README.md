# Documentación

Bienvenido/a a la documentación del Proyecto RISK.

## Contenido
* [Introducción](#introducción)
* [Características](#características)
* [Arquitectura](#arquitectura)
* [Requerimientos](#requerimientos)
* [Cómo empezar](#cómo-empezar)

## Introducción
RISK es un mini framework que sigue el paradigma ["SmartDB"](https://asktom.oracle.com/ords/r/tech/catalog/series-landing-page?p5_series_id=15684323403093480964656912197598498105) y sirve como base para el back-end de aplicaciones de tipo [LOB](https://en.wikipedia.org/wiki/Line_of_business).

Consiste en una colección de objetos de Base de Datos Oracle (paquetes, types, tablas, entre otros) y una API web ASP.NET Core.

## Características
* Operaciones (Servicios Web, Reportes, Trabajos, Monitoreos): Parámetros, Logs, Paginación
* Configuración: Módulos, Dominios, Aplicaciones, Parámetros, Significados, Archivos, Datos Adicionales, Migraciones
* Autenticación: Personas, Usuarios, Claves, Sesiones, Dispositivos
* Autorización: Roles, Permisos
* Globalización: Países, Departamentos, Ciudades, Barrios, Monedas, Idiomas, Textos
* Reportes en formatos PDF, DOCX, XLSX, CSV, HTML
* Mensajería a través de Correo electrónico (E-mail), Mensaje de texto (SMS) y Notificación push
* Definición de interfaz HTTP con la especificación OpenAPI (Swagger)

## Arquitectura
### Componentes
RISK tiene dos componentes principales:

#### Base de Datos
Es una instancia de Base de Datos Oracle con un esquema central en el que se encuentra instalada una colección de objetos (paquetes, types, tablas, entre otros), que se encarga de persistir los datos e implementar la mayor parte de la lógica de negocio del sistema.

Más información: [Base de Datos](database/README.md)

#### Back-End
Es una API web ASP.NET Core que se encarga de recibir peticiones HTTP de clientes (aplicaciones u otros sistemas) y se conecta a la Base de Datos para procesarlas.

Más información: [Back-End](backend/README.md)

![Arquitectura General](architecture/Risk.png)

Adicionalmente RISK incluye dos componentes opcionales:

#### Redis
Es un almacen de datos en memoria que guarda valores más frecuentes de la comunicación entre los componentes de Base de Datos y Back-End y permite una mejora de velocidad en las respuestas.

#### RISK Admin
Es una aplicación web de referencia implementada en Oracle APEX para administración y configuración del sistema.

### Módulos

#### RISK (General)
Módulo principal con manejo de Operaciones (Servicios Web, Reportes, Trabajos) y sus Parámetros, Autenticación y Autorización de Usuarios, Parámetros, Significados, Archivos, Datos Adicionales, entre otros.

#### Mensajería
Módulo para envío de mensajes a los usuarios a través de Correo electrónico (E-mail), Mensaje de texto (SMS) y Notificación push.

![Arquitectura Mensajería](architecture/Msj.png)

## Requerimientos
### Base de Datos
* [Oracle Database 12c o superior](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)

### Back-End
* [.NET 9.0 o superior](https://dotnet.microsoft.com/en-us/download/dotnet)

Los servicios de mensajería tienen requerimientos especiales de terceros:

Servicio|Requerimiento
--------|-------------
Mail|Cuenta de Gmail configurada con autenticación [OAuth](https://github.com/jstedfast/MailKit/blob/master/GMailOAuth2.md) o acceso de [apps menos seguras](https://www.google.com/settings/security/lesssecureapps).
Push|Cuenta de Azure configurada con el servicio [Notification Hubs](https://azure.microsoft.com/es-es/services/notification-hubs/).
SMS|Cuenta de Twilio configurada con el servicio [SMS](https://www.twilio.com/sms).

## Cómo empezar
Si querés empezar a desarrollar una aplicación o un sistema con RISK, podés hacerlo con una de estas opciones:
* [Usando Docker](getting-started.md#usando-docker)
* [Nativamente](getting-started.md#nativamente)