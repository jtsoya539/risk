# GloApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**listarBarrios**](GloApi.md#listarBarrios) | **GET** /Api/Glo/ListarBarrios | ListarBarrios
[**listarCiudades**](GloApi.md#listarCiudades) | **GET** /Api/Glo/ListarCiudades | ListarCiudades
[**listarDepartamentos**](GloApi.md#listarDepartamentos) | **GET** /Api/Glo/ListarDepartamentos | ListarDepartamentos
[**listarPaises**](GloApi.md#listarPaises) | **GET** /Api/Glo/ListarPaises | ListarPaises



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
import org.openapitools.client.api.GloApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GloApi apiInstance = new GloApi(defaultClient);
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
            System.err.println("Exception when calling GloApi#listarBarrios");
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
import org.openapitools.client.api.GloApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GloApi apiInstance = new GloApi(defaultClient);
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
            System.err.println("Exception when calling GloApi#listarCiudades");
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
import org.openapitools.client.api.GloApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GloApi apiInstance = new GloApi(defaultClient);
        Integer idPais = 56; // Integer | Identificador del país
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            DepartamentoPaginaRespuesta result = apiInstance.listarDepartamentos(idPais, pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GloApi#listarDepartamentos");
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
import org.openapitools.client.api.GloApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        GloApi apiInstance = new GloApi(defaultClient);
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            PaisPaginaRespuesta result = apiInstance.listarPaises(pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling GloApi#listarPaises");
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

