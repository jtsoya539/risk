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
    [SwaggerTag("Servicios del dominio GENERAL", "https://jtsoya539.github.io/risk/")]
    [Authorize(Roles = "ADMINISTRADOR,USUARIO")]
    [Route("Api/[controller]")]
    [ApiController]
    public class GenController : RiskControllerBase
    {
        private readonly IGenService _genService;
        private readonly IConfiguration _configuration;

        public GenController(IGenService genService, IConfiguration configuration)
        {
            _genService = genService;
            _configuration = configuration;
        }

        [AllowAnyClient]
        [AllowAnonymous]
        [HttpGet("VersionSistema")]
        [SwaggerOperation(OperationId = "VersionSistema", Summary = "VersionSistema", Description = "Obtiene la versión actual del sistema")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult VersionSistema()
        {
            var respuesta = _genService.VersionSistema();
            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("ValorParametro")]
        [SwaggerOperation(OperationId = "ValorParametro", Summary = "ValorParametro", Description = "Obtiene el valor de un parámetro")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult ValorParametro([FromQuery, SwaggerParameter(Description = "Identificador del parámetro", Required = true)] string parametro)
        {
            var respuesta = _genService.ValorParametro(parametro);
            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("SignificadoCodigo")]
        [SwaggerOperation(OperationId = "SignificadoCodigo", Summary = "SignificadoCodigo", Description = "Obtiene el significado de un código dentro de un dominio")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult SignificadoCodigo([FromQuery, SwaggerParameter(Description = "Dominio", Required = true)] string dominio, [FromQuery, SwaggerParameter(Description = "Código", Required = true)] string codigo)
        {
            var respuesta = _genService.SignificadoCodigo(dominio, codigo);
            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpGet("ListarPaises")]
        [SwaggerOperation(OperationId = "ListarPaises", Summary = "ListarPaises", Description = "Obtiene una lista de países")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Pagina<Pais>>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult ListarPaises([FromQuery, SwaggerParameter(Description = "Número de página", Required = false)] int pagina,
        [FromQuery, SwaggerParameter(Description = "Cantidad de elementos por página", Required = false)] int porPagina)
        {
            var respuesta = _genService.ListarPaises(null, pagina, porPagina);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpGet("ListarPaises/{idPais}")]
        [SwaggerOperation(OperationId = "ListarPais", Summary = "ListarPais", Description = "Obtiene los datos de un país")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(Respuesta<Pagina<Pais>>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status500InternalServerError, "Error inesperado", typeof(Respuesta<Dato>))]
        [SwaggerResponse(StatusCodes.Status501NotImplemented, "Servicio no implementado o inactivo", typeof(Respuesta<Dato>))]
        public IActionResult ListarPaises([FromRoute, SwaggerParameter(Description = "Identificador del país", Required = true)] int idPais)
        {
            var respuesta = _genService.ListarPaises(idPais);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }
    }
}
