# GenApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**guardarArchivo**](GenApi.md#guardarArchivo) | **POST** /Api/Gen/GuardarArchivo | GuardarArchivo
[**listarAplicaciones**](GenApi.md#listarAplicaciones) | **GET** /Api/Gen/ListarAplicaciones | ListarAplicaciones
[**listarBarrios**](GenApi.md#listarBarrios) | **GET** /Api/Gen/ListarBarrios | ListarBarrios
[**listarCiudades**](GenApi.md#listarCiudades) | **GET** /Api/Gen/ListarCiudades | ListarCiudades
[**listarDepartamentos**](GenApi.md#listarDepartamentos) | **GET** /Api/Gen/ListarDepartamentos | ListarDepartamentos
[**listarErrores**](GenApi.md#listarErrores) | **GET** /Api/Gen/ListarErrores | ListarErrores
[**listarPaises**](GenApi.md#listarPaises) | **GET** /Api/Gen/ListarPaises | ListarPaises
[**listarSignificados**](GenApi.md#listarSignificados) | **GET** /Api/Gen/ListarSignificados | ListarSignificados
[**recuperarArchivo**](GenApi.md#recuperarArchivo) | **GET** /Api/Gen/RecuperarArchivo | RecuperarArchivo
[**recuperarTexto**](GenApi.md#recuperarTexto) | **GET** /Api/Gen/RecuperarTexto | RecuperarTexto
[**reporteListarSignificados**](GenApi.md#reporteListarSignificados) | **GET** /Api/Gen/ReporteListarSignificados | ReporteListarSignificados
[**reporteVersionSistema**](GenApi.md#reporteVersionSistema) | **GET** /Api/Gen/ReporteVersionSistema | ReporteVersionSistema
[**significadoCodigo**](GenApi.md#significadoCodigo) | **GET** /Api/Gen/SignificadoCodigo | SignificadoCodigo
[**valorParametro**](GenApi.md#valorParametro) | **GET** /Api/Gen/ValorParametro | ValorParametro
[**versionServicio**](GenApi.md#versionServicio) | **GET** /Api/Gen/VersionServicio | VersionServicio
[**versionSistema**](GenApi.md#versionSistema) | **GET** /Gen/VersionSistema | VersionSistema



## guardarArchivo

> DatoRespuesta guardarArchivo(tabla, campo, referencia, riskServiceVersion, archivo, url, nombre, extension)

GuardarArchivo

Permite guardar un archivo

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure HTTP bearer authorization: AccessToken
        HttpBearerAuth AccessToken = (HttpBearerAuth) defaultClient.getAuthentication("AccessToken");
        AccessToken.setBearerToken("BEARER TOKEN");

        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        String tabla = "tabla_example"; // String | Tabla
        String campo = "campo_example"; // String | Campo
        String referencia = "referencia_example"; // String | Referencia
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        File archivo = new File("/path/to/file"); // File | Contenido del archivo
        String url = "url_example"; // String | URL del archivo
        String nombre = "nombre_example"; // String | Nombre del archivo
        String extension = "extension_example"; // String | Extensión del archivo
        try {
            DatoRespuesta result = apiInstance.guardarArchivo(tabla, campo, referencia, riskServiceVersion, archivo, url, nombre, extension);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#guardarArchivo");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tabla** | **String**| Tabla |
 **campo** | **String**| Campo |
 **referencia** | **String**| Referencia |
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]
 **archivo** | **File**| Contenido del archivo | [optional]
 **url** | **String**| URL del archivo | [optional]
 **nombre** | **String**| Nombre del archivo | [optional]
 **extension** | **String**| Extensión del archivo | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: multipart/form-data
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **401** | Operación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## listarAplicaciones

> AplicacionPaginaRespuesta listarAplicaciones(idAplicacion, claveAplicacion, pagina, porPagina, noPaginar, riskServiceVersion)

ListarAplicaciones

Obtiene una lista de aplicaciones

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        String idAplicacion = "idAplicacion_example"; // String | Identificador de la aplicacion
        String claveAplicacion = "claveAplicacion_example"; // String | Clave de la aplicacion
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            AplicacionPaginaRespuesta result = apiInstance.listarAplicaciones(idAplicacion, claveAplicacion, pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#listarAplicaciones");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAplicacion** | **String**| Identificador de la aplicacion | [optional]
 **claveAplicacion** | **String**| Clave de la aplicacion | [optional]
 **pagina** | **Integer**| Número de la página | [optional]
 **porPagina** | **Integer**| Cantidad de elementos por página | [optional]
 **noPaginar** | **Boolean**| No paginar? | [optional]
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**AplicacionPaginaRespuesta**](AplicacionPaginaRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## listarBarrios

> BarrioPaginaRespuesta listarBarrios(idPais, idDepartamento, idCiudad, pagina, porPagina, noPaginar, riskServiceVersion)

ListarBarrios

Obtiene una lista de barrios

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        Integer idPais = 56; // Integer | Identificador del país
        Integer idDepartamento = 56; // Integer | Identificador del departamento
        Integer idCiudad = 56; // Integer | Identificador de la ciudad
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            BarrioPaginaRespuesta result = apiInstance.listarBarrios(idPais, idDepartamento, idCiudad, pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#listarBarrios");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idPais** | **Integer**| Identificador del país | [optional]
 **idDepartamento** | **Integer**| Identificador del departamento | [optional]
 **idCiudad** | **Integer**| Identificador de la ciudad | [optional]
 **pagina** | **Integer**| Número de la página | [optional]
 **porPagina** | **Integer**| Cantidad de elementos por página | [optional]
 **noPaginar** | **Boolean**| No paginar? | [optional]
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**BarrioPaginaRespuesta**](BarrioPaginaRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## listarCiudades

> CiudadPaginaRespuesta listarCiudades(idPais, idDepartamento, pagina, porPagina, noPaginar, riskServiceVersion)

ListarCiudades

Obtiene una lista de ciudades

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        Integer idPais = 56; // Integer | Identificador del país
        Integer idDepartamento = 56; // Integer | Identificador del departamento
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            CiudadPaginaRespuesta result = apiInstance.listarCiudades(idPais, idDepartamento, pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#listarCiudades");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idPais** | **Integer**| Identificador del país | [optional]
 **idDepartamento** | **Integer**| Identificador del departamento | [optional]
 **pagina** | **Integer**| Número de la página | [optional]
 **porPagina** | **Integer**| Cantidad de elementos por página | [optional]
 **noPaginar** | **Boolean**| No paginar? | [optional]
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**CiudadPaginaRespuesta**](CiudadPaginaRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## listarDepartamentos

> DepartamentoPaginaRespuesta listarDepartamentos(idPais, pagina, porPagina, noPaginar, riskServiceVersion)

ListarDepartamentos

Obtiene una lista de departamentos

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        Integer idPais = 56; // Integer | Identificador del país
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            DepartamentoPaginaRespuesta result = apiInstance.listarDepartamentos(idPais, pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#listarDepartamentos");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idPais** | **Integer**| Identificador del país | [optional]
 **pagina** | **Integer**| Número de la página | [optional]
 **porPagina** | **Integer**| Cantidad de elementos por página | [optional]
 **noPaginar** | **Boolean**| No paginar? | [optional]
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**DepartamentoPaginaRespuesta**](DepartamentoPaginaRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## listarErrores

> ErrorPaginaRespuesta listarErrores(idError, pagina, porPagina, noPaginar, riskServiceVersion)

ListarErrores

Obtiene una lista de errores

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        String idError = "idError_example"; // String | Identificador del error
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            ErrorPaginaRespuesta result = apiInstance.listarErrores(idError, pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#listarErrores");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idError** | **String**| Identificador del error | [optional]
 **pagina** | **Integer**| Número de la página | [optional]
 **porPagina** | **Integer**| Cantidad de elementos por página | [optional]
 **noPaginar** | **Boolean**| No paginar? | [optional]
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**ErrorPaginaRespuesta**](ErrorPaginaRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## listarPaises

> PaisPaginaRespuesta listarPaises(pagina, porPagina, noPaginar, riskServiceVersion)

ListarPaises

Obtiene una lista de países

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            PaisPaginaRespuesta result = apiInstance.listarPaises(pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#listarPaises");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pagina** | **Integer**| Número de la página | [optional]
 **porPagina** | **Integer**| Cantidad de elementos por página | [optional]
 **noPaginar** | **Boolean**| No paginar? | [optional]
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**PaisPaginaRespuesta**](PaisPaginaRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## listarSignificados

> SignificadoPaginaRespuesta listarSignificados(dominio, pagina, porPagina, noPaginar, riskServiceVersion)

ListarSignificados

Obtiene una lista de significados dentro de un dominio

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure HTTP bearer authorization: AccessToken
        HttpBearerAuth AccessToken = (HttpBearerAuth) defaultClient.getAuthentication("AccessToken");
        AccessToken.setBearerToken("BEARER TOKEN");

        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        String dominio = "dominio_example"; // String | Dominio
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            SignificadoPaginaRespuesta result = apiInstance.listarSignificados(dominio, pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#listarSignificados");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dominio** | **String**| Dominio |
 **pagina** | **Integer**| Número de la página | [optional]
 **porPagina** | **Integer**| Cantidad de elementos por página | [optional]
 **noPaginar** | **Boolean**| No paginar? | [optional]
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**SignificadoPaginaRespuesta**](SignificadoPaginaRespuesta.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **401** | Operación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## recuperarArchivo

> File recuperarArchivo(tabla, campo, referencia, version, riskServiceVersion)

RecuperarArchivo

Permite recuperar un archivo

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure HTTP bearer authorization: AccessToken
        HttpBearerAuth AccessToken = (HttpBearerAuth) defaultClient.getAuthentication("AccessToken");
        AccessToken.setBearerToken("BEARER TOKEN");

        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        String tabla = "tabla_example"; // String | Tabla
        String campo = "campo_example"; // String | Campo
        String referencia = "referencia_example"; // String | Referencia
        Integer version = 56; // Integer | Versión
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            File result = apiInstance.recuperarArchivo(tabla, campo, referencia, version, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#recuperarArchivo");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tabla** | **String**| Tabla |
 **campo** | **String**| Campo |
 **referencia** | **String**| Referencia |
 **version** | **Integer**| Versión | [optional]
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**File**](File.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/octet-stream, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **401** | Operación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## recuperarTexto

> DatoRespuesta recuperarTexto(referencia, riskServiceVersion)

RecuperarTexto

Obtiene un texto definido en el sistema

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        String referencia = "referencia_example"; // String | Referencia del texto
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            DatoRespuesta result = apiInstance.recuperarTexto(referencia, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#recuperarTexto");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **referencia** | **String**| Referencia del texto |
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## reporteListarSignificados

> File reporteListarSignificados(formato, dominio, riskServiceVersion)

ReporteListarSignificados

Obtiene un reporte con los significados dentro de un dominio

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure HTTP bearer authorization: AccessToken
        HttpBearerAuth AccessToken = (HttpBearerAuth) defaultClient.getAuthentication("AccessToken");
        AccessToken.setBearerToken("BEARER TOKEN");

        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        FormatoReporte formato = FormatoReporte.fromValue("Pdf"); // FormatoReporte | Formato del reporte
        String dominio = "dominio_example"; // String | Dominio
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            File result = apiInstance.reporteListarSignificados(formato, dominio, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#reporteListarSignificados");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formato** | [**FormatoReporte**](.md)| Formato del reporte | [enum: Pdf, Docx, Xlsx, Csv, Html]
 **dominio** | **String**| Dominio | [optional]
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**File**](File.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/octet-stream, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **401** | Operación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## reporteVersionSistema

> File reporteVersionSistema(formato, riskServiceVersion)

ReporteVersionSistema

Obtiene un reporte con la versión actual del sistema

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure HTTP bearer authorization: AccessToken
        HttpBearerAuth AccessToken = (HttpBearerAuth) defaultClient.getAuthentication("AccessToken");
        AccessToken.setBearerToken("BEARER TOKEN");

        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        FormatoReporte formato = FormatoReporte.fromValue("Pdf"); // FormatoReporte | Formato del reporte
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            File result = apiInstance.reporteVersionSistema(formato, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#reporteVersionSistema");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formato** | [**FormatoReporte**](.md)| Formato del reporte | [enum: Pdf, Docx, Xlsx, Csv, Html]
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**File**](File.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/octet-stream, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **401** | Operación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## significadoCodigo

> DatoRespuesta significadoCodigo(dominio, codigo, riskServiceVersion)

SignificadoCodigo

Obtiene el significado de un código dentro de un dominio

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure HTTP bearer authorization: AccessToken
        HttpBearerAuth AccessToken = (HttpBearerAuth) defaultClient.getAuthentication("AccessToken");
        AccessToken.setBearerToken("BEARER TOKEN");

        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        String dominio = "dominio_example"; // String | Dominio
        String codigo = "codigo_example"; // String | Código
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            DatoRespuesta result = apiInstance.significadoCodigo(dominio, codigo, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#significadoCodigo");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dominio** | **String**| Dominio |
 **codigo** | **String**| Código |
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **401** | Operación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## valorParametro

> DatoRespuesta valorParametro(parametro, riskServiceVersion)

ValorParametro

Obtiene el valor de un parámetro

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure HTTP bearer authorization: AccessToken
        HttpBearerAuth AccessToken = (HttpBearerAuth) defaultClient.getAuthentication("AccessToken");
        AccessToken.setBearerToken("BEARER TOKEN");

        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        String parametro = "parametro_example"; // String | Identificador del parámetro
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            DatoRespuesta result = apiInstance.valorParametro(parametro, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#valorParametro");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **parametro** | **String**| Identificador del parámetro |
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **401** | Operación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## versionServicio

> DatoRespuesta versionServicio(servicio, riskServiceVersion)

VersionServicio

Obtiene la versión actual del servicio

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GenApi apiInstance = new GenApi(defaultClient);
        String servicio = "servicio_example"; // String | Nombre del servicio
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            DatoRespuesta result = apiInstance.versionServicio(servicio, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#versionServicio");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **servicio** | **String**| Nombre del servicio |
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, text/plain


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |


## versionSistema

> DatoRespuesta versionSistema(riskServiceVersion)

VersionSistema

Obtiene la versión actual del sistema

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.models.*;
import org.openapitools.client.api.GenApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");

        GenApi apiInstance = new GenApi(defaultClient);
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            DatoRespuesta result = apiInstance.versionSistema(riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GenApi#versionSistema");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskServiceVersion** | **String**| Versión del Servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |

