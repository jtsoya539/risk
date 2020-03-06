using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
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
    [Authorize]
    [Route("Api/[controller]")]
    [ApiController]
    public class AutController : ControllerBase
    {
        private readonly IAutService _autService;
        private readonly IConfiguration _configuration;

        public AutController(IAutService autService, IConfiguration configuration)
        {
            _autService = autService;
            _configuration = configuration;
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
            YRespuesta<YDato> respuesta = _autService.ValidarCredenciales(requestBody.Usuario, requestBody.Clave, "A");

            if (!respuesta.Codigo.Equals("0"))
            {
                return BadRequest(respuesta);
            }

            var respuesta2 = _autService.DatosUsuario(requestBody.Usuario);

            if (!respuesta.Codigo.Equals("0"))
            {
                return BadRequest(respuesta2);
            }

            YUsuario usuario = respuesta2.Datos;

            // Creamos los claims (pertenencias, características) del usuario
            List<Claim> claims = new List<Claim>();

            claims.Add(new Claim(ClaimTypes.NameIdentifier, usuario.Alias));
            claims.Add(new Claim(ClaimTypes.GivenName, usuario.Nombre ?? ""));
            claims.Add(new Claim(ClaimTypes.Surname, usuario.Apellido ?? ""));
            claims.Add(new Claim(ClaimTypes.Email, usuario.DireccionCorreo ?? ""));
            //claimsList.Add(new Claim(ClaimTypes.HomePhone, usuario.NumeroTelefono ?? ""));

            foreach (var rol in usuario.Roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, rol.Nombre));
            }

            var key = Encoding.ASCII.GetBytes(_configuration.GetValue<string>("SecretKey"));

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims.ToArray()),
                // Nuestro token va a durar 15 minutos
                Expires = DateTime.UtcNow.AddMinutes(15),
                // Credenciales para generar el token usando nuestro secretykey y el algoritmo hash 256
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var createdToken = tokenHandler.CreateToken(tokenDescriptor);
            var token = tokenHandler.WriteToken(createdToken);

            respuesta = _autService.IniciarSesion(requestBody.Usuario, token);

            if (!respuesta.Codigo.Equals("0"))
            {
                return BadRequest(respuesta);
            }

            return Ok(token);
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
