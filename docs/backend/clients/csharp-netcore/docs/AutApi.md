# Risk.API.Client.Api.AutApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**ActivarUsuario**](AutApi.md#activarusuario) | **GET** /Aut/ActivarUsuario | ActivarUsuario
[**CambiarClaveAcceso**](AutApi.md#cambiarclaveacceso) | **POST** /Api/Aut/CambiarClaveAcceso | CambiarClaveAcceso
[**CambiarClaveTransaccional**](AutApi.md#cambiarclavetransaccional) | **POST** /Api/Aut/CambiarClaveTransaccional | CambiarClaveTransaccional
[**DatosUsuario**](AutApi.md#datosusuario) | **GET** /Api/Aut/DatosUsuario | DatosUsuario
[**EditarUsuario**](AutApi.md#editarusuario) | **POST** /Api/Aut/EditarUsuario | EditarUsuario
[**EliminarUsuario**](AutApi.md#eliminarusuario) | **POST** /Api/Aut/EliminarUsuario | EliminarUsuario
[**FinalizarSesion**](AutApi.md#finalizarsesion) | **POST** /Api/Aut/FinalizarSesion | FinalizarSesion
[**GenerarOtp**](AutApi.md#generarotp) | **POST** /Api/Aut/GenerarOtp | GenerarOtp
[**GuardarAvatarUsuario**](AutApi.md#guardaravatarusuario) | **POST** /Api/Aut/GuardarAvatarUsuario | GuardarAvatarUsuario
[**IniciarSesion**](AutApi.md#iniciarsesion) | **POST** /Api/Aut/IniciarSesion | IniciarSesion
[**IniciarSesionFacebook**](AutApi.md#iniciarsesionfacebook) | **POST** /Api/Aut/IniciarSesionFacebook | IniciarSesionFacebook
[**IniciarSesionGoogle**](AutApi.md#iniciarsesiongoogle) | **POST** /Api/Aut/IniciarSesionGoogle | IniciarSesionGoogle
[**RecuperarAvatarUsuario**](AutApi.md#recuperaravatarusuario) | **GET** /Api/Aut/RecuperarAvatarUsuario | RecuperarAvatarUsuario
[**RefrescarSesion**](AutApi.md#refrescarsesion) | **POST** /Api/Aut/RefrescarSesion | RefrescarSesion
[**RefrescarSesionFacebook**](AutApi.md#refrescarsesionfacebook) | **POST** /Api/Aut/RefrescarSesionFacebook | RefrescarSesionFacebook
[**RefrescarSesionGoogle**](AutApi.md#refrescarsesiongoogle) | **POST** /Api/Aut/RefrescarSesionGoogle | RefrescarSesionGoogle
[**RegistrarClaveTransaccional**](AutApi.md#registrarclavetransaccional) | **POST** /Api/Aut/RegistrarClaveTransaccional | RegistrarClaveTransaccional
[**RegistrarDispositivo**](AutApi.md#registrardispositivo) | **POST** /Api/Aut/RegistrarDispositivo | RegistrarDispositivo
[**RegistrarUbicacion**](AutApi.md#registrarubicacion) | **POST** /Api/Aut/RegistrarUbicacion | RegistrarUbicacion
[**RegistrarUsuario**](AutApi.md#registrarusuario) | **POST** /Api/Aut/RegistrarUsuario | RegistrarUsuario
[**ValidarOtp**](AutApi.md#validarotp) | **GET** /Api/Aut/ValidarOtp | ValidarOtp
[**ValidarSesion**](AutApi.md#validarsesion) | **GET** /Api/Aut/ValidarSesion | ValidarSesion


<a name="activarusuario"></a>
# **ActivarUsuario**
> DatoRespuesta ActivarUsuario (string key, string riskServiceVersion = null)

ActivarUsuario

Permite activar un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ActivarUsuarioExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            var apiInstance = new AutApi(config);
            var key = key_example;  // string | Clave para la activación
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // ActivarUsuario
                DatoRespuesta result = apiInstance.ActivarUsuario(key, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.ActivarUsuario: " + e.Message );
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
 **key** | **string**| Clave para la activación | 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/html, application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Operación exitosa |  -  |
| **400** | Operación con error |  -  |
| **500** | Error inesperado |  -  |
| **501** | Servicio no implementado o inactivo |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

<a name="cambiarclaveacceso"></a>
# **CambiarClaveAcceso**
> DatoRespuesta CambiarClaveAcceso (string riskServiceVersion = null, CambiarClaveAccesoRequestBody cambiarClaveAccesoRequestBody = null)

CambiarClaveAcceso

Permite cambiar la clave de acceso de un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class CambiarClaveAccesoExample
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

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var cambiarClaveAccesoRequestBody = new CambiarClaveAccesoRequestBody(); // CambiarClaveAccesoRequestBody |  (optional) 

            try
            {
                // CambiarClaveAcceso
                DatoRespuesta result = apiInstance.CambiarClaveAcceso(riskServiceVersion, cambiarClaveAccesoRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.CambiarClaveAcceso: " + e.Message );
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
 **cambiarClaveAccesoRequestBody** | [**CambiarClaveAccesoRequestBody**](CambiarClaveAccesoRequestBody.md)|  | [optional] 

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

<a name="cambiarclavetransaccional"></a>
# **CambiarClaveTransaccional**
> DatoRespuesta CambiarClaveTransaccional (string riskServiceVersion = null, CambiarClaveTransaccionalRequestBody cambiarClaveTransaccionalRequestBody = null)

CambiarClaveTransaccional

Permite cambiar la clave transaccional de un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class CambiarClaveTransaccionalExample
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

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var cambiarClaveTransaccionalRequestBody = new CambiarClaveTransaccionalRequestBody(); // CambiarClaveTransaccionalRequestBody |  (optional) 

            try
            {
                // CambiarClaveTransaccional
                DatoRespuesta result = apiInstance.CambiarClaveTransaccional(riskServiceVersion, cambiarClaveTransaccionalRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.CambiarClaveTransaccional: " + e.Message );
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
 **cambiarClaveTransaccionalRequestBody** | [**CambiarClaveTransaccionalRequestBody**](CambiarClaveTransaccionalRequestBody.md)|  | [optional] 

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

<a name="datosusuario"></a>
# **DatosUsuario**
> UsuarioRespuesta DatosUsuario (string usuario, string riskServiceVersion = null)

DatosUsuario

Permite obtener los datos de un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class DatosUsuarioExample
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

            var apiInstance = new AutApi(config);
            var usuario = usuario_example;  // string | Usuario
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // DatosUsuario
                UsuarioRespuesta result = apiInstance.DatosUsuario(usuario, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.DatosUsuario: " + e.Message );
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
 **usuario** | **string**| Usuario | 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 

### Return type

[**UsuarioRespuesta**](UsuarioRespuesta.md)

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

<a name="editarusuario"></a>
# **EditarUsuario**
> DatoRespuesta EditarUsuario (string usuario, string riskServiceVersion = null, EditarUsuarioRequestBody editarUsuarioRequestBody = null)

EditarUsuario

Permite editar un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class EditarUsuarioExample
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

            var apiInstance = new AutApi(config);
            var usuario = usuario_example;  // string | Usuario
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var editarUsuarioRequestBody = new EditarUsuarioRequestBody(); // EditarUsuarioRequestBody |  (optional) 

            try
            {
                // EditarUsuario
                DatoRespuesta result = apiInstance.EditarUsuario(usuario, riskServiceVersion, editarUsuarioRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.EditarUsuario: " + e.Message );
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
 **usuario** | **string**| Usuario | 
 **riskServiceVersion** | **string**| Versión del Servicio | [optional] 
 **editarUsuarioRequestBody** | [**EditarUsuarioRequestBody**](EditarUsuarioRequestBody.md)|  | [optional] 

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

<a name="eliminarusuario"></a>
# **EliminarUsuario**
> DatoRespuesta EliminarUsuario (string riskServiceVersion = null, EliminarUsuarioRequestBody eliminarUsuarioRequestBody = null)

EliminarUsuario

Permite eliminar un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class EliminarUsuarioExample
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

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var eliminarUsuarioRequestBody = new EliminarUsuarioRequestBody(); // EliminarUsuarioRequestBody |  (optional) 

            try
            {
                // EliminarUsuario
                DatoRespuesta result = apiInstance.EliminarUsuario(riskServiceVersion, eliminarUsuarioRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.EliminarUsuario: " + e.Message );
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
 **eliminarUsuarioRequestBody** | [**EliminarUsuarioRequestBody**](EliminarUsuarioRequestBody.md)|  | [optional] 

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

<a name="finalizarsesion"></a>
# **FinalizarSesion**
> DatoRespuesta FinalizarSesion (string riskServiceVersion = null, FinalizarSesionRequestBody finalizarSesionRequestBody = null)

FinalizarSesion

Permite finalizar la sesión de un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class FinalizarSesionExample
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

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var finalizarSesionRequestBody = new FinalizarSesionRequestBody(); // FinalizarSesionRequestBody |  (optional) 

            try
            {
                // FinalizarSesion
                DatoRespuesta result = apiInstance.FinalizarSesion(riskServiceVersion, finalizarSesionRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.FinalizarSesion: " + e.Message );
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
 **finalizarSesionRequestBody** | [**FinalizarSesionRequestBody**](FinalizarSesionRequestBody.md)|  | [optional] 

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

<a name="generarotp"></a>
# **GenerarOtp**
> DatoRespuesta GenerarOtp (TipoMensajeria tipoMensajeria, string destino, string riskServiceVersion = null)

GenerarOtp

Permite generar un código OTP

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class GenerarOtpExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var tipoMensajeria = ;  // TipoMensajeria | Tipo de mensajería (Mail/SMS/Push)
            var destino = destino_example;  // string | Destino de la mensajería
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // GenerarOtp
                DatoRespuesta result = apiInstance.GenerarOtp(tipoMensajeria, destino, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.GenerarOtp: " + e.Message );
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
 **tipoMensajeria** | **TipoMensajeria**| Tipo de mensajería (Mail/SMS/Push) | 
 **destino** | **string**| Destino de la mensajería | 
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

<a name="guardaravatarusuario"></a>
# **GuardarAvatarUsuario**
> DatoRespuesta GuardarAvatarUsuario (string usuario, string riskServiceVersion = null, System.IO.Stream archivo = null, string url = null, string nombre = null, string extension = null)

GuardarAvatarUsuario

Permite guardar el avatar de un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class GuardarAvatarUsuarioExample
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

            var apiInstance = new AutApi(config);
            var usuario = usuario_example;  // string | Usuario
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var archivo = BINARY_DATA_HERE;  // System.IO.Stream | Contenido del archivo (optional) 
            var url = url_example;  // string | URL del archivo (optional) 
            var nombre = nombre_example;  // string | Nombre del archivo (optional) 
            var extension = extension_example;  // string | Extensión del archivo (optional) 

            try
            {
                // GuardarAvatarUsuario
                DatoRespuesta result = apiInstance.GuardarAvatarUsuario(usuario, riskServiceVersion, archivo, url, nombre, extension);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.GuardarAvatarUsuario: " + e.Message );
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
 **usuario** | **string**| Usuario | 
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

<a name="iniciarsesion"></a>
# **IniciarSesion**
> SesionRespuesta IniciarSesion (string riskServiceVersion = null, IniciarSesionRequestBody iniciarSesionRequestBody = null)

IniciarSesion

Permite iniciar la sesión de un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class IniciarSesionExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var iniciarSesionRequestBody = new IniciarSesionRequestBody(); // IniciarSesionRequestBody |  (optional) 

            try
            {
                // IniciarSesion
                SesionRespuesta result = apiInstance.IniciarSesion(riskServiceVersion, iniciarSesionRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.IniciarSesion: " + e.Message );
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
 **iniciarSesionRequestBody** | [**IniciarSesionRequestBody**](IniciarSesionRequestBody.md)|  | [optional] 

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="iniciarsesionfacebook"></a>
# **IniciarSesionFacebook**
> SesionRespuesta IniciarSesionFacebook (string riskServiceVersion = null, IniciarSesionFacebookRequestBody iniciarSesionFacebookRequestBody = null)

IniciarSesionFacebook

Permite iniciar la sesión de un usuario con su cuenta de facebook

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class IniciarSesionFacebookExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var iniciarSesionFacebookRequestBody = new IniciarSesionFacebookRequestBody(); // IniciarSesionFacebookRequestBody |  (optional) 

            try
            {
                // IniciarSesionFacebook
                SesionRespuesta result = apiInstance.IniciarSesionFacebook(riskServiceVersion, iniciarSesionFacebookRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.IniciarSesionFacebook: " + e.Message );
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
 **iniciarSesionFacebookRequestBody** | [**IniciarSesionFacebookRequestBody**](IniciarSesionFacebookRequestBody.md)|  | [optional] 

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="iniciarsesiongoogle"></a>
# **IniciarSesionGoogle**
> SesionRespuesta IniciarSesionGoogle (string riskServiceVersion = null, IniciarSesionGoogleRequestBody iniciarSesionGoogleRequestBody = null)

IniciarSesionGoogle

Permite iniciar la sesión de un usuario con su cuenta de google

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class IniciarSesionGoogleExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var iniciarSesionGoogleRequestBody = new IniciarSesionGoogleRequestBody(); // IniciarSesionGoogleRequestBody |  (optional) 

            try
            {
                // IniciarSesionGoogle
                SesionRespuesta result = apiInstance.IniciarSesionGoogle(riskServiceVersion, iniciarSesionGoogleRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.IniciarSesionGoogle: " + e.Message );
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
 **iniciarSesionGoogleRequestBody** | [**IniciarSesionGoogleRequestBody**](IniciarSesionGoogleRequestBody.md)|  | [optional] 

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="recuperaravatarusuario"></a>
# **RecuperarAvatarUsuario**
> System.IO.Stream RecuperarAvatarUsuario (string usuario, int? version = null, string riskServiceVersion = null)

RecuperarAvatarUsuario

Permite recuperar el avatar de un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class RecuperarAvatarUsuarioExample
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

            var apiInstance = new AutApi(config);
            var usuario = usuario_example;  // string | Usuario
            var version = 56;  // int? | Versión (optional) 
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // RecuperarAvatarUsuario
                System.IO.Stream result = apiInstance.RecuperarAvatarUsuario(usuario, version, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RecuperarAvatarUsuario: " + e.Message );
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
 **usuario** | **string**| Usuario | 
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

<a name="refrescarsesion"></a>
# **RefrescarSesion**
> SesionRespuesta RefrescarSesion (string riskServiceVersion = null, RefrescarSesionRequestBody refrescarSesionRequestBody = null)

RefrescarSesion

Permite refrescar la sesión de un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class RefrescarSesionExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var refrescarSesionRequestBody = new RefrescarSesionRequestBody(); // RefrescarSesionRequestBody |  (optional) 

            try
            {
                // RefrescarSesion
                SesionRespuesta result = apiInstance.RefrescarSesion(riskServiceVersion, refrescarSesionRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RefrescarSesion: " + e.Message );
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
 **refrescarSesionRequestBody** | [**RefrescarSesionRequestBody**](RefrescarSesionRequestBody.md)|  | [optional] 

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="refrescarsesionfacebook"></a>
# **RefrescarSesionFacebook**
> SesionRespuesta RefrescarSesionFacebook (string riskServiceVersion = null, RefrescarSesionFacebookRequestBody refrescarSesionFacebookRequestBody = null)

RefrescarSesionFacebook

Permite refrescar la sesión de un usuario con su cuenta de facebook

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class RefrescarSesionFacebookExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var refrescarSesionFacebookRequestBody = new RefrescarSesionFacebookRequestBody(); // RefrescarSesionFacebookRequestBody |  (optional) 

            try
            {
                // RefrescarSesionFacebook
                SesionRespuesta result = apiInstance.RefrescarSesionFacebook(riskServiceVersion, refrescarSesionFacebookRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RefrescarSesionFacebook: " + e.Message );
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
 **refrescarSesionFacebookRequestBody** | [**RefrescarSesionFacebookRequestBody**](RefrescarSesionFacebookRequestBody.md)|  | [optional] 

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="refrescarsesiongoogle"></a>
# **RefrescarSesionGoogle**
> SesionRespuesta RefrescarSesionGoogle (string riskServiceVersion = null, RefrescarSesionGoogleRequestBody refrescarSesionGoogleRequestBody = null)

RefrescarSesionGoogle

Permite refrescar la sesión de un usuario con su cuenta de google

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class RefrescarSesionGoogleExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var refrescarSesionGoogleRequestBody = new RefrescarSesionGoogleRequestBody(); // RefrescarSesionGoogleRequestBody |  (optional) 

            try
            {
                // RefrescarSesionGoogle
                SesionRespuesta result = apiInstance.RefrescarSesionGoogle(riskServiceVersion, refrescarSesionGoogleRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RefrescarSesionGoogle: " + e.Message );
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
 **refrescarSesionGoogleRequestBody** | [**RefrescarSesionGoogleRequestBody**](RefrescarSesionGoogleRequestBody.md)|  | [optional] 

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="registrarclavetransaccional"></a>
# **RegistrarClaveTransaccional**
> DatoRespuesta RegistrarClaveTransaccional (string riskServiceVersion = null, RegistrarClaveTransaccionalRequestBody registrarClaveTransaccionalRequestBody = null)

RegistrarClaveTransaccional

Permite registrar una clave transaccional para un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class RegistrarClaveTransaccionalExample
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

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var registrarClaveTransaccionalRequestBody = new RegistrarClaveTransaccionalRequestBody(); // RegistrarClaveTransaccionalRequestBody |  (optional) 

            try
            {
                // RegistrarClaveTransaccional
                DatoRespuesta result = apiInstance.RegistrarClaveTransaccional(riskServiceVersion, registrarClaveTransaccionalRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RegistrarClaveTransaccional: " + e.Message );
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
 **registrarClaveTransaccionalRequestBody** | [**RegistrarClaveTransaccionalRequestBody**](RegistrarClaveTransaccionalRequestBody.md)|  | [optional] 

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

<a name="registrardispositivo"></a>
# **RegistrarDispositivo**
> DatoRespuesta RegistrarDispositivo (string riskServiceVersion = null, RegistrarDispositivoRequestBody registrarDispositivoRequestBody = null)

RegistrarDispositivo

Permite registrar un dispositivo

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class RegistrarDispositivoExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var registrarDispositivoRequestBody = new RegistrarDispositivoRequestBody(); // RegistrarDispositivoRequestBody |  (optional) 

            try
            {
                // RegistrarDispositivo
                DatoRespuesta result = apiInstance.RegistrarDispositivo(riskServiceVersion, registrarDispositivoRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RegistrarDispositivo: " + e.Message );
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
 **registrarDispositivoRequestBody** | [**RegistrarDispositivoRequestBody**](RegistrarDispositivoRequestBody.md)|  | [optional] 

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="registrarubicacion"></a>
# **RegistrarUbicacion**
> DatoRespuesta RegistrarUbicacion (string riskServiceVersion = null, RegistrarUbicacionRequestBody registrarUbicacionRequestBody = null)

RegistrarUbicacion

Permite registrar la ubicación (coordenadas geográficas) de un dispositivo

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class RegistrarUbicacionExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var registrarUbicacionRequestBody = new RegistrarUbicacionRequestBody(); // RegistrarUbicacionRequestBody |  (optional) 

            try
            {
                // RegistrarUbicacion
                DatoRespuesta result = apiInstance.RegistrarUbicacion(riskServiceVersion, registrarUbicacionRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RegistrarUbicacion: " + e.Message );
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
 **registrarUbicacionRequestBody** | [**RegistrarUbicacionRequestBody**](RegistrarUbicacionRequestBody.md)|  | [optional] 

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="registrarusuario"></a>
# **RegistrarUsuario**
> DatoRespuesta RegistrarUsuario (string riskServiceVersion = null, RegistrarUsuarioRequestBody registrarUsuarioRequestBody = null)

RegistrarUsuario

Permite registrar un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class RegistrarUsuarioExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 
            var registrarUsuarioRequestBody = new RegistrarUsuarioRequestBody(); // RegistrarUsuarioRequestBody |  (optional) 

            try
            {
                // RegistrarUsuario
                DatoRespuesta result = apiInstance.RegistrarUsuario(riskServiceVersion, registrarUsuarioRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RegistrarUsuario: " + e.Message );
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
 **registrarUsuarioRequestBody** | [**RegistrarUsuarioRequestBody**](RegistrarUsuarioRequestBody.md)|  | [optional] 

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="validarotp"></a>
# **ValidarOtp**
> DatoRespuesta ValidarOtp (string secret, int otp, string riskServiceVersion = null)

ValidarOtp

Permite validar un código OTP

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ValidarOtpExample
    {
        public static void Main()
        {
            Configuration config = new Configuration();
            config.BasePath = "https://localhost:5001";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var secret = secret_example;  // string | Secret recibido al generar el código OTP
            var otp = 56;  // int | Código OTP a validar
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // ValidarOtp
                DatoRespuesta result = apiInstance.ValidarOtp(secret, otp, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.ValidarOtp: " + e.Message );
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
 **secret** | **string**| Secret recibido al generar el código OTP | 
 **otp** | **int**| Código OTP a validar | 
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

<a name="validarsesion"></a>
# **ValidarSesion**
> DatoRespuesta ValidarSesion (string accessToken, string riskServiceVersion = null)

ValidarSesion

Permite validar si una sesión está activa o no

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ValidarSesionExample
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

            var apiInstance = new AutApi(config);
            var accessToken = accessToken_example;  // string | Access Token de la sesión
            var riskServiceVersion = riskServiceVersion_example;  // string | Versión del Servicio (optional) 

            try
            {
                // ValidarSesion
                DatoRespuesta result = apiInstance.ValidarSesion(accessToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.ValidarSesion: " + e.Message );
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
 **accessToken** | **string**| Access Token de la sesión | 
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

