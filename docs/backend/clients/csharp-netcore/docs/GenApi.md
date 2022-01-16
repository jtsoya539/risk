# Risk.API.Client.Api.GenApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**GuardarArchivo**](GenApi.md#guardararchivo) | **POST** /Api/Gen/GuardarArchivo | GuardarArchivo
[**ListarAplicaciones**](GenApi.md#listaraplicaciones) | **GET** /Api/Gen/ListarAplicaciones | ListarAplicaciones
[**ListarErrores**](GenApi.md#listarerrores) | **GET** /Api/Gen/ListarErrores | ListarErrores
[**ListarSignificados**](GenApi.md#listarsignificados) | **GET** /Api/Gen/ListarSignificados | ListarSignificados
[**RecuperarArchivo**](GenApi.md#recuperararchivo) | **GET** /Api/Gen/RecuperarArchivo | RecuperarArchivo
[**RecuperarTexto**](GenApi.md#recuperartexto) | **GET** /Api/Gen/RecuperarTexto | RecuperarTexto
[**ReporteListarSignificados**](GenApi.md#reportelistarsignificados) | **GET** /Api/Gen/ReporteListarSignificados | ReporteListarSignificados
[**ReporteVersionSistema**](GenApi.md#reporteversionsistema) | **GET** /Api/Gen/ReporteVersionSistema | ReporteVersionSistema
[**SignificadoCodigo**](GenApi.md#significadocodigo) | **GET** /Api/Gen/SignificadoCodigo | SignificadoCodigo
[**ValorParametro**](GenApi.md#valorparametro) | **GET** /Api/Gen/ValorParametro | ValorParametro
[**VersionServicio**](GenApi.md#versionservicio) | **GET** /Api/Gen/VersionServicio | VersionServicio
[**VersionSistema**](GenApi.md#versionsistema) | **GET** /Gen/VersionSistema | VersionSistema


<a name="guardararchivo"></a>
# **GuardarArchivo**
> DatoRespuesta GuardarArchivo (string tabla, string campo, string referencia, string riskServiceVersion = null, System.IO.Stream archivo = null, string url = null, string nombre = null, string extension = null)

GuardarArchivo

Permite guardar un archivo

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class GuardarArchivoExample
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

            var apiInstance = new GenApi(config);
            var tabla = tabla_example;  // string | Tabla
            var campo = campo_example;  // string | Campo
            var referencia = referencia_example;  // string | Referencia
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var archivo = BINARY_DATA_HERE;  // System.IO.Stream | Contenido del archivo (optional) 
            var url = url_example;  // string | URL del archivo (optional) 
            var nombre = nombre_example;  // string | Nombre del archivo (optional) 
            var extension = extension_example;  // string | Extensión del archivo (optional) 

            try
            {
                // GuardarArchivo
                DatoRespuesta result = apiInstance.GuardarArchivo(tabla, campo, referencia, riskServiceVersion, archivo, url, nombre, extension);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.GuardarArchivo: " + e.Message );
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
 **tabla** | **string**| Tabla | 
 **campo** | **string**| Campo | 
 **referencia** | **string**| Referencia | 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 
 **archivo** | **System.IO.Stream****System.IO.Stream**| Contenido del archivo | [optional] 
 **url** | **string**| URL del archivo | [optional] 
 **nombre** | **string**| Nombre del archivo | [optional] 
 **extension** | **string**| Extensión del archivo | [optional] 

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="listaraplicaciones"></a>
# **ListarAplicaciones**
> AplicacionPaginaRespuesta ListarAplicaciones (string idAplicacion = null, string claveAplicacion = null, int? pagina = null, int? porPagina = null, bool? noPaginar = null, string riskServiceVersion = null)

ListarAplicaciones

Obtiene una lista de aplicaciones

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ListarAplicacionesExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GenApi(config);
            var idAplicacion = idAplicacion_example;  // string | Identificador de la aplicacion (optional) 
            var claveAplicacion = claveAplicacion_example;  // string | Clave de la aplicacion (optional) 
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = true;  // bool? | No paginar? (optional) 
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // ListarAplicaciones
                AplicacionPaginaRespuesta result = apiInstance.ListarAplicaciones(idAplicacion, claveAplicacion, pagina, porPagina, noPaginar, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.ListarAplicaciones: " + e.Message );
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
 **idAplicacion** | **string**| Identificador de la aplicacion | [optional] 
 **claveAplicacion** | **string**| Clave de la aplicacion | [optional] 
 **pagina** | **int?**| Número de la página | [optional] 
 **porPagina** | **int?**| Cantidad de elementos por página | [optional] 
 **noPaginar** | **bool?**| No paginar? | [optional] 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="listarerrores"></a>
# **ListarErrores**
> ErrorPaginaRespuesta ListarErrores (string idError = null, int? pagina = null, int? porPagina = null, bool? noPaginar = null, string riskServiceVersion = null)

ListarErrores

Obtiene una lista de errores

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ListarErroresExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GenApi(config);
            var idError = idError_example;  // string | Identificador del error (optional) 
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = true;  // bool? | No paginar? (optional) 
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // ListarErrores
                ErrorPaginaRespuesta result = apiInstance.ListarErrores(idError, pagina, porPagina, noPaginar, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.ListarErrores: " + e.Message );
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
 **idError** | **string**| Identificador del error | [optional] 
 **pagina** | **int?**| Número de la página | [optional] 
 **porPagina** | **int?**| Cantidad de elementos por página | [optional] 
 **noPaginar** | **bool?**| No paginar? | [optional] 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="listarsignificados"></a>
# **ListarSignificados**
> SignificadoPaginaRespuesta ListarSignificados (string dominio, int? pagina = null, int? porPagina = null, bool? noPaginar = null, string riskServiceVersion = null)

ListarSignificados

Obtiene una lista de significados dentro de un dominio

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ListarSignificadosExample
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

            var apiInstance = new GenApi(config);
            var dominio = dominio_example;  // string | Dominio
            var pagina = 56;  // int? | Número de la página (optional) 
            var porPagina = 56;  // int? | Cantidad de elementos por página (optional) 
            var noPaginar = true;  // bool? | No paginar? (optional) 
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // ListarSignificados
                SignificadoPaginaRespuesta result = apiInstance.ListarSignificados(dominio, pagina, porPagina, noPaginar, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.ListarSignificados: " + e.Message );
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
 **pagina** | **int?**| Número de la página | [optional] 
 **porPagina** | **int?**| Cantidad de elementos por página | [optional] 
 **noPaginar** | **bool?**| No paginar? | [optional] 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="recuperararchivo"></a>
# **RecuperarArchivo**
> System.IO.Stream RecuperarArchivo (string tabla, string campo, string referencia, int? version = null, string riskServiceVersion = null)

RecuperarArchivo

Permite recuperar un archivo

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class RecuperarArchivoExample
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

            var apiInstance = new GenApi(config);
            var tabla = tabla_example;  // string | Tabla
            var campo = campo_example;  // string | Campo
            var referencia = referencia_example;  // string | Referencia
            var version = 56;  // int? | Versión (optional) 
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // RecuperarArchivo
                System.IO.Stream result = apiInstance.RecuperarArchivo(tabla, campo, referencia, version, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.RecuperarArchivo: " + e.Message );
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
 **tabla** | **string**| Tabla | 
 **campo** | **string**| Campo | 
 **referencia** | **string**| Referencia | 
 **version** | **int?**| Versión | [optional] 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

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

<a name="recuperartexto"></a>
# **RecuperarTexto**
> DatoRespuesta RecuperarTexto (string referencia, string riskServiceVersion = null)

RecuperarTexto

Obtiene un texto definido en el sistema

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class RecuperarTextoExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GenApi(config);
            var referencia = referencia_example;  // string | Referencia del texto
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // RecuperarTexto
                DatoRespuesta result = apiInstance.RecuperarTexto(referencia, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.RecuperarTexto: " + e.Message );
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
 **referencia** | **string**| Referencia del texto | 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="reportelistarsignificados"></a>
# **ReporteListarSignificados**
> System.IO.Stream ReporteListarSignificados (FormatoReporte formato, string dominio = null, string riskServiceVersion = null)

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

            var apiInstance = new GenApi(config);
            var formato = ;  // FormatoReporte | Formato del reporte
            var dominio = dominio_example;  // string | Dominio (optional) 
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // ReporteListarSignificados
                System.IO.Stream result = apiInstance.ReporteListarSignificados(formato, dominio, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.ReporteListarSignificados: " + e.Message );
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
 **formato** | **FormatoReporte**| Formato del reporte | 
 **dominio** | **string**| Dominio | [optional] 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

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

<a name="reporteversionsistema"></a>
# **ReporteVersionSistema**
> System.IO.Stream ReporteVersionSistema (FormatoReporte formato, string riskServiceVersion = null)

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

            var apiInstance = new GenApi(config);
            var formato = ;  // FormatoReporte | Formato del reporte
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // ReporteVersionSistema
                System.IO.Stream result = apiInstance.ReporteVersionSistema(formato, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.ReporteVersionSistema: " + e.Message );
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
 **formato** | **FormatoReporte**| Formato del reporte | 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

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

<a name="significadocodigo"></a>
# **SignificadoCodigo**
> DatoRespuesta SignificadoCodigo (string dominio, string codigo, string riskServiceVersion = null)

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
            config.BasePath = "https://localhost:5001";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GenApi(config);
            var dominio = dominio_example;  // string | Dominio
            var codigo = codigo_example;  // string | Código
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // SignificadoCodigo
                DatoRespuesta result = apiInstance.SignificadoCodigo(dominio, codigo, riskServiceVersion);
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
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

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

<a name="valorparametro"></a>
# **ValorParametro**
> DatoRespuesta ValorParametro (string parametro, string riskServiceVersion = null)

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
            config.BasePath = "https://localhost:5001";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GenApi(config);
            var parametro = parametro_example;  // string | Identificador del parámetro
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // ValorParametro
                DatoRespuesta result = apiInstance.ValorParametro(parametro, riskServiceVersion);
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
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

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

<a name="versionservicio"></a>
# **VersionServicio**
> DatoRespuesta VersionServicio (string servicio, string riskServiceVersion = null)

VersionServicio

Obtiene la versión actual del servicio

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class VersionServicioExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new GenApi(config);
            var servicio = servicio_example;  // string | Nombre del servicio
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // VersionServicio
                DatoRespuesta result = apiInstance.VersionServicio(servicio, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling GenApi.VersionServicio: " + e.Message );
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
 **servicio** | **string**| Nombre del servicio | 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

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

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="versionsistema"></a>
# **VersionSistema**
> DatoRespuesta VersionSistema (string riskServiceVersion = null)

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
            config.BasePath = "https://localhost:5001";
            var apiInstance = new GenApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // VersionSistema
                DatoRespuesta result = apiInstance.VersionSistema(riskServiceVersion);
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

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

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

