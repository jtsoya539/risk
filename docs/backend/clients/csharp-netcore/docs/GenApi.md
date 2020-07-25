# Risk.API.Client.Api.GenApi

All URIs are relative to *https://risk-project-api.azurewebsites.net*

Method | HTTP request | Description
------------- | ------------- | -------------
[**ListarPais**](GenApi.md#listarpais) | **GET** /Api/Gen/ListarPaises/{idPais} | ListarPais
[**ListarPaises**](GenApi.md#listarpaises) | **GET** /Api/Gen/ListarPaises | ListarPaises
[**SignificadoCodigo**](GenApi.md#significadocodigo) | **GET** /Api/Gen/SignificadoCodigo | SignificadoCodigo
[**ValorParametro**](GenApi.md#valorparametro) | **GET** /Api/Gen/ValorParametro | ValorParametro
[**VersionSistema**](GenApi.md#versionsistema) | **GET** /Api/Gen/VersionSistema | VersionSistema


<a name="listarpais"></a>
# **ListarPais**
> PaisPaginaRespuesta ListarPais (int idPais)

ListarPais

Obtiene los datos de un país

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ListarPaisExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GenApi(config);
            var idPais = 56;  // int | Identificador del país

            try
            {
                // ListarPais
                PaisPaginaRespuesta result = apiInstance.ListarPais(idPais);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.ListarPais: " + e.Message );
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
 **idPais** | **int**| Identificador del país | 

### Return type

[**PaisPaginaRespuesta**](PaisPaginaRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="listarpaises"></a>
# **ListarPaises**
> PaisPaginaRespuesta ListarPaises (int? pagina = null, int? porPagina = null, string noPaginar = null)

ListarPaises

Obtiene una lista de países

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ListarPaisesExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GenApi(config);
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = noPaginar_example;  // string | No paginar? (S/N) (optional) 

            try
            {
                // ListarPaises
                PaisPaginaRespuesta result = apiInstance.ListarPaises(pagina, porPagina, noPaginar);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.ListarPaises: " + e.Message );
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

[**PaisPaginaRespuesta**](PaisPaginaRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **403** | Aplicación no autorizada |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="significadocodigo"></a>
# **SignificadoCodigo**
> DatoRespuesta SignificadoCodigo (string dominio, string codigo)

SignificadoCodigo

Obtiene el significado de un código dentro de un dominio

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class SignificadoCodigoExample
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

            var apiInstance = new GenApi(config);
            var dominio = dominio_example;  // string | Dominio
            var codigo = codigo_example;  // string | Código

            try
            {
                // SignificadoCodigo
                DatoRespuesta result = apiInstance.SignificadoCodigo(dominio, codigo);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.SignificadoCodigo: " + e.Message );
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
 **dominio** | **string**| Dominio | 
 **codigo** | **string**| Código | 

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

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

<a name="valorparametro"></a>
# **ValorParametro**
> DatoRespuesta ValorParametro (string parametro)

ValorParametro

Obtiene el valor de un parámetro

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ValorParametroExample
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

            var apiInstance = new GenApi(config);
            var parametro = parametro_example;  // string | Identificador del parámetro

            try
            {
                // ValorParametro
                DatoRespuesta result = apiInstance.ValorParametro(parametro);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.ValorParametro: " + e.Message );
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
 **parametro** | **string**| Identificador del parámetro | 

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

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

<a name="versionsistema"></a>
# **VersionSistema**
> DatoRespuesta VersionSistema ()

VersionSistema

Obtiene la versión actual del sistema

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class VersionSistemaExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            var apiInstance = new GenApi(config);

            try
            {
                // VersionSistema
                DatoRespuesta result = apiInstance.VersionSistema();
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.VersionSistema: " + e.Message );
                Debug.Print("Status Code: "+ e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

### Parameters
This endpoint does not need any parameter.

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

