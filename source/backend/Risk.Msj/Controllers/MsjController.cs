using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace Risk.Msj.Controllers
{
    [ApiController]
    [Route("Api/[controller]")]
    public class MsjController : ControllerBase
    {
        private readonly ILogger<MsjController> _logger;
        private readonly IRiskAPIClientConnection _riskAPIClientConnection;

        public MsjController(ILogger<MsjController> logger, IRiskAPIClientConnection riskAPIClientConnection)
        {
            _logger = logger;
            _riskAPIClientConnection = riskAPIClientConnection;
        }

        [HttpPost("ActivarMensajeria")]
        public IActionResult ActivarMensajeria()
        {
            string respuesta = "OK";
            try
            {
                _riskAPIClientConnection.IniciarSesion();
                _riskAPIClientConnection.MensajeriaActiva = true;
            }
            catch (Exception)
            {
                respuesta = "ERROR";
            }
            return Ok(respuesta);
        }

        [HttpPost("DesactivarMensajeria")]
        public IActionResult DesactivarMensajeria()
        {
            string respuesta = "OK";
            try
            {
                _riskAPIClientConnection.FinalizarSesion();
                _riskAPIClientConnection.MensajeriaActiva = false;
            }
            catch (Exception)
            {
                respuesta = "ERROR";
            }
            return Ok(respuesta);
        }
    }
}
