# Risk.API.Client.Api.MsjApi

All URIs are relative to *https://localhost:5001*

| Method | HTTP request | Description |
|--------|--------------|-------------|
| [**ActivarMensajeria**](MsjApi.md#activarmensajeria) | **POST** /Api/Msj/ActivarMensajeria | ActivarMensajeria |
| [**CambiarEstadoMensajeria**](MsjApi.md#cambiarestadomensajeria) | **POST** /Api/Msj/CambiarEstadoMensajeria | CambiarEstadoMensajeria |
| [**DesactivarMensajeria**](MsjApi.md#desactivarmensajeria) | **POST** /Api/Msj/DesactivarMensajeria | DesactivarMensajeria |
| [**ListarCorreosPendientes**](MsjApi.md#listarcorreospendientes) | **GET** /Api/Msj/ListarCorreosPendientes | ListarCorreosPendientes |
| [**ListarMensajesPendientes**](MsjApi.md#listarmensajespendientes) | **GET** /Api/Msj/ListarMensajesPendientes | ListarMensajesPendientes |
| [**ListarNotificacionesPendientes**](MsjApi.md#listarnotificacionespendientes) | **GET** /Api/Msj/ListarNotificacionesPendientes | ListarNotificacionesPendientes |

<a name="activarmensajeria"></a>
# **ActivarMensajeria**
> DatoRespuesta ActivarMensajeria (TipoMensajeria tipoMensajeria, string riskDeviceToken = null, string riskServiceVersion = null)

ActivarMensajeria

Permite activar el servicio de mensajería

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ActivarMensajeriaExample
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

            var apiInstance = new MsjApi(config);
            var tipoMensajeria = (TipoMensajeria) "Mail";  // TipoMensajeria | Tipo de mensajería a activar
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // ActivarMensajeria
                DatoRespuesta result = apiInstance.ActivarMensajeria(tipoMensajeria, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling MsjApi.ActivarMensajeria: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the ActivarMensajeriaWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // ActivarMensajeria
    ApiResponse<DatoRespuesta> response = apiInstance.ActivarMensajeriaWithHttpInfo(tipoMensajeria, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling MsjApi.ActivarMensajeriaWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **tipoMensajeria** | **TipoMensajeria** | Tipo de mensajería a activar |  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="cambiarestadomensajeria"></a>
# **CambiarEstadoMensajeria**
> DatoRespuesta CambiarEstadoMensajeria (string riskDeviceToken = null, string riskServiceVersion = null, CambiarEstadoMensajeriaRequestBody cambiarEstadoMensajeriaRequestBody = null)

CambiarEstadoMensajeria

Permite cambiar el estado de envío de un mensaje de texto (SMS), correo electrónico (E-mail) o notificación push

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class CambiarEstadoMensajeriaExample
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

            var apiInstance = new MsjApi(config);
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var cambiarEstadoMensajeriaRequestBody = new CambiarEstadoMensajeriaRequestBody(); // CambiarEstadoMensajeriaRequestBody |  (optional) 

            try
            {
                // CambiarEstadoMensajeria
                DatoRespuesta result = apiInstance.CambiarEstadoMensajeria(riskDeviceToken, riskServiceVersion, cambiarEstadoMensajeriaRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling MsjApi.CambiarEstadoMensajeria: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the CambiarEstadoMensajeriaWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // CambiarEstadoMensajeria
    ApiResponse<DatoRespuesta> response = apiInstance.CambiarEstadoMensajeriaWithHttpInfo(riskDeviceToken, riskServiceVersion, cambiarEstadoMensajeriaRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling MsjApi.CambiarEstadoMensajeriaWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **cambiarEstadoMensajeriaRequestBody** | [**CambiarEstadoMensajeriaRequestBody**](CambiarEstadoMensajeriaRequestBody.md) |  | [optional]  |

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="desactivarmensajeria"></a>
# **DesactivarMensajeria**
> DatoRespuesta DesactivarMensajeria (TipoMensajeria tipoMensajeria, string riskDeviceToken = null, string riskServiceVersion = null)

DesactivarMensajeria

Permite desactivar el servicio de mensajería

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class DesactivarMensajeriaExample
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

            var apiInstance = new MsjApi(config);
            var tipoMensajeria = (TipoMensajeria) "Mail";  // TipoMensajeria | Tipo de mensajería a desactivar
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // DesactivarMensajeria
                DatoRespuesta result = apiInstance.DesactivarMensajeria(tipoMensajeria, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling MsjApi.DesactivarMensajeria: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the DesactivarMensajeriaWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // DesactivarMensajeria
    ApiResponse<DatoRespuesta> response = apiInstance.DesactivarMensajeriaWithHttpInfo(tipoMensajeria, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling MsjApi.DesactivarMensajeriaWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **tipoMensajeria** | **TipoMensajeria** | Tipo de mensajería a desactivar |  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="listarcorreospendientes"></a>
# **ListarCorreosPendientes**
> CorreoPaginaRespuesta ListarCorreosPendientes (int? pagina = null, int? porPagina = null, bool? noPaginar = null, string riskDeviceToken = null, string riskServiceVersion = null)

ListarCorreosPendientes

Obtiene una lista de correos electrónicos (E-mail) pendientes de envío

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ListarCorreosPendientesExample
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

            var apiInstance = new MsjApi(config);
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = true;  // bool? | No paginar? (optional) 
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // ListarCorreosPendientes
                CorreoPaginaRespuesta result = apiInstance.ListarCorreosPendientes(pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling MsjApi.ListarCorreosPendientes: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the ListarCorreosPendientesWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // ListarCorreosPendientes
    ApiResponse<CorreoPaginaRespuesta> response = apiInstance.ListarCorreosPendientesWithHttpInfo(pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling MsjApi.ListarCorreosPendientesWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **pagina** | **int?** | Número de la página | [optional]  |
| **porPagina** | **int?** | Cantidad de elementos por página | [optional]  |
| **noPaginar** | **bool?** | No paginar? | [optional]  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="listarmensajespendientes"></a>
# **ListarMensajesPendientes**
> MensajePaginaRespuesta ListarMensajesPendientes (int? pagina = null, int? porPagina = null, bool? noPaginar = null, string riskDeviceToken = null, string riskServiceVersion = null)

ListarMensajesPendientes

Obtiene una lista de mensajes de texto (SMS) pendientes de envío

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ListarMensajesPendientesExample
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

            var apiInstance = new MsjApi(config);
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = true;  // bool? | No paginar? (optional) 
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // ListarMensajesPendientes
                MensajePaginaRespuesta result = apiInstance.ListarMensajesPendientes(pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling MsjApi.ListarMensajesPendientes: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the ListarMensajesPendientesWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // ListarMensajesPendientes
    ApiResponse<MensajePaginaRespuesta> response = apiInstance.ListarMensajesPendientesWithHttpInfo(pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling MsjApi.ListarMensajesPendientesWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **pagina** | **int?** | Número de la página | [optional]  |
| **porPagina** | **int?** | Cantidad de elementos por página | [optional]  |
| **noPaginar** | **bool?** | No paginar? | [optional]  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="listarnotificacionespendientes"></a>
# **ListarNotificacionesPendientes**
> NotificacionPaginaRespuesta ListarNotificacionesPendientes (int? pagina = null, int? porPagina = null, bool? noPaginar = null, string riskDeviceToken = null, string riskServiceVersion = null)

ListarNotificacionesPendientes

Obtiene una lista de notificaciones push pendientes de envío

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ListarNotificacionesPendientesExample
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

            var apiInstance = new MsjApi(config);
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = true;  // bool? | No paginar? (optional) 
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // ListarNotificacionesPendientes
                NotificacionPaginaRespuesta result = apiInstance.ListarNotificacionesPendientes(pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling MsjApi.ListarNotificacionesPendientes: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the ListarNotificacionesPendientesWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // ListarNotificacionesPendientes
    ApiResponse<NotificacionPaginaRespuesta> response = apiInstance.ListarNotificacionesPendientesWithHttpInfo(pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling MsjApi.ListarNotificacionesPendientesWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **pagina** | **int?** | Número de la página | [optional]  |
| **porPagina** | **int?** | Cantidad de elementos por página | [optional]  |
| **noPaginar** | **bool?** | No paginar? | [optional]  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

