using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Risk.API.Entities;
using Risk.API.Services;

namespace Risk.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService service;

        public AuthController(IAuthService authService)
        {
            service = authService;
        }

        // DELETE poliscrum/api/auth/sesion
        [HttpDelete("sesion")]
        public IActionResult finalizarSesion(int idSesion)
        {
            YRespuesta respuesta = service.ApiFinalizarSesion(idSesion);
            return Ok(respuesta);
        }
    }
}
