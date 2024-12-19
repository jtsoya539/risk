# Back-End

## Contenido
* [Introducción](#introducción)
* [Instalación](#instalación)
* [Configuraciones](#configuraciones)
* [API de clientes de Risk.API](#api-de-clientes-de-riskapi)
* [Generación de clientes de Risk.API](clients/README.md)

## Introducción
Este componente consiste en una API web ASP.NET Core que se encarga de recibir peticiones HTTP de clientes (aplicaciones u otros sistemas) y se conecta a la Base de Datos para procesarlas.

## Instalación
### Pasos para configurar el entorno de desarrollo
1. Instalar el SDK de .NET siguiendo las instrucciones según la plataforma preferida.
2. Opcionalmente, instalar el editor Visual Studio Code con la extensión C# o C# Dev Kit.
3. Clonar o descargar el repositorio de RISK.
4. En el command prompt, ubicarse en la raíz del repositorio e ir hasta *source/backend/Risk.API* (contiene el archivo del proyecto *Risk.API.csproj*).
5. Realizar las configuraciones necesarias en los archivos *appsettings.{Environment}.json* y *config/log/nlog.config*.
6. Ejecutar el comando: `dotnet run`.

## Configuraciones

### Archivo *appsettings.{Environment}.json*
#### Conexión a Base de Datos Oracle
TO-DO

#### Swagger
TO-DO

#### Mensajería
TO-DO

#### Logging
TO-DO

#### Caching
TO-DO

### Archivo *config/log/nlog.config*
TO-DO

## API de clientes de Risk.API

* [.NET](clients/csharp/README.md)
* [Java](clients/java/README.md)
* [Kotlin](clients/kotlin/README.md)