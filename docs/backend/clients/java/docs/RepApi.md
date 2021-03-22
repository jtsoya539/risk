# RepApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reporteListarSignificados**](RepApi.md#reporteListarSignificados) | **GET** /Api/Gen/ReporteListarSignificados | ReporteListarSignificados
[**reporteVersionSistema**](RepApi.md#reporteVersionSistema) | **GET** /Api/Gen/ReporteVersionSistema | ReporteVersionSistema



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
import org.openapitools.client.api.RepApi;

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

        RepApi apiInstance = new RepApi(defaultClient);
        FormatoReporte formato = new FormatoReporte(); // FormatoReporte | Formato del reporte
        String dominio = "dominio_example"; // String | Dominio
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            File result = apiInstance.reporteListarSignificados(formato, dominio, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling RepApi#reporteListarSignificados");
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
import org.openapitools.client.api.RepApi;

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

        RepApi apiInstance = new RepApi(defaultClient);
        FormatoReporte formato = new FormatoReporte(); // FormatoReporte | Formato del reporte
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del Servicio
        try {
            File result = apiInstance.reporteVersionSistema(formato, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling RepApi#reporteVersionSistema");
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

