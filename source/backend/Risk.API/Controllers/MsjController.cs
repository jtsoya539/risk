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

using System.Net.Mime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Risk.API.Attributes;
using Risk.API.Models;
using Risk.API.Services;
using Swashbuckle.AspNetCore.Annotations;

namespace Risk.API.Controllers
{
    [SwaggerTag("Servicios del dominio MENSAJERÍA", "https://jtsoya539.github.io/risk/")]
    [Authorize(Roles = "ADMINISTRADOR,MENSAJERIA")]
    [Route("Api/[controller]")]
    [ApiController]
    public class MsjController : RiskControllerBase
    {
        private readonly IMsjService _msjService;
        private readonly IConfiguration _configuration;

        public MsjController(IMsjService msjService, IConfiguration configuration)
        {
            _msjService = msjService;
            _configuration = configuration;
        }

        [HttpGet("ListarMensajesPendientes")]
        [SwaggerOperation(OperationId = "ListarMensajesPendientes", Summary = "ListarMensajesPendientes", Description = "Obtiene una lista de mensajes de texto (SMS) pendientes de envío")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Pagina<Mensaje>>))]
        public IActionResult ListarMensajesPendientes([FromQuery, SwaggerParameter(Description = "Número de la página", Required = false)] int pagina,
        [FromQuery, SwaggerParameter(Description = "Cantidad de elementos por página", Required = false)] int porPagina,
        [FromQuery, SwaggerParameter(Description = "No paginar? (S/N)", Required = false)] string noPaginar)
        {
            var respuesta = _msjService.ListarMensajesPendientes(pagina, porPagina, noPaginar);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("CambiarEstadoMensaje")]
        [SwaggerOperation(OperationId = "CambiarEstadoMensaje", Summary = "CambiarEstadoMensaje", Description = "Permite cambiar el estado de un mensaje de texto (SMS)")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult CambiarEstadoMensaje([FromBody] CambiarEstadoMensajeRequestBody requestBody)
        {
            var respuesta = _msjService.CambiarEstadoMensaje(requestBody.IdMensaje, requestBody.Estado, requestBody.RespuestaEnvio);
            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("ListarCorreosPendientes")]
        [SwaggerOperation(OperationId = "ListarCorreosPendientes", Summary = "ListarCorreosPendientes", Description = "Obtiene una lista de correos electrónicos (E-mail) pendientes de envío")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Pagina<Correo>>))]
        public IActionResult ListarCorreosPendientes([FromQuery, SwaggerParameter(Description = "Número de la página", Required = false)] int pagina,
        [FromQuery, SwaggerParameter(Description = "Cantidad de elementos por página", Required = false)] int porPagina,
        [FromQuery, SwaggerParameter(Description = "No paginar? (S/N)", Required = false)] string noPaginar)
        {
            var respuesta = _msjService.ListarCorreosPendientes(pagina, porPagina, noPaginar);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("CambiarEstadoCorreo")]
        [SwaggerOperation(OperationId = "CambiarEstadoCorreo", Summary = "CambiarEstadoCorreo", Description = "Permite cambiar el estado de un correo electrónico (E-mail)")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult CambiarEstadoCorreo([FromBody] CambiarEstadoCorreoRequestBody requestBody)
        {
            var respuesta = _msjService.CambiarEstadoCorreo(requestBody.IdCorreo, requestBody.Estado, requestBody.RespuestaEnvio);
            return ProcesarRespuesta(respuesta);
        }
    }
}
