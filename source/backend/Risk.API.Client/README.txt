Risk.API.Client

// Descargar el generador de clientes openapi-generator-cli.jar o swagger-codegen-cli.jar
Invoke-WebRequest -OutFile openapi-generator-cli.jar https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/4.3.1/openapi-generator-cli-4.3.1.jar
Invoke-WebRequest -OutFile swagger-codegen-cli.jar https://repo1.maven.org/maven2/io/swagger/codegen/v3/swagger-codegen-cli/3.0.19/swagger-codegen-cli-3.0.19.jar

java -jar openapi-generator-cli.jar help
java -jar swagger-codegen-cli.jar version

// Generar cliente
java -jar openapi-generator-cli.jar generate -i https://risk-project.azurewebsites.net/swagger/v1/swagger.json -o Risk.API.Client -g csharp-netcore -c config-csharp-netcore.json
java -jar swagger-codegen-cli.jar generate -i https://risk-project.azurewebsites.net/swagger/v1/swagger.json -o Risk.API.JavaClient -l java -c config-java.json


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