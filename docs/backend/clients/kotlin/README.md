# py.com.risk.client - Kotlin client library for Risk.API

## Requires

* Kotlin 1.4.30
* Gradle 6.8.3

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

All URIs are relative to *https://localhost:5001*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*AutApi* | [**activarUsuario**](docs/AutApi.md#activarusuario) | **GET** /Aut/ActivarUsuario | ActivarUsuario
*AutApi* | [**cambiarClaveAcceso**](docs/AutApi.md#cambiarclaveacceso) | **POST** /Api/Aut/CambiarClaveAcceso | CambiarClaveAcceso
*AutApi* | [**cambiarClaveTransaccional**](docs/AutApi.md#cambiarclavetransaccional) | **POST** /Api/Aut/CambiarClaveTransaccional | CambiarClaveTransaccional
*AutApi* | [**datosUsuario**](docs/AutApi.md#datosusuario) | **GET** /Api/Aut/DatosUsuario | DatosUsuario
*AutApi* | [**editarDatoUsuario**](docs/AutApi.md#editardatousuario) | **POST** /Api/Aut/EditarDatoUsuario | EditarDatoUsuario
*AutApi* | [**editarUsuario**](docs/AutApi.md#editarusuario) | **POST** /Api/Aut/EditarUsuario | EditarUsuario
*AutApi* | [**eliminarUsuario**](docs/AutApi.md#eliminarusuario) | **POST** /Api/Aut/EliminarUsuario | EliminarUsuario
*AutApi* | [**finalizarSesion**](docs/AutApi.md#finalizarsesion) | **POST** /Api/Aut/FinalizarSesion | FinalizarSesion
*AutApi* | [**generarOtp**](docs/AutApi.md#generarotp) | **POST** /Api/Aut/GenerarOtp | GenerarOtp
*AutApi* | [**guardarAvatarUsuario**](docs/AutApi.md#guardaravatarusuario) | **POST** /Api/Aut/GuardarAvatarUsuario | GuardarAvatarUsuario
*AutApi* | [**iniciarSesion**](docs/AutApi.md#iniciarsesion) | **POST** /Api/Aut/IniciarSesion | IniciarSesion
*AutApi* | [**iniciarSesionFacebook**](docs/AutApi.md#iniciarsesionfacebook) | **POST** /Api/Aut/IniciarSesionFacebook | IniciarSesionFacebook
*AutApi* | [**iniciarSesionGoogle**](docs/AutApi.md#iniciarsesiongoogle) | **POST** /Api/Aut/IniciarSesionGoogle | IniciarSesionGoogle
*AutApi* | [**recuperarAvatarUsuario**](docs/AutApi.md#recuperaravatarusuario) | **GET** /Api/Aut/RecuperarAvatarUsuario | RecuperarAvatarUsuario
*AutApi* | [**refrescarSesion**](docs/AutApi.md#refrescarsesion) | **POST** /Api/Aut/RefrescarSesion | RefrescarSesion
*AutApi* | [**refrescarSesionFacebook**](docs/AutApi.md#refrescarsesionfacebook) | **POST** /Api/Aut/RefrescarSesionFacebook | RefrescarSesionFacebook
*AutApi* | [**refrescarSesionGoogle**](docs/AutApi.md#refrescarsesiongoogle) | **POST** /Api/Aut/RefrescarSesionGoogle | RefrescarSesionGoogle
*AutApi* | [**registrarClaveTransaccional**](docs/AutApi.md#registrarclavetransaccional) | **POST** /Api/Aut/RegistrarClaveTransaccional | RegistrarClaveTransaccional
*AutApi* | [**registrarDispositivo**](docs/AutApi.md#registrardispositivo) | **POST** /Api/Aut/RegistrarDispositivo | RegistrarDispositivo
*AutApi* | [**registrarUbicacion**](docs/AutApi.md#registrarubicacion) | **POST** /Api/Aut/RegistrarUbicacion | RegistrarUbicacion
*AutApi* | [**registrarUsuario**](docs/AutApi.md#registrarusuario) | **POST** /Api/Aut/RegistrarUsuario | RegistrarUsuario
*AutApi* | [**validarOtp**](docs/AutApi.md#validarotp) | **GET** /Api/Aut/ValidarOtp | ValidarOtp
*AutApi* | [**validarPermiso**](docs/AutApi.md#validarpermiso) | **GET** /Api/Aut/ValidarPermiso | ValidarPermiso
*AutApi* | [**validarSesion**](docs/AutApi.md#validarsesion) | **GET** /Api/Aut/ValidarSesion | ValidarSesion
*GenApi* | [**guardarArchivo**](docs/GenApi.md#guardararchivo) | **POST** /Api/Gen/GuardarArchivo | GuardarArchivo
*GenApi* | [**listarAplicaciones**](docs/GenApi.md#listaraplicaciones) | **GET** /Api/Gen/ListarAplicaciones | ListarAplicaciones
*GenApi* | [**listarBarrios**](docs/GenApi.md#listarbarrios) | **GET** /Api/Gen/ListarBarrios | ListarBarrios
*GenApi* | [**listarCiudades**](docs/GenApi.md#listarciudades) | **GET** /Api/Gen/ListarCiudades | ListarCiudades
*GenApi* | [**listarDepartamentos**](docs/GenApi.md#listardepartamentos) | **GET** /Api/Gen/ListarDepartamentos | ListarDepartamentos
*GenApi* | [**listarErrores**](docs/GenApi.md#listarerrores) | **GET** /Api/Gen/ListarErrores | ListarErrores
*GenApi* | [**listarPaises**](docs/GenApi.md#listarpaises) | **GET** /Api/Gen/ListarPaises | ListarPaises
*GenApi* | [**listarSignificados**](docs/GenApi.md#listarsignificados) | **GET** /Api/Gen/ListarSignificados | ListarSignificados
*GenApi* | [**recuperarArchivo**](docs/GenApi.md#recuperararchivo) | **GET** /Api/Gen/RecuperarArchivo | RecuperarArchivo
*GenApi* | [**recuperarTexto**](docs/GenApi.md#recuperartexto) | **GET** /Api/Gen/RecuperarTexto | RecuperarTexto
*GenApi* | [**reporteListarSignificados**](docs/GenApi.md#reportelistarsignificados) | **GET** /Api/Gen/ReporteListarSignificados | ReporteListarSignificados
*GenApi* | [**reporteVersionSistema**](docs/GenApi.md#reporteversionsistema) | **GET** /Api/Gen/ReporteVersionSistema | ReporteVersionSistema
*GenApi* | [**significadoCodigo**](docs/GenApi.md#significadocodigo) | **GET** /Api/Gen/SignificadoCodigo | SignificadoCodigo
*GenApi* | [**valorParametro**](docs/GenApi.md#valorparametro) | **GET** /Api/Gen/ValorParametro | ValorParametro
*GenApi* | [**versionServicio**](docs/GenApi.md#versionservicio) | **GET** /Api/Gen/VersionServicio | VersionServicio
*GenApi* | [**versionSistema**](docs/GenApi.md#versionsistema) | **GET** /Gen/VersionSistema | VersionSistema
*MsjApi* | [**activarMensajeria**](docs/MsjApi.md#activarmensajeria) | **POST** /Api/Msj/ActivarMensajeria | ActivarMensajeria
*MsjApi* | [**cambiarEstadoMensajeria**](docs/MsjApi.md#cambiarestadomensajeria) | **POST** /Api/Msj/CambiarEstadoMensajeria | CambiarEstadoMensajeria
*MsjApi* | [**desactivarMensajeria**](docs/MsjApi.md#desactivarmensajeria) | **POST** /Api/Msj/DesactivarMensajeria | DesactivarMensajeria
*MsjApi* | [**listarCorreosPendientes**](docs/MsjApi.md#listarcorreospendientes) | **GET** /Api/Msj/ListarCorreosPendientes | ListarCorreosPendientes
*MsjApi* | [**listarMensajesPendientes**](docs/MsjApi.md#listarmensajespendientes) | **GET** /Api/Msj/ListarMensajesPendientes | ListarMensajesPendientes
*MsjApi* | [**listarNotificacionesPendientes**](docs/MsjApi.md#listarnotificacionespendientes) | **GET** /Api/Msj/ListarNotificacionesPendientes | ListarNotificacionesPendientes
*RepApi* | [**reporteListarSignificados**](docs/RepApi.md#reportelistarsignificados) | **GET** /Api/Gen/ReporteListarSignificados | ReporteListarSignificados
*RepApi* | [**reporteVersionSistema**](docs/RepApi.md#reporteversionsistema) | **GET** /Api/Gen/ReporteVersionSistema | ReporteVersionSistema


<a name="documentation-for-models"></a>
## Documentation for Models

 - [py.com.risk.client.models.AccionPermiso](docs/AccionPermiso.md)
 - [py.com.risk.client.models.Aplicacion](docs/Aplicacion.md)
 - [py.com.risk.client.models.AplicacionPagina](docs/AplicacionPagina.md)
 - [py.com.risk.client.models.AplicacionPaginaRespuesta](docs/AplicacionPaginaRespuesta.md)
 - [py.com.risk.client.models.Archivo](docs/Archivo.md)
 - [py.com.risk.client.models.Barrio](docs/Barrio.md)
 - [py.com.risk.client.models.BarrioPagina](docs/BarrioPagina.md)
 - [py.com.risk.client.models.BarrioPaginaRespuesta](docs/BarrioPaginaRespuesta.md)
 - [py.com.risk.client.models.CambiarClaveAccesoRequestBody](docs/CambiarClaveAccesoRequestBody.md)
 - [py.com.risk.client.models.CambiarClaveTransaccionalRequestBody](docs/CambiarClaveTransaccionalRequestBody.md)
 - [py.com.risk.client.models.CambiarEstadoMensajeriaRequestBody](docs/CambiarEstadoMensajeriaRequestBody.md)
 - [py.com.risk.client.models.Ciudad](docs/Ciudad.md)
 - [py.com.risk.client.models.CiudadPagina](docs/CiudadPagina.md)
 - [py.com.risk.client.models.CiudadPaginaRespuesta](docs/CiudadPaginaRespuesta.md)
 - [py.com.risk.client.models.Correo](docs/Correo.md)
 - [py.com.risk.client.models.CorreoPagina](docs/CorreoPagina.md)
 - [py.com.risk.client.models.CorreoPaginaRespuesta](docs/CorreoPaginaRespuesta.md)
 - [py.com.risk.client.models.Dato](docs/Dato.md)
 - [py.com.risk.client.models.DatoRespuesta](docs/DatoRespuesta.md)
 - [py.com.risk.client.models.Departamento](docs/Departamento.md)
 - [py.com.risk.client.models.DepartamentoPagina](docs/DepartamentoPagina.md)
 - [py.com.risk.client.models.DepartamentoPaginaRespuesta](docs/DepartamentoPaginaRespuesta.md)
 - [py.com.risk.client.models.Dispositivo](docs/Dispositivo.md)
 - [py.com.risk.client.models.EditarDatoUsuarioRequestBody](docs/EditarDatoUsuarioRequestBody.md)
 - [py.com.risk.client.models.EditarUsuarioRequestBody](docs/EditarUsuarioRequestBody.md)
 - [py.com.risk.client.models.EliminarUsuarioRequestBody](docs/EliminarUsuarioRequestBody.md)
 - [py.com.risk.client.models.Error](docs/Error.md)
 - [py.com.risk.client.models.ErrorPagina](docs/ErrorPagina.md)
 - [py.com.risk.client.models.ErrorPaginaRespuesta](docs/ErrorPaginaRespuesta.md)
 - [py.com.risk.client.models.EstadoMensajeria](docs/EstadoMensajeria.md)
 - [py.com.risk.client.models.FinalizarSesionRequestBody](docs/FinalizarSesionRequestBody.md)
 - [py.com.risk.client.models.FormatoReporte](docs/FormatoReporte.md)
 - [py.com.risk.client.models.IniciarSesionFacebookRequestBody](docs/IniciarSesionFacebookRequestBody.md)
 - [py.com.risk.client.models.IniciarSesionGoogleRequestBody](docs/IniciarSesionGoogleRequestBody.md)
 - [py.com.risk.client.models.IniciarSesionRequestBody](docs/IniciarSesionRequestBody.md)
 - [py.com.risk.client.models.Mensaje](docs/Mensaje.md)
 - [py.com.risk.client.models.MensajePagina](docs/MensajePagina.md)
 - [py.com.risk.client.models.MensajePaginaRespuesta](docs/MensajePaginaRespuesta.md)
 - [py.com.risk.client.models.Notificacion](docs/Notificacion.md)
 - [py.com.risk.client.models.NotificacionPagina](docs/NotificacionPagina.md)
 - [py.com.risk.client.models.NotificacionPaginaRespuesta](docs/NotificacionPaginaRespuesta.md)
 - [py.com.risk.client.models.OrigenSesion](docs/OrigenSesion.md)
 - [py.com.risk.client.models.Pais](docs/Pais.md)
 - [py.com.risk.client.models.PaisPagina](docs/PaisPagina.md)
 - [py.com.risk.client.models.PaisPaginaRespuesta](docs/PaisPaginaRespuesta.md)
 - [py.com.risk.client.models.Plantilla](docs/Plantilla.md)
 - [py.com.risk.client.models.RefrescarSesionFacebookRequestBody](docs/RefrescarSesionFacebookRequestBody.md)
 - [py.com.risk.client.models.RefrescarSesionGoogleRequestBody](docs/RefrescarSesionGoogleRequestBody.md)
 - [py.com.risk.client.models.RefrescarSesionRequestBody](docs/RefrescarSesionRequestBody.md)
 - [py.com.risk.client.models.RegistrarClaveTransaccionalRequestBody](docs/RegistrarClaveTransaccionalRequestBody.md)
 - [py.com.risk.client.models.RegistrarDispositivoRequestBody](docs/RegistrarDispositivoRequestBody.md)
 - [py.com.risk.client.models.RegistrarUbicacionRequestBody](docs/RegistrarUbicacionRequestBody.md)
 - [py.com.risk.client.models.RegistrarUsuarioRequestBody](docs/RegistrarUsuarioRequestBody.md)
 - [py.com.risk.client.models.Rol](docs/Rol.md)
 - [py.com.risk.client.models.Sesion](docs/Sesion.md)
 - [py.com.risk.client.models.SesionRespuesta](docs/SesionRespuesta.md)
 - [py.com.risk.client.models.Significado](docs/Significado.md)
 - [py.com.risk.client.models.SignificadoPagina](docs/SignificadoPagina.md)
 - [py.com.risk.client.models.SignificadoPaginaRespuesta](docs/SignificadoPaginaRespuesta.md)
 - [py.com.risk.client.models.TipoAplicacion](docs/TipoAplicacion.md)
 - [py.com.risk.client.models.TipoDispositivo](docs/TipoDispositivo.md)
 - [py.com.risk.client.models.TipoMensajeria](docs/TipoMensajeria.md)
 - [py.com.risk.client.models.Usuario](docs/Usuario.md)
 - [py.com.risk.client.models.UsuarioRespuesta](docs/UsuarioRespuesta.md)


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

