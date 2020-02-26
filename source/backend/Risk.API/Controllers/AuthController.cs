using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Risk.API.Entities;
using Risk.API.Models;
using Risk.API.Services;

namespace Risk.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;
        private readonly IConfiguration _configuration;

        public AuthController(IAuthService authService, IConfiguration configuration)
        {
            _authService = authService;
            _configuration = configuration;
        }

        [HttpPost("RegistrarUsuario")]
        public IActionResult RegistrarUsuario([FromBody] RegistrarUsuarioRequestBody requestBody)
        {
            YRespuesta respuesta = _authService.ApiRegistrarUsuario(requestBody.Usuario, requestBody.Clave);
            return Ok(respuesta);
        }

        [HttpPost("IniciarSesion")]
        public IActionResult IniciarSesion([FromBody] IniciarSesionRequestBody requestBody)
        {
            YRespuesta respuesta = _authService.ApiValidarCredenciales(requestBody.Usuario, requestBody.Clave, "A");

            if (!respuesta.Codigo.Equals("0"))
            {
                return BadRequest(respuesta);
            }

            var secretKey = _configuration.GetValue<string>("SecretKey");
            var key = Encoding.ASCII.GetBytes(secretKey);

            // Creamos los claims (pertenencias, características) del usuario
            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, requestBody.Usuario)
            };

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                // Nuestro token va a durar un día
                Expires = DateTime.UtcNow.AddDays(1),
                // Credenciales para generar el token usando nuestro secretykey y el algoritmo hash 256
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var createdToken = tokenHandler.CreateToken(tokenDescriptor);
            var token = tokenHandler.WriteToken(createdToken);

            respuesta = _authService.ApiIniciarSesion(requestBody.Usuario, token);

            if (!respuesta.Codigo.Equals("0"))
            {
                return BadRequest(respuesta);
            }

            return Ok(token);
        }

        [HttpPost("FinalizarSesion")]
        public IActionResult FinalizarSesion([FromBody] FinalizarSesionRequestBody requestBody)
        {
            YRespuesta respuesta = _authService.ApiFinalizarSesion(requestBody.Token);
            return Ok(respuesta);
        }

        [HttpPost("RegistrarClaveTransaccional")]
        public IActionResult RegistrarClaveTransaccional([FromBody] RegistrarClaveTransaccionalRequestBody requestBody)
        {
            YRespuesta respuesta = _authService.ApiRegistrarClave(requestBody.Usuario, requestBody.Clave, "T");
            return Ok(respuesta);
        }

        [HttpPost("CambiarClaveAcceso")]
        public IActionResult CambiarClaveAcceso([FromBody] CambiarClaveAccesoRequestBody requestBody)
        {
            YRespuesta respuesta = _authService.ApiCambiarClave(requestBody.Usuario, requestBody.ClaveAntigua, requestBody.ClaveNueva, "A");
            return Ok(respuesta);
        }

        [HttpPost("CambiarClaveTransaccional")]
        public IActionResult CambiarClaveTransaccional([FromBody] CambiarClaveTransaccionalRequestBody requestBody)
        {
            YRespuesta respuesta = _authService.ApiCambiarClave(requestBody.Usuario, requestBody.ClaveAntigua, requestBody.ClaveNueva, "T");
            return Ok(respuesta);
        }
    }
}
