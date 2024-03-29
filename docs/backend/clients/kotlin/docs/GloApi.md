# GloApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**listarBarrios**](GloApi.md#listarBarrios) | **GET** /Api/Glo/ListarBarrios | ListarBarrios
[**listarCiudades**](GloApi.md#listarCiudades) | **GET** /Api/Glo/ListarCiudades | ListarCiudades
[**listarDepartamentos**](GloApi.md#listarDepartamentos) | **GET** /Api/Glo/ListarDepartamentos | ListarDepartamentos
[**listarPaises**](GloApi.md#listarPaises) | **GET** /Api/Glo/ListarPaises | ListarPaises


<a id="listarBarrios"></a>
# **listarBarrios**
> BarrioPaginaRespuesta listarBarrios(idPais, idDepartamento, idCiudad, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)

ListarBarrios

Obtiene una lista de barrios

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GloApi()
val idPais : kotlin.Int = 56 // kotlin.Int | Identificador del país
val idDepartamento : kotlin.Int = 56 // kotlin.Int | Identificador del departamento
val idCiudad : kotlin.Int = 56 // kotlin.Int | Identificador de la ciudad
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.Boolean = true // kotlin.Boolean | No paginar?
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : BarrioPaginaRespuesta = apiInstance.listarBarrios(idPais, idDepartamento, idCiudad, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GloApi#listarBarrios")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GloApi#listarBarrios")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idPais** | **kotlin.Int**| Identificador del país | [optional]
 **idDepartamento** | **kotlin.Int**| Identificador del departamento | [optional]
 **idCiudad** | **kotlin.Int**| Identificador de la ciudad | [optional]
 **pagina** | **kotlin.Int**| Número de la página | [optional]
 **porPagina** | **kotlin.Int**| Cantidad de elementos por página | [optional]
 **noPaginar** | **kotlin.Boolean**| No paginar? | [optional]
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**BarrioPaginaRespuesta**](BarrioPaginaRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a id="listarCiudades"></a>
# **listarCiudades**
> CiudadPaginaRespuesta listarCiudades(idPais, idDepartamento, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)

ListarCiudades

Obtiene una lista de ciudades

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GloApi()
val idPais : kotlin.Int = 56 // kotlin.Int | Identificador del país
val idDepartamento : kotlin.Int = 56 // kotlin.Int | Identificador del departamento
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.Boolean = true // kotlin.Boolean | No paginar?
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : CiudadPaginaRespuesta = apiInstance.listarCiudades(idPais, idDepartamento, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GloApi#listarCiudades")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GloApi#listarCiudades")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idPais** | **kotlin.Int**| Identificador del país | [optional]
 **idDepartamento** | **kotlin.Int**| Identificador del departamento | [optional]
 **pagina** | **kotlin.Int**| Número de la página | [optional]
 **porPagina** | **kotlin.Int**| Cantidad de elementos por página | [optional]
 **noPaginar** | **kotlin.Boolean**| No paginar? | [optional]
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**CiudadPaginaRespuesta**](CiudadPaginaRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a id="listarDepartamentos"></a>
# **listarDepartamentos**
> DepartamentoPaginaRespuesta listarDepartamentos(idPais, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)

ListarDepartamentos

Obtiene una lista de departamentos

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GloApi()
val idPais : kotlin.Int = 56 // kotlin.Int | Identificador del país
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.Boolean = true // kotlin.Boolean | No paginar?
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : DepartamentoPaginaRespuesta = apiInstance.listarDepartamentos(idPais, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GloApi#listarDepartamentos")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GloApi#listarDepartamentos")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idPais** | **kotlin.Int**| Identificador del país | [optional]
 **pagina** | **kotlin.Int**| Número de la página | [optional]
 **porPagina** | **kotlin.Int**| Cantidad de elementos por página | [optional]
 **noPaginar** | **kotlin.Boolean**| No paginar? | [optional]
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**DepartamentoPaginaRespuesta**](DepartamentoPaginaRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a id="listarPaises"></a>
# **listarPaises**
> PaisPaginaRespuesta listarPaises(pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)

ListarPaises

Obtiene una lista de países

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GloApi()
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.Boolean = true // kotlin.Boolean | No paginar?
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : PaisPaginaRespuesta = apiInstance.listarPaises(pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GloApi#listarPaises")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GloApi#listarPaises")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pagina** | **kotlin.Int**| Número de la página | [optional]
 **porPagina** | **kotlin.Int**| Cantidad de elementos por página | [optional]
 **noPaginar** | **kotlin.Boolean**| No paginar? | [optional]
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**PaisPaginaRespuesta**](PaisPaginaRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

