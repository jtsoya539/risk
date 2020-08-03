# AutApi

All URIs are relative to *https://risk-project-api.azurewebsites.net*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cambiarClaveAcceso**](AutApi.md#cambiarClaveAcceso) | **POST** /Api/Aut/CambiarClaveAcceso | CambiarClaveAcceso
[**cambiarClaveTransaccional**](AutApi.md#cambiarClaveTransaccional) | **POST** /Api/Aut/CambiarClaveTransaccional | CambiarClaveTransaccional
[**editarUsuario**](AutApi.md#editarUsuario) | **POST** /Api/Aut/EditarUsuario | EditarUsuario
[**eliminarUsuario**](AutApi.md#eliminarUsuario) | **POST** /Api/Aut/EliminarUsuario | EliminarUsuario
[**finalizarSesion**](AutApi.md#finalizarSesion) | **POST** /Api/Aut/FinalizarSesion | FinalizarSesion
[**generarOtp**](AutApi.md#generarOtp) | **POST** /Api/Aut/GenerarOtp | GenerarOtp
[**guardarAvatarUsuario**](AutApi.md#guardarAvatarUsuario) | **POST** /Api/Aut/GuardarAvatarUsuario | GuardarAvatarUsuario
[**iniciarSesion**](AutApi.md#iniciarSesion) | **POST** /Api/Aut/IniciarSesion | IniciarSesion
[**recuperarAvatarUsuario**](AutApi.md#recuperarAvatarUsuario) | **GET** /Api/Aut/RecuperarAvatarUsuario | RecuperarAvatarUsuario
[**refrescarSesion**](AutApi.md#refrescarSesion) | **POST** /Api/Aut/RefrescarSesion | RefrescarSesion
[**registrarClaveTransaccional**](AutApi.md#registrarClaveTransaccional) | **POST** /Api/Aut/RegistrarClaveTransaccional | RegistrarClaveTransaccional
[**registrarDispositivo**](AutApi.md#registrarDispositivo) | **POST** /Api/Aut/RegistrarDispositivo | RegistrarDispositivo
[**registrarUsuario**](AutApi.md#registrarUsuario) | **POST** /Api/Aut/RegistrarUsuario | RegistrarUsuario
[**validarOtp**](AutApi.md#validarOtp) | **GET** /Api/Aut/ValidarOtp | ValidarOtp
[**validarSesion**](AutApi.md#validarSesion) | **GET** /Api/Aut/ValidarSesion | ValidarSesion


<a name="cambiarClaveAcceso"></a>
# **cambiarClaveAcceso**
> DatoRespuesta cambiarClaveAcceso(cambiarClaveAccesoRequestBody)

CambiarClaveAcceso

Permite cambiar la clave de acceso de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val cambiarClaveAccesoRequestBody : CambiarClaveAccesoRequestBody =  // CambiarClaveAccesoRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.cambiarClaveAcceso(cambiarClaveAccesoRequestBody)
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
> DatoRespuesta cambiarClaveTransaccional(cambiarClaveTransaccionalRequestBody)

CambiarClaveTransaccional

Permite cambiar la clave transaccional de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val cambiarClaveTransaccionalRequestBody : CambiarClaveTransaccionalRequestBody =  // CambiarClaveTransaccionalRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.cambiarClaveTransaccional(cambiarClaveTransaccionalRequestBody)
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

<a name="editarUsuario"></a>
# **editarUsuario**
> DatoRespuesta editarUsuario(usuario, editarUsuarioRequestBody)

EditarUsuario

Permite editar un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
val editarUsuarioRequestBody : EditarUsuarioRequestBody =  // EditarUsuarioRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.editarUsuario(usuario, editarUsuarioRequestBody)
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
> DatoRespuesta eliminarUsuario(eliminarUsuarioRequestBody)

EliminarUsuario

Permite eliminar un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val eliminarUsuarioRequestBody : EliminarUsuarioRequestBody =  // EliminarUsuarioRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.eliminarUsuario(eliminarUsuarioRequestBody)
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
> DatoRespuesta finalizarSesion(finalizarSesionRequestBody)

FinalizarSesion

Permite finalizar la sesión de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val finalizarSesionRequestBody : FinalizarSesionRequestBody =  // FinalizarSesionRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.finalizarSesion(finalizarSesionRequestBody)
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
> DatoRespuesta generarOtp(tipoMensajeria, destino)

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
try {
    val result : DatoRespuesta = apiInstance.generarOtp(tipoMensajeria, destino)
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
> DatoRespuesta guardarAvatarUsuario(usuario, archivo, nombre, extension)

GuardarAvatarUsuario

Permite guardar el avatar de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
val archivo : java.io.File = BINARY_DATA_HERE // java.io.File | 
val nombre : kotlin.String = nombre_example // kotlin.String | 
val extension : kotlin.String = extension_example // kotlin.String | 
try {
    val result : DatoRespuesta = apiInstance.guardarAvatarUsuario(usuario, archivo, nombre, extension)
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
 **archivo** | **java.io.File**|  | [optional]
 **nombre** | **kotlin.String**|  | [optional]
 **extension** | **kotlin.String**|  | [optional]

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
> SesionRespuesta iniciarSesion(iniciarSesionRequestBody)

IniciarSesion

Permite iniciar la sesión de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val iniciarSesionRequestBody : IniciarSesionRequestBody =  // IniciarSesionRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.iniciarSesion(iniciarSesionRequestBody)
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

<a name="recuperarAvatarUsuario"></a>
# **recuperarAvatarUsuario**
> java.io.File recuperarAvatarUsuario(usuario)

RecuperarAvatarUsuario

Permite recuperar el avatar de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val usuario : kotlin.String = usuario_example // kotlin.String | Usuario
try {
    val result : java.io.File = apiInstance.recuperarAvatarUsuario(usuario)
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
 - **Accept**: application/json, application/octet-stream

<a name="refrescarSesion"></a>
# **refrescarSesion**
> SesionRespuesta refrescarSesion(refrescarSesionRequestBody)

RefrescarSesion

Permite refrescar la sesión de un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val refrescarSesionRequestBody : RefrescarSesionRequestBody =  // RefrescarSesionRequestBody | 
try {
    val result : SesionRespuesta = apiInstance.refrescarSesion(refrescarSesionRequestBody)
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

<a name="registrarClaveTransaccional"></a>
# **registrarClaveTransaccional**
> DatoRespuesta registrarClaveTransaccional(registrarClaveTransaccionalRequestBody)

RegistrarClaveTransaccional

Permite registrar una clave transaccional para un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val registrarClaveTransaccionalRequestBody : RegistrarClaveTransaccionalRequestBody =  // RegistrarClaveTransaccionalRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.registrarClaveTransaccional(registrarClaveTransaccionalRequestBody)
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
> DatoRespuesta registrarDispositivo(registrarDispositivoRequestBody)

RegistrarDispositivo

Permite registrar un dispositivo

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val registrarDispositivoRequestBody : RegistrarDispositivoRequestBody =  // RegistrarDispositivoRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.registrarDispositivo(registrarDispositivoRequestBody)
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

<a name="registrarUsuario"></a>
# **registrarUsuario**
> DatoRespuesta registrarUsuario(registrarUsuarioRequestBody)

RegistrarUsuario

Permite registrar un usuario

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val registrarUsuarioRequestBody : RegistrarUsuarioRequestBody =  // RegistrarUsuarioRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.registrarUsuario(registrarUsuarioRequestBody)
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
> DatoRespuesta validarOtp(secret, otp)

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
try {
    val result : DatoRespuesta = apiInstance.validarOtp(secret, otp)
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

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a name="validarSesion"></a>
# **validarSesion**
> DatoRespuesta validarSesion(accessToken)

ValidarSesion

Permite validar si una sesión está activa o no

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = AutApi()
val accessToken : kotlin.String = accessToken_example // kotlin.String | Access Token de la sesión
try {
    val result : DatoRespuesta = apiInstance.validarSesion(accessToken)
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

