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
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Net.Mime;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.NotificationHubs;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Risk.API.Helpers;
using Risk.API.Models;
using Risk.API.Services;
using Swashbuckle.AspNetCore.Annotations;

namespace Risk.API.Controllers
{
    [SwaggerTag("Servicios del dominio AUTENTICACIÓN", "https://jtsoya539.github.io/risk/")]
    [Authorize(Roles = "ADMINISTRADOR,USUARIO")]
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

        private string GenerarAccessToken(string usuario, string claveAplicacion)
        {
            var respDatosUsuario = _autService.DatosUsuario(usuario);
            if (!respDatosUsuario.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return string.Empty;
            }

            Usuario datosUsuario = respDatosUsuario.Datos;

            // Crea la lista de claims (pertenencias, características) del usuario
            List<Claim> claims = new List<Claim>();

            claims.Add(new Claim(ClaimTypes.Name, datosUsuario.Alias));
            claims.Add(new Claim(ClaimTypes.GivenName, datosUsuario.Nombre ?? ""));
            claims.Add(new Claim(ClaimTypes.Surname, datosUsuario.Apellido ?? ""));
            claims.Add(new Claim(ClaimTypes.Email, datosUsuario.DireccionCorreo ?? ""));
            //claimsList.Add(new Claim(ClaimTypes.HomePhone, usuario.NumeroTelefono ?? ""));

            // Agrega los roles del usuario a la lista de claims
            foreach (var rol in datosUsuario.Roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, rol.Nombre));
            }

            var respTiempoExpiracionToken = _autService.TiempoExpiracionToken(claveAplicacion, TipoToken.AccessToken);
            if (!respTiempoExpiracionToken.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return string.Empty;
            }
            int tiempoExpiracion = int.Parse(respTiempoExpiracionToken.Datos.Contenido);

            var respValorParametro = _genService.ValorParametro("CLAVE_VALIDACION_ACCESS_TOKEN");
            if (!respValorParametro.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return string.Empty;
            }
            var signingKey = Encoding.ASCII.GetBytes(respValorParametro.Datos.Contenido);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims.ToArray()),
                Expires = DateTime.UtcNow.AddSeconds(tiempoExpiracion),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(signingKey), SecurityAlgorithms.HmacSha256Signature)
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var createdToken = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(createdToken);
        }

        private void RegistrarDispositivoNotificationHub(string tokenDispositivo)
        {
            if (_notificationHubClientConnection.Hub == null)
            {
                return;
            }

            var respDatosDispositivo = _autService.DatosDispositivo(tokenDispositivo);
            if (!respDatosDispositivo.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return;
            }

            Dispositivo dispositivo = respDatosDispositivo.Datos;

            if (dispositivo.TokenNotificacion == null || dispositivo.TokenNotificacion.Equals(string.Empty))
            {
                return;
            }

            NotificationPlatform platform;
            switch (dispositivo.PlataformaNotificacion)
            {
                case "wns":
                    platform = NotificationPlatform.Wns;
                    break;
                case "apns":
                    platform = NotificationPlatform.Apns;
                    break;
                case "mpns":
                    platform = NotificationPlatform.Mpns;
                    break;
                case "fcm":
                    platform = NotificationPlatform.Fcm;
                    break;
                case "adm":
                    platform = NotificationPlatform.Adm;
                    break;
                case "baidu":
                    platform = NotificationPlatform.Baidu;
                    break;
                default:
                    platform = NotificationPlatform.Fcm;
                    break;
            }

            List<string> tags = new List<string>();
            if (dispositivo.Suscripciones != null)
            {
                foreach (var item in dispositivo.Suscripciones)
                {
                    tags.Add(item.Contenido);
                }
            }

            var templates = new Dictionary<string, InstallationTemplate>()
            {
                {"default_template", new InstallationTemplate { Body = dispositivo.TemplateNotificacion }}
            };

            Installation installation = new Installation
            {
                InstallationId = dispositivo.TokenDispositivo,
                Platform = platform,
                PushChannel = dispositivo.TokenNotificacion,
                PushChannelExpired = false,
                Tags = tags,
                Templates = templates
            };

            _notificationHubClientConnection.Hub.CreateOrUpdateInstallation(installation);
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

            var accessToken = GenerarAccessToken(requestBody.Usuario, TokenHelper.ObtenerClaveAplicacionDeHeaders(Request.Headers));
            var refreshToken = TokenHelper.GenerarRefreshToken();

            var respIniciarSesion = _autService.IniciarSesion(TokenHelper.ObtenerClaveAplicacionDeHeaders(Request.Headers), requestBody.Usuario, accessToken, refreshToken, requestBody.TokenDispositivo);

            if (respIniciarSesion.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                RegistrarDispositivoNotificationHub(requestBody.TokenDispositivo);
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

            var accessTokenNuevo = GenerarAccessToken(usuario, TokenHelper.ObtenerClaveAplicacionDeHeaders(Request.Headers));
            var refreshTokenNuevo = TokenHelper.GenerarRefreshToken();

            var respuesta = _autService.RefrescarSesion(TokenHelper.ObtenerClaveAplicacionDeHeaders(Request.Headers), requestBody.AccessToken, requestBody.RefreshToken, accessTokenNuevo, refreshTokenNuevo);
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

            var respuesta = _autService.RegistrarDispositivo(TokenHelper.ObtenerClaveAplicacionDeHeaders(Request.Headers), requestBody.Dispositivo);

            if (respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                RegistrarDispositivoNotificationHub(respuesta.Datos.Contenido);
            }

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

        [HttpGet("RecuperarAvatarUsuario")]
        [SwaggerOperation(OperationId = "RecuperarAvatarUsuario", Summary = "RecuperarAvatarUsuario", Description = "Permite recuperar el avatar de un usuario")]
        [Produces(MediaTypeNames.Application.Json, new[] { "application/octet-stream" })]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(FileContentResult))]
        public IActionResult RecuperarAvatarUsuario([FromQuery, SwaggerParameter(Description = "Usuario", Required = true)] string usuario,
            [FromQuery, SwaggerParameter(Description = "Version", Required = false)] int? version)
        {
            var respuesta = _genService.RecuperarArchivo("T_USUARIOS", "AVATAR", usuario, version);

            if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return ProcesarRespuesta(respuesta);
            }

            var archivo = respuesta.Datos;
            byte[] contenido = GZipHelper.Decompress(Convert.FromBase64String(archivo.Contenido));

            return File(contenido, archivo.TipoMime, string.Concat(archivo.Nombre, ".", archivo.Extension));
        }

        [HttpPost("GuardarAvatarUsuario")]
        [SwaggerOperation(OperationId = "GuardarAvatarUsuario", Summary = "GuardarAvatarUsuario", Description = "Permite guardar el avatar de un usuario")]
        [Consumes("multipart/form-data")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult GuardarAvatarUsuario([FromQuery, SwaggerParameter(Description = "Usuario", Required = true)] string usuario, [FromForm] GuardarArchivoRequestBody requestBody)
        {
            string contenido = string.Empty;

            if (requestBody.Archivo.Length > 0)
            {
                using (var ms = new MemoryStream())
                {
                    requestBody.Archivo.CopyTo(ms);
                    contenido = Convert.ToBase64String(GZipHelper.Compress(ms.ToArray()));
                }
            }

            Archivo archivo = new Archivo
            {
                Contenido = contenido,
                Nombre = requestBody.Nombre,
                Extension = requestBody.Extension
            };

            var respuesta = _genService.GuardarArchivo("T_USUARIOS", "AVATAR", usuario, archivo);
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
