using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
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

            // Creamos los claims (pertenencias, características) del usuario
            List<Claim> claims = new List<Claim>();

            claims.Add(new Claim(ClaimTypes.NameIdentifier, datosUsuario.Alias));
            claims.Add(new Claim(ClaimTypes.GivenName, datosUsuario.Nombre ?? ""));
            claims.Add(new Claim(ClaimTypes.Surname, datosUsuario.Apellido ?? ""));
            claims.Add(new Claim(ClaimTypes.Email, datosUsuario.DireccionCorreo ?? ""));
            //claimsList.Add(new Claim(ClaimTypes.HomePhone, usuario.NumeroTelefono ?? ""));

            foreach (var rol in datosUsuario.Roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, rol.Nombre));
            }

            int tiempoExpiracion = int.Parse(_genService.ValorParametro("TIEMPO_EXPIRACION_ACCESS_TOKEN").Datos.Dato);
            var securityKey = Encoding.ASCII.GetBytes(_configuration.GetValue<string>("SecretKey"));

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims.ToArray()),
                // Nuestro token va a durar 15 minutos
                Expires = DateTime.UtcNow.AddSeconds(tiempoExpiracion),
                // Credenciales para generar el token usando nuestro secretykey y el algoritmo hash 256
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(securityKey), SecurityAlgorithms.HmacSha256Signature)
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

        [AllowAnonymous]
        [HttpPost("RegistrarUsuario")]
        public IActionResult RegistrarUsuario([FromBody] RegistrarUsuarioRequestBody requestBody)
        {
            YRespuesta<YDato> respuesta = _autService.RegistrarUsuario(requestBody.Usuario, requestBody.Clave, requestBody.Nombre, requestBody.Apellido, requestBody.DireccionCorreo, requestBody.NumeroTelefono);
            return Ok(respuesta);
        }

        [AllowAnonymous]
        [HttpPost("IniciarSesion")]
        public IActionResult IniciarSesion([FromBody] IniciarSesionRequestBody requestBody)
        {
            var respValidarCredenciales = _autService.ValidarCredenciales(requestBody.Usuario, requestBody.Clave, "A");

            if (!respValidarCredenciales.Codigo.Equals("0"))
            {
                return BadRequest(respValidarCredenciales);
            }

            var accessToken = GenerarAccessToken(requestBody.Usuario);
            var refreshToken = GenerarRefreshToken();

            var respIniciarSesion = _autService.IniciarSesion(requestBody.Usuario, accessToken, refreshToken);

            if (!respIniciarSesion.Codigo.Equals("0"))
            {
                return BadRequest(respIniciarSesion);
            }

            return Ok(respIniciarSesion);
        }

        [AllowAnonymous]
        [HttpPost("RefrescarSesion")]
        public IActionResult RefrescarSesion([FromBody] RefrescarSesionRequestBody requestBody)
        {
            JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();
            SecurityToken validatedToken;

            var securityKey = Encoding.ASCII.GetBytes(_configuration.GetValue<string>("SecretKey"));

            ClaimsPrincipal claimsPrincipal = tokenHandler.ValidateToken(requestBody.AccessToken, new TokenValidationParameters
            {
                ValidateAudience = false,
                ValidateIssuer = false,
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(securityKey),
                ValidateLifetime = false // we check expired tokens here
            }, out validatedToken);

            string usuario = claimsPrincipal.Claims.First(c => c.Type == ClaimTypes.NameIdentifier).Value;

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
        public IActionResult FinalizarSesion([FromBody] FinalizarSesionRequestBody requestBody)
        {
            YRespuesta<YDato> respuesta = _autService.CambiarEstadoSesion(requestBody.Token, "F");
            return Ok(respuesta);
        }

        [HttpPost("RegistrarClaveTransaccional")]
        public IActionResult RegistrarClaveTransaccional([FromBody] RegistrarClaveTransaccionalRequestBody requestBody)
        {
            YRespuesta<YDato> respuesta = _autService.RegistrarClave(requestBody.Usuario, requestBody.Clave, "T");
            return Ok(respuesta);
        }

        [HttpPost("CambiarClaveAcceso")]
        public IActionResult CambiarClaveAcceso([FromBody] CambiarClaveAccesoRequestBody requestBody)
        {
            YRespuesta<YDato> respuesta = _autService.CambiarClave(requestBody.Usuario, requestBody.ClaveAntigua, requestBody.ClaveNueva, "A");
            return Ok(respuesta);
        }

        [HttpPost("CambiarClaveTransaccional")]
        public IActionResult CambiarClaveTransaccional([FromBody] CambiarClaveTransaccionalRequestBody requestBody)
        {
            YRespuesta<YDato> respuesta = _autService.CambiarClave(requestBody.Usuario, requestBody.ClaveAntigua, requestBody.ClaveNueva, "T");
            return Ok(respuesta);
        }

        [HttpGet("ValidarSesion")]
        public IActionResult ValidarSesion([FromQuery] string token)
        {
            YRespuesta<YDato> respuesta = _autService.ValidarSesion(token);
            return Ok(respuesta);
        }
    }
}
