# AutApi

All URIs are relative to *https://localhost:5001*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**activarUsuario**](AutApi.md#activarUsuario) | **GET** /Aut/ActivarUsuario | ActivarUsuario |
| [**cambiarClaveAcceso**](AutApi.md#cambiarClaveAcceso) | **POST** /Api/Aut/CambiarClaveAcceso | CambiarClaveAcceso |
| [**cambiarClaveTransaccional**](AutApi.md#cambiarClaveTransaccional) | **POST** /Api/Aut/CambiarClaveTransaccional | CambiarClaveTransaccional |
| [**datosUsuario**](AutApi.md#datosUsuario) | **GET** /Api/Aut/DatosUsuario | DatosUsuario |
| [**editarDatoUsuario**](AutApi.md#editarDatoUsuario) | **POST** /Api/Aut/EditarDatoUsuario | EditarDatoUsuario |
| [**editarUsuario**](AutApi.md#editarUsuario) | **POST** /Api/Aut/EditarUsuario | EditarUsuario |
| [**eliminarUsuario**](AutApi.md#eliminarUsuario) | **POST** /Api/Aut/EliminarUsuario | EliminarUsuario |
| [**finalizarSesion**](AutApi.md#finalizarSesion) | **POST** /Api/Aut/FinalizarSesion | FinalizarSesion |
| [**generarOtp**](AutApi.md#generarOtp) | **POST** /Api/Aut/GenerarOtp | GenerarOtp |
| [**guardarAvatarUsuario**](AutApi.md#guardarAvatarUsuario) | **POST** /Api/Aut/GuardarAvatarUsuario | GuardarAvatarUsuario |
| [**iniciarSesion**](AutApi.md#iniciarSesion) | **POST** /Api/Aut/IniciarSesion | IniciarSesion |
| [**iniciarSesionFacebook**](AutApi.md#iniciarSesionFacebook) | **POST** /Api/Aut/IniciarSesionFacebook | IniciarSesionFacebook |
| [**iniciarSesionGoogle**](AutApi.md#iniciarSesionGoogle) | **POST** /Api/Aut/IniciarSesionGoogle | IniciarSesionGoogle |
| [**recuperarAvatarUsuario**](AutApi.md#recuperarAvatarUsuario) | **GET** /Api/Aut/RecuperarAvatarUsuario | RecuperarAvatarUsuario |
| [**refrescarSesion**](AutApi.md#refrescarSesion) | **POST** /Api/Aut/RefrescarSesion | RefrescarSesion |
| [**refrescarSesionFacebook**](AutApi.md#refrescarSesionFacebook) | **POST** /Api/Aut/RefrescarSesionFacebook | RefrescarSesionFacebook |
| [**refrescarSesionGoogle**](AutApi.md#refrescarSesionGoogle) | **POST** /Api/Aut/RefrescarSesionGoogle | RefrescarSesionGoogle |
| [**registrarClaveTransaccional**](AutApi.md#registrarClaveTransaccional) | **POST** /Api/Aut/RegistrarClaveTransaccional | RegistrarClaveTransaccional |
| [**registrarDispositivo**](AutApi.md#registrarDispositivo) | **POST** /Api/Aut/RegistrarDispositivo | RegistrarDispositivo |
| [**registrarUbicacion**](AutApi.md#registrarUbicacion) | **POST** /Api/Aut/RegistrarUbicacion | RegistrarUbicacion |
| [**registrarUsuario**](AutApi.md#registrarUsuario) | **POST** /Api/Aut/RegistrarUsuario | RegistrarUsuario |
| [**validarOtp**](AutApi.md#validarOtp) | **GET** /Api/Aut/ValidarOtp | ValidarOtp |
| [**validarPermiso**](AutApi.md#validarPermiso) | **GET** /Api/Aut/ValidarPermiso | ValidarPermiso |
| [**validarSesion**](AutApi.md#validarSesion) | **GET** /Api/Aut/ValidarSesion | ValidarSesion |



## activarUsuario

> DatoRespuesta activarUsuario(key, riskDeviceToken, riskServiceVersion)

ActivarUsuario

Permite activar un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");

        AutApi apiInstance = new AutApi(defaultClient);
        String key = "key_example"; // String | Clave para la activación
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            DatoRespuesta result = apiInstance.activarUsuario(key, riskDeviceToken, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#activarUsuario");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **key** | **String**| Clave para la activación | |
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |

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


## cambiarClaveAcceso

> DatoRespuesta cambiarClaveAcceso(riskDeviceToken, riskServiceVersion, cambiarClaveAccesoRequestBody)

CambiarClaveAcceso

Permite cambiar la clave de acceso de un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        CambiarClaveAccesoRequestBody cambiarClaveAccesoRequestBody = new CambiarClaveAccesoRequestBody(); // CambiarClaveAccesoRequestBody | 
        try {
            DatoRespuesta result = apiInstance.cambiarClaveAcceso(riskDeviceToken, riskServiceVersion, cambiarClaveAccesoRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#cambiarClaveAcceso");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **cambiarClaveAccesoRequestBody** | [**CambiarClaveAccesoRequestBody**](CambiarClaveAccesoRequestBody.md)|  | [optional] |

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


## cambiarClaveTransaccional

> DatoRespuesta cambiarClaveTransaccional(riskDeviceToken, riskServiceVersion, cambiarClaveTransaccionalRequestBody)

CambiarClaveTransaccional

Permite cambiar la clave transaccional de un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        CambiarClaveTransaccionalRequestBody cambiarClaveTransaccionalRequestBody = new CambiarClaveTransaccionalRequestBody(); // CambiarClaveTransaccionalRequestBody | 
        try {
            DatoRespuesta result = apiInstance.cambiarClaveTransaccional(riskDeviceToken, riskServiceVersion, cambiarClaveTransaccionalRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#cambiarClaveTransaccional");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **cambiarClaveTransaccionalRequestBody** | [**CambiarClaveTransaccionalRequestBody**](CambiarClaveTransaccionalRequestBody.md)|  | [optional] |

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


## datosUsuario

> UsuarioRespuesta datosUsuario(usuario, riskDeviceToken, riskServiceVersion)

DatosUsuario

Permite obtener los datos de un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String usuario = "usuario_example"; // String | Usuario
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            UsuarioRespuesta result = apiInstance.datosUsuario(usuario, riskDeviceToken, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#datosUsuario");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **usuario** | **String**| Usuario | |
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |

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


## editarDatoUsuario

> DatoRespuesta editarDatoUsuario(usuario, riskDeviceToken, riskServiceVersion, editarDatoUsuarioRequestBody)

EditarDatoUsuario

Permite editar dato de un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String usuario = "usuario_example"; // String | Usuario
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        EditarDatoUsuarioRequestBody editarDatoUsuarioRequestBody = new EditarDatoUsuarioRequestBody(); // EditarDatoUsuarioRequestBody | 
        try {
            DatoRespuesta result = apiInstance.editarDatoUsuario(usuario, riskDeviceToken, riskServiceVersion, editarDatoUsuarioRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#editarDatoUsuario");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **usuario** | **String**| Usuario | |
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **editarDatoUsuarioRequestBody** | [**EditarDatoUsuarioRequestBody**](EditarDatoUsuarioRequestBody.md)|  | [optional] |

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


## editarUsuario

> DatoRespuesta editarUsuario(usuario, riskDeviceToken, riskServiceVersion, editarUsuarioRequestBody)

EditarUsuario

Permite editar un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String usuario = "usuario_example"; // String | Usuario
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        EditarUsuarioRequestBody editarUsuarioRequestBody = new EditarUsuarioRequestBody(); // EditarUsuarioRequestBody | 
        try {
            DatoRespuesta result = apiInstance.editarUsuario(usuario, riskDeviceToken, riskServiceVersion, editarUsuarioRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#editarUsuario");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **usuario** | **String**| Usuario | |
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **editarUsuarioRequestBody** | [**EditarUsuarioRequestBody**](EditarUsuarioRequestBody.md)|  | [optional] |

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


## eliminarUsuario

> DatoRespuesta eliminarUsuario(riskDeviceToken, riskServiceVersion, eliminarUsuarioRequestBody)

EliminarUsuario

Permite eliminar un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        EliminarUsuarioRequestBody eliminarUsuarioRequestBody = new EliminarUsuarioRequestBody(); // EliminarUsuarioRequestBody | 
        try {
            DatoRespuesta result = apiInstance.eliminarUsuario(riskDeviceToken, riskServiceVersion, eliminarUsuarioRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#eliminarUsuario");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **eliminarUsuarioRequestBody** | [**EliminarUsuarioRequestBody**](EliminarUsuarioRequestBody.md)|  | [optional] |

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


## finalizarSesion

> DatoRespuesta finalizarSesion(riskDeviceToken, riskServiceVersion, finalizarSesionRequestBody)

FinalizarSesion

Permite finalizar la sesión de un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        FinalizarSesionRequestBody finalizarSesionRequestBody = new FinalizarSesionRequestBody(); // FinalizarSesionRequestBody | 
        try {
            DatoRespuesta result = apiInstance.finalizarSesion(riskDeviceToken, riskServiceVersion, finalizarSesionRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#finalizarSesion");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **finalizarSesionRequestBody** | [**FinalizarSesionRequestBody**](FinalizarSesionRequestBody.md)|  | [optional] |

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


## generarOtp

> DatoRespuesta generarOtp(tipoMensajeria, destino, riskDeviceToken, riskServiceVersion)

GenerarOtp

Permite generar un código OTP

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        AutApi apiInstance = new AutApi(defaultClient);
        TipoMensajeria tipoMensajeria = TipoMensajeria.fromValue("Mail"); // TipoMensajeria | Tipo de mensajería (Mail/SMS/Push)
        String destino = "destino_example"; // String | Destino de la mensajería
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            DatoRespuesta result = apiInstance.generarOtp(tipoMensajeria, destino, riskDeviceToken, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#generarOtp");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **tipoMensajeria** | [**TipoMensajeria**](.md)| Tipo de mensajería (Mail/SMS/Push) | [enum: Mail, SMS, Push] |
| **destino** | **String**| Destino de la mensajería | |
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |

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


## guardarAvatarUsuario

> DatoRespuesta guardarAvatarUsuario(usuario, riskDeviceToken, riskServiceVersion, archivo, url, nombre, extension)

GuardarAvatarUsuario

Permite guardar el avatar de un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String usuario = "usuario_example"; // String | Usuario
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        File archivo = new File("/path/to/file"); // File | Contenido del archivo
        String url = "url_example"; // String | URL del archivo
        String nombre = "nombre_example"; // String | Nombre del archivo
        String extension = "extension_example"; // String | Extensión del archivo
        try {
            DatoRespuesta result = apiInstance.guardarAvatarUsuario(usuario, riskDeviceToken, riskServiceVersion, archivo, url, nombre, extension);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#guardarAvatarUsuario");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **usuario** | **String**| Usuario | |
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **archivo** | **File**| Contenido del archivo | [optional] |
| **url** | **String**| URL del archivo | [optional] |
| **nombre** | **String**| Nombre del archivo | [optional] |
| **extension** | **String**| Extensión del archivo | [optional] |

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


## iniciarSesion

> SesionRespuesta iniciarSesion(riskDeviceToken, riskServiceVersion, iniciarSesionRequestBody)

IniciarSesion

Permite iniciar la sesión de un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        IniciarSesionRequestBody iniciarSesionRequestBody = new IniciarSesionRequestBody(); // IniciarSesionRequestBody | 
        try {
            SesionRespuesta result = apiInstance.iniciarSesion(riskDeviceToken, riskServiceVersion, iniciarSesionRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#iniciarSesion");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **iniciarSesionRequestBody** | [**IniciarSesionRequestBody**](IniciarSesionRequestBody.md)|  | [optional] |

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


## iniciarSesionFacebook

> SesionRespuesta iniciarSesionFacebook(riskDeviceToken, riskServiceVersion, iniciarSesionFacebookRequestBody)

IniciarSesionFacebook

Permite iniciar la sesión de un usuario con su cuenta de Facebook

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        IniciarSesionFacebookRequestBody iniciarSesionFacebookRequestBody = new IniciarSesionFacebookRequestBody(); // IniciarSesionFacebookRequestBody | 
        try {
            SesionRespuesta result = apiInstance.iniciarSesionFacebook(riskDeviceToken, riskServiceVersion, iniciarSesionFacebookRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#iniciarSesionFacebook");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **iniciarSesionFacebookRequestBody** | [**IniciarSesionFacebookRequestBody**](IniciarSesionFacebookRequestBody.md)|  | [optional] |

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


## iniciarSesionGoogle

> SesionRespuesta iniciarSesionGoogle(riskDeviceToken, riskServiceVersion, iniciarSesionGoogleRequestBody)

IniciarSesionGoogle

Permite iniciar la sesión de un usuario con su cuenta de Google

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        IniciarSesionGoogleRequestBody iniciarSesionGoogleRequestBody = new IniciarSesionGoogleRequestBody(); // IniciarSesionGoogleRequestBody | 
        try {
            SesionRespuesta result = apiInstance.iniciarSesionGoogle(riskDeviceToken, riskServiceVersion, iniciarSesionGoogleRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#iniciarSesionGoogle");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **iniciarSesionGoogleRequestBody** | [**IniciarSesionGoogleRequestBody**](IniciarSesionGoogleRequestBody.md)|  | [optional] |

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


## recuperarAvatarUsuario

> File recuperarAvatarUsuario(usuario, version, riskDeviceToken, riskServiceVersion)

RecuperarAvatarUsuario

Permite recuperar el avatar de un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String usuario = "usuario_example"; // String | Usuario
        Integer version = 56; // Integer | Versión
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            File result = apiInstance.recuperarAvatarUsuario(usuario, version, riskDeviceToken, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#recuperarAvatarUsuario");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **usuario** | **String**| Usuario | |
| **version** | **Integer**| Versión | [optional] |
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |

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


## refrescarSesion

> SesionRespuesta refrescarSesion(riskDeviceToken, riskServiceVersion, refrescarSesionRequestBody)

RefrescarSesion

Permite refrescar la sesión de un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        RefrescarSesionRequestBody refrescarSesionRequestBody = new RefrescarSesionRequestBody(); // RefrescarSesionRequestBody | 
        try {
            SesionRespuesta result = apiInstance.refrescarSesion(riskDeviceToken, riskServiceVersion, refrescarSesionRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#refrescarSesion");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **refrescarSesionRequestBody** | [**RefrescarSesionRequestBody**](RefrescarSesionRequestBody.md)|  | [optional] |

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


## refrescarSesionFacebook

> SesionRespuesta refrescarSesionFacebook(riskDeviceToken, riskServiceVersion, refrescarSesionFacebookRequestBody)

RefrescarSesionFacebook

Permite refrescar la sesión de un usuario con su cuenta de Facebook

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        RefrescarSesionFacebookRequestBody refrescarSesionFacebookRequestBody = new RefrescarSesionFacebookRequestBody(); // RefrescarSesionFacebookRequestBody | 
        try {
            SesionRespuesta result = apiInstance.refrescarSesionFacebook(riskDeviceToken, riskServiceVersion, refrescarSesionFacebookRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#refrescarSesionFacebook");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **refrescarSesionFacebookRequestBody** | [**RefrescarSesionFacebookRequestBody**](RefrescarSesionFacebookRequestBody.md)|  | [optional] |

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


## refrescarSesionGoogle

> SesionRespuesta refrescarSesionGoogle(riskDeviceToken, riskServiceVersion, refrescarSesionGoogleRequestBody)

RefrescarSesionGoogle

Permite refrescar la sesión de un usuario con su cuenta de Google

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        RefrescarSesionGoogleRequestBody refrescarSesionGoogleRequestBody = new RefrescarSesionGoogleRequestBody(); // RefrescarSesionGoogleRequestBody | 
        try {
            SesionRespuesta result = apiInstance.refrescarSesionGoogle(riskDeviceToken, riskServiceVersion, refrescarSesionGoogleRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#refrescarSesionGoogle");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **refrescarSesionGoogleRequestBody** | [**RefrescarSesionGoogleRequestBody**](RefrescarSesionGoogleRequestBody.md)|  | [optional] |

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


## registrarClaveTransaccional

> DatoRespuesta registrarClaveTransaccional(riskDeviceToken, riskServiceVersion, registrarClaveTransaccionalRequestBody)

RegistrarClaveTransaccional

Permite registrar una clave transaccional para un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        RegistrarClaveTransaccionalRequestBody registrarClaveTransaccionalRequestBody = new RegistrarClaveTransaccionalRequestBody(); // RegistrarClaveTransaccionalRequestBody | 
        try {
            DatoRespuesta result = apiInstance.registrarClaveTransaccional(riskDeviceToken, riskServiceVersion, registrarClaveTransaccionalRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#registrarClaveTransaccional");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **registrarClaveTransaccionalRequestBody** | [**RegistrarClaveTransaccionalRequestBody**](RegistrarClaveTransaccionalRequestBody.md)|  | [optional] |

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


## registrarDispositivo

> DatoRespuesta registrarDispositivo(riskDeviceToken, riskServiceVersion, registrarDispositivoRequestBody)

RegistrarDispositivo

Permite registrar un dispositivo

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        RegistrarDispositivoRequestBody registrarDispositivoRequestBody = new RegistrarDispositivoRequestBody(); // RegistrarDispositivoRequestBody | 
        try {
            DatoRespuesta result = apiInstance.registrarDispositivo(riskDeviceToken, riskServiceVersion, registrarDispositivoRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#registrarDispositivo");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **registrarDispositivoRequestBody** | [**RegistrarDispositivoRequestBody**](RegistrarDispositivoRequestBody.md)|  | [optional] |

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


## registrarUbicacion

> DatoRespuesta registrarUbicacion(riskDeviceToken, riskServiceVersion, registrarUbicacionRequestBody)

RegistrarUbicacion

Permite registrar la ubicación (coordenadas geográficas) de un dispositivo

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        RegistrarUbicacionRequestBody registrarUbicacionRequestBody = new RegistrarUbicacionRequestBody(); // RegistrarUbicacionRequestBody | 
        try {
            DatoRespuesta result = apiInstance.registrarUbicacion(riskDeviceToken, riskServiceVersion, registrarUbicacionRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#registrarUbicacion");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **registrarUbicacionRequestBody** | [**RegistrarUbicacionRequestBody**](RegistrarUbicacionRequestBody.md)|  | [optional] |

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


## registrarUsuario

> DatoRespuesta registrarUsuario(riskDeviceToken, riskServiceVersion, registrarUsuarioRequestBody)

RegistrarUsuario

Permite registrar un usuario

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        AutApi apiInstance = new AutApi(defaultClient);
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        RegistrarUsuarioRequestBody registrarUsuarioRequestBody = new RegistrarUsuarioRequestBody(); // RegistrarUsuarioRequestBody | 
        try {
            DatoRespuesta result = apiInstance.registrarUsuario(riskDeviceToken, riskServiceVersion, registrarUsuarioRequestBody);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#registrarUsuario");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |
| **registrarUsuarioRequestBody** | [**RegistrarUsuarioRequestBody**](RegistrarUsuarioRequestBody.md)|  | [optional] |

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


## validarOtp

> DatoRespuesta validarOtp(secret, otp, riskDeviceToken, riskServiceVersion)

ValidarOtp

Permite validar un código OTP

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("https://localhost:5001");
        
        // Configure API key authorization: RiskAppKey
        ApiKeyAuth RiskAppKey = (ApiKeyAuth) defaultClient.getAuthentication("RiskAppKey");
        RiskAppKey.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //RiskAppKey.setApiKeyPrefix("Token");

        AutApi apiInstance = new AutApi(defaultClient);
        String secret = "secret_example"; // String | Secret recibido al generar el código OTP
        Integer otp = 56; // Integer | Código OTP a validar
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            DatoRespuesta result = apiInstance.validarOtp(secret, otp, riskDeviceToken, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#validarOtp");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **secret** | **String**| Secret recibido al generar el código OTP | |
| **otp** | **Integer**| Código OTP a validar | |
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |

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


## validarPermiso

> DatoRespuesta validarPermiso(idPermiso, accion, riskDeviceToken, riskServiceVersion)

ValidarPermiso

Permite validar un permiso o una acción sobre un permiso

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String idPermiso = "idPermiso_example"; // String | Identificador del permiso
        AccionPermiso accion = AccionPermiso.fromValue("Consultar"); // AccionPermiso | Acción sobre el permiso
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            DatoRespuesta result = apiInstance.validarPermiso(idPermiso, accion, riskDeviceToken, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#validarPermiso");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **idPermiso** | **String**| Identificador del permiso | |
| **accion** | [**AccionPermiso**](.md)| Acción sobre el permiso | [optional] [enum: Consultar, Insertar, Actualizar, Eliminar] |
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |

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


## validarSesion

> DatoRespuesta validarSesion(accessToken, riskDeviceToken, riskServiceVersion)

ValidarSesion

Permite validar si una sesión está activa o no

### Example

```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.auth.*;
import org.openapitools.client.models.*;
import org.openapitools.client.api.AutApi;

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

        AutApi apiInstance = new AutApi(defaultClient);
        String accessToken = "accessToken_example"; // String | Access Token de la sesión
        String riskDeviceToken = "riskDeviceToken_example"; // String | Token del dispositivo desde el cual se realiza la petición
        String riskServiceVersion = "riskServiceVersion_example"; // String | Versión del servicio
        try {
            DatoRespuesta result = apiInstance.validarSesion(accessToken, riskDeviceToken, riskServiceVersion);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AutApi#validarSesion");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **accessToken** | **String**| Access Token de la sesión | |
| **riskDeviceToken** | **String**| Token del dispositivo desde el cual se realiza la petición | [optional] |
| **riskServiceVersion** | **String**| Versión del servicio | [optional] |

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

