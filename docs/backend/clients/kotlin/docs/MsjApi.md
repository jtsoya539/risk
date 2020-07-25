# MsjApi

All URIs are relative to *https://risk-project-api.azurewebsites.net*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cambiarEstadoMensajeria**](MsjApi.md#cambiarEstadoMensajeria) | **POST** /Api/Msj/CambiarEstadoMensajeria | CambiarEstadoMensajeria
[**listarCorreosPendientes**](MsjApi.md#listarCorreosPendientes) | **GET** /Api/Msj/ListarCorreosPendientes | ListarCorreosPendientes
[**listarMensajesPendientes**](MsjApi.md#listarMensajesPendientes) | **GET** /Api/Msj/ListarMensajesPendientes | ListarMensajesPendientes
[**listarNotificacionesPendientes**](MsjApi.md#listarNotificacionesPendientes) | **GET** /Api/Msj/ListarNotificacionesPendientes | ListarNotificacionesPendientes


<a name="cambiarEstadoMensajeria"></a>
# **cambiarEstadoMensajeria**
> DatoRespuesta cambiarEstadoMensajeria(cambiarEstadoMensajeriaRequestBody)

CambiarEstadoMensajeria

Permite cambiar el estado de envío de un mensaje de texto (SMS), correo electrónico (E-mail) o notificación push

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = MsjApi()
val cambiarEstadoMensajeriaRequestBody : CambiarEstadoMensajeriaRequestBody =  // CambiarEstadoMensajeriaRequestBody | 
try {
    val result : DatoRespuesta = apiInstance.cambiarEstadoMensajeria(cambiarEstadoMensajeriaRequestBody)
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
 - **Accept**: application/json

<a name="listarCorreosPendientes"></a>
# **listarCorreosPendientes**
> CorreoPaginaRespuesta listarCorreosPendientes(pagina, porPagina, noPaginar)

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
val noPaginar : kotlin.String = noPaginar_example // kotlin.String | No paginar? (S/N)
try {
    val result : CorreoPaginaRespuesta = apiInstance.listarCorreosPendientes(pagina, porPagina, noPaginar)
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
 **noPaginar** | **kotlin.String**| No paginar? (S/N) | [optional]

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
 - **Accept**: application/json

<a name="listarMensajesPendientes"></a>
# **listarMensajesPendientes**
> MensajePaginaRespuesta listarMensajesPendientes(pagina, porPagina, noPaginar)

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
val noPaginar : kotlin.String = noPaginar_example // kotlin.String | No paginar? (S/N)
try {
    val result : MensajePaginaRespuesta = apiInstance.listarMensajesPendientes(pagina, porPagina, noPaginar)
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
 **noPaginar** | **kotlin.String**| No paginar? (S/N) | [optional]

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
 - **Accept**: application/json

<a name="listarNotificacionesPendientes"></a>
# **listarNotificacionesPendientes**
> NotificacionPaginaRespuesta listarNotificacionesPendientes(pagina, porPagina, noPaginar)

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
val noPaginar : kotlin.String = noPaginar_example // kotlin.String | No paginar? (S/N)
try {
    val result : NotificacionPaginaRespuesta = apiInstance.listarNotificacionesPendientes(pagina, porPagina, noPaginar)
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
 **noPaginar** | **kotlin.String**| No paginar? (S/N) | [optional]

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
 - **Accept**: application/json

