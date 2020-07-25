# Risk.API.Client.Api.MsjApi

All URIs are relative to *https://risk-project-api.azurewebsites.net*

Method | HTTP request | Description
------------- | ------------- | -------------
[**CambiarEstadoMensajeria**](MsjApi.md#cambiarestadomensajeria) | **POST** /Api/Msj/CambiarEstadoMensajeria | CambiarEstadoMensajeria
[**ListarCorreosPendientes**](MsjApi.md#listarcorreospendientes) | **GET** /Api/Msj/ListarCorreosPendientes | ListarCorreosPendientes
[**ListarMensajesPendientes**](MsjApi.md#listarmensajespendientes) | **GET** /Api/Msj/ListarMensajesPendientes | ListarMensajesPendientes
[**ListarNotificacionesPendientes**](MsjApi.md#listarnotificacionespendientes) | **GET** /Api/Msj/ListarNotificacionesPendientes | ListarNotificacionesPendientes


<a name="cambiarestadomensajeria"></a>
# **CambiarEstadoMensajeria**
> DatoRespuesta CambiarEstadoMensajeria (CambiarEstadoMensajeriaRequestBody cambiarEstadoMensajeriaRequestBody = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new MsjApi(config);
            var cambiarEstadoMensajeriaRequestBody = new CambiarEstadoMensajeriaRequestBody(); // CambiarEstadoMensajeriaRequestBody |  (optional) 

            try
            {
                // CambiarEstadoMensajeria
                DatoRespuesta result = apiInstance.CambiarEstadoMensajeria(cambiarEstadoMensajeriaRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling MsjApi.CambiarEstadoMensajeria: " + e.Message );
                Debug.Print("Status Code: "+ e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cambiarEstadoMensajeriaRequestBody** | [**CambiarEstadoMensajeriaRequestBody**](CambiarEstadoMensajeriaRequestBody.md)|  | [optional] 

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

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
> CorreoPaginaRespuesta ListarCorreosPendientes (int? pagina = null, int? porPagina = null, string noPaginar = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new MsjApi(config);
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = noPaginar_example;  // string | No paginar? (S/N) (optional) 

            try
            {
                // ListarCorreosPendientes
                CorreoPaginaRespuesta result = apiInstance.ListarCorreosPendientes(pagina, porPagina, noPaginar);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling MsjApi.ListarCorreosPendientes: " + e.Message );
                Debug.Print("Status Code: "+ e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pagina** | **int?**| Número de la página | [optional] 
 **porPagina** | **int?**| Cantidad de elementos por página | [optional] 
 **noPaginar** | **string**| No paginar? (S/N) | [optional] 

### Return type

[**CorreoPaginaRespuesta**](CorreoPaginaRespuesta.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

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
> MensajePaginaRespuesta ListarMensajesPendientes (int? pagina = null, int? porPagina = null, string noPaginar = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new MsjApi(config);
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = noPaginar_example;  // string | No paginar? (S/N) (optional) 

            try
            {
                // ListarMensajesPendientes
                MensajePaginaRespuesta result = apiInstance.ListarMensajesPendientes(pagina, porPagina, noPaginar);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling MsjApi.ListarMensajesPendientes: " + e.Message );
                Debug.Print("Status Code: "+ e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pagina** | **int?**| Número de la página | [optional] 
 **porPagina** | **int?**| Cantidad de elementos por página | [optional] 
 **noPaginar** | **string**| No paginar? (S/N) | [optional] 

### Return type

[**MensajePaginaRespuesta**](MensajePaginaRespuesta.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

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
> NotificacionPaginaRespuesta ListarNotificacionesPendientes (int? pagina = null, int? porPagina = null, string noPaginar = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new MsjApi(config);
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = noPaginar_example;  // string | No paginar? (S/N) (optional) 

            try
            {
                // ListarNotificacionesPendientes
                NotificacionPaginaRespuesta result = apiInstance.ListarNotificacionesPendientes(pagina, porPagina, noPaginar);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling MsjApi.ListarNotificacionesPendientes: " + e.Message );
                Debug.Print("Status Code: "+ e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pagina** | **int?**| Número de la página | [optional] 
 **porPagina** | **int?**| Cantidad de elementos por página | [optional] 
 **noPaginar** | **string**| No paginar? (S/N) | [optional] 

### Return type

[**NotificacionPaginaRespuesta**](NotificacionPaginaRespuesta.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

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

