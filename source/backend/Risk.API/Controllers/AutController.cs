using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net.Mime;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Risk.API.Entities;
using Risk.API.Models;
using Risk.API.Services;
using Swashbuckle.AspNetCore.Annotations;

namespace Risk.API.Controllers
{
    [SwaggerTag("Servicios Web del dominio AUTENTICACION")]
    [Authorize(Roles = "ADMINISTRADOR,USUARIO")]
    [Route("Api/[controller]")]
    [ApiController]
    public class AutController : ControllerBase
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
            if (!respDatosUsuario.Codigo.Equals("0"))
            {
                return string.Empty;
            }

            YUsuario datosUsuario = respDatosUsuario.Datos;

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
            if (!respValorParametro.Codigo.Equals("0"))
            {
                return string.Empty;
            }

            int tiempoExpiracion = int.Parse(respValorParametro.Datos.Dato);
            var signingKey = Encoding.ASCII.GetBytes(_configuration.GetValue<string>("SecretKey"));

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

            var signingKey = Encoding.ASCII.GetBytes(_configuration.GetValue<string>("SecretKey"));

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
        [SwaggerOperation(Summary = "Summary", Description = "Description", OperationId = "")]
        [Consumes(MediaTypeNames.Application.Json)]
        public IActionResult RegistrarUsuario([FromBody] RegistrarUsuarioRequestBody requestBody)
        {
            YRespuesta<YDato> respuesta = _autService.RegistrarUsuario(requestBody.Usuario, requestBody.Clave, requestBody.Nombre, requestBody.Apellido, requestBody.DireccionCorreo, requestBody.NumeroTelefono);
            return Ok(respuesta);
        }

        [AllowAnonymous]
        [HttpPost("IniciarSesion")]
        [SwaggerOperation(Summary = "Summary", Description = "Description", OperationId = "")]
        [Consumes(MediaTypeNames.Application.Json)]
        public IActionResult IniciarSesion([FromBody] IniciarSesionRequestBody requestBody)
        {
            var respValidarCredenciales = _autService.ValidarCredenciales(requestBody.Usuario, requestBody.Clave, "A");

            if (!respValidarCredenciales.Codigo.Equals("0"))
            {
                return BadRequest(respValidarCredenciales);
            }

            var accessToken = GenerarAccessToken(requestBody.Usuario);
            var refreshToken = GenerarRefreshToken();

            var respIniciarSesion = _autService.IniciarSesion(requestBody.Usuario, Request.Headers["Risk-App-Key"], accessToken, refreshToken);

            if (!respIniciarSesion.Codigo.Equals("0"))
            {
                return BadRequest(respIniciarSesion);
            }

            return Ok(respIniciarSesion);
        }

        [AllowAnonymous]
        [HttpPost("RefrescarSesion")]
        [SwaggerOperation(Summary = "Summary", Description = "Description", OperationId = "")]
        [Consumes(MediaTypeNames.Application.Json)]
        public IActionResult RefrescarSesion([FromBody] RefrescarSesionRequestBody requestBody)
        {
            string usuario = ObtenerUsuarioDeAccessToken(requestBody.AccessToken);

            var accessTokenNuevo = GenerarAccessToken(usuario);
            var refreshTokenNuevo = GenerarRefreshToken();

            var respRefrescarSesion = _autService.RefrescarSesion(requestBody.AccessToken, requestBody.RefreshToken, accessTokenNuevo, refreshTokenNuevo);

            if (!respRefrescarSesion.Codigo.Equals("0"))
            {
                return BadRequest(respRefrescarSesion);
            }

            return Ok(respRefrescarSesion);
        }

        [HttpPost("FinalizarSesion")]
        [SwaggerOperation(Summary = "Summary", Description = "Description", OperationId = "")]
        [Consumes(MediaTypeNames.Application.Json)]
        public IActionResult FinalizarSesion([FromBody] FinalizarSesionRequestBody requestBody)
        {
            YRespuesta<YDato> respuesta = _autService.CambiarEstadoSesion(requestBody.Token, "F");
            return Ok(respuesta);
        }

        [HttpPost("RegistrarClaveTransaccional")]
        [SwaggerOperation(Summary = "Summary", Description = "Description", OperationId = "")]
        [Consumes(MediaTypeNames.Application.Json)]
        public IActionResult RegistrarClaveTransaccional([FromBody] RegistrarClaveTransaccionalRequestBody requestBody)
        {
            YRespuesta<YDato> respuesta = _autService.RegistrarClave(requestBody.Usuario, requestBody.Clave, "T");
            return Ok(respuesta);
        }

        [HttpPost("CambiarClaveAcceso")]
        [SwaggerOperation(Summary = "Summary", Description = "Description", OperationId = "")]
        [Consumes(MediaTypeNames.Application.Json)]
        public IActionResult CambiarClaveAcceso([FromBody] CambiarClaveAccesoRequestBody requestBody)
        {
            YRespuesta<YDato> respuesta = _autService.CambiarClave(requestBody.Usuario, requestBody.ClaveAntigua, requestBody.ClaveNueva, "A");
            return Ok(respuesta);
        }

        [HttpPost("CambiarClaveTransaccional")]
        [SwaggerOperation(Summary = "Summary", Description = "Description", OperationId = "")]
        [Consumes(MediaTypeNames.Application.Json)]
        public IActionResult CambiarClaveTransaccional([FromBody] CambiarClaveTransaccionalRequestBody requestBody)
        {
            YRespuesta<YDato> respuesta = _autService.CambiarClave(requestBody.Usuario, requestBody.ClaveAntigua, requestBody.ClaveNueva, "T");
            return Ok(respuesta);
        }

        [HttpGet("ValidarSesion")]
        [SwaggerOperation(Summary = "Summary", Description = "Description", OperationId = "")]
        public IActionResult ValidarSesion([FromQuery] string token)
        {
            YRespuesta<YDato> respuesta = _autService.ValidarSesion(token);
            return Ok(respuesta);
        }
    }
}
