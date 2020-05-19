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
using System.Net.Mime;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Risk.API.Helpers;
using Risk.API.Models;
using Risk.API.Services;
using Swashbuckle.AspNetCore.Annotations;

namespace Risk.API.Controllers
{
    [SwaggerTag("Servicios del dominio AUTENTICACION", "https://jtsoya539.github.io/risk/")]
    [Authorize(Roles = "ADMINISTRADOR,USUARIO")]
    [Route("Api/[controller]")]
    [ApiController]
    public class AutController : RiskControllerBase
    {
        private readonly IAutService _autService;
        private readonly IGenService _genService;
        private readonly IConfiguration _configuration;

        public AutController(IAutService autService, IGenService genService, IConfiguration configuration)
        {
            _autService = autService;
            _genService = genService;
            _configuration = configuration;
        }

        private string GenerarAccessToken(string usuario)
        {
            var respDatosUsuario = _autService.DatosUsuario(usuario);
            if (!respDatosUsuario.Codigo.Equals(RiskDbConstants.CODIGO_OK))
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

            var respValorParametro = _genService.ValorParametro("TIEMPO_EXPIRACION_ACCESS_TOKEN");
            if (!respValorParametro.Codigo.Equals(RiskDbConstants.CODIGO_OK))
            {
                return string.Empty;
            }
            int tiempoExpiracion = int.Parse(respValorParametro.Datos.Contenido);

            var respValorParametro2 = _genService.ValorParametro("CLAVE_VALIDACION_ACCESS_TOKEN");
            if (!respValorParametro2.Codigo.Equals(RiskDbConstants.CODIGO_OK))
            {
                return string.Empty;
            }
            var signingKey = Encoding.ASCII.GetBytes(respValorParametro2.Datos.Contenido);

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

        private string GenerarRefreshToken(int size = 32)
        {
            var randomNumber = new byte[size];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(randomNumber);
                return Convert.ToBase64String(randomNumber);
            }
        }

        private string ObtenerUsuarioDeAccessToken(string accessToken)
        {
            JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();

            ClaimsPrincipal claimsPrincipal;
            SecurityToken validatedToken;

            var respValorParametro2 = _genService.ValorParametro("CLAVE_VALIDACION_ACCESS_TOKEN");
            if (!respValorParametro2.Codigo.Equals(RiskDbConstants.CODIGO_OK))
            {
                return string.Empty;
            }
            var signingKey = Encoding.ASCII.GetBytes(respValorParametro2.Datos.Contenido);

            try
            {
                claimsPrincipal = tokenHandler.ValidateToken(accessToken, new TokenValidationParameters
                {
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(signingKey),
                    ValidateLifetime = false // No se valida el tiempo de expiración del JWT
                }, out validatedToken);
            }
            catch (ArgumentException)
            {
                return string.Empty;
            }

            var jwtSecurityToken = validatedToken as JwtSecurityToken;
            if (jwtSecurityToken == null || !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase))
            {
                return string.Empty;
            }

            return claimsPrincipal.Identity.Name;
        }

        [AllowAnonymous]
        [HttpPost("RegistrarUsuario")]
        [SwaggerOperation(OperationId = "RegistrarUsuario", Summary = "RegistrarUsuario", Description = "Permite registrar un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
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
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult IniciarSesion([FromBody] IniciarSesionRequestBody requestBody)
        {
            var respValidarCredenciales = _autService.ValidarCredenciales(requestBody.Usuario, requestBody.Clave, "A");

            if (!respValidarCredenciales.Codigo.Equals(RiskDbConstants.CODIGO_OK))
            {
                return ProcesarRespuesta(respValidarCredenciales);
            }

            var accessToken = GenerarAccessToken(requestBody.Usuario);
            var refreshToken = GenerarRefreshToken();

            var respIniciarSesion = _autService.IniciarSesion(requestBody.Usuario, Request.Headers["Risk-App-Key"], accessToken, refreshToken);
            return ProcesarRespuesta(respIniciarSesion);
        }

        [AllowAnonymous]
        [HttpPost("RefrescarSesion")]
        [SwaggerOperation(OperationId = "RefrescarSesion", Summary = "RefrescarSesion", Description = "Permite refrescar la sesión de un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Sesion>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult RefrescarSesion([FromBody] RefrescarSesionRequestBody requestBody)
        {
            string usuario = ObtenerUsuarioDeAccessToken(requestBody.AccessToken);

            var accessTokenNuevo = GenerarAccessToken(usuario);
            var refreshTokenNuevo = GenerarRefreshToken();

            var respuesta = _autService.RefrescarSesion(requestBody.AccessToken, requestBody.RefreshToken, accessTokenNuevo, refreshTokenNuevo);
            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("FinalizarSesion")]
        [SwaggerOperation(OperationId = "FinalizarSesion", Summary = "FinalizarSesion", Description = "Permite finalizar la sesión de un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult FinalizarSesion([FromBody] FinalizarSesionRequestBody requestBody)
        {
            var respuesta = _autService.CambiarEstadoSesion(requestBody.AccessToken, "F");
            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("RegistrarClaveTransaccional")]
        [SwaggerOperation(OperationId = "RegistrarClaveTransaccional", Summary = "RegistrarClaveTransaccional", Description = "Permite registrar una clave transaccional para un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult RegistrarClaveTransaccional([FromBody] RegistrarClaveTransaccionalRequestBody requestBody)
        {
            var respuesta = _autService.RegistrarClave(requestBody.Usuario, requestBody.Clave, "T");
            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("CambiarClaveAcceso")]
        [SwaggerOperation(OperationId = "CambiarClaveAcceso", Summary = "CambiarClaveAcceso", Description = "Permite cambiar la clave de acceso de un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult CambiarClaveAcceso([FromBody] CambiarClaveAccesoRequestBody requestBody)
        {
            var respuesta = _autService.CambiarClave(requestBody.Usuario, requestBody.ClaveAntigua, requestBody.ClaveNueva, "A");
            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("CambiarClaveTransaccional")]
        [SwaggerOperation(OperationId = "CambiarClaveTransaccional", Summary = "CambiarClaveTransaccional", Description = "Permite cambiar la clave transaccional de un usuario")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult CambiarClaveTransaccional([FromBody] CambiarClaveTransaccionalRequestBody requestBody)
        {
            var respuesta = _autService.CambiarClave(requestBody.Usuario, requestBody.ClaveAntigua, requestBody.ClaveNueva, "T");
            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("ValidarSesion")]
        [SwaggerOperation(OperationId = "ValidarSesion", Summary = "ValidarSesion", Description = "Permite validar si una sesión está activa o no")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
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
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult RegistrarDispositivo([FromBody] RegistrarDispositivoRequestBody requestBody)
        {
            var respuesta = _autService.RegistrarDispositivo(Request.Headers["Risk-App-Key"], requestBody.Dispositivo);
            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("AvatarUsuario")]
        [SwaggerOperation(OperationId = "AvatarUsuario", Summary = "AvatarUsuario", Description = "Obtiene el avatar de un usuario")]
        [Produces(MediaTypeNames.Application.Json, new[] { "image/gif", "image/jpeg", "image/png" })]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa")]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult AvatarUsuario([FromQuery, SwaggerParameter(Description = "Usuario", Required = true)] string usuario)
        {
            var respuesta = _autService.AvatarUsuario(usuario);

            if (!respuesta.Codigo.Equals(RiskDbConstants.CODIGO_OK))
            {
                return ProcesarRespuesta(respuesta);
            }

            var archivo = respuesta.Datos;
            byte[] contenido = GZipHelper.Decompress(Convert.FromBase64String(archivo.Contenido));
            return File(contenido, string.Concat("image/", archivo.Extension), string.Concat(archivo.Nombre, ".", archivo.Extension));
        }
    }
}
