# Risk.API.Client.Api.AutApi

All URIs are relative to *https://localhost:5001*

| Method | HTTP request | Description |
|--------|--------------|-------------|
| [**ActivarUsuario**](AutApi.md#activarusuario) | **GET** /Aut/ActivarUsuario | ActivarUsuario |
| [**CambiarClaveAcceso**](AutApi.md#cambiarclaveacceso) | **POST** /Api/Aut/CambiarClaveAcceso | CambiarClaveAcceso |
| [**CambiarClaveTransaccional**](AutApi.md#cambiarclavetransaccional) | **POST** /Api/Aut/CambiarClaveTransaccional | CambiarClaveTransaccional |
| [**DatosUsuario**](AutApi.md#datosusuario) | **GET** /Api/Aut/DatosUsuario | DatosUsuario |
| [**EditarDatoUsuario**](AutApi.md#editardatousuario) | **POST** /Api/Aut/EditarDatoUsuario | EditarDatoUsuario |
| [**EditarUsuario**](AutApi.md#editarusuario) | **POST** /Api/Aut/EditarUsuario | EditarUsuario |
| [**EliminarUsuario**](AutApi.md#eliminarusuario) | **POST** /Api/Aut/EliminarUsuario | EliminarUsuario |
| [**FinalizarSesion**](AutApi.md#finalizarsesion) | **POST** /Api/Aut/FinalizarSesion | FinalizarSesion |
| [**GenerarOtp**](AutApi.md#generarotp) | **POST** /Api/Aut/GenerarOtp | GenerarOtp |
| [**GuardarAvatarUsuario**](AutApi.md#guardaravatarusuario) | **POST** /Api/Aut/GuardarAvatarUsuario | GuardarAvatarUsuario |
| [**IniciarSesion**](AutApi.md#iniciarsesion) | **POST** /Api/Aut/IniciarSesion | IniciarSesion |
| [**IniciarSesionFacebook**](AutApi.md#iniciarsesionfacebook) | **POST** /Api/Aut/IniciarSesionFacebook | IniciarSesionFacebook |
| [**IniciarSesionGoogle**](AutApi.md#iniciarsesiongoogle) | **POST** /Api/Aut/IniciarSesionGoogle | IniciarSesionGoogle |
| [**RecuperarAvatarUsuario**](AutApi.md#recuperaravatarusuario) | **GET** /Api/Aut/RecuperarAvatarUsuario | RecuperarAvatarUsuario |
| [**RefrescarSesion**](AutApi.md#refrescarsesion) | **POST** /Api/Aut/RefrescarSesion | RefrescarSesion |
| [**RefrescarSesionFacebook**](AutApi.md#refrescarsesionfacebook) | **POST** /Api/Aut/RefrescarSesionFacebook | RefrescarSesionFacebook |
| [**RefrescarSesionGoogle**](AutApi.md#refrescarsesiongoogle) | **POST** /Api/Aut/RefrescarSesionGoogle | RefrescarSesionGoogle |
| [**RegistrarClaveTransaccional**](AutApi.md#registrarclavetransaccional) | **POST** /Api/Aut/RegistrarClaveTransaccional | RegistrarClaveTransaccional |
| [**RegistrarDispositivo**](AutApi.md#registrardispositivo) | **POST** /Api/Aut/RegistrarDispositivo | RegistrarDispositivo |
| [**RegistrarUbicacion**](AutApi.md#registrarubicacion) | **POST** /Api/Aut/RegistrarUbicacion | RegistrarUbicacion |
| [**RegistrarUsuario**](AutApi.md#registrarusuario) | **POST** /Api/Aut/RegistrarUsuario | RegistrarUsuario |
| [**ValidarOtp**](AutApi.md#validarotp) | **GET** /Api/Aut/ValidarOtp | ValidarOtp |
| [**ValidarPermiso**](AutApi.md#validarpermiso) | **GET** /Api/Aut/ValidarPermiso | ValidarPermiso |
| [**ValidarSesion**](AutApi.md#validarsesion) | **GET** /Api/Aut/ValidarSesion | ValidarSesion |

<a id="activarusuario"></a>
# **ActivarUsuario**
> DatoRespuesta ActivarUsuario (string key, string riskDeviceToken = null, string riskServiceVersion = null)

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
            var key = "key_example";  // string | Clave para la activación
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // ActivarUsuario
                DatoRespuesta result = apiInstance.ActivarUsuario(key, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.ActivarUsuario: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the ActivarUsuarioWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // ActivarUsuario
    ApiResponse<DatoRespuesta> response = apiInstance.ActivarUsuarioWithHttpInfo(key, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.ActivarUsuarioWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **key** | **string** | Clave para la activación |  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |

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

<a id="cambiarclaveacceso"></a>
# **CambiarClaveAcceso**
> DatoRespuesta CambiarClaveAcceso (string riskDeviceToken = null, string riskServiceVersion = null, CambiarClaveAccesoRequestBody cambiarClaveAccesoRequestBody = null)

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var cambiarClaveAccesoRequestBody = new CambiarClaveAccesoRequestBody(); // CambiarClaveAccesoRequestBody |  (optional) 

            try
            {
                // CambiarClaveAcceso
                DatoRespuesta result = apiInstance.CambiarClaveAcceso(riskDeviceToken, riskServiceVersion, cambiarClaveAccesoRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.CambiarClaveAcceso: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the CambiarClaveAccesoWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // CambiarClaveAcceso
    ApiResponse<DatoRespuesta> response = apiInstance.CambiarClaveAccesoWithHttpInfo(riskDeviceToken, riskServiceVersion, cambiarClaveAccesoRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.CambiarClaveAccesoWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **cambiarClaveAccesoRequestBody** | [**CambiarClaveAccesoRequestBody**](CambiarClaveAccesoRequestBody.md) |  | [optional]  |

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

<a id="cambiarclavetransaccional"></a>
# **CambiarClaveTransaccional**
> DatoRespuesta CambiarClaveTransaccional (string riskDeviceToken = null, string riskServiceVersion = null, CambiarClaveTransaccionalRequestBody cambiarClaveTransaccionalRequestBody = null)

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var cambiarClaveTransaccionalRequestBody = new CambiarClaveTransaccionalRequestBody(); // CambiarClaveTransaccionalRequestBody |  (optional) 

            try
            {
                // CambiarClaveTransaccional
                DatoRespuesta result = apiInstance.CambiarClaveTransaccional(riskDeviceToken, riskServiceVersion, cambiarClaveTransaccionalRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.CambiarClaveTransaccional: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the CambiarClaveTransaccionalWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // CambiarClaveTransaccional
    ApiResponse<DatoRespuesta> response = apiInstance.CambiarClaveTransaccionalWithHttpInfo(riskDeviceToken, riskServiceVersion, cambiarClaveTransaccionalRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.CambiarClaveTransaccionalWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **cambiarClaveTransaccionalRequestBody** | [**CambiarClaveTransaccionalRequestBody**](CambiarClaveTransaccionalRequestBody.md) |  | [optional]  |

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

<a id="datosusuario"></a>
# **DatosUsuario**
> UsuarioRespuesta DatosUsuario (string usuario, string riskDeviceToken = null, string riskServiceVersion = null)

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
            var usuario = "usuario_example";  // string | Usuario
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // DatosUsuario
                UsuarioRespuesta result = apiInstance.DatosUsuario(usuario, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.DatosUsuario: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the DatosUsuarioWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // DatosUsuario
    ApiResponse<UsuarioRespuesta> response = apiInstance.DatosUsuarioWithHttpInfo(usuario, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.DatosUsuarioWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **usuario** | **string** | Usuario |  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |

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

<a id="editardatousuario"></a>
# **EditarDatoUsuario**
> DatoRespuesta EditarDatoUsuario (string usuario, string riskDeviceToken = null, string riskServiceVersion = null, EditarDatoUsuarioRequestBody editarDatoUsuarioRequestBody = null)

EditarDatoUsuario

Permite editar dato de un usuario

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class EditarDatoUsuarioExample
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
            var usuario = "usuario_example";  // string | Usuario
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var editarDatoUsuarioRequestBody = new EditarDatoUsuarioRequestBody(); // EditarDatoUsuarioRequestBody |  (optional) 

            try
            {
                // EditarDatoUsuario
                DatoRespuesta result = apiInstance.EditarDatoUsuario(usuario, riskDeviceToken, riskServiceVersion, editarDatoUsuarioRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.EditarDatoUsuario: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the EditarDatoUsuarioWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // EditarDatoUsuario
    ApiResponse<DatoRespuesta> response = apiInstance.EditarDatoUsuarioWithHttpInfo(usuario, riskDeviceToken, riskServiceVersion, editarDatoUsuarioRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.EditarDatoUsuarioWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **usuario** | **string** | Usuario |  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **editarDatoUsuarioRequestBody** | [**EditarDatoUsuarioRequestBody**](EditarDatoUsuarioRequestBody.md) |  | [optional]  |

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

<a id="editarusuario"></a>
# **EditarUsuario**
> DatoRespuesta EditarUsuario (string usuario, string riskDeviceToken = null, string riskServiceVersion = null, EditarUsuarioRequestBody editarUsuarioRequestBody = null)

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
            var usuario = "usuario_example";  // string | Usuario
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var editarUsuarioRequestBody = new EditarUsuarioRequestBody(); // EditarUsuarioRequestBody |  (optional) 

            try
            {
                // EditarUsuario
                DatoRespuesta result = apiInstance.EditarUsuario(usuario, riskDeviceToken, riskServiceVersion, editarUsuarioRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.EditarUsuario: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the EditarUsuarioWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // EditarUsuario
    ApiResponse<DatoRespuesta> response = apiInstance.EditarUsuarioWithHttpInfo(usuario, riskDeviceToken, riskServiceVersion, editarUsuarioRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.EditarUsuarioWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **usuario** | **string** | Usuario |  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **editarUsuarioRequestBody** | [**EditarUsuarioRequestBody**](EditarUsuarioRequestBody.md) |  | [optional]  |

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

<a id="eliminarusuario"></a>
# **EliminarUsuario**
> DatoRespuesta EliminarUsuario (string riskDeviceToken = null, string riskServiceVersion = null, EliminarUsuarioRequestBody eliminarUsuarioRequestBody = null)

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var eliminarUsuarioRequestBody = new EliminarUsuarioRequestBody(); // EliminarUsuarioRequestBody |  (optional) 

            try
            {
                // EliminarUsuario
                DatoRespuesta result = apiInstance.EliminarUsuario(riskDeviceToken, riskServiceVersion, eliminarUsuarioRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.EliminarUsuario: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the EliminarUsuarioWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // EliminarUsuario
    ApiResponse<DatoRespuesta> response = apiInstance.EliminarUsuarioWithHttpInfo(riskDeviceToken, riskServiceVersion, eliminarUsuarioRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.EliminarUsuarioWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **eliminarUsuarioRequestBody** | [**EliminarUsuarioRequestBody**](EliminarUsuarioRequestBody.md) |  | [optional]  |

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

<a id="finalizarsesion"></a>
# **FinalizarSesion**
> DatoRespuesta FinalizarSesion (string riskDeviceToken = null, string riskServiceVersion = null, FinalizarSesionRequestBody finalizarSesionRequestBody = null)

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var finalizarSesionRequestBody = new FinalizarSesionRequestBody(); // FinalizarSesionRequestBody |  (optional) 

            try
            {
                // FinalizarSesion
                DatoRespuesta result = apiInstance.FinalizarSesion(riskDeviceToken, riskServiceVersion, finalizarSesionRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.FinalizarSesion: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the FinalizarSesionWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // FinalizarSesion
    ApiResponse<DatoRespuesta> response = apiInstance.FinalizarSesionWithHttpInfo(riskDeviceToken, riskServiceVersion, finalizarSesionRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.FinalizarSesionWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **finalizarSesionRequestBody** | [**FinalizarSesionRequestBody**](FinalizarSesionRequestBody.md) |  | [optional]  |

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

<a id="generarotp"></a>
# **GenerarOtp**
> DatoRespuesta GenerarOtp (TipoMensajeria tipoMensajeria, string destino, string riskDeviceToken = null, string riskServiceVersion = null)

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
            var tipoMensajeria = (TipoMensajeria) "Mail";  // TipoMensajeria | Tipo de mensajería (Mail/SMS/Push)
            var destino = "destino_example";  // string | Destino de la mensajería
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // GenerarOtp
                DatoRespuesta result = apiInstance.GenerarOtp(tipoMensajeria, destino, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.GenerarOtp: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the GenerarOtpWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // GenerarOtp
    ApiResponse<DatoRespuesta> response = apiInstance.GenerarOtpWithHttpInfo(tipoMensajeria, destino, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.GenerarOtpWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **tipoMensajeria** | **TipoMensajeria** | Tipo de mensajería (Mail/SMS/Push) |  |
| **destino** | **string** | Destino de la mensajería |  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |

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

<a id="guardaravatarusuario"></a>
# **GuardarAvatarUsuario**
> DatoRespuesta GuardarAvatarUsuario (string usuario, string riskDeviceToken = null, string riskServiceVersion = null, System.IO.Stream archivo = null, string url = null, string nombre = null, string extension = null)

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
            var usuario = "usuario_example";  // string | Usuario
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var archivo = new System.IO.MemoryStream(System.IO.File.ReadAllBytes("/path/to/file.txt"));  // System.IO.Stream | Contenido del archivo (optional) 
            var url = "url_example";  // string | URL del archivo (optional) 
            var nombre = "nombre_example";  // string | Nombre del archivo (optional) 
            var extension = "extension_example";  // string | Extensión del archivo (optional) 

            try
            {
                // GuardarAvatarUsuario
                DatoRespuesta result = apiInstance.GuardarAvatarUsuario(usuario, riskDeviceToken, riskServiceVersion, archivo, url, nombre, extension);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.GuardarAvatarUsuario: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the GuardarAvatarUsuarioWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // GuardarAvatarUsuario
    ApiResponse<DatoRespuesta> response = apiInstance.GuardarAvatarUsuarioWithHttpInfo(usuario, riskDeviceToken, riskServiceVersion, archivo, url, nombre, extension);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.GuardarAvatarUsuarioWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **usuario** | **string** | Usuario |  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **archivo** | **System.IO.Stream****System.IO.Stream** | Contenido del archivo | [optional]  |
| **url** | **string** | URL del archivo | [optional]  |
| **nombre** | **string** | Nombre del archivo | [optional]  |
| **extension** | **string** | Extensión del archivo | [optional]  |

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

<a id="iniciarsesion"></a>
# **IniciarSesion**
> SesionRespuesta IniciarSesion (string riskDeviceToken = null, string riskServiceVersion = null, IniciarSesionRequestBody iniciarSesionRequestBody = null)

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var iniciarSesionRequestBody = new IniciarSesionRequestBody(); // IniciarSesionRequestBody |  (optional) 

            try
            {
                // IniciarSesion
                SesionRespuesta result = apiInstance.IniciarSesion(riskDeviceToken, riskServiceVersion, iniciarSesionRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.IniciarSesion: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the IniciarSesionWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // IniciarSesion
    ApiResponse<SesionRespuesta> response = apiInstance.IniciarSesionWithHttpInfo(riskDeviceToken, riskServiceVersion, iniciarSesionRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.IniciarSesionWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **iniciarSesionRequestBody** | [**IniciarSesionRequestBody**](IniciarSesionRequestBody.md) |  | [optional]  |

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

<a id="iniciarsesionfacebook"></a>
# **IniciarSesionFacebook**
> SesionRespuesta IniciarSesionFacebook (string riskDeviceToken = null, string riskServiceVersion = null, IniciarSesionFacebookRequestBody iniciarSesionFacebookRequestBody = null)

IniciarSesionFacebook

Permite iniciar la sesión de un usuario con su cuenta de Facebook

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var iniciarSesionFacebookRequestBody = new IniciarSesionFacebookRequestBody(); // IniciarSesionFacebookRequestBody |  (optional) 

            try
            {
                // IniciarSesionFacebook
                SesionRespuesta result = apiInstance.IniciarSesionFacebook(riskDeviceToken, riskServiceVersion, iniciarSesionFacebookRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.IniciarSesionFacebook: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the IniciarSesionFacebookWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // IniciarSesionFacebook
    ApiResponse<SesionRespuesta> response = apiInstance.IniciarSesionFacebookWithHttpInfo(riskDeviceToken, riskServiceVersion, iniciarSesionFacebookRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.IniciarSesionFacebookWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **iniciarSesionFacebookRequestBody** | [**IniciarSesionFacebookRequestBody**](IniciarSesionFacebookRequestBody.md) |  | [optional]  |

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

<a id="iniciarsesiongoogle"></a>
# **IniciarSesionGoogle**
> SesionRespuesta IniciarSesionGoogle (string riskDeviceToken = null, string riskServiceVersion = null, IniciarSesionGoogleRequestBody iniciarSesionGoogleRequestBody = null)

IniciarSesionGoogle

Permite iniciar la sesión de un usuario con su cuenta de Google

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var iniciarSesionGoogleRequestBody = new IniciarSesionGoogleRequestBody(); // IniciarSesionGoogleRequestBody |  (optional) 

            try
            {
                // IniciarSesionGoogle
                SesionRespuesta result = apiInstance.IniciarSesionGoogle(riskDeviceToken, riskServiceVersion, iniciarSesionGoogleRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.IniciarSesionGoogle: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the IniciarSesionGoogleWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // IniciarSesionGoogle
    ApiResponse<SesionRespuesta> response = apiInstance.IniciarSesionGoogleWithHttpInfo(riskDeviceToken, riskServiceVersion, iniciarSesionGoogleRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.IniciarSesionGoogleWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **iniciarSesionGoogleRequestBody** | [**IniciarSesionGoogleRequestBody**](IniciarSesionGoogleRequestBody.md) |  | [optional]  |

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

<a id="recuperaravatarusuario"></a>
# **RecuperarAvatarUsuario**
> System.IO.Stream RecuperarAvatarUsuario (string usuario, int? version = null, string riskDeviceToken = null, string riskServiceVersion = null)

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
            var usuario = "usuario_example";  // string | Usuario
            var version = 56;  // int? | Versión (optional) 
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // RecuperarAvatarUsuario
                System.IO.Stream result = apiInstance.RecuperarAvatarUsuario(usuario, version, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RecuperarAvatarUsuario: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the RecuperarAvatarUsuarioWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // RecuperarAvatarUsuario
    ApiResponse<System.IO.Stream> response = apiInstance.RecuperarAvatarUsuarioWithHttpInfo(usuario, version, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.RecuperarAvatarUsuarioWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **usuario** | **string** | Usuario |  |
| **version** | **int?** | Versión | [optional]  |
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

<a id="refrescarsesion"></a>
# **RefrescarSesion**
> SesionRespuesta RefrescarSesion (string riskDeviceToken = null, string riskServiceVersion = null, RefrescarSesionRequestBody refrescarSesionRequestBody = null)

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var refrescarSesionRequestBody = new RefrescarSesionRequestBody(); // RefrescarSesionRequestBody |  (optional) 

            try
            {
                // RefrescarSesion
                SesionRespuesta result = apiInstance.RefrescarSesion(riskDeviceToken, riskServiceVersion, refrescarSesionRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RefrescarSesion: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the RefrescarSesionWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // RefrescarSesion
    ApiResponse<SesionRespuesta> response = apiInstance.RefrescarSesionWithHttpInfo(riskDeviceToken, riskServiceVersion, refrescarSesionRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.RefrescarSesionWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **refrescarSesionRequestBody** | [**RefrescarSesionRequestBody**](RefrescarSesionRequestBody.md) |  | [optional]  |

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

<a id="refrescarsesionfacebook"></a>
# **RefrescarSesionFacebook**
> SesionRespuesta RefrescarSesionFacebook (string riskDeviceToken = null, string riskServiceVersion = null, RefrescarSesionFacebookRequestBody refrescarSesionFacebookRequestBody = null)

RefrescarSesionFacebook

Permite refrescar la sesión de un usuario con su cuenta de Facebook

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var refrescarSesionFacebookRequestBody = new RefrescarSesionFacebookRequestBody(); // RefrescarSesionFacebookRequestBody |  (optional) 

            try
            {
                // RefrescarSesionFacebook
                SesionRespuesta result = apiInstance.RefrescarSesionFacebook(riskDeviceToken, riskServiceVersion, refrescarSesionFacebookRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RefrescarSesionFacebook: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the RefrescarSesionFacebookWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // RefrescarSesionFacebook
    ApiResponse<SesionRespuesta> response = apiInstance.RefrescarSesionFacebookWithHttpInfo(riskDeviceToken, riskServiceVersion, refrescarSesionFacebookRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.RefrescarSesionFacebookWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **refrescarSesionFacebookRequestBody** | [**RefrescarSesionFacebookRequestBody**](RefrescarSesionFacebookRequestBody.md) |  | [optional]  |

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

<a id="refrescarsesiongoogle"></a>
# **RefrescarSesionGoogle**
> SesionRespuesta RefrescarSesionGoogle (string riskDeviceToken = null, string riskServiceVersion = null, RefrescarSesionGoogleRequestBody refrescarSesionGoogleRequestBody = null)

RefrescarSesionGoogle

Permite refrescar la sesión de un usuario con su cuenta de Google

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var refrescarSesionGoogleRequestBody = new RefrescarSesionGoogleRequestBody(); // RefrescarSesionGoogleRequestBody |  (optional) 

            try
            {
                // RefrescarSesionGoogle
                SesionRespuesta result = apiInstance.RefrescarSesionGoogle(riskDeviceToken, riskServiceVersion, refrescarSesionGoogleRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RefrescarSesionGoogle: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the RefrescarSesionGoogleWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // RefrescarSesionGoogle
    ApiResponse<SesionRespuesta> response = apiInstance.RefrescarSesionGoogleWithHttpInfo(riskDeviceToken, riskServiceVersion, refrescarSesionGoogleRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.RefrescarSesionGoogleWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **refrescarSesionGoogleRequestBody** | [**RefrescarSesionGoogleRequestBody**](RefrescarSesionGoogleRequestBody.md) |  | [optional]  |

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

<a id="registrarclavetransaccional"></a>
# **RegistrarClaveTransaccional**
> DatoRespuesta RegistrarClaveTransaccional (string riskDeviceToken = null, string riskServiceVersion = null, RegistrarClaveTransaccionalRequestBody registrarClaveTransaccionalRequestBody = null)

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var registrarClaveTransaccionalRequestBody = new RegistrarClaveTransaccionalRequestBody(); // RegistrarClaveTransaccionalRequestBody |  (optional) 

            try
            {
                // RegistrarClaveTransaccional
                DatoRespuesta result = apiInstance.RegistrarClaveTransaccional(riskDeviceToken, riskServiceVersion, registrarClaveTransaccionalRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RegistrarClaveTransaccional: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the RegistrarClaveTransaccionalWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // RegistrarClaveTransaccional
    ApiResponse<DatoRespuesta> response = apiInstance.RegistrarClaveTransaccionalWithHttpInfo(riskDeviceToken, riskServiceVersion, registrarClaveTransaccionalRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.RegistrarClaveTransaccionalWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **registrarClaveTransaccionalRequestBody** | [**RegistrarClaveTransaccionalRequestBody**](RegistrarClaveTransaccionalRequestBody.md) |  | [optional]  |

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

<a id="registrardispositivo"></a>
# **RegistrarDispositivo**
> DatoRespuesta RegistrarDispositivo (string riskDeviceToken = null, string riskServiceVersion = null, RegistrarDispositivoRequestBody registrarDispositivoRequestBody = null)

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var registrarDispositivoRequestBody = new RegistrarDispositivoRequestBody(); // RegistrarDispositivoRequestBody |  (optional) 

            try
            {
                // RegistrarDispositivo
                DatoRespuesta result = apiInstance.RegistrarDispositivo(riskDeviceToken, riskServiceVersion, registrarDispositivoRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RegistrarDispositivo: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the RegistrarDispositivoWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // RegistrarDispositivo
    ApiResponse<DatoRespuesta> response = apiInstance.RegistrarDispositivoWithHttpInfo(riskDeviceToken, riskServiceVersion, registrarDispositivoRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.RegistrarDispositivoWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **registrarDispositivoRequestBody** | [**RegistrarDispositivoRequestBody**](RegistrarDispositivoRequestBody.md) |  | [optional]  |

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

<a id="registrarubicacion"></a>
# **RegistrarUbicacion**
> DatoRespuesta RegistrarUbicacion (string riskDeviceToken = null, string riskServiceVersion = null, RegistrarUbicacionRequestBody registrarUbicacionRequestBody = null)

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var registrarUbicacionRequestBody = new RegistrarUbicacionRequestBody(); // RegistrarUbicacionRequestBody |  (optional) 

            try
            {
                // RegistrarUbicacion
                DatoRespuesta result = apiInstance.RegistrarUbicacion(riskDeviceToken, riskServiceVersion, registrarUbicacionRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RegistrarUbicacion: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the RegistrarUbicacionWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // RegistrarUbicacion
    ApiResponse<DatoRespuesta> response = apiInstance.RegistrarUbicacionWithHttpInfo(riskDeviceToken, riskServiceVersion, registrarUbicacionRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.RegistrarUbicacionWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **registrarUbicacionRequestBody** | [**RegistrarUbicacionRequestBody**](RegistrarUbicacionRequestBody.md) |  | [optional]  |

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

<a id="registrarusuario"></a>
# **RegistrarUsuario**
> DatoRespuesta RegistrarUsuario (string riskDeviceToken = null, string riskServiceVersion = null, RegistrarUsuarioRequestBody registrarUsuarioRequestBody = null)

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
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 
            var registrarUsuarioRequestBody = new RegistrarUsuarioRequestBody(); // RegistrarUsuarioRequestBody |  (optional) 

            try
            {
                // RegistrarUsuario
                DatoRespuesta result = apiInstance.RegistrarUsuario(riskDeviceToken, riskServiceVersion, registrarUsuarioRequestBody);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.RegistrarUsuario: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the RegistrarUsuarioWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // RegistrarUsuario
    ApiResponse<DatoRespuesta> response = apiInstance.RegistrarUsuarioWithHttpInfo(riskDeviceToken, riskServiceVersion, registrarUsuarioRequestBody);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.RegistrarUsuarioWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |
| **registrarUsuarioRequestBody** | [**RegistrarUsuarioRequestBody**](RegistrarUsuarioRequestBody.md) |  | [optional]  |

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

<a id="validarotp"></a>
# **ValidarOtp**
> DatoRespuesta ValidarOtp (string secret, int otp, string riskDeviceToken = null, string riskServiceVersion = null)

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
            var secret = "secret_example";  // string | Secret recibido al generar el código OTP
            var otp = 56;  // int | Código OTP a validar
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // ValidarOtp
                DatoRespuesta result = apiInstance.ValidarOtp(secret, otp, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.ValidarOtp: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the ValidarOtpWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // ValidarOtp
    ApiResponse<DatoRespuesta> response = apiInstance.ValidarOtpWithHttpInfo(secret, otp, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.ValidarOtpWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **secret** | **string** | Secret recibido al generar el código OTP |  |
| **otp** | **int** | Código OTP a validar |  |
| **riskDeviceToken** | **string** | Token del dispositivo desde el cual se realiza la petición | [optional]  |
| **riskServiceVersion** | **string** | Versión del servicio | [optional]  |

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

<a id="validarpermiso"></a>
# **ValidarPermiso**
> DatoRespuesta ValidarPermiso (string idPermiso, AccionPermiso? accion = null, string riskDeviceToken = null, string riskServiceVersion = null)

ValidarPermiso

Permite validar un permiso o una acción sobre un permiso

### Example
```csharp
using System.Collections.Generic;
using System.Diagnostics;
using Risk.API.Client.Api;
using Risk.API.Client.Client;
using Risk.API.Client.Model;

namespace Example
{
    public class ValidarPermisoExample
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
            var idPermiso = "idPermiso_example";  // string | Identificador del permiso
            var accion = (AccionPermiso) "Consultar";  // AccionPermiso? | Acción sobre el permiso (optional) 
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // ValidarPermiso
                DatoRespuesta result = apiInstance.ValidarPermiso(idPermiso, accion, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.ValidarPermiso: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the ValidarPermisoWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // ValidarPermiso
    ApiResponse<DatoRespuesta> response = apiInstance.ValidarPermisoWithHttpInfo(idPermiso, accion, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.ValidarPermisoWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **idPermiso** | **string** | Identificador del permiso |  |
| **accion** | **AccionPermiso?** | Acción sobre el permiso | [optional]  |
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

<a id="validarsesion"></a>
# **ValidarSesion**
> DatoRespuesta ValidarSesion (string accessToken, string riskDeviceToken = null, string riskServiceVersion = null)

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
            var accessToken = "accessToken_example";  // string | Access Token de la sesión
            var riskDeviceToken = "riskDeviceToken_example";  // string | Token del dispositivo desde el cual se realiza la petición (optional) 
            var riskServiceVersion = "riskServiceVersion_example";  // string | Versión del servicio (optional) 

            try
            {
                // ValidarSesion
                DatoRespuesta result = apiInstance.ValidarSesion(accessToken, riskDeviceToken, riskServiceVersion);
                Debug.WriteLine(result);
            }
            catch (ApiException  e)
            {
                Debug.Print("Exception when calling AutApi.ValidarSesion: " + e.Message);
                Debug.Print("Status Code: " + e.ErrorCode);
                Debug.Print(e.StackTrace);
            }
        }
    }
}
```

#### Using the ValidarSesionWithHttpInfo variant
This returns an ApiResponse object which contains the response data, status code and headers.

```csharp
try
{
    // ValidarSesion
    ApiResponse<DatoRespuesta> response = apiInstance.ValidarSesionWithHttpInfo(accessToken, riskDeviceToken, riskServiceVersion);
    Debug.Write("Status Code: " + response.StatusCode);
    Debug.Write("Response Headers: " + response.Headers);
    Debug.Write("Response Body: " + response.Data);
}
catch (ApiException e)
{
    Debug.Print("Exception when calling AutApi.ValidarSesionWithHttpInfo: " + e.Message);
    Debug.Print("Status Code: " + e.ErrorCode);
    Debug.Print(e.StackTrace);
}
```

### Parameters

| Name | Type | Description | Notes |
|------|------|-------------|-------|
| **accessToken** | **string** | Access Token de la sesión |  |
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

