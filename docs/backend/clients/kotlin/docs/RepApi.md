# RepApi

All URIs are relative to *https://localhost:5001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reporteListarSignificados**](RepApi.md#reporteListarSignificados) | **GET** /Api/Gen/ReporteListarSignificados | ReporteListarSignificados
[**reporteVersionSistema**](RepApi.md#reporteVersionSistema) | **GET** /Api/Gen/ReporteVersionSistema | ReporteVersionSistema


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

val apiInstance = RepApi()
val formato : FormatoReporte =  // FormatoReporte | Formato del reporte
val dominio : kotlin.String = dominio_example // kotlin.String | Dominio
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : java.io.File = apiInstance.reporteListarSignificados(formato, dominio, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling RepApi#reporteListarSignificados")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling RepApi#reporteListarSignificados")
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
 - **Accept**: application/json

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

val apiInstance = RepApi()
val formato : FormatoReporte =  // FormatoReporte | Formato del reporte
val riskDeviceToken : kotlin.String = riskDeviceToken_example // kotlin.String | Token del dispositivo desde el cual se realiza la petición
val riskServiceVersion : kotlin.String = riskServiceVersion_example // kotlin.String | Versión del servicio
try {
    val result : java.io.File = apiInstance.reporteVersionSistema(formato, riskDeviceToken, riskServiceVersion)
    println(result)
} catch (e: ClientException) {
    println("4xx response calling RepApi#reporteVersionSistema")
    e.printStackTrace()
} catch (e: ServerException) {
    println("5xx response calling RepApi#reporteVersionSistema")
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
 - **Accept**: application/json

