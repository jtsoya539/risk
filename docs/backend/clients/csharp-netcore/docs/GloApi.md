# Risk.API.Client.Api.GloApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**ListarBarrios**](GloApi.md#listarbarrios) | **GET** /Api/Glo/ListarBarrios | ListarBarrios
[**ListarCiudades**](GloApi.md#listarciudades) | **GET** /Api/Glo/ListarCiudades | ListarCiudades
[**ListarDepartamentos**](GloApi.md#listardepartamentos) | **GET** /Api/Glo/ListarDepartamentos | ListarDepartamentos
[**ListarPaises**](GloApi.md#listarpaises) | **GET** /Api/Glo/ListarPaises | ListarPaises


<a name="listarbarrios"></a>
# **ListarBarrios**
> BarrioPaginaRespuesta ListarBarrios (int? idPais = null, int? idDepartamento = null, int? idCiudad = null, int? pagina = null, int? porPagina = null, bool? noPaginar = null, string riskDeviceToken = null, string riskServiceVersion = null)

ListarBarrios

Obtiene una lista de barrios

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ListarBarriosExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GloApi(config);
            var idPais = 56;  // int? | Identificador del país (optional) 
            var idDepartamento = 56;  // int? | Identificador del departamento (optional) 
            var idCiudad = 56;  // int? | Identificador de la ciudad (optional) 
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = true;  // bool? | No paginar? (optional) 
            var riskDeviceToken = riskDeviceToken_example;  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del servicio (optional) 

            try
            {
                // ListarBarrios
                BarrioPaginaRespuesta result = apiInstance.ListarBarrios(idPais, idDepartamento, idCiudad, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GloApi.ListarBarrios: " + e.Message );
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
 **idPais** | **int?**| Identificador del país | [optional] 
 **idDepartamento** | **int?**| Identificador del departamento | [optional] 
 **idCiudad** | **int?**| Identificador de la ciudad | [optional] 
 **pagina** | **int?**| Número de la página | [optional] 
 **porPagina** | **int?**| Cantidad de elementos por página | [optional] 
 **noPaginar** | **bool?**| No paginar? | [optional] 
 **riskDeviceToken** | **string**| Token del dispositivo desde el cual se realiza la petición | [optional] 
 **riskServiceVersion** | **string**| Versión del servicio | [optional] 

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="listarciudades"></a>
# **ListarCiudades**
> CiudadPaginaRespuesta ListarCiudades (int? idPais = null, int? idDepartamento = null, int? pagina = null, int? porPagina = null, bool? noPaginar = null, string riskDeviceToken = null, string riskServiceVersion = null)

ListarCiudades

Obtiene una lista de ciudades

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ListarCiudadesExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GloApi(config);
            var idPais = 56;  // int? | Identificador del país (optional) 
            var idDepartamento = 56;  // int? | Identificador del departamento (optional) 
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = true;  // bool? | No paginar? (optional) 
            var riskDeviceToken = riskDeviceToken_example;  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del servicio (optional) 

            try
            {
                // ListarCiudades
                CiudadPaginaRespuesta result = apiInstance.ListarCiudades(idPais, idDepartamento, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GloApi.ListarCiudades: " + e.Message );
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
 **idPais** | **int?**| Identificador del país | [optional] 
 **idDepartamento** | **int?**| Identificador del departamento | [optional] 
 **pagina** | **int?**| Número de la página | [optional] 
 **porPagina** | **int?**| Cantidad de elementos por página | [optional] 
 **noPaginar** | **bool?**| No paginar? | [optional] 
 **riskDeviceToken** | **string**| Token del dispositivo desde el cual se realiza la petición | [optional] 
 **riskServiceVersion** | **string**| Versión del servicio | [optional] 

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="listardepartamentos"></a>
# **ListarDepartamentos**
> DepartamentoPaginaRespuesta ListarDepartamentos (int? idPais = null, int? pagina = null, int? porPagina = null, bool? noPaginar = null, string riskDeviceToken = null, string riskServiceVersion = null)

ListarDepartamentos

Obtiene una lista de departamentos

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ListarDepartamentosExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GloApi(config);
            var idPais = 56;  // int? | Identificador del país (optional) 
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = true;  // bool? | No paginar? (optional) 
            var riskDeviceToken = riskDeviceToken_example;  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del servicio (optional) 

            try
            {
                // ListarDepartamentos
                DepartamentoPaginaRespuesta result = apiInstance.ListarDepartamentos(idPais, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GloApi.ListarDepartamentos: " + e.Message );
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
 **idPais** | **int?**| Identificador del país | [optional] 
 **pagina** | **int?**| Número de la página | [optional] 
 **porPagina** | **int?**| Cantidad de elementos por página | [optional] 
 **noPaginar** | **bool?**| No paginar? | [optional] 
 **riskDeviceToken** | **string**| Token del dispositivo desde el cual se realiza la petición | [optional] 
 **riskServiceVersion** | **string**| Versión del servicio | [optional] 

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="listarpaises"></a>
# **ListarPaises**
> PaisPaginaRespuesta ListarPaises (int? pagina = null, int? porPagina = null, bool? noPaginar = null, string riskDeviceToken = null, string riskServiceVersion = null)

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
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GloApi(config);
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = true;  // bool? | No paginar? (optional) 
            var riskDeviceToken = riskDeviceToken_example;  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del servicio (optional) 

            try
            {
                // ListarPaises
                PaisPaginaRespuesta result = apiInstance.ListarPaises(pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GloApi.ListarPaises: " + e.Message );
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
 **noPaginar** | **bool?**| No paginar? | [optional] 
 **riskDeviceToken** | **string**| Token del dispositivo desde el cual se realiza la petición | [optional] 
 **riskServiceVersion** | **string**| Versión del servicio | [optional] 

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

