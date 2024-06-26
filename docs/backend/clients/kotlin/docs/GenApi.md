# GenApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**guardarArchivo**](GenApi.md#guardarArchivo) | **POST** /Api/Gen/GuardarArchivo | GuardarArchivo
[**listarAplicaciones**](GenApi.md#listarAplicaciones) | **GET** /Api/Gen/ListarAplicaciones | ListarAplicaciones
[**listarErrores**](GenApi.md#listarErrores) | **GET** /Api/Gen/ListarErrores | ListarErrores
[**listarSignificados**](GenApi.md#listarSignificados) | **GET** /Api/Gen/ListarSignificados | ListarSignificados
[**recuperarArchivo**](GenApi.md#recuperarArchivo) | **GET** /Api/Gen/RecuperarArchivo | RecuperarArchivo
[**recuperarTexto**](GenApi.md#recuperarTexto) | **GET** /Api/Gen/RecuperarTexto | RecuperarTexto
[**reporteListarSignificados**](GenApi.md#reporteListarSignificados) | **GET** /Api/Gen/ReporteListarSignificados | ReporteListarSignificados
[**reporteVersionSistema**](GenApi.md#reporteVersionSistema) | **GET** /Api/Gen/ReporteVersionSistema | ReporteVersionSistema
[**significadoCodigo**](GenApi.md#significadoCodigo) | **GET** /Api/Gen/SignificadoCodigo | SignificadoCodigo
[**valorParametro**](GenApi.md#valorParametro) | **GET** /Api/Gen/ValorParametro | ValorParametro
[**versionServicio**](GenApi.md#versionServicio) | **GET** /Api/Gen/VersionServicio | VersionServicio
[**versionSistema**](GenApi.md#versionSistema) | **GET** /Gen/VersionSistema | VersionSistema


<a id="guardarArchivo"></a>
# **guardarArchivo**
> DatoRespuesta guardarArchivo(tabla, campo, referencia, riskDeviceToken, riskServiceVersion, archivo, url, nombre, extension)

GuardarArchivo

Permite guardar un archivo

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val tabla : kotlin.String = tabla_example // kotlin.String | Tabla
val campo : kotlin.String = campo_example // kotlin.String | Campo
val referencia : kotlin.String = referencia_example // kotlin.String | Referencia
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
val archivo : java.io.File = BINARY_DATA_HERE // java.io.File | Contenido del archivo
val url : kotlin.String = url_example // kotlin.String | URL del archivo
val nombre : kotlin.String = nombre_example // kotlin.String | Nombre del archivo
val extension : kotlin.String = extension_example // kotlin.String | Extensión del archivo
try {
    val result : DatoRespuesta = apiInstance.guardarArchivo(tabla, campo, referencia, riskDeviceToken, riskServiceVersion, archivo, url, nombre, extension)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#guardarArchivo")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#guardarArchivo")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tabla** | **kotlin.String**| Tabla |
 **campo** | **kotlin.String**| Campo |
 **referencia** | **kotlin.String**| Referencia |
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

<a id="listarAplicaciones"></a>
# **listarAplicaciones**
> AplicacionPaginaRespuesta listarAplicaciones(idAplicacion, claveAplicacion, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)

ListarAplicaciones

Obtiene una lista de aplicaciones

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val idAplicacion : kotlin.String = idAplicacion_example // kotlin.String | Identificador de la aplicacion
val claveAplicacion : kotlin.String = claveAplicacion_example // kotlin.String | Clave de la aplicacion
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.Boolean = true // kotlin.Boolean | No paginar?
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : AplicacionPaginaRespuesta = apiInstance.listarAplicaciones(idAplicacion, claveAplicacion, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#listarAplicaciones")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#listarAplicaciones")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idAplicacion** | **kotlin.String**| Identificador de la aplicacion | [optional]
 **claveAplicacion** | **kotlin.String**| Clave de la aplicacion | [optional]
 **pagina** | **kotlin.Int**| Número de la página | [optional]
 **porPagina** | **kotlin.Int**| Cantidad de elementos por página | [optional]
 **noPaginar** | **kotlin.Boolean**| No paginar? | [optional]
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**AplicacionPaginaRespuesta**](AplicacionPaginaRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a id="listarErrores"></a>
# **listarErrores**
> ErrorPaginaRespuesta listarErrores(idError, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)

ListarErrores

Obtiene una lista de errores

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val idError : kotlin.String = idError_example // kotlin.String | Identificador del error
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.Boolean = true // kotlin.Boolean | No paginar?
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : ErrorPaginaRespuesta = apiInstance.listarErrores(idError, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#listarErrores")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#listarErrores")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idError** | **kotlin.String**| Identificador del error | [optional]
 **pagina** | **kotlin.Int**| Número de la página | [optional]
 **porPagina** | **kotlin.Int**| Cantidad de elementos por página | [optional]
 **noPaginar** | **kotlin.Boolean**| No paginar? | [optional]
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**ErrorPaginaRespuesta**](ErrorPaginaRespuesta.md)

### Authorization


Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a id="listarSignificados"></a>
# **listarSignificados**
> SignificadoPaginaRespuesta listarSignificados(dominio, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)

ListarSignificados

Obtiene una lista de significados dentro de un dominio

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val dominio : kotlin.String = dominio_example // kotlin.String | Dominio
val pagina : kotlin.Int = 56 // kotlin.Int | Número de la página
val porPagina : kotlin.Int = 56 // kotlin.Int | Cantidad de elementos por página
val noPaginar : kotlin.Boolean = true // kotlin.Boolean | No paginar?
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : SignificadoPaginaRespuesta = apiInstance.listarSignificados(dominio, pagina, porPagina, noPaginar, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#listarSignificados")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#listarSignificados")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dominio** | **kotlin.String**| Dominio |
 **pagina** | **kotlin.Int**| Número de la página | [optional]
 **porPagina** | **kotlin.Int**| Cantidad de elementos por página | [optional]
 **noPaginar** | **kotlin.Boolean**| No paginar? | [optional]
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**SignificadoPaginaRespuesta**](SignificadoPaginaRespuesta.md)

### Authorization


Configure AccessToken:
    ApiClient.accessToken = ""
Configure RiskAppKey:
    ApiClient.apiKey["Risk-App-Key"] = ""
    ApiClient.apiKeyPrefix["Risk-App-Key"] = ""

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

<a id="recuperarArchivo"></a>
# **recuperarArchivo**
> java.io.File recuperarArchivo(tabla, campo, referencia, version, riskDeviceToken, riskServiceVersion)

RecuperarArchivo

Permite recuperar un archivo

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val tabla : kotlin.String = tabla_example // kotlin.String | Tabla
val campo : kotlin.String = campo_example // kotlin.String | Campo
val referencia : kotlin.String = referencia_example // kotlin.String | Referencia
val version : kotlin.Int = 56 // kotlin.Int | Versión
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : java.io.File = apiInstance.recuperarArchivo(tabla, campo, referencia, version, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#recuperarArchivo")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#recuperarArchivo")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tabla** | **kotlin.String**| Tabla |
 **campo** | **kotlin.String**| Campo |
 **referencia** | **kotlin.String**| Referencia |
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
 - **Accept**: application/json, application/octet-stream

<a id="recuperarTexto"></a>
# **recuperarTexto**
> DatoRespuesta recuperarTexto(referencia, riskDeviceToken, riskServiceVersion)

RecuperarTexto

Obtiene un texto definido en el sistema

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val referencia : kotlin.String = referencia_example // kotlin.String | Referencia del texto
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : DatoRespuesta = apiInstance.recuperarTexto(referencia, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#recuperarTexto")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#recuperarTexto")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **referencia** | **kotlin.String**| Referencia del texto |
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

<a id="reporteListarSignificados"></a>
# **reporteListarSignificados**
> java.io.File reporteListarSignificados(formato, dominio, riskDeviceToken, riskServiceVersion)

ReporteListarSignificados

Obtiene un reporte con los significados dentro de un dominio

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val formato : FormatoReporte =  // FormatoReporte | Formato del reporte
val dominio : kotlin.String = dominio_example // kotlin.String | Dominio
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : java.io.File = apiInstance.reporteListarSignificados(formato, dominio, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#reporteListarSignificados")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#reporteListarSignificados")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formato** | [**FormatoReporte**](.md)| Formato del reporte | [enum: Pdf, Docx, Xlsx, Csv, Html]
 **dominio** | **kotlin.String**| Dominio | [optional]
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
 - **Accept**: application/json, application/octet-stream

<a id="reporteVersionSistema"></a>
# **reporteVersionSistema**
> java.io.File reporteVersionSistema(formato, riskDeviceToken, riskServiceVersion)

ReporteVersionSistema

Obtiene un reporte con la versión actual del sistema

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val formato : FormatoReporte =  // FormatoReporte | Formato del reporte
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : java.io.File = apiInstance.reporteVersionSistema(formato, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#reporteVersionSistema")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#reporteVersionSistema")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **formato** | [**FormatoReporte**](.md)| Formato del reporte | [enum: Pdf, Docx, Xlsx, Csv, Html]
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
 - **Accept**: application/json, application/octet-stream

<a id="significadoCodigo"></a>
# **significadoCodigo**
> DatoRespuesta significadoCodigo(dominio, codigo, riskDeviceToken, riskServiceVersion)

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
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : DatoRespuesta = apiInstance.significadoCodigo(dominio, codigo, riskDeviceToken, riskServiceVersion)
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

<a id="valorParametro"></a>
# **valorParametro**
> DatoRespuesta valorParametro(parametro, riskDeviceToken, riskServiceVersion)

ValorParametro

Obtiene el valor de un parámetro

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val parametro : kotlin.String = parametro_example // kotlin.String | Identificador del parámetro
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : DatoRespuesta = apiInstance.valorParametro(parametro, riskDeviceToken, riskServiceVersion)
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

<a id="versionServicio"></a>
# **versionServicio**
> DatoRespuesta versionServicio(servicio, riskDeviceToken, riskServiceVersion)

VersionServicio

Obtiene la versión actual del servicio

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val servicio : kotlin.String = servicio_example // kotlin.String | Nombre del servicio
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : DatoRespuesta = apiInstance.versionServicio(servicio, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling GenApi#versionServicio")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling GenApi#versionServicio")
    e.printStackTrace()
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **servicio** | **kotlin.String**| Nombre del servicio |
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

<a id="versionSistema"></a>
# **versionSistema**
> DatoRespuesta versionSistema(riskDeviceToken, riskServiceVersion)

VersionSistema

Obtiene la versión actual del sistema

### Example
```kotlin
// Import classes:
//import py.com.risk.client.infrastructure.*
//import py.com.risk.client.models.*

val apiInstance = GenApi()
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : DatoRespuesta = apiInstance.versionSistema(riskDeviceToken, riskServiceVersion)
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

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **riskDeviceToken** | **kotlin.String**| Token del dispositivo desde el cual se realiza la petición | [optional]
 **riskServiceVersion** | **kotlin.String**| Versión del servicio | [optional]

### Return type

[**DatoRespuesta**](DatoRespuesta.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

