# AutApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activarUsuario**](AutApi.md#activarUsuario) | **GET** /Aut/ActivarUsuario | ActivarUsuario
[**cambiarClaveAcceso**](AutApi.md#cambiarClaveAcceso) | **POST** /Api/Aut/CambiarClaveAcceso | CambiarClaveAcceso
[**cambiarClaveTransaccional**](AutApi.md#cambiarClaveTransaccional) | **POST** /Api/Aut/CambiarClaveTransaccional | CambiarClaveTransaccional
[**datosUsuario**](AutApi.md#datosUsuario) | **GET** /Api/Aut/DatosUsuario | DatosUsuario
[**editarDatoUsuario**](AutApi.md#editarDatoUsuario) | **POST** /Api/Aut/EditarDatoUsuario | EditarDatoUsuario
[**editarUsuario**](AutApi.md#editarUsuario) | **POST** /Api/Aut/EditarUsuario | EditarUsuario
[**eliminarUsuario**](AutApi.md#eliminarUsuario) | **POST** /Api/Aut/EliminarUsuario | EliminarUsuario
[**finalizarSesion**](AutApi.md#finalizarSesion) | **POST** /Api/Aut/FinalizarSesion | FinalizarSesion
[**generarOtp**](AutApi.md#generarOtp) | **POST** /Api/Aut/GenerarOtp | GenerarOtp
[**guardarAvatarUsuario**](AutApi.md#guardarAvatarUsuario) | **POST** /Api/Aut/GuardarAvatarUsuario | GuardarAvatarUsuario
[**iniciarSesion**](AutApi.md#iniciarSesion) | **POST** /Api/Aut/IniciarSesion | IniciarSesion
[**iniciarSesionFacebook**](AutApi.md#iniciarSesionFacebook) | **POST** /Api/Aut/IniciarSesionFacebook | IniciarSesionFacebook
[**iniciarSesionGoogle**](AutApi.md#iniciarSesionGoogle) | **POST** /Api/Aut/IniciarSesionGoogle | IniciarSesionGoogle
[**recuperarAvatarUsuario**](AutApi.md#recuperarAvatarUsuario) | **GET** /Api/Aut/RecuperarAvatarUsuario | RecuperarAvatarUsuario
[**refrescarSesion**](AutApi.md#refrescarSesion) | **POST** /Api/Aut/RefrescarSesion | RefrescarSesion
[**refrescarSesionFacebook**](AutApi.md#refrescarSesionFacebook) | **POST** /Api/Aut/RefrescarSesionFacebook | RefrescarSesionFacebook
[**refrescarSesionGoogle**](AutApi.md#refrescarSesionGoogle) | **POST** /Api/Aut/RefrescarSesionGoogle | RefrescarSesionGoogle
[**registrarClaveTransaccional**](AutApi.md#registrarClaveTransaccional) | **POST** /Api/Aut/RegistrarClaveTransaccional | RegistrarClaveTransaccional
[**registrarDispositivo**](AutApi.md#registrarDispositivo) | **POST** /Api/Aut/RegistrarDispositivo | RegistrarDispositivo
[**registrarUbicacion**](AutApi.md#registrarUbicacion) | **POST** /Api/Aut/RegistrarUbicacion | RegistrarUbicacion
[**registrarUsuario**](AutApi.md#registrarUsuario) | **POST** /Api/Aut/RegistrarUsuario | RegistrarUsuario
[**validarOtp**](AutApi.md#validarOtp) | **GET** /Api/Aut/ValidarOtp | ValidarOtp
[**validarPermiso**](AutApi.md#validarPermiso) | **GET** /Api/Aut/ValidarPermiso | ValidarPermiso
[**validarSesion**](AutApi.md#validarSesion) | **GET** /Api/Aut/ValidarSesion | ValidarSesion


<a name="activarUsuario"></a>
# **activarUsuario**
> DatoRespuesta activarUsuario(key, riskDeviceToken, riskServiceVersion)

ActivarUsuario

Permite activar un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val key : kotlin.String = key_example // kotlin.String | Clave para la activación
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : DatoRespuesta = apiInstance.activarUsuario(key, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#activarUsuario")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#activarUsuario")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **kotlin.String**| Clave para la activación |
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a name="cambiarClaveAcceso"></a>
# **cambiarClaveAcceso**
> DatoRespuesta cambiarClaveAcceso(riskDeviceToken, riskServiceVersion, cambiarClaveAccesoRequestBody)

CambiarClaveAcceso

Permite cambiar la clave de acceso de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val cambiarClaveAccesoRequestBody : CambiarClaveAccesoRequestBody =  // CambiarClaveAccesoRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.cambiarClaveAcceso(riskDeviceToken, riskServiceVersion, cambiarClaveAccesoRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#cambiarClaveAcceso")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#cambiarClaveAcceso")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **cambiarClaveAccesoRequestBody** | [**CambiarClaveAccesoRequestBody**](CambiarClaveAccesoRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="cambiarClaveTransaccional"></a>
# **cambiarClaveTransaccional**
> DatoRespuesta cambiarClaveTransaccional(riskDeviceToken, riskServiceVersion, cambiarClaveTransaccionalRequestBody)

CambiarClaveTransaccional

Permite cambiar la clave transaccional de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val cambiarClaveTransaccionalRequestBody : CambiarClaveTransaccionalRequestBody =  // CambiarClaveTransaccionalRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.cambiarClaveTransaccional(riskDeviceToken, riskServiceVersion, cambiarClaveTransaccionalRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#cambiarClaveTransaccional")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#cambiarClaveTransaccional")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **cambiarClaveTransaccionalRequestBody** | [**CambiarClaveTransaccionalRequestBody**](CambiarClaveTransaccionalRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="datosUsuario"></a>
# **datosUsuario**
> UsuarioRespuesta datosUsuario(usuario, riskDeviceToken, riskServiceVersion)

DatosUsuario

Permite obtener los datos de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : UsuarioRespuesta = apiInstance.datosUsuario(usuario, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#datosUsuario")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#datosUsuario")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **usuario** | **kotlin.String**| Usuario |
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**UsuarioRespuesta**](UsuarioRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a name="editarDatoUsuario"></a>
# **editarDatoUsuario**
> DatoRespuesta editarDatoUsuario(usuario, riskDeviceToken, riskServiceVersion, editarDatoUsuarioRequestBody)

EditarDatoUsuario

Permite editar dato de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val editarDatoUsuarioRequestBody : EditarDatoUsuarioRequestBody =  // EditarDatoUsuarioRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.editarDatoUsuario(usuario, riskDeviceToken, riskServiceVersion, editarDatoUsuarioRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#editarDatoUsuario")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#editarDatoUsuario")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **usuario** | **kotlin.String**| Usuario |
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **editarDatoUsuarioRequestBody** | [**EditarDatoUsuarioRequestBody**](EditarDatoUsuarioRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="editarUsuario"></a>
# **editarUsuario**
> DatoRespuesta editarUsuario(usuario, riskDeviceToken, riskServiceVersion, editarUsuarioRequestBody)

EditarUsuario

Permite editar un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val editarUsuarioRequestBody : EditarUsuarioRequestBody =  // EditarUsuarioRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.editarUsuario(usuario, riskDeviceToken, riskServiceVersion, editarUsuarioRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#editarUsuario")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#editarUsuario")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **usuario** | **kotlin.String**| Usuario |
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **editarUsuarioRequestBody** | [**EditarUsuarioRequestBody**](EditarUsuarioRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="eliminarUsuario"></a>
# **eliminarUsuario**
> DatoRespuesta eliminarUsuario(riskDeviceToken, riskServiceVersion, eliminarUsuarioRequestBody)

EliminarUsuario

Permite eliminar un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val eliminarUsuarioRequestBody : EliminarUsuarioRequestBody =  // EliminarUsuarioRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.eliminarUsuario(riskDeviceToken, riskServiceVersion, eliminarUsuarioRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#eliminarUsuario")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#eliminarUsuario")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **eliminarUsuarioRequestBody** | [**EliminarUsuarioRequestBody**](EliminarUsuarioRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="finalizarSesion"></a>
# **finalizarSesion**
> DatoRespuesta finalizarSesion(riskDeviceToken, riskServiceVersion, finalizarSesionRequestBody)

FinalizarSesion

Permite finalizar la sesión de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val finalizarSesionRequestBody : FinalizarSesionRequestBody =  // FinalizarSesionRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.finalizarSesion(riskDeviceToken, riskServiceVersion, finalizarSesionRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#finalizarSesion")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#finalizarSesion")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **finalizarSesionRequestBody** | [**FinalizarSesionRequestBody**](FinalizarSesionRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="generarOtp"></a>
# **generarOtp**
> DatoRespuesta generarOtp(tipoMensajeria, destino, riskDeviceToken, riskServiceVersion)

GenerarOtp

Permite generar un código OTP

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val tipoMensajeria : TipoMensajeria =  // TipoMensajeria | Tipo de mensajería (Mail/SMS/Push)
val destino : kotlin.String = destino_example // kotlin.String | Destino de la mensajería
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : DatoRespuesta = apiInstance.generarOtp(tipoMensajeria, destino, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#generarOtp")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#generarOtp")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tipoMensajeria** | [**TipoMensajeria**](.md)| Tipo de mensajería (Mail/SMS/Push) | [enum: Mail, SMS, Push]
 **destino** | **kotlin.String**| Destino de la mensajería |
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a name="guardarAvatarUsuario"></a>
# **guardarAvatarUsuario**
> DatoRespuesta guardarAvatarUsuario(usuario, riskDeviceToken, riskServiceVersion, archivo, url, nombre, extension)

GuardarAvatarUsuario

Permite guardar el avatar de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val archivo : java.io.File = BINARY_DATA_HERE // java.io.File | Contenido del archivo
val url : kotlin.String = url_example // kotlin.String | URL del archivo
val nombre : kotlin.String = nombre_example // kotlin.String | Nombre del archivo
val extension : kotlin.String = extension_example // kotlin.String | Extensión del archivo
try {
    val result : DatoRespuesta = apiInstance.guardarAvatarUsuario(usuario, riskDeviceToken, riskServiceVersion, archivo, url, nombre, extension)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#guardarAvatarUsuario")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#guardarAvatarUsuario")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **usuario** | **kotlin.String**| Usuario |
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **archivo** | **java.io.File**| Contenido del archivo | [optional]
 **url** | **kotlin.String**| URL del archivo | [optional]
 **nombre** | **kotlin.String**| Nombre del archivo | [optional]
 **extension** | **kotlin.String**| Extensión del archivo | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

<a name="iniciarSesion"></a>
# **iniciarSesion**
> SesionRespuesta iniciarSesion(riskDeviceToken, riskServiceVersion, iniciarSesionRequestBody)

IniciarSesion

Permite iniciar la sesión de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val iniciarSesionRequestBody : IniciarSesionRequestBody =  // IniciarSesionRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.iniciarSesion(riskDeviceToken, riskServiceVersion, iniciarSesionRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#iniciarSesion")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#iniciarSesion")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **iniciarSesionRequestBody** | [**IniciarSesionRequestBody**](IniciarSesionRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="iniciarSesionFacebook"></a>
# **iniciarSesionFacebook**
> SesionRespuesta iniciarSesionFacebook(riskDeviceToken, riskServiceVersion, iniciarSesionFacebookRequestBody)

IniciarSesionFacebook

Permite iniciar la sesión de un usuario con su cuenta de Facebook

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val iniciarSesionFacebookRequestBody : IniciarSesionFacebookRequestBody =  // IniciarSesionFacebookRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.iniciarSesionFacebook(riskDeviceToken, riskServiceVersion, iniciarSesionFacebookRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#iniciarSesionFacebook")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#iniciarSesionFacebook")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **iniciarSesionFacebookRequestBody** | [**IniciarSesionFacebookRequestBody**](IniciarSesionFacebookRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="iniciarSesionGoogle"></a>
# **iniciarSesionGoogle**
> SesionRespuesta iniciarSesionGoogle(riskDeviceToken, riskServiceVersion, iniciarSesionGoogleRequestBody)

IniciarSesionGoogle

Permite iniciar la sesión de un usuario con su cuenta de Google

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val iniciarSesionGoogleRequestBody : IniciarSesionGoogleRequestBody =  // IniciarSesionGoogleRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.iniciarSesionGoogle(riskDeviceToken, riskServiceVersion, iniciarSesionGoogleRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#iniciarSesionGoogle")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#iniciarSesionGoogle")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **iniciarSesionGoogleRequestBody** | [**IniciarSesionGoogleRequestBody**](IniciarSesionGoogleRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="recuperarAvatarUsuario"></a>
# **recuperarAvatarUsuario**
> java.io.File recuperarAvatarUsuario(usuario, version, riskDeviceToken, riskServiceVersion)

RecuperarAvatarUsuario

Permite recuperar el avatar de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
val version : kotlin.Int = 56 // kotlin.Int | Versión
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : java.io.File = apiInstance.recuperarAvatarUsuario(usuario, version, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#recuperarAvatarUsuario")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#recuperarAvatarUsuario")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **usuario** | **kotlin.String**| Usuario |
 **version** | **kotlin.Int**| Versión | [optional]
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**java.io.File**](java.io.File.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a name="refrescarSesion"></a>
# **refrescarSesion**
> SesionRespuesta refrescarSesion(riskDeviceToken, riskServiceVersion, refrescarSesionRequestBody)

RefrescarSesion

Permite refrescar la sesión de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val refrescarSesionRequestBody : RefrescarSesionRequestBody =  // RefrescarSesionRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.refrescarSesion(riskDeviceToken, riskServiceVersion, refrescarSesionRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#refrescarSesion")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#refrescarSesion")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **refrescarSesionRequestBody** | [**RefrescarSesionRequestBody**](RefrescarSesionRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="refrescarSesionFacebook"></a>
# **refrescarSesionFacebook**
> SesionRespuesta refrescarSesionFacebook(riskDeviceToken, riskServiceVersion, refrescarSesionFacebookRequestBody)

RefrescarSesionFacebook

Permite refrescar la sesión de un usuario con su cuenta de Facebook

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val refrescarSesionFacebookRequestBody : RefrescarSesionFacebookRequestBody =  // RefrescarSesionFacebookRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.refrescarSesionFacebook(riskDeviceToken, riskServiceVersion, refrescarSesionFacebookRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#refrescarSesionFacebook")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#refrescarSesionFacebook")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **refrescarSesionFacebookRequestBody** | [**RefrescarSesionFacebookRequestBody**](RefrescarSesionFacebookRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="refrescarSesionGoogle"></a>
# **refrescarSesionGoogle**
> SesionRespuesta refrescarSesionGoogle(riskDeviceToken, riskServiceVersion, refrescarSesionGoogleRequestBody)

RefrescarSesionGoogle

Permite refrescar la sesión de un usuario con su cuenta de Google

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val refrescarSesionGoogleRequestBody : RefrescarSesionGoogleRequestBody =  // RefrescarSesionGoogleRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.refrescarSesionGoogle(riskDeviceToken, riskServiceVersion, refrescarSesionGoogleRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#refrescarSesionGoogle")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#refrescarSesionGoogle")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **refrescarSesionGoogleRequestBody** | [**RefrescarSesionGoogleRequestBody**](RefrescarSesionGoogleRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="registrarClaveTransaccional"></a>
# **registrarClaveTransaccional**
> DatoRespuesta registrarClaveTransaccional(riskDeviceToken, riskServiceVersion, registrarClaveTransaccionalRequestBody)

RegistrarClaveTransaccional

Permite registrar una clave transaccional para un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val registrarClaveTransaccionalRequestBody : RegistrarClaveTransaccionalRequestBody =  // RegistrarClaveTransaccionalRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.registrarClaveTransaccional(riskDeviceToken, riskServiceVersion, registrarClaveTransaccionalRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#registrarClaveTransaccional")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#registrarClaveTransaccional")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **registrarClaveTransaccionalRequestBody** | [**RegistrarClaveTransaccionalRequestBody**](RegistrarClaveTransaccionalRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="registrarDispositivo"></a>
# **registrarDispositivo**
> DatoRespuesta registrarDispositivo(riskDeviceToken, riskServiceVersion, registrarDispositivoRequestBody)

RegistrarDispositivo

Permite registrar un dispositivo

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val registrarDispositivoRequestBody : RegistrarDispositivoRequestBody =  // RegistrarDispositivoRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.registrarDispositivo(riskDeviceToken, riskServiceVersion, registrarDispositivoRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#registrarDispositivo")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#registrarDispositivo")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **registrarDispositivoRequestBody** | [**RegistrarDispositivoRequestBody**](RegistrarDispositivoRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="registrarUbicacion"></a>
# **registrarUbicacion**
> DatoRespuesta registrarUbicacion(riskDeviceToken, riskServiceVersion, registrarUbicacionRequestBody)

RegistrarUbicacion

Permite registrar la ubicación (coordenadas geográficas) de un dispositivo

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val registrarUbicacionRequestBody : RegistrarUbicacionRequestBody =  // RegistrarUbicacionRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.registrarUbicacion(riskDeviceToken, riskServiceVersion, registrarUbicacionRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#registrarUbicacion")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#registrarUbicacion")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **registrarUbicacionRequestBody** | [**RegistrarUbicacionRequestBody**](RegistrarUbicacionRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="registrarUsuario"></a>
# **registrarUsuario**
> DatoRespuesta registrarUsuario(riskDeviceToken, riskServiceVersion, registrarUsuarioRequestBody)

RegistrarUsuario

Permite registrar un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val registrarUsuarioRequestBody : RegistrarUsuarioRequestBody =  // RegistrarUsuarioRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.registrarUsuario(riskDeviceToken, riskServiceVersion, registrarUsuarioRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#registrarUsuario")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#registrarUsuario")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]
 **registrarUsuarioRequestBody** | [**RegistrarUsuarioRequestBody**](RegistrarUsuarioRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="validarOtp"></a>
# **validarOtp**
> DatoRespuesta validarOtp(secret, otp, riskDeviceToken, riskServiceVersion)

ValidarOtp

Permite validar un código OTP

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val secret : kotlin.String = secret_example // kotlin.String | Secret recibido al generar el código OTP
val otp : kotlin.Int = 56 // kotlin.Int | Código OTP a validar
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : DatoRespuesta = apiInstance.validarOtp(secret, otp, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#validarOtp")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#validarOtp")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **secret** | **kotlin.String**| Secret recibido al generar el código OTP |
 **otp** | **kotlin.Int**| Código OTP a validar |
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a name="validarPermiso"></a>
# **validarPermiso**
> DatoRespuesta validarPermiso(idPermiso, accion, riskDeviceToken, riskServiceVersion)

ValidarPermiso

Permite validar un permiso o una acción sobre un permiso

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val idPermiso : kotlin.String = idPermiso_example // kotlin.String | Identificador del permiso
val accion : AccionPermiso =  // AccionPermiso | Acción sobre el permiso
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : DatoRespuesta = apiInstance.validarPermiso(idPermiso, accion, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#validarPermiso")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#validarPermiso")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idPermiso** | **kotlin.String**| Identificador del permiso |
 **accion** | [**AccionPermiso**](.md)| Acción sobre el permiso | [optional] [enum: Consultar, Insertar, Actualizar, Eliminar]
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a name="validarSesion"></a>
# **validarSesion**
> DatoRespuesta validarSesion(accessToken, riskDeviceToken, riskServiceVersion)

ValidarSesion

Permite validar si una sesión está activa o no

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val accessToken : kotlin.String = accessToken_example // kotlin.String | Access Token de la sesión
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : DatoRespuesta = apiInstance.validarSesion(accessToken, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling AutApi#validarSesion")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling AutApi#validarSesion")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accessToken** | **kotlin.String**| Access Token de la sesión |
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

