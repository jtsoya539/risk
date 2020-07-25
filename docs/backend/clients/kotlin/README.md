# py.com.risk.client - Kotlin client library for Risk.API

## Requires

* Kotlin 1.3.41
* Gradle 4.9

## Build

First, create the gradle wrapper script:

```
gradle wrapper
```

Then, run:

```
./gradlew check assemble
```

This runs all tests and packages the library.

## Features/Implementation Notes

* Supports JSON inputs/outputs, File inputs, and Form inputs.
* Supports collection formats for query parameters: csv, tsv, ssv, pipes.
* Some Kotlin and Java types are fully qualified to avoid conflicts with types defined in OpenAPI definitions.
* Implementation of ApiClient is intended to reduce method counts, specifically to benefit Android targets.

<a name="documentation-for-api-endpoints"></a>
## Documentation for API Endpoints

All URIs are relative to *https://risk-project-api.azurewebsites.net*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*AutApi* | [**cambiarClaveAcceso**](docs/AutApi.md#cambiarclaveacceso) | **POST** /Api/Aut/CambiarClaveAcceso | CambiarClaveAcceso
*AutApi* | [**cambiarClaveTransaccional**](docs/AutApi.md#cambiarclavetransaccional) | **POST** /Api/Aut/CambiarClaveTransaccional | CambiarClaveTransaccional
*AutApi* | [**editarUsuario**](docs/AutApi.md#editarusuario) | **POST** /Api/Aut/EditarUsuario | EditarUsuario
*AutApi* | [**eliminarUsuario**](docs/AutApi.md#eliminarusuario) | **POST** /Api/Aut/EliminarUsuario | EliminarUsuario
*AutApi* | [**finalizarSesion**](docs/AutApi.md#finalizarsesion) | **POST** /Api/Aut/FinalizarSesion | FinalizarSesion
*AutApi* | [**guardarAvatarUsuario**](docs/AutApi.md#guardaravatarusuario) | **POST** /Api/Aut/GuardarAvatarUsuario | GuardarAvatarUsuario
*AutApi* | [**iniciarSesion**](docs/AutApi.md#iniciarsesion) | **POST** /Api/Aut/IniciarSesion | IniciarSesion
*AutApi* | [**recuperarAvatarUsuario**](docs/AutApi.md#recuperaravatarusuario) | **GET** /Api/Aut/RecuperarAvatarUsuario | RecuperarAvatarUsuario
*AutApi* | [**refrescarSesion**](docs/AutApi.md#refrescarsesion) | **POST** /Api/Aut/RefrescarSesion | RefrescarSesion
*AutApi* | [**registrarClaveTransaccional**](docs/AutApi.md#registrarclavetransaccional) | **POST** /Api/Aut/RegistrarClaveTransaccional | RegistrarClaveTransaccional
*AutApi* | [**registrarDispositivo**](docs/AutApi.md#registrardispositivo) | **POST** /Api/Aut/RegistrarDispositivo | RegistrarDispositivo
*AutApi* | [**registrarUsuario**](docs/AutApi.md#registrarusuario) | **POST** /Api/Aut/RegistrarUsuario | RegistrarUsuario
*AutApi* | [**validarSesion**](docs/AutApi.md#validarsesion) | **GET** /Api/Aut/ValidarSesion | ValidarSesion
*GenApi* | [**listarPais**](docs/GenApi.md#listarpais) | **GET** /Api/Gen/ListarPaises/{idPais} | ListarPais
*GenApi* | [**listarPaises**](docs/GenApi.md#listarpaises) | **GET** /Api/Gen/ListarPaises | ListarPaises
*GenApi* | [**significadoCodigo**](docs/GenApi.md#significadocodigo) | **GET** /Api/Gen/SignificadoCodigo | SignificadoCodigo
*GenApi* | [**valorParametro**](docs/GenApi.md#valorparametro) | **GET** /Api/Gen/ValorParametro | ValorParametro
*GenApi* | [**versionSistema**](docs/GenApi.md#versionsistema) | **GET** /Api/Gen/VersionSistema | VersionSistema
*MsjApi* | [**cambiarEstadoMensajeria**](docs/MsjApi.md#cambiarestadomensajeria) | **POST** /Api/Msj/CambiarEstadoMensajeria | CambiarEstadoMensajeria
*MsjApi* | [**listarCorreosPendientes**](docs/MsjApi.md#listarcorreospendientes) | **GET** /Api/Msj/ListarCorreosPendientes | ListarCorreosPendientes
*MsjApi* | [**listarMensajesPendientes**](docs/MsjApi.md#listarmensajespendientes) | **GET** /Api/Msj/ListarMensajesPendientes | ListarMensajesPendientes
*MsjApi* | [**listarNotificacionesPendientes**](docs/MsjApi.md#listarnotificacionespendientes) | **GET** /Api/Msj/ListarNotificacionesPendientes | ListarNotificacionesPendientes


<a name="documentation-for-models"></a>
## Documentation for Models

 - [py.com.risk.client.models.CambiarClaveAccesoRequestBody](docs/CambiarClaveAccesoRequestBody.md)
 - [py.com.risk.client.models.CambiarClaveTransaccionalRequestBody](docs/CambiarClaveTransaccionalRequestBody.md)
 - [py.com.risk.client.models.CambiarEstadoMensajeriaRequestBody](docs/CambiarEstadoMensajeriaRequestBody.md)
 - [py.com.risk.client.models.Correo](docs/Correo.md)
 - [py.com.risk.client.models.CorreoPagina](docs/CorreoPagina.md)
 - [py.com.risk.client.models.CorreoPaginaRespuesta](docs/CorreoPaginaRespuesta.md)
 - [py.com.risk.client.models.Dato](docs/Dato.md)
 - [py.com.risk.client.models.DatoRespuesta](docs/DatoRespuesta.md)
 - [py.com.risk.client.models.Dispositivo](docs/Dispositivo.md)
 - [py.com.risk.client.models.EditarUsuarioRequestBody](docs/EditarUsuarioRequestBody.md)
 - [py.com.risk.client.models.EliminarUsuarioRequestBody](docs/EliminarUsuarioRequestBody.md)
 - [py.com.risk.client.models.FinalizarSesionRequestBody](docs/FinalizarSesionRequestBody.md)
 - [py.com.risk.client.models.IniciarSesionRequestBody](docs/IniciarSesionRequestBody.md)
 - [py.com.risk.client.models.InlineObject](docs/InlineObject.md)
 - [py.com.risk.client.models.Mensaje](docs/Mensaje.md)
 - [py.com.risk.client.models.MensajePagina](docs/MensajePagina.md)
 - [py.com.risk.client.models.MensajePaginaRespuesta](docs/MensajePaginaRespuesta.md)
 - [py.com.risk.client.models.Notificacion](docs/Notificacion.md)
 - [py.com.risk.client.models.NotificacionPagina](docs/NotificacionPagina.md)
 - [py.com.risk.client.models.NotificacionPaginaRespuesta](docs/NotificacionPaginaRespuesta.md)
 - [py.com.risk.client.models.Pais](docs/Pais.md)
 - [py.com.risk.client.models.PaisPagina](docs/PaisPagina.md)
 - [py.com.risk.client.models.PaisPaginaRespuesta](docs/PaisPaginaRespuesta.md)
 - [py.com.risk.client.models.RefrescarSesionRequestBody](docs/RefrescarSesionRequestBody.md)
 - [py.com.risk.client.models.RegistrarClaveTransaccionalRequestBody](docs/RegistrarClaveTransaccionalRequestBody.md)
 - [py.com.risk.client.models.RegistrarDispositivoRequestBody](docs/RegistrarDispositivoRequestBody.md)
 - [py.com.risk.client.models.RegistrarUsuarioRequestBody](docs/RegistrarUsuarioRequestBody.md)
 - [py.com.risk.client.models.Sesion](docs/Sesion.md)
 - [py.com.risk.client.models.SesionRespuesta](docs/SesionRespuesta.md)


<a name="documentation-for-authorization"></a>
## Documentation for Authorization

<a name="AccessToken"></a>
### AccessToken

- **Type**: HTTP basic authentication

<a name="RiskAppKey"></a>
### RiskAppKey

- **Type**: API key
- **API key parameter name**: Risk-App-Key
- **Location**: HTTP header

