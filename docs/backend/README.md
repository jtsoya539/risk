# Back-End

## Contenido
* [Instalación](#instalación)
* [Generación de clientes de Risk.API](clients/README.md)
* [API de clientes de Risk.API](#api-de-clientes-de-riskapi)

## Instalación
### Pasos para configurar el entorno de desarrollo
1. Instalar el SDK de .NET siguiendo las instrucciones según la plataforma preferida.
2. Opcionalmente, instalar el editor Visual Studio Code con la extensión C#.
3. Clonar o descargar el repositorio de RISK.
4. En el command prompt, ubicarse en la raíz del repositorio e ir hasta *source/backend/Risk.API* (contiene el archivo del proyecto *Risk.API.csproj*).
5. Realizar las configuraciones necesarias en los archivos *appsettings.json* y *config/log/nlog.config*.
6. Ejecutar el comando: `dotnet run`.

## API de clientes de Risk.API

* [.NET Core](clients/csharp-netcore/README.md)
* [Java](clients/java/README.md)
* [Kotlin](clients/kotlin/README.md)