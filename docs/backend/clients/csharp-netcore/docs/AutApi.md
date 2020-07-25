# Risk.API.Client.Api.AutApi

All URIs are relative to *https://risk-project-api.azurewebsites.net*

Method | HTTP request | Description
------------- | ------------- | -------------
[**CambiarClaveAcceso**](AutApi.md#cambiarclaveacceso) | **POST** /Api/Aut/CambiarClaveAcceso | CambiarClaveAcceso
[**CambiarClaveTransaccional**](AutApi.md#cambiarclavetransaccional) | **POST** /Api/Aut/CambiarClaveTransaccional | CambiarClaveTransaccional
[**EditarUsuario**](AutApi.md#editarusuario) | **POST** /Api/Aut/EditarUsuario | EditarUsuario
[**EliminarUsuario**](AutApi.md#eliminarusuario) | **POST** /Api/Aut/EliminarUsuario | EliminarUsuario
[**FinalizarSesion**](AutApi.md#finalizarsesion) | **POST** /Api/Aut/FinalizarSesion | FinalizarSesion
[**GuardarAvatarUsuario**](AutApi.md#guardaravatarusuario) | **POST** /Api/Aut/GuardarAvatarUsuario | GuardarAvatarUsuario
[**IniciarSesion**](AutApi.md#iniciarsesion) | **POST** /Api/Aut/IniciarSesion | IniciarSesion
[**RecuperarAvatarUsuario**](AutApi.md#recuperaravatarusuario) | **GET** /Api/Aut/RecuperarAvatarUsuario | RecuperarAvatarUsuario
[**RefrescarSesion**](AutApi.md#refrescarsesion) | **POST** /Api/Aut/RefrescarSesion | RefrescarSesion
[**RegistrarClaveTransaccional**](AutApi.md#registrarclavetransaccional) | **POST** /Api/Aut/RegistrarClaveTransaccional | RegistrarClaveTransaccional
[**RegistrarDispositivo**](AutApi.md#registrardispositivo) | **POST** /Api/Aut/RegistrarDispositivo | RegistrarDispositivo
[**RegistrarUsuario**](AutApi.md#registrarusuario) | **POST** /Api/Aut/RegistrarUsuario | RegistrarUsuario
[**ValidarSesion**](AutApi.md#validarsesion) | **GET** /Api/Aut/ValidarSesion | ValidarSesion


<a name="cambiarclaveacceso"></a>
# **CambiarClaveAcceso**
> DatoRespuesta CambiarClaveAcceso (CambiarClaveAccesoRequestBody cambiarClaveAccesoRequestBody = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var cambiarClaveAccesoRequestBody = new CambiarClaveAccesoRequestBody(); // CambiarClaveAccesoRequestBody |  (optional) 

            try
            {
                // CambiarClaveAcceso
                DatoRespuesta result = apiInstance.CambiarClaveAcceso(cambiarClaveAccesoRequestBody);
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
 **cambiarClaveAccesoRequestBody** | [**CambiarClaveAccesoRequestBody**](CambiarClaveAccesoRequestBody.md)|  | [optional] 

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

<a name="cambiarclavetransaccional"></a>
# **CambiarClaveTransaccional**
> DatoRespuesta CambiarClaveTransaccional (CambiarClaveTransaccionalRequestBody cambiarClaveTransaccionalRequestBody = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var cambiarClaveTransaccionalRequestBody = new CambiarClaveTransaccionalRequestBody(); // CambiarClaveTransaccionalRequestBody |  (optional) 

            try
            {
                // CambiarClaveTransaccional
                DatoRespuesta result = apiInstance.CambiarClaveTransaccional(cambiarClaveTransaccionalRequestBody);
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
 **cambiarClaveTransaccionalRequestBody** | [**CambiarClaveTransaccionalRequestBody**](CambiarClaveTransaccionalRequestBody.md)|  | [optional] 

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

<a name="editarusuario"></a>
# **EditarUsuario**
> DatoRespuesta EditarUsuario (string usuario, EditarUsuarioRequestBody editarUsuarioRequestBody = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var usuario = usuario_example;  // string | Usuario
            var editarUsuarioRequestBody = new EditarUsuarioRequestBody(); // EditarUsuarioRequestBody |  (optional) 

            try
            {
                // EditarUsuario
                DatoRespuesta result = apiInstance.EditarUsuario(usuario, editarUsuarioRequestBody);
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
 **editarUsuarioRequestBody** | [**EditarUsuarioRequestBody**](EditarUsuarioRequestBody.md)|  | [optional] 

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

<a name="eliminarusuario"></a>
# **EliminarUsuario**
> DatoRespuesta EliminarUsuario (EliminarUsuarioRequestBody eliminarUsuarioRequestBody = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var eliminarUsuarioRequestBody = new EliminarUsuarioRequestBody(); // EliminarUsuarioRequestBody |  (optional) 

            try
            {
                // EliminarUsuario
                DatoRespuesta result = apiInstance.EliminarUsuario(eliminarUsuarioRequestBody);
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
 **eliminarUsuarioRequestBody** | [**EliminarUsuarioRequestBody**](EliminarUsuarioRequestBody.md)|  | [optional] 

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

<a name="finalizarsesion"></a>
# **FinalizarSesion**
> DatoRespuesta FinalizarSesion (FinalizarSesionRequestBody finalizarSesionRequestBody = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var finalizarSesionRequestBody = new FinalizarSesionRequestBody(); // FinalizarSesionRequestBody |  (optional) 

            try
            {
                // FinalizarSesion
                DatoRespuesta result = apiInstance.FinalizarSesion(finalizarSesionRequestBody);
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
 **finalizarSesionRequestBody** | [**FinalizarSesionRequestBody**](FinalizarSesionRequestBody.md)|  | [optional] 

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

<a name="guardaravatarusuario"></a>
# **GuardarAvatarUsuario**
> DatoRespuesta GuardarAvatarUsuario (string usuario, System.IO.Stream archivo = null, string nombre = null, string extension = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var usuario = usuario_example;  // string | Usuario
            var archivo = BINARY_DATA_HERE;  // System.IO.Stream |  (optional) 
            var nombre = nombre_example;  // string |  (optional) 
            var extension = extension_example;  // string |  (optional) 

            try
            {
                // GuardarAvatarUsuario
                DatoRespuesta result = apiInstance.GuardarAvatarUsuario(usuario, archivo, nombre, extension);
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
 **archivo** | **System.IO.Stream****System.IO.Stream**|  | [optional] 
 **nombre** | **string**|  | [optional] 
 **extension** | **string**|  | [optional] 

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: multipart/form-data
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

<a name="iniciarsesion"></a>
# **IniciarSesion**
> SesionRespuesta IniciarSesion (IniciarSesionRequestBody iniciarSesionRequestBody = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var iniciarSesionRequestBody = new IniciarSesionRequestBody(); // IniciarSesionRequestBody |  (optional) 

            try
            {
                // IniciarSesion
                SesionRespuesta result = apiInstance.IniciarSesion(iniciarSesionRequestBody);
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
 **iniciarSesionRequestBody** | [**IniciarSesionRequestBody**](IniciarSesionRequestBody.md)|  | [optional] 

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="recuperaravatarusuario"></a>
# **RecuperarAvatarUsuario**
> System.IO.Stream RecuperarAvatarUsuario (string usuario)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var usuario = usuario_example;  // string | Usuario

            try
            {
                // RecuperarAvatarUsuario
                System.IO.Stream result = apiInstance.RecuperarAvatarUsuario(usuario);
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

### Return type

**System.IO.Stream**

### Authorization

[AccessToken](../README.md#AccessToken), [RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/octet-stream

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
> SesionRespuesta RefrescarSesion (RefrescarSesionRequestBody refrescarSesionRequestBody = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var refrescarSesionRequestBody = new RefrescarSesionRequestBody(); // RefrescarSesionRequestBody |  (optional) 

            try
            {
                // RefrescarSesion
                SesionRespuesta result = apiInstance.RefrescarSesion(refrescarSesionRequestBody);
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
 **refrescarSesionRequestBody** | [**RefrescarSesionRequestBody**](RefrescarSesionRequestBody.md)|  | [optional] 

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="registrarclavetransaccional"></a>
# **RegistrarClaveTransaccional**
> DatoRespuesta RegistrarClaveTransaccional (RegistrarClaveTransaccionalRequestBody registrarClaveTransaccionalRequestBody = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var registrarClaveTransaccionalRequestBody = new RegistrarClaveTransaccionalRequestBody(); // RegistrarClaveTransaccionalRequestBody |  (optional) 

            try
            {
                // RegistrarClaveTransaccional
                DatoRespuesta result = apiInstance.RegistrarClaveTransaccional(registrarClaveTransaccionalRequestBody);
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
 **registrarClaveTransaccionalRequestBody** | [**RegistrarClaveTransaccionalRequestBody**](RegistrarClaveTransaccionalRequestBody.md)|  | [optional] 

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

<a name="registrardispositivo"></a>
# **RegistrarDispositivo**
> DatoRespuesta RegistrarDispositivo (RegistrarDispositivoRequestBody registrarDispositivoRequestBody = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var registrarDispositivoRequestBody = new RegistrarDispositivoRequestBody(); // RegistrarDispositivoRequestBody |  (optional) 

            try
            {
                // RegistrarDispositivo
                DatoRespuesta result = apiInstance.RegistrarDispositivo(registrarDispositivoRequestBody);
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
 **registrarDispositivoRequestBody** | [**RegistrarDispositivoRequestBody**](RegistrarDispositivoRequestBody.md)|  | [optional] 

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="registrarusuario"></a>
# **RegistrarUsuario**
> DatoRespuesta RegistrarUsuario (RegistrarUsuarioRequestBody registrarUsuarioRequestBody = null)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var registrarUsuarioRequestBody = new RegistrarUsuarioRequestBody(); // RegistrarUsuarioRequestBody |  (optional) 

            try
            {
                // RegistrarUsuario
                DatoRespuesta result = apiInstance.RegistrarUsuario(registrarUsuarioRequestBody);
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
 **registrarUsuarioRequestBody** | [**RegistrarUsuarioRequestBody**](RegistrarUsuarioRequestBody.md)|  | [optional] 

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

[RiskAppKey](../README.md#RiskAppKey)

### HTTP request headers

 - **Content-Type**: application/json
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

<a name="validarsesion"></a>
# **ValidarSesion**
> DatoRespuesta ValidarSesion (string accessToken)

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
            config.BasePath = "https://risk-project-api.azurewebsites.net";
            // Configure Bearer token for authorization: AccessToken
            config.AccessToken = "YOUR_BEARER_TOKEN";
            // Configure API key authorization: RiskAppKey
            config.AddApiKey("Risk-App-Key", "YOUR_API_KEY");
            // Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
            // config.AddApiKeyPrefix("Risk-App-Key", "Bearer");

            var apiInstance = new AutApi(config);
            var accessToken = accessToken_example;  // string | Access Token de la sesión

            try
            {
                // ValidarSesion
                DatoRespuesta result = apiInstance.ValidarSesion(accessToken);
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

