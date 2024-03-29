# Risk.API.Client.Api.RepApi

All URIs are relative to *https://localhost:5001*

| Method | HTTP request | Description |
|--------|--------------|-------------|
| [**ReporteListarSignificados**](RepApi.md#reportelistarsignificados) | **GET** /Api/Gen/ReporteListarSignificados | ReporteListarSignificados |
| [**ReporteVersionSistema**](RepApi.md#reporteversionsistema) | **GET** /Api/Gen/ReporteVersionSistema | ReporteVersionSistema |

<a id="reportelistarsignificados"></a>
# **ReporteListarSignificados**
> System.IO.Stream ReporteListarSignificados (FormatoReporte formato, string dominio = null, string riskDeviceToken = null, string riskServiceVersion = null)

ReporteListarSignificados

Obtiene un reporte con los significados dentro de un dominio

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ReporteListarSignificadosExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new RepApi(config);
            var formato = (FormatoReporte) "Pdf";  // FormatoReporte | Formato del reporte
            var dominio = "dominio_example";  // string | Dominio (optional) 
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // ReporteListarSignificados
                System.IO.Stream result = apiInstance.ReporteListarSignificados(formato, dominio, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling RepApi.ReporteListarSignificados: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the ReporteListarSignificadosWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // ReporteListarSignificados
    ApiResponse<System.IO.Stream> response = apiInstance.ReporteListarSignificadosWithHttpInfo(formato, dominio, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling RepApi.ReporteListarSignificadosWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **formato** | **FormatoReporte** | Formato del reporte |  |
| **dominio** | **string** | Dominio | [optional]  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |

### Return type

**System.IO.Stream**

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a id="reporteversionsistema"></a>
# **ReporteVersionSistema**
> System.IO.Stream ReporteVersionSistema (FormatoReporte formato, string riskDeviceToken = null, string riskServiceVersion = null)

ReporteVersionSistema

Obtiene un reporte con la versión actual del sistema

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ReporteVersionSistemaExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new RepApi(config);
            var formato = (FormatoReporte) "Pdf";  // FormatoReporte | Formato del reporte
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // ReporteVersionSistema
                System.IO.Stream result = apiInstance.ReporteVersionSistema(formato, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling RepApi.ReporteVersionSistema: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the ReporteVersionSistemaWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // ReporteVersionSistema
    ApiResponse<System.IO.Stream> response = apiInstance.ReporteVersionSistemaWithHttpInfo(formato, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling RepApi.ReporteVersionSistemaWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **formato** | **FormatoReporte** | Formato del reporte |  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |

### Return type

**System.IO.Stream**

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

