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
using Risk.Common.Helpers;
using Swashbuckle.AspNetCore.Annotations;

namespace Risk.API.Controllers
{
    [SwaggerTag("Servicios del dominio GLOBAL", "https://jtsoya539.github.io/risk/")]
    [Authorize(Roles = "ADMINISTRADOR,USUARIO,USUARIO_NUEVO")]
    [Route("Api/[controller]")]
    [ApiController]
    public class GloController : RiskControllerBase
    {
        private readonly IGloService _gloService;

        public GloController(IGloService gloService, IConfiguration configuration) : base(configuration)
        {
            _gloService = gloService;
        }

        [AllowAnonymous]
        [HttpGet("ListarPaises")]
        [SwaggerOperation(OperationId = "ListarPaises", Summary = "ListarPaises", Description = "Obtiene una lista de países")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Pagina<Pais>>))]
        public IActionResult ListarPaises([FromQuery, SwaggerParameter(Description = "Número de la página", Required = false)] int pagina,
            [FromQuery, SwaggerParameter(Description = "Cantidad de elementos por página", Required = false)] int porPagina,
            [FromQuery, SwaggerParameter(Description = "No paginar?", Required = false)] bool noPaginar)
        {
            PaginaParametros paginaParametros = new PaginaParametros
            {
                Pagina = pagina,
                PorPagina = porPagina,
                NoPaginar = noPaginar
            };
            var respuesta = _gloService.ListarPaises(null, paginaParametros);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpGet("ListarDepartamentos")]
        [SwaggerOperation(OperationId = "ListarDepartamentos", Summary = "ListarDepartamentos", Description = "Obtiene una lista de departamentos")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Pagina<Departamento>>))]
        public IActionResult ListarDepartamentos([FromQuery, SwaggerParameter(Description = "Identificador del país", Required = false)] int? idPais,
            [FromQuery, SwaggerParameter(Description = "Número de la página", Required = false)] int pagina,
            [FromQuery, SwaggerParameter(Description = "Cantidad de elementos por página", Required = false)] int porPagina,
            [FromQuery, SwaggerParameter(Description = "No paginar?", Required = false)] bool noPaginar)
        {
            PaginaParametros paginaParametros = new PaginaParametros
            {
                Pagina = pagina,
                PorPagina = porPagina,
                NoPaginar = noPaginar
            };
            var respuesta = _gloService.ListarDepartamentos(null, idPais, paginaParametros);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpGet("ListarCiudades")]
        [SwaggerOperation(OperationId = "ListarCiudades", Summary = "ListarCiudades", Description = "Obtiene una lista de ciudades")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Pagina<Ciudad>>))]
        public IActionResult ListarCiudades([FromQuery, SwaggerParameter(Description = "Identificador del país", Required = false)] int? idPais,
            [FromQuery, SwaggerParameter(Description = "Identificador del departamento", Required = false)] int? idDepartamento,
            [FromQuery, SwaggerParameter(Description = "Número de la página", Required = false)] int pagina,
            [FromQuery, SwaggerParameter(Description = "Cantidad de elementos por página", Required = false)] int porPagina,
            [FromQuery, SwaggerParameter(Description = "No paginar?", Required = false)] bool noPaginar)
        {
            PaginaParametros paginaParametros = new PaginaParametros
            {
                Pagina = pagina,
                PorPagina = porPagina,
                NoPaginar = noPaginar
            };
            var respuesta = _gloService.ListarCiudades(null, idPais, idDepartamento, paginaParametros);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpGet("ListarBarrios")]
        [SwaggerOperation(OperationId = "ListarBarrios", Summary = "ListarBarrios", Description = "Obtiene una lista de barrios")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Pagina<Barrio>>))]
        public IActionResult ListarBarrios([FromQuery, SwaggerParameter(Description = "Identificador del país", Required = false)] int? idPais,
            [FromQuery, SwaggerParameter(Description = "Identificador del departamento", Required = false)] int? idDepartamento,
            [FromQuery, SwaggerParameter(Description = "Identificador de la ciudad", Required = false)] int? idCiudad,
            [FromQuery, SwaggerParameter(Description = "Número de la página", Required = false)] int pagina,
            [FromQuery, SwaggerParameter(Description = "Cantidad de elementos por página", Required = false)] int porPagina,
            [FromQuery, SwaggerParameter(Description = "No paginar?", Required = false)] bool noPaginar)
        {
            PaginaParametros paginaParametros = new PaginaParametros
            {
                Pagina = pagina,
                PorPagina = porPagina,
                NoPaginar = noPaginar
            };
            var respuesta = _gloService.ListarBarrios(null, idPais, idDepartamento, idCiudad, paginaParametros);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }
    }
}
