# MsjApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activarMensajeria**](MsjApi.md#activarMensajeria) | **POST** /Api/Msj/ActivarMensajeria | ActivarMensajeria
[**cambiarEstadoMensajeria**](MsjApi.md#cambiarEstadoMensajeria) | **POST** /Api/Msj/CambiarEstadoMensajeria | CambiarEstadoMensajeria
[**desactivarMensajeria**](MsjApi.md#desactivarMensajeria) | **POST** /Api/Msj/DesactivarMensajeria | DesactivarMensajeria
[**listarCorreosPendientes**](MsjApi.md#listarCorreosPendientes) | **GET** /Api/Msj/ListarCorreosPendientes | ListarCorreosPendientes
[**listarMensajesPendientes**](MsjApi.md#listarMensajesPendientes) | **GET** /Api/Msj/ListarMensajesPendientes | ListarMensajesPendientes
[**listarNotificacionesPendientes**](MsjApi.md#listarNotificacionesPendientes) | **GET** /Api/Msj/ListarNotificacionesPendientes | ListarNotificacionesPendientes



## activarMensajeria

> DatoRespuesta activarMensajeria(tipoMensajeria, riskServiceVersion)

ActivarMensajeria

Permite activar el servicio de mensajería

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.MsjApi;

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

        MsjApi apiInstance = new MsjApi(defaultClient);
        TipoMensajeria tipoMensajeria = new TipoMensajeria(); // TipoMensajeria | Tipo de mensajería a activar
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            DatoRespuesta result = apiInstance.activarMensajeria(tipoMensajeria, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling MsjApi#activarMensajeria");
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
 **tipoMensajeria** | [**TipoMensajeria**](.md)| Tipo de mensajería a activar | [enum: Mail, SMS, Push]
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


## cambiarEstadoMensajeria

> DatoRespuesta cambiarEstadoMensajeria(riskServiceVersion, cambiarEstadoMensajeriaRequestBody)

CambiarEstadoMensajeria

Permite cambiar el estado de envío de un mensaje de texto (SMS), correo electrónico (E-mail) o notificación push

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.MsjApi;

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

        MsjApi apiInstance = new MsjApi(defaultClient);
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        CambiarEstadoMensajeriaRequestBody cambiarEstadoMensajeriaRequestBody = new CambiarEstadoMensajeriaRequestBody(); // CambiarEstadoMensajeriaRequestBody | 
        try {
            DatoRespuesta result = apiInstance.cambiarEstadoMensajeria(riskServiceVersion, cambiarEstadoMensajeriaRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling MsjApi#cambiarEstadoMensajeria");
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
 **cambiarEstadoMensajeriaRequestBody** | [**CambiarEstadoMensajeriaRequestBody**](CambiarEstadoMensajeriaRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

- **Content-Type**: application/json
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


## desactivarMensajeria

> DatoRespuesta desactivarMensajeria(tipoMensajeria, riskServiceVersion)

DesactivarMensajeria

Permite desactivar el servicio de mensajería

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.MsjApi;

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

        MsjApi apiInstance = new MsjApi(defaultClient);
        TipoMensajeria tipoMensajeria = new TipoMensajeria(); // TipoMensajeria | Tipo de mensajería a desactivar
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            DatoRespuesta result = apiInstance.desactivarMensajeria(tipoMensajeria, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling MsjApi#desactivarMensajeria");
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
 **tipoMensajeria** | [**TipoMensajeria**](.md)| Tipo de mensajería a desactivar | [enum: Mail, SMS, Push]
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


## listarCorreosPendientes

> CorreoPaginaRespuesta listarCorreosPendientes(pagina, porPagina, noPaginar, riskServiceVersion)

ListarCorreosPendientes

Obtiene una lista de correos electrónicos (E-mail) pendientes de envío

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.MsjApi;

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

        MsjApi apiInstance = new MsjApi(defaultClient);
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            CorreoPaginaRespuesta result = apiInstance.listarCorreosPendientes(pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling MsjApi#listarCorreosPendientes");
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

[**CorreoPaginaRespuesta**](CorreoPaginaRespuesta.md)

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


## listarMensajesPendientes

> MensajePaginaRespuesta listarMensajesPendientes(pagina, porPagina, noPaginar, riskServiceVersion)

ListarMensajesPendientes

Obtiene una lista de mensajes de texto (SMS) pendientes de envío

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.MsjApi;

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

        MsjApi apiInstance = new MsjApi(defaultClient);
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            MensajePaginaRespuesta result = apiInstance.listarMensajesPendientes(pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling MsjApi#listarMensajesPendientes");
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

[**MensajePaginaRespuesta**](MensajePaginaRespuesta.md)

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


## listarNotificacionesPendientes

> NotificacionPaginaRespuesta listarNotificacionesPendientes(pagina, porPagina, noPaginar, riskServiceVersion)

ListarNotificacionesPendientes

Obtiene una lista de notificaciones push pendientes de envío

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.MsjApi;

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

        MsjApi apiInstance = new MsjApi(defaultClient);
        Integer pagina = 56; // Integer | Número de la página
        Integer porPagina = 56; // Integer | Cantidad de elementos por página
        Boolean noPaginar = true; // Boolean | No paginar?
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            NotificacionPaginaRespuesta result = apiInstance.listarNotificacionesPendientes(pagina, porPagina, noPaginar, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling MsjApi#listarNotificacionesPendientes");
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

[**NotificacionPaginaRespuesta**](NotificacionPaginaRespuesta.md)

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

