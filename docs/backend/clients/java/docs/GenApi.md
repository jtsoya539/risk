# GenApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**guardarArchivo**](GenApi.md#guardarArchivo) | **POST** /Api/Gen/GuardarArchivo | GuardarArchivo
[**listarAplicaciones**](GenApi.md#listarAplicaciones) | **GET** /Api/Gen/ListarAplicaciones | ListarAplicaciones
[**listarErrores**](GenApi.md#listarErrores) | **GET** /Api/Gen/ListarErrores | ListarErrores
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

> DatoRespuesta guardarArchivo(tabla, campo, referencia, riskDeviceToken, riskServiceVersion, archivo, url, nombre, extension)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        File archivo = new File("/path/to/file"); // File | Contenido del archivo
        String url = "url_example"; // String | URL del archivo
        String nombre = "nombre_example"; // String | Nombre del archivo
        String extension = "extension_example"; // String | Extensión del archivo
        try {
            DatoRespuesta result = apiInstance.guardarArchivo(tabla, campo, referencia, riskDeviceToken, riskServiceVersion, archivo, url, nombre, extension);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]
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

> AplicacionPaginaRespuesta listarAplicaciones(idAplicacion, claveAplicacion, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            AplicacionPaginaRespuesta result = apiInstance.listarAplicaciones(idAplicacion, claveAplicacion, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]

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


## listarErrores

> ErrorPaginaRespuesta listarErrores(idError, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            ErrorPaginaRespuesta result = apiInstance.listarErrores(idError, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]

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


## listarSignificados

> SignificadoPaginaRespuesta listarSignificados(dominio, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            SignificadoPaginaRespuesta result = apiInstance.listarSignificados(dominio, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]

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

> File recuperarArchivo(tabla, campo, referencia, version, riskDeviceToken, riskServiceVersion)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            File result = apiInstance.recuperarArchivo(tabla, campo, referencia, version, riskDeviceToken, riskServiceVersion);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]

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

> DatoRespuesta recuperarTexto(referencia, riskDeviceToken, riskServiceVersion)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            DatoRespuesta result = apiInstance.recuperarTexto(referencia, riskDeviceToken, riskServiceVersion);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]

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

> File reporteListarSignificados(formato, dominio, riskDeviceToken, riskServiceVersion)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            File result = apiInstance.reporteListarSignificados(formato, dominio, riskDeviceToken, riskServiceVersion);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]

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

> File reporteVersionSistema(formato, riskDeviceToken, riskServiceVersion)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            File result = apiInstance.reporteVersionSistema(formato, riskDeviceToken, riskServiceVersion);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]

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

> DatoRespuesta significadoCodigo(dominio, codigo, riskDeviceToken, riskServiceVersion)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            DatoRespuesta result = apiInstance.significadoCodigo(dominio, codigo, riskDeviceToken, riskServiceVersion);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]

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

> DatoRespuesta valorParametro(parametro, riskDeviceToken, riskServiceVersion)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            DatoRespuesta result = apiInstance.valorParametro(parametro, riskDeviceToken, riskServiceVersion);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]

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

> DatoRespuesta versionServicio(servicio, riskDeviceToken, riskServiceVersion)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            DatoRespuesta result = apiInstance.versionServicio(servicio, riskDeviceToken, riskServiceVersion);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]

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

> DatoRespuesta versionSistema(riskDeviceToken, riskServiceVersion)

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
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            DatoRespuesta result = apiInstance.versionSistema(riskDeviceToken, riskServiceVersion);
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
 **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **String**| Versión del servicio | [optional]

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

