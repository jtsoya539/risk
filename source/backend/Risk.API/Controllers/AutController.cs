/*
--------------------------------- MIT License ---------------------------------
Copyright (c) 2019 jtsoya539

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-------------------------------------------------------------------------------
*/

using System;
using System.Net.Mime;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json.Linq;
using Risk.API.Attributes;
using Risk.API.Helpers;
using Risk.API.Models;
using Risk.API.Services;
using Swashbuckle.AspNetCore.Annotations;

namespace Risk.API.Controllers
{
    [SwaggerTag("Servicios del dominio AUTENTICACIÓN", "https://jtsoya539.github.io/risk/")]
    [Authorize(Roles = "ADMINISTRADOR,USUARIO,USUARIO_NUEVO")]
    [Route("Api/[controller]")]
    [ApiController]
    public class AutController : RiskControllerBase
    {
        private readonly IAutService _autService;
        private readonly IGenService _genService;
        private readonly INotificationHubClientConnection _notificationHubClientConnection;

        public AutController(IAutService autService, IGenService genService, INotificationHubClientConnection notificationHubClientConnection, IConfiguration configuration) : base(configuration)
        {
            _autService = autService;
            _genService = genService;
            _notificationHubClientConnection = notificationHubClientConnection;
        }

        [AllowAnonymous]
        [HttpPost("RegistrarUsuario")]
        [SwaggerOperation(OperationId = "RegistrarUsuario", Summary = "RegistrarUsuario", Description = "Permite registrar un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult RegistrarUsuario([FromBody] RegistrarUsuarioRequestBody requestBody)
        {
            var respuesta = _autService.RegistrarUsuario(requestBody.Usuario, requestBody.Clave, requestBody.Nombre, requestBody.Apellido, requestBody.DireccionCorreo, requestBody.NumeroTelefono);
            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpPost("IniciarSesion")]
        [SwaggerOperation(OperationId = "IniciarSesion", Summary = "IniciarSesion", Description = "Permite iniciar la sesión de un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Sesion>))]
        public IActionResult IniciarSesion([FromBody] IniciarSesionRequestBody requestBody)
        {
            var respValidarCredenciales = _autService.ValidarCredenciales(requestBody.Usuario, requestBody.Clave, TipoClave.Acceso);

            if (!respValidarCredenciales.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return ProcesarRespuesta(respValidarCredenciales);
            }

            var accessToken = TokenHelper.GenerarAccessToken(requestBody.Usuario, _autService, _genService);
            var refreshToken = TokenHelper.GenerarRefreshToken();

            var respIniciarSesion = _autService.IniciarSesion(requestBody.Usuario, accessToken, refreshToken, requestBody.TokenDispositivo);

            if (respIniciarSesion.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                NotificationHubHelper.RegistrarDispositivo(requestBody.TokenDispositivo, _autService, _notificationHubClientConnection);
            }

            return ProcesarRespuesta(respIniciarSesion);
        }

        [AllowAnonymous]
        [HttpPost("RefrescarSesion")]
        [SwaggerOperation(OperationId = "RefrescarSesion", Summary = "RefrescarSesion", Description = "Permite refrescar la sesión de un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Sesion>))]
        public IActionResult RefrescarSesion([FromBody] RefrescarSesionRequestBody requestBody)
        {
            string usuario = TokenHelper.ObtenerUsuarioDeAccessToken(requestBody.AccessToken);

            var accessTokenNuevo = TokenHelper.GenerarAccessToken(usuario, _autService, _genService);
            var refreshTokenNuevo = TokenHelper.GenerarRefreshToken();

            var respuesta = _autService.RefrescarSesion(requestBody.AccessToken, requestBody.RefreshToken, accessTokenNuevo, refreshTokenNuevo);
            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("FinalizarSesion")]
        [SwaggerOperation(OperationId = "FinalizarSesion", Summary = "FinalizarSesion", Description = "Permite finalizar la sesión de un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult FinalizarSesion([FromBody] FinalizarSesionRequestBody requestBody)
        {
            var respuesta = _autService.CambiarEstadoSesion(requestBody.AccessToken, EstadoSesion.Finalizado);
            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("RegistrarClaveTransaccional")]
        [SwaggerOperation(OperationId = "RegistrarClaveTransaccional", Summary = "RegistrarClaveTransaccional", Description = "Permite registrar una clave transaccional para un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult RegistrarClaveTransaccional([FromBody] RegistrarClaveTransaccionalRequestBody requestBody)
        {
            var respuesta = _autService.RegistrarClave(requestBody.Usuario, requestBody.Clave, TipoClave.Transaccional);
            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("CambiarClaveAcceso")]
        [SwaggerOperation(OperationId = "CambiarClaveAcceso", Summary = "CambiarClaveAcceso", Description = "Permite cambiar la clave de acceso de un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult CambiarClaveAcceso([FromBody] CambiarClaveAccesoRequestBody requestBody)
        {
            var respuesta = _autService.CambiarClave(requestBody.Usuario, requestBody.ClaveAntigua, requestBody.ClaveNueva, TipoClave.Acceso);
            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("CambiarClaveTransaccional")]
        [SwaggerOperation(OperationId = "CambiarClaveTransaccional", Summary = "CambiarClaveTransaccional", Description = "Permite cambiar la clave transaccional de un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult CambiarClaveTransaccional([FromBody] CambiarClaveTransaccionalRequestBody requestBody)
        {
            var respuesta = _autService.CambiarClave(requestBody.Usuario, requestBody.ClaveAntigua, requestBody.ClaveNueva, TipoClave.Transaccional);
            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("ValidarSesion")]
        [SwaggerOperation(OperationId = "ValidarSesion", Summary = "ValidarSesion", Description = "Permite validar si una sesión está activa o no")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult ValidarSesion([FromQuery, SwaggerParameter(Description = "Access Token de la sesión", Required = true)] string accessToken)
        {
            var respuesta = _autService.ValidarSesion(accessToken);
            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpPost("RegistrarDispositivo")]
        [SwaggerOperation(OperationId = "RegistrarDispositivo", Summary = "RegistrarDispositivo", Description = "Permite registrar un dispositivo")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult RegistrarDispositivo([FromBody] RegistrarDispositivoRequestBody requestBody)
        {
            if (requestBody.Dispositivo.TokenDispositivo == null || requestBody.Dispositivo.TokenDispositivo.Equals(string.Empty))
            {
                requestBody.Dispositivo.TokenDispositivo = TokenHelper.GenerarTokenDispositivo();
            }

            var respuesta = _autService.RegistrarDispositivo(requestBody.Dispositivo);

            if (respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                NotificationHubHelper.RegistrarDispositivo(respuesta.Datos.Contenido, _autService, _notificationHubClientConnection);
            }

            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpPost("RegistrarUbicacion")]
        [SwaggerOperation(OperationId = "RegistrarUbicacion", Summary = "RegistrarUbicacion", Description = "Permite registrar la ubicación (coordenadas geográficas) de un dispositivo")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult RegistrarUbicacion([FromBody] RegistrarUbicacionRequestBody requestBody)
        {
            var respuesta = _autService.RegistrarUbicacion(requestBody.TokenDispositivo, requestBody.Latitud, requestBody.Longitud);
            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("DatosUsuario")]
        [SwaggerOperation(OperationId = "DatosUsuario", Summary = "DatosUsuario", Description = "Permite obtener los datos de un usuario")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Usuario>))]
        public IActionResult DatosUsuario([FromQuery, SwaggerParameter(Description = "Usuario", Required = true)] string usuario)
        {
            var respuesta = _autService.DatosUsuario(usuario);
            return ProcesarRespuesta(respuesta);
        }

        [Obsolete("Usar servicio RecuperarArchivo del dominio GENERAL")]
        [HttpGet("RecuperarAvatarUsuario")]
        [SwaggerOperation(OperationId = "RecuperarAvatarUsuario", Summary = "RecuperarAvatarUsuario", Description = "Permite recuperar el avatar de un usuario")]
        [Produces(MediaTypeNames.Application.Json, new[] { "application/octet-stream" })]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(FileContentResult))]
        public IActionResult RecuperarAvatarUsuario([FromQuery, SwaggerParameter(Description = "Usuario", Required = true)] string usuario,
            [FromQuery, SwaggerParameter(Description = "Versión", Required = false)] int? version)
        {
            var respuesta = _genService.RecuperarArchivo("T_USUARIOS", "AVATAR", usuario, version);

            if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return ProcesarRespuesta(respuesta);
            }

            return ProcesarArchivo(respuesta.Datos);
        }

        [Obsolete("Usar servicio GuardarArchivo del dominio GENERAL")]
        [HttpPost("GuardarAvatarUsuario")]
        [SwaggerOperation(OperationId = "GuardarAvatarUsuario", Summary = "GuardarAvatarUsuario", Description = "Permite guardar el avatar de un usuario")]
        [Consumes("multipart/form-data")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult GuardarAvatarUsuario([FromQuery, SwaggerParameter(Description = "Usuario", Required = true)] string usuario, [FromForm] GuardarArchivoRequestBody requestBody)
        {
            var respuesta = _genService.GuardarArchivo("T_USUARIOS", "AVATAR", usuario, ProcesarArchivo(requestBody));
            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("EditarUsuario")]
        [SwaggerOperation(OperationId = "EditarUsuario", Summary = "EditarUsuario", Description = "Permite editar un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult EditarUsuario([FromQuery, SwaggerParameter(Description = "Usuario", Required = true)] string usuario, [FromBody] EditarUsuarioRequestBody requestBody)
        {
            var respuesta = _autService.EditarUsuario(usuario, requestBody.UsuarioNuevo, requestBody.Nombre, requestBody.Apellido, requestBody.DireccionCorreo, requestBody.NumeroTelefono);
            return ProcesarRespuesta(respuesta);
        }

        [AllowAnyClient]
        [AllowAnonymous]
        [HttpGet("/[controller]/ActivarUsuario")]
        [SwaggerOperation(OperationId = "ActivarUsuario", Summary = "ActivarUsuario", Description = "Permite activar un usuario")]
        [Produces(MediaTypeNames.Text.Html)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult ActivarUsuario([FromQuery, SwaggerParameter(Description = "Clave para la activación", Required = true)] string key)
        {
            string mensaje;

            try
            {
                string json = Encoding.Default.GetString(Convert.FromBase64String(key));

                var jObject = JObject.Parse(json);
                string usuario = jObject.Value<string>("usuario");
                string hash = jObject.Value<string>("hash");

                if (!hash.Equals(HashHelper.SHA1(usuario)))
                {
                    throw new Exception();
                }

                var respuesta = _autService.CambiarEstadoUsuario(usuario, EstadoUsuario.Activo);
                if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
                {
                    throw new Exception();
                }

                mensaje = "Tu dirección de correo fue confirmada con éxito";
            }
            catch (Exception)
            {
                mensaje = "Hubo un error al tratar de confirmar tu dirección de correo";
            }

            return Content("<!DOCTYPE html>\n" +
                "<html>\n" +
                "<head>\n" +
                "    <meta charset=\"utf-8\">\n" +
                "    <title>Confirmación de correo</title>\n" +
                "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n" +
                "    <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">\n" +
                "    <link rel=\"stylesheet\" href=\"https://fonts.googleapis.com/css?family=Raleway\">\n" +
                "    <style>\n" +
                "        body,\n" +
                "        h1 {\n" +
                "            font-family: \"Raleway\", sans-serif\n" +
                "        }\n" +
                "        body,\n" +
                "        html {\n" +
                "            height: 100%\n" +
                "        }\n" +
                "        .bgimg {\n" +
                "            min-height: 100%;\n" +
                "            background-color: darkgreen;\n" +
                "            background-position: center;\n" +
                "            background-size: cover;\n" +
                "        }\n" +
                "    </style>\n" +
                "</head>\n" +
                "<body>\n" +
                "    <div class=\"bgimg w3-display-container w3-animate-opacity w3-text-white\">\n" +
                "        <div class=\"w3-display-topleft w3-padding-large w3-xlarge\"></div>\n" +
                "        <div class=\"w3-display-middle\">\n" +
                "            <h1 class=\"w3-xlarge w3-animate-top\">" + mensaje + "</h1>\n" +
                "            <hr class=\"w3-border-grey\" style=\"margin:auto;width:40%\">\n" +
                "            <p class=\"w3-medium w3-center\">Podés cerrar esta ventana</p>\n" +
                "        </div>\n" +
                "        <div class=\"w3-display-bottomleft w3-padding-large\"></div>\n" +
                "    </div>\n" +
                "</body>\n" +
                "</html>", MediaTypeNames.Text.Html);
        }

        [HttpPost("EliminarUsuario")]
        [SwaggerOperation(OperationId = "EliminarUsuario", Summary = "EliminarUsuario", Description = "Permite eliminar un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult EliminarUsuario([FromBody] EliminarUsuarioRequestBody requestBody)
        {
            var respValidarCredenciales = _autService.ValidarCredenciales(requestBody.Usuario, requestBody.Clave, TipoClave.Acceso);

            if (!respValidarCredenciales.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return ProcesarRespuesta(respValidarCredenciales);
            }

            var respCambiarEstadoSesion = _autService.CambiarEstadoSesion(requestBody.AccessToken, EstadoSesion.Finalizado);

            if (!respCambiarEstadoSesion.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return ProcesarRespuesta(respCambiarEstadoSesion);
            }

            var respCambiarEstadoUsuario = _autService.CambiarEstadoUsuario(requestBody.Usuario, EstadoUsuario.Inactivo);
            return ProcesarRespuesta(respCambiarEstadoUsuario);
        }

        [AllowAnonymous]
        [HttpPost("GenerarOtp")]
        [SwaggerOperation(OperationId = "GenerarOtp", Summary = "GenerarOtp", Description = "Permite generar un código OTP")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult GenerarOtp([FromQuery, SwaggerParameter(Description = "Tipo de mensajería (Mail/SMS/Push)", Required = true)] TipoMensajeria tipoMensajeria,
            [FromQuery, SwaggerParameter(Description = "Destino de la mensajería", Required = true)] string destino)
        {
            var respuesta = _autService.GenerarOtp(tipoMensajeria, destino);
            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpGet("ValidarOtp")]
        [SwaggerOperation(OperationId = "ValidarOtp", Summary = "ValidarOtp", Description = "Permite validar un código OTP")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult ValidarOtp([FromQuery, SwaggerParameter(Description = "Secret recibido al generar el código OTP", Required = true)] string secret,
            [FromQuery, SwaggerParameter(Description = "Código OTP a validar", Required = true)] int otp)
        {
            var respuesta = _autService.ValidarOtp(secret, otp);
            return ProcesarRespuesta(respuesta);
        }
    }
}
