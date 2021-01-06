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

        public MsjController(IMsjService msjService, IConfiguration configuration) : base(configuration)
        {
            _msjService = msjService;
        }

        [HttpGet("ListarMensajesPendientes")]
        [SwaggerOperation(OperationId = "ListarMensajesPendientes", Summary = "ListarMensajesPendientes", Description = "Obtiene una lista de mensajes de texto (SMS) pendientes de envío")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Pagina<Mensaje>>))]
        public IActionResult ListarMensajesPendientes([FromQuery, SwaggerParameter(Description = "Número de la página", Required = false)] int pagina,
        [FromQuery, SwaggerParameter(Description = "Cantidad de elementos por página", Required = false)] int porPagina,
        [FromQuery, SwaggerParameter(Description = "No paginar? (S/N)", Required = false)] string noPaginar)
        {
            PaginaParametros paginaParametros = new PaginaParametros
            {
                Pagina = pagina,
                PorPagina = porPagina,
                NoPaginar = noPaginar
            };
            var respuesta = _msjService.ListarMensajesPendientes(paginaParametros);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

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
            PaginaParametros paginaParametros = new PaginaParametros
            {
                Pagina = pagina,
                PorPagina = porPagina,
                NoPaginar = noPaginar
            };
            var respuesta = _msjService.ListarCorreosPendientes(paginaParametros);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("ListarNotificacionesPendientes")]
        [SwaggerOperation(OperationId = "ListarNotificacionesPendientes", Summary = "ListarNotificacionesPendientes", Description = "Obtiene una lista de notificaciones push pendientes de envío")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Pagina<Notificacion>>))]
        public IActionResult ListarNotificacionesPendientes([FromQuery, SwaggerParameter(Description = "Número de la página", Required = false)] int pagina,
        [FromQuery, SwaggerParameter(Description = "Cantidad de elementos por página", Required = false)] int porPagina,
        [FromQuery, SwaggerParameter(Description = "No paginar? (S/N)", Required = false)] string noPaginar)
        {
            PaginaParametros paginaParametros = new PaginaParametros
            {
                Pagina = pagina,
                PorPagina = porPagina,
                NoPaginar = noPaginar
            };
            var respuesta = _msjService.ListarNotificacionesPendientes(paginaParametros);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }

        [HttpPost("CambiarEstadoMensajeria")]
        [SwaggerOperation(OperationId = "CambiarEstadoMensajeria", Summary = "CambiarEstadoMensajeria", Description = "Permite cambiar el estado de envío de un mensaje de texto (SMS), correo electrónico (E-mail) o notificación push")]
        [Consumes(MediaTypeNames.Application.Json)]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        public IActionResult CambiarEstadoMensajeria([FromBody] CambiarEstadoMensajeriaRequestBody requestBody)
        {
            var respuesta = _msjService.CambiarEstadoMensajeria(requestBody.TipoMensajeria, requestBody.IdMensajeria, requestBody.Estado, requestBody.RespuestaEnvio);
            return ProcesarRespuesta(respuesta);
        }
    }
}
