# GenApi

All URIs are relative to *https://risk-project-api.azurewebsites.net*

Method | HTTP request | Description
------------- | ------------- | -------------
[**listarPais**](GenApi.md#listarPais) | **GET** /Api/Gen/ListarPaises/{idPais} | ListarPais
[**listarPaises**](GenApi.md#listarPaises) | **GET** /Api/Gen/ListarPaises | ListarPaises
[**significadoCodigo**](GenApi.md#significadoCodigo) | **GET** /Api/Gen/SignificadoCodigo | SignificadoCodigo
[**valorParametro**](GenApi.md#valorParametro) | **GET** /Api/Gen/ValorParametro | ValorParametro
[**versionSistema**](GenApi.md#versionSistema) | **GET** /Api/Gen/VersionSistema | VersionSistema


<a name="listarPais"></a>
# **listarPais**
> PaisPaginaRespuesta listarPais(idPais)

ListarPais

Obtiene los datos de un país

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val idPais : kotlin.Int = 56 // kotlin.Int | Identificador del país
try {
    val result : PaisPaginaRespuesta = apiInstance.listarPais(idPais)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#listarPais")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#listarPais")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idPais** | **kotlin.Int**| Identificador del país |

### Return type

[**PaisPaginaRespuesta**](PaisPaginaRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a name="listarPaises"></a>
# **listarPaises**
> PaisPaginaRespuesta listarPaises(pagina, porPagina, noPaginar)

ListarPaises

Obtiene una lista de países

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.String = noPaginar_example // kotlin.String | No paginar? (S/N)
try {
    val result : PaisPaginaRespuesta = apiInstance.listarPaises(pagina, porPagina, noPaginar)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#listarPaises")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#listarPaises")
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

[**PaisPaginaRespuesta**](PaisPaginaRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a name="significadoCodigo"></a>
# **significadoCodigo**
> DatoRespuesta significadoCodigo(dominio, codigo)

SignificadoCodigo

Obtiene el significado de un código dentro de un dominio

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val dominio : kotlin.String = dominio_example // kotlin.String | Dominio
val codigo : kotlin.String = codigo_example // kotlin.String | Código
try {
    val result : DatoRespuesta = apiInstance.significadoCodigo(dominio, codigo)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#significadoCodigo")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#significadoCodigo")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dominio** | **kotlin.String**| Dominio |
 **codigo** | **kotlin.String**| Código |

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

<a name="valorParametro"></a>
# **valorParametro**
> DatoRespuesta valorParametro(parametro)

ValorParametro

Obtiene el valor de un parámetro

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val parametro : kotlin.String = parametro_example // kotlin.String | Identificador del parámetro
try {
    val result : DatoRespuesta = apiInstance.valorParametro(parametro)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#valorParametro")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#valorParametro")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **parametro** | **kotlin.String**| Identificador del parámetro |

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

<a name="versionSistema"></a>
# **versionSistema**
> DatoRespuesta versionSistema()

VersionSistema

Obtiene la versión actual del sistema

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
try {
    val result : DatoRespuesta = apiInstance.versionSistema()
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#versionSistema")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#versionSistema")
    e.printStackTrace()
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

