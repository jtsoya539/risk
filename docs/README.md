# Documentación

Bienvenido/a a la documentación del Proyecto RISK.

## Contenido
* [Requerimientos](#requerimientos)
* [Instalación](#instalación)
* [Guía de estilo para Desarrollo](database/styleguide.md)
* [API PL/SQL](database/plsqldoc/index.html)

## Requerimientos
### Base de Datos
* [Oracle Database 12c o superior](https://www.oracle.com/database/technologies/xe-downloads.html)

### Back-End
* [.NET Core 2.1](https://dotnet.microsoft.com/download/dotnet-core/2.1)

## Instalación
### Base de Datos

Script|Descripción
------|-----------
compile_schema.sql|Compila objetos inválidos del esquema actual.
create_user.sql|Crea usuario y otorga permisos necesarios para instalar el Proyecto RISK. Se debe ejecutar con SYS o SYSTEM.
generate_docs.sql|Genera archivos de documentación de objetos de Base de Datos con la herramienta *plsqldoc*. Se debe ejecutar desde un Command Window de PL/SQL Developer con el plug-in *plsqldoc* instalado.
install.sql|Instala en el esquema actual los objetos de Base de Datos del Proyecto RISK.
install_audit.sql|Genera campos y triggers de auditoría.
uninstall.sql|Desinstala del esquema actual los objetos de Base de Datos del Proyecto RISK.

### Back-End