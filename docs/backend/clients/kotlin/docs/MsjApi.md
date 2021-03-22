# MsjApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activarMensajeria**](MsjApi.md#activarMensajeria) | **POST** /Api/Msj/ActivarMensajeria | ActivarMensajeria
[**cambiarEstadoMensajeria**](MsjApi.md#cambiarEstadoMensajeria) | **POST** /Api/Msj/CambiarEstadoMensajeria | CambiarEstadoMensajeria
[**desactivarMensajeria**](MsjApi.md#desactivarMensajeria) | **POST** /Api/Msj/DesactivarMensajeria | DesactivarMensajeria
[**listarCorreosPendientes**](MsjApi.md#listarCorreosPendientes) | **GET** /Api/Msj/ListarCorreosPendientes | ListarCorreosPendientes
[**listarMensajesPendientes**](MsjApi.md#listarMensajesPendientes) | **GET** /Api/Msj/ListarMensajesPendientes | ListarMensajesPendientes
[**listarNotificacionesPendientes**](MsjApi.md#listarNotificacionesPendientes) | **GET** /Api/Msj/ListarNotificacionesPendientes | ListarNotificacionesPendientes


<a name="activarMensajeria"></a>
# **activarMensajeria**
> DatoRespuesta activarMensajeria(tipoMensajeria, riskMinusServiceMinusVersion)

ActivarMensajeria

Permite activar el servicio de mensajería

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = MsjApi()
val tipoMensajeria : TipoMensajeria =  // TipoMensajeria | Tipo de mensajería a activar
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : DatoRespuesta = apiInstance.activarMensajeria(tipoMensajeria, riskMinusServiceMinusVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling MsjApi#activarMensajeria")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling MsjApi#activarMensajeria")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tipoMensajeria** | [**TipoMensajeria**](.md)| Tipo de mensajería a activar | [enum: Mail, SMS, Push]
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

<a name="cambiarEstadoMensajeria"></a>
# **cambiarEstadoMensajeria**
> DatoRespuesta cambiarEstadoMensajeria(riskMinusServiceMinusVersion, cambiarEstadoMensajeriaRequestBody)

CambiarEstadoMensajeria

Permite cambiar el estado de envío de un mensaje de texto (SMS), correo electrónico (E-mail) o notificación push

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = MsjApi()
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
val cambiarEstadoMensajeriaRequestBody : CambiarEstadoMensajeriaRequestBody =  // CambiarEstadoMensajeriaRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.cambiarEstadoMensajeria(riskMinusServiceMinusVersion, cambiarEstadoMensajeriaRequestBody)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling MsjApi#cambiarEstadoMensajeria")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling MsjApi#cambiarEstadoMensajeria")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]
 **cambiarEstadoMensajeriaRequestBody** | [**CambiarEstadoMensajeriaRequestBody**](CambiarEstadoMensajeriaRequestBody.md)|  | [optional]

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

<a name="desactivarMensajeria"></a>
# **desactivarMensajeria**
> DatoRespuesta desactivarMensajeria(tipoMensajeria, riskMinusServiceMinusVersion)

DesactivarMensajeria

Permite desactivar el servicio de mensajería

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = MsjApi()
val tipoMensajeria : TipoMensajeria =  // TipoMensajeria | Tipo de mensajería a desactivar
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : DatoRespuesta = apiInstance.desactivarMensajeria(tipoMensajeria, riskMinusServiceMinusVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling MsjApi#desactivarMensajeria")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling MsjApi#desactivarMensajeria")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tipoMensajeria** | [**TipoMensajeria**](.md)| Tipo de mensajería a desactivar | [enum: Mail, SMS, Push]
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

<a name="listarCorreosPendientes"></a>
# **listarCorreosPendientes**
> CorreoPaginaRespuesta listarCorreosPendientes(pagina, porPagina, noPaginar, riskMinusServiceMinusVersion)

ListarCorreosPendientes

Obtiene una lista de correos electrónicos (E-mail) pendientes de envío

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = MsjApi()
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.Boolean = true // kotlin.Boolean | No paginar?
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : CorreoPaginaRespuesta = apiInstance.listarCorreosPendientes(pagina, porPagina, noPaginar, riskMinusServiceMinusVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling MsjApi#listarCorreosPendientes")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling MsjApi#listarCorreosPendientes")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pagina** | **kotlin.Int**| Número de la página | [optional]
 **porPagina** | **kotlin.Int**| Cantidad de elementos por página | [optional]
 **noPaginar** | **kotlin.Boolean**| No paginar? | [optional]
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]

### Return type

[**CorreoPaginaRespuesta**](CorreoPaginaRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, text/plain

<a name="listarMensajesPendientes"></a>
# **listarMensajesPendientes**
> MensajePaginaRespuesta listarMensajesPendientes(pagina, porPagina, noPaginar, riskMinusServiceMinusVersion)

ListarMensajesPendientes

Obtiene una lista de mensajes de texto (SMS) pendientes de envío

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = MsjApi()
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.Boolean = true // kotlin.Boolean | No paginar?
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : MensajePaginaRespuesta = apiInstance.listarMensajesPendientes(pagina, porPagina, noPaginar, riskMinusServiceMinusVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling MsjApi#listarMensajesPendientes")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling MsjApi#listarMensajesPendientes")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pagina** | **kotlin.Int**| Número de la página | [optional]
 **porPagina** | **kotlin.Int**| Cantidad de elementos por página | [optional]
 **noPaginar** | **kotlin.Boolean**| No paginar? | [optional]
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]

### Return type

[**MensajePaginaRespuesta**](MensajePaginaRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, text/plain

<a name="listarNotificacionesPendientes"></a>
# **listarNotificacionesPendientes**
> NotificacionPaginaRespuesta listarNotificacionesPendientes(pagina, porPagina, noPaginar, riskMinusServiceMinusVersion)

ListarNotificacionesPendientes

Obtiene una lista de notificaciones push pendientes de envío

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = MsjApi()
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.Boolean = true // kotlin.Boolean | No paginar?
val riskMinusServiceMinusVersion : kotlin.String = riskMinusServiceMinusVersion_example // kotlin.String | Versión del Servicio
try {
    val result : NotificacionPaginaRespuesta = apiInstance.listarNotificacionesPendientes(pagina, porPagina, noPaginar, riskMinusServiceMinusVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling MsjApi#listarNotificacionesPendientes")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling MsjApi#listarNotificacionesPendientes")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pagina** | **kotlin.Int**| Número de la página | [optional]
 **porPagina** | **kotlin.Int**| Cantidad de elementos por página | [optional]
 **noPaginar** | **kotlin.Boolean**| No paginar? | [optional]
 **riskMinusServiceMinusVersion** | **kotlin.String**| Versión del Servicio | [optional]

### Return type

[**NotificacionPaginaRespuesta**](NotificacionPaginaRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, text/plain

