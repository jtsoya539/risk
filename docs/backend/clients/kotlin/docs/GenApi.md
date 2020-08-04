# GenApi

All URIs are relative to *https://risk-project-api.azurewebsites.net*

Method | HTTP request | Description
------------- | ------------- | -------------
[**listarBarrios**](GenApi.md#listarBarrios) | **GET** /Api/Gen/ListarBarrios | ListarBarrios
[**listarCiudades**](GenApi.md#listarCiudades) | **GET** /Api/Gen/ListarCiudades | ListarCiudades
[**listarDepartamentos**](GenApi.md#listarDepartamentos) | **GET** /Api/Gen/ListarDepartamentos | ListarDepartamentos
[**listarPaises**](GenApi.md#listarPaises) | **GET** /Api/Gen/ListarPaises | ListarPaises
[**significadoCodigo**](GenApi.md#significadoCodigo) | **GET** /Api/Gen/SignificadoCodigo | SignificadoCodigo
[**valorParametro**](GenApi.md#valorParametro) | **GET** /Api/Gen/ValorParametro | ValorParametro
[**versionSistema**](GenApi.md#versionSistema) | **GET** /Api/Gen/VersionSistema | VersionSistema


<a name="listarBarrios"></a>
# **listarBarrios**
> BarrioPaginaRespuesta listarBarrios(idPais, idDepartamento, idCiudad, pagina, porPagina, noPaginar)

ListarBarrios

Obtiene una lista de barrios

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val idPais : kotlin.Int = 56 // kotlin.Int | Identificador del país
val idDepartamento : kotlin.Int = 56 // kotlin.Int | Identificador del departamento
val idCiudad : kotlin.Int = 56 // kotlin.Int | Identificador de la ciudad
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.String = noPaginar_example // kotlin.String | No paginar? (S/N)
try {
    val result : BarrioPaginaRespuesta = apiInstance.listarBarrios(idPais, idDepartamento, idCiudad, pagina, porPagina, noPaginar)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#listarBarrios")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#listarBarrios")
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
 **noPaginar** | **kotlin.String**| No paginar? (S/N) | [optional]

### Return type

[**BarrioPaginaRespuesta**](BarrioPaginaRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a name="listarCiudades"></a>
# **listarCiudades**
> CiudadPaginaRespuesta listarCiudades(idPais, idDepartamento, pagina, porPagina, noPaginar)

ListarCiudades

Obtiene una lista de ciudades

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val idPais : kotlin.Int = 56 // kotlin.Int | Identificador del país
val idDepartamento : kotlin.Int = 56 // kotlin.Int | Identificador del departamento
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.String = noPaginar_example // kotlin.String | No paginar? (S/N)
try {
    val result : CiudadPaginaRespuesta = apiInstance.listarCiudades(idPais, idDepartamento, pagina, porPagina, noPaginar)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#listarCiudades")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#listarCiudades")
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
 **noPaginar** | **kotlin.String**| No paginar? (S/N) | [optional]

### Return type

[**CiudadPaginaRespuesta**](CiudadPaginaRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a name="listarDepartamentos"></a>
# **listarDepartamentos**
> DepartamentoPaginaRespuesta listarDepartamentos(idPais, pagina, porPagina, noPaginar)

ListarDepartamentos

Obtiene una lista de departamentos

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val idPais : kotlin.Int = 56 // kotlin.Int | Identificador del país
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.String = noPaginar_example // kotlin.String | No paginar? (S/N)
try {
    val result : DepartamentoPaginaRespuesta = apiInstance.listarDepartamentos(idPais, pagina, porPagina, noPaginar)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#listarDepartamentos")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#listarDepartamentos")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idPais** | **kotlin.Int**| Identificador del país | [optional]
 **pagina** | **kotlin.Int**| Número de la página | [optional]
 **porPagina** | **kotlin.Int**| Cantidad de elementos por página | [optional]
 **noPaginar** | **kotlin.String**| No paginar? (S/N) | [optional]

### Return type

[**DepartamentoPaginaRespuesta**](DepartamentoPaginaRespuesta.md)

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

