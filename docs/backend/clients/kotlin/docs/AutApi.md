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
> DatoRespuesta activarUsuario(key, riskMinusServiceMinusVersion)

ActivarUsuario

Permite activar un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val key : kotlin.String = key_example // kotlin.String | Clave para la activación
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : DatoRespuesta = apiInstance.activarUsuario(key, riskMinusServiceMinusVersion)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/html, application/json

<a name="cambiarClaveAcceso"></a>
# **cambiarClaveAcceso**
> DatoRespuesta cambiarClaveAcceso(riskMinusServiceMinusVersion, cambiarClaveAccesoRequestBody)

CambiarClaveAcceso

Permite cambiar la clave de acceso de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val cambiarClaveAccesoRequestBody : CambiarClaveAccesoRequestBody =  // CambiarClaveAccesoRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.cambiarClaveAcceso(riskMinusServiceMinusVersion, cambiarClaveAccesoRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
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
 - **Accept**: application/json, text/plain

<a name="cambiarClaveTransaccional"></a>
# **cambiarClaveTransaccional**
> DatoRespuesta cambiarClaveTransaccional(riskMinusServiceMinusVersion, cambiarClaveTransaccionalRequestBody)

CambiarClaveTransaccional

Permite cambiar la clave transaccional de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val cambiarClaveTransaccionalRequestBody : CambiarClaveTransaccionalRequestBody =  // CambiarClaveTransaccionalRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.cambiarClaveTransaccional(riskMinusServiceMinusVersion, cambiarClaveTransaccionalRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
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
 - **Accept**: application/json, text/plain

<a name="datosUsuario"></a>
# **datosUsuario**
> UsuarioRespuesta datosUsuario(usuario, riskMinusServiceMinusVersion)

DatosUsuario

Permite obtener los datos de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : UsuarioRespuesta = apiInstance.datosUsuario(usuario, riskMinusServiceMinusVersion)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]

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
 - **Accept**: application/json, text/plain

<a name="editarDatoUsuario"></a>
# **editarDatoUsuario**
> DatoRespuesta editarDatoUsuario(usuario, riskMinusServiceMinusVersion, editarDatoUsuarioRequestBody)

EditarDatoUsuario

Permite editar dato de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val editarDatoUsuarioRequestBody : EditarDatoUsuarioRequestBody =  // EditarDatoUsuarioRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.editarDatoUsuario(usuario, riskMinusServiceMinusVersion, editarDatoUsuarioRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
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
 - **Accept**: application/json, text/plain

<a name="editarUsuario"></a>
# **editarUsuario**
> DatoRespuesta editarUsuario(usuario, riskMinusServiceMinusVersion, editarUsuarioRequestBody)

EditarUsuario

Permite editar un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val editarUsuarioRequestBody : EditarUsuarioRequestBody =  // EditarUsuarioRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.editarUsuario(usuario, riskMinusServiceMinusVersion, editarUsuarioRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
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
 - **Accept**: application/json, text/plain

<a name="eliminarUsuario"></a>
# **eliminarUsuario**
> DatoRespuesta eliminarUsuario(riskMinusServiceMinusVersion, eliminarUsuarioRequestBody)

EliminarUsuario

Permite eliminar un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val eliminarUsuarioRequestBody : EliminarUsuarioRequestBody =  // EliminarUsuarioRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.eliminarUsuario(riskMinusServiceMinusVersion, eliminarUsuarioRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
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
 - **Accept**: application/json, text/plain

<a name="finalizarSesion"></a>
# **finalizarSesion**
> DatoRespuesta finalizarSesion(riskMinusServiceMinusVersion, finalizarSesionRequestBody)

FinalizarSesion

Permite finalizar la sesión de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val finalizarSesionRequestBody : FinalizarSesionRequestBody =  // FinalizarSesionRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.finalizarSesion(riskMinusServiceMinusVersion, finalizarSesionRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
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
 - **Accept**: application/json, text/plain

<a name="generarOtp"></a>
# **generarOtp**
> DatoRespuesta generarOtp(tipoMensajeria, destino, riskMinusServiceMinusVersion)

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
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : DatoRespuesta = apiInstance.generarOtp(tipoMensajeria, destino, riskMinusServiceMinusVersion)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, text/plain

<a name="guardarAvatarUsuario"></a>
# **guardarAvatarUsuario**
> DatoRespuesta guardarAvatarUsuario(usuario, riskMinusServiceMinusVersion, archivo, url, nombre, extension)

GuardarAvatarUsuario

Permite guardar el avatar de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val archivo : java.io.File = BINARY_DATA_HERE // java.io.File | Contenido del archivo
val url : kotlin.String = url_example // kotlin.String | URL del archivo
val nombre : kotlin.String = nombre_example // kotlin.String | Nombre del archivo
val extension : kotlin.String = extension_example // kotlin.String | Extensión del archivo
try {
    val result : DatoRespuesta = apiInstance.guardarAvatarUsuario(usuario, riskMinusServiceMinusVersion, archivo, url, nombre, extension)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
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
 - **Accept**: application/json, text/plain

<a name="iniciarSesion"></a>
# **iniciarSesion**
> SesionRespuesta iniciarSesion(riskMinusServiceMinusVersion, iniciarSesionRequestBody)

IniciarSesion

Permite iniciar la sesión de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val iniciarSesionRequestBody : IniciarSesionRequestBody =  // IniciarSesionRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.iniciarSesion(riskMinusServiceMinusVersion, iniciarSesionRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
 **iniciarSesionRequestBody** | [**IniciarSesionRequestBody**](IniciarSesionRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, text/plain

<a name="iniciarSesionFacebook"></a>
# **iniciarSesionFacebook**
> SesionRespuesta iniciarSesionFacebook(riskMinusServiceMinusVersion, iniciarSesionFacebookRequestBody)

IniciarSesionFacebook

Permite iniciar la sesión de un usuario con su cuenta de facebook

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val iniciarSesionFacebookRequestBody : IniciarSesionFacebookRequestBody =  // IniciarSesionFacebookRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.iniciarSesionFacebook(riskMinusServiceMinusVersion, iniciarSesionFacebookRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
 **iniciarSesionFacebookRequestBody** | [**IniciarSesionFacebookRequestBody**](IniciarSesionFacebookRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, text/plain

<a name="iniciarSesionGoogle"></a>
# **iniciarSesionGoogle**
> SesionRespuesta iniciarSesionGoogle(riskMinusServiceMinusVersion, iniciarSesionGoogleRequestBody)

IniciarSesionGoogle

Permite iniciar la sesión de un usuario con su cuenta de google

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val iniciarSesionGoogleRequestBody : IniciarSesionGoogleRequestBody =  // IniciarSesionGoogleRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.iniciarSesionGoogle(riskMinusServiceMinusVersion, iniciarSesionGoogleRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
 **iniciarSesionGoogleRequestBody** | [**IniciarSesionGoogleRequestBody**](IniciarSesionGoogleRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, text/plain

<a name="recuperarAvatarUsuario"></a>
# **recuperarAvatarUsuario**
> java.io.File recuperarAvatarUsuario(usuario, version, riskMinusServiceMinusVersion)

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
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : java.io.File = apiInstance.recuperarAvatarUsuario(usuario, version, riskMinusServiceMinusVersion)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]

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
 - **Accept**: application/json, application/octet-stream, text/plain

<a name="refrescarSesion"></a>
# **refrescarSesion**
> SesionRespuesta refrescarSesion(riskMinusServiceMinusVersion, refrescarSesionRequestBody)

RefrescarSesion

Permite refrescar la sesión de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val refrescarSesionRequestBody : RefrescarSesionRequestBody =  // RefrescarSesionRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.refrescarSesion(riskMinusServiceMinusVersion, refrescarSesionRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
 **refrescarSesionRequestBody** | [**RefrescarSesionRequestBody**](RefrescarSesionRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, text/plain

<a name="refrescarSesionFacebook"></a>
# **refrescarSesionFacebook**
> SesionRespuesta refrescarSesionFacebook(riskMinusServiceMinusVersion, refrescarSesionFacebookRequestBody)

RefrescarSesionFacebook

Permite refrescar la sesión de un usuario con su cuenta de facebook

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val refrescarSesionFacebookRequestBody : RefrescarSesionFacebookRequestBody =  // RefrescarSesionFacebookRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.refrescarSesionFacebook(riskMinusServiceMinusVersion, refrescarSesionFacebookRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
 **refrescarSesionFacebookRequestBody** | [**RefrescarSesionFacebookRequestBody**](RefrescarSesionFacebookRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, text/plain

<a name="refrescarSesionGoogle"></a>
# **refrescarSesionGoogle**
> SesionRespuesta refrescarSesionGoogle(riskMinusServiceMinusVersion, refrescarSesionGoogleRequestBody)

RefrescarSesionGoogle

Permite refrescar la sesión de un usuario con su cuenta de google

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val refrescarSesionGoogleRequestBody : RefrescarSesionGoogleRequestBody =  // RefrescarSesionGoogleRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.refrescarSesionGoogle(riskMinusServiceMinusVersion, refrescarSesionGoogleRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
 **refrescarSesionGoogleRequestBody** | [**RefrescarSesionGoogleRequestBody**](RefrescarSesionGoogleRequestBody.md)|  | [optional]

### Return type

[**SesionRespuesta**](SesionRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, text/plain

<a name="registrarClaveTransaccional"></a>
# **registrarClaveTransaccional**
> DatoRespuesta registrarClaveTransaccional(riskMinusServiceMinusVersion, registrarClaveTransaccionalRequestBody)

RegistrarClaveTransaccional

Permite registrar una clave transaccional para un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val registrarClaveTransaccionalRequestBody : RegistrarClaveTransaccionalRequestBody =  // RegistrarClaveTransaccionalRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.registrarClaveTransaccional(riskMinusServiceMinusVersion, registrarClaveTransaccionalRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
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
 - **Accept**: application/json, text/plain

<a name="registrarDispositivo"></a>
# **registrarDispositivo**
> DatoRespuesta registrarDispositivo(riskMinusServiceMinusVersion, registrarDispositivoRequestBody)

RegistrarDispositivo

Permite registrar un dispositivo

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val registrarDispositivoRequestBody : RegistrarDispositivoRequestBody =  // RegistrarDispositivoRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.registrarDispositivo(riskMinusServiceMinusVersion, registrarDispositivoRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
 **registrarDispositivoRequestBody** | [**RegistrarDispositivoRequestBody**](RegistrarDispositivoRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, text/plain

<a name="registrarUbicacion"></a>
# **registrarUbicacion**
> DatoRespuesta registrarUbicacion(riskMinusServiceMinusVersion, registrarUbicacionRequestBody)

RegistrarUbicacion

Permite registrar la ubicación (coordenadas geográficas) de un dispositivo

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val registrarUbicacionRequestBody : RegistrarUbicacionRequestBody =  // RegistrarUbicacionRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.registrarUbicacion(riskMinusServiceMinusVersion, registrarUbicacionRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
 **registrarUbicacionRequestBody** | [**RegistrarUbicacionRequestBody**](RegistrarUbicacionRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, text/plain

<a name="registrarUsuario"></a>
# **registrarUsuario**
> DatoRespuesta registrarUsuario(riskMinusServiceMinusVersion, registrarUsuarioRequestBody)

RegistrarUsuario

Permite registrar un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val registrarUsuarioRequestBody : RegistrarUsuarioRequestBody =  // RegistrarUsuarioRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.registrarUsuario(riskMinusServiceMinusVersion, registrarUsuarioRequestBody)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
 **registrarUsuarioRequestBody** | [**RegistrarUsuarioRequestBody**](RegistrarUsuarioRequestBody.md)|  | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, text/plain

<a name="validarOtp"></a>
# **validarOtp**
> DatoRespuesta validarOtp(secret, otp, riskMinusServiceMinusVersion)

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
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : DatoRespuesta = apiInstance.validarOtp(secret, otp, riskMinusServiceMinusVersion)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, text/plain

<a name="validarPermiso"></a>
# **validarPermiso**
> DatoRespuesta validarPermiso(idPermiso, accion, riskMinusServiceMinusVersion)

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
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : DatoRespuesta = apiInstance.validarPermiso(idPermiso, accion, riskMinusServiceMinusVersion)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]

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
 - **Accept**: application/json, text/plain

<a name="validarSesion"></a>
# **validarSesion**
> DatoRespuesta validarSesion(accessToken, riskMinusServiceMinusVersion)

ValidarSesion

Permite validar si una sesión está activa o no

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val accessToken : kotlin.String = accessToken_example // kotlin.String | Access Token de la sesión
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : DatoRespuesta = apiInstance.validarSesion(accessToken, riskMinusServiceMinusVersion)
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
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]

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
 - **Accept**: application/json, text/plain

