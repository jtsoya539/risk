# Documentación

Bienvenido/a a la documentación del Proyecto RISK.

## Contenido
* [Introducción](#introducción)
* [Características](#características)
* [Arquitectura](#arquitectura)
* [Requerimientos](#requerimientos)
* [Base de Datos](database/README.md)
* [Back-End](backend/README.md)

## Introducción
RISK es una colección de objetos de Base de Datos Oracle (paquetes, types, tablas, entre otros) y una API web ASP.NET Core, que sigue el paradigma ["Thick Database"](https://www.oracle.com/a/tech/docs/why-use-plsql-whitepaper-10.pdf) y sirve como plantilla para el back-end de cualquier aplicación.

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
### General
![Arquitectura General](architecture/Risk.png)

### Mensajería
![Arquitectura Mensajería](architecture/Msj.png)

## Requerimientos
### Base de Datos
* [Oracle Database 12c o superior](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)

### Back-End
* [.NET 8.0 o superior](https://dotnet.microsoft.com/en-us/download/dotnet)

Los servicios de mensajería tienen requerimientos especiales de terceros:

Servicio|Requerimiento
--------|-------------
Mail|Cuenta de Gmail configurada con autenticación [OAuth](https://github.com/jstedfast/MailKit/blob/master/GMailOAuth2.md) o acceso de [apps menos seguras](https://www.google.com/settings/security/lesssecureapps).
Push|Cuenta de Azure configurada con el servicio [Notification Hubs](https://azure.microsoft.com/es-es/services/notification-hubs/).
SMS|Cuenta de Twilio configurada con el servicio [SMS](https://www.twilio.com/sms).