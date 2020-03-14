Risk.API.Client

// Descargar el generador de clientes openapi-generator-cli.jar
Invoke-WebRequest -OutFile openapi-generator-cli.jar https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/4.2.3/openapi-generator-cli-4.2.3.jar

java -jar openapi-generator-cli.jar help

// Generar cliente .NET
java -jar openapi-generator-cli.jar generate -i http://localhost:5000/swagger/v1/swagger.json -o Risk.API.Client -g csharp-netcore -c config.json
java -jar openapi-generator-cli.jar generate -i http://localhost:5000/swagger/v1/swagger.json -g csharp-netcore -c config.json

// Agregar los metadatos del paquete NuGet en Risk.API.Client.csproj
  <PropertyGroup>
    <PackageId>Risk.API.Client</PackageId>
    <Version>0.1</Version>
    <Authors>jtsoya539</Authors>
    <Company>RamaPy</Company>
    <Title>Risk.API.Client</Title>
    <PackageDescription>.NET Client for Risk.API</PackageDescription>

// En el directorio donde se encuentra Risk.API.Client.csproj
dotnet pack

// En el directorio donde se encuentra Risk.API.Client.x.x.x.nupkg
dotnet nuget push .\Risk.API.Client.x.x.x.nupkg -k MI_API_KEY -s https://api.nuget.org/v3/index.json