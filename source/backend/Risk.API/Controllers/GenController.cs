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
    [SwaggerTag("Servicios del dominio GENERAL", "https://jtsoya539.github.io/risk/")]
    [Authorize(Roles = "ADMINISTRADOR,USUARIO,USUARIO_NUEVO")]
    [Route("Api/[controller]")]
    [ApiController]
    public class GenController : RiskControllerBase
    {
        private readonly IGenService _genService;

        public GenController(IGenService genService, IConfiguration configuration) : base(configuration)
        {
            _genService = genService;
        }

        [AllowAnyClient]
        [AllowAnonymous]
        [HttpGet("/[controller]/VersionSistema")]
        [SwaggerOperation(OperationId = "VersionSistema", Summary = "VersionSistema", Description = "Obtiene la versión actual del sistema")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Dato>))]
        public IActionResult VersionSistema()
        {
            var respuesta = _genService.VersionSistema();
            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpGet("VersionServicio")]
        [SwaggerOperation(OperationId = "VersionServicio", Summary = "VersionServicio", Description = "Obtiene la versión actual del servicio")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Dato>))]
        public IActionResult VersionServicio([FromQuery, SwaggerParameter(Description = "Nombre del servicio", Required = true)] string servicio)
        {
            var respuesta = _genService.VersionServicio(servicio);
            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("ValorParametro")]
        [SwaggerOperation(OperationId = "ValorParametro", Summary = "ValorParametro", Description = "Obtiene el valor de un parámetro")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Dato>))]
        public IActionResult ValorParametro([FromQuery, SwaggerParameter(Description = "Identificador del parámetro", Required = true)] string parametro)
        {
            var respuesta = _genService.ValorParametro(parametro);
            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("SignificadoCodigo")]
        [SwaggerOperation(OperationId = "SignificadoCodigo", Summary = "SignificadoCodigo", Description = "Obtiene el significado de un código dentro de un dominio")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Dato>))]
        public IActionResult SignificadoCodigo([FromQuery, SwaggerParameter(Description = "Dominio", Required = true)] string dominio, [FromQuery, SwaggerParameter(Description = "Código", Required = true)] string codigo)
        {
            var respuesta = _genService.SignificadoCodigo(dominio, codigo);
            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("ListarSignificados")]
        [SwaggerOperation(OperationId = "ListarSignificados", Summary = "ListarSignificados", Description = "Obtiene una lista de significados dentro de un dominio")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Pagina<Significado>>))]
        public IActionResult ListarSignificados([FromQuery, SwaggerParameter(Description = "Dominio", Required = true)] string dominio,
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
            var respuesta = _genService.ListarSignificados(dominio, paginaParametros);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpGet("ListarErrores")]
        [SwaggerOperation(OperationId = "ListarErrores", Summary = "ListarErrores", Description = "Obtiene una lista de errores o textos")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Pagina<Error>>))]
        public IActionResult ListarErrores([FromQuery, SwaggerParameter(Description = "Clave del error o texto", Required = false)] string clave,
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
            var respuesta = _genService.ListarErrores(clave, paginaParametros);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpGet("ListarAplicaciones")]
        [SwaggerOperation(OperationId = "ListarAplicaciones", Summary = "ListarAplicaciones", Description = "Obtiene una lista de aplicaciones")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Pagina<Aplicacion>>))]
        public IActionResult ListarAplicaciones([FromQuery, SwaggerParameter(Description = "Identificador de la aplicacion", Required = false)] string idAplicacion,
            [FromQuery, SwaggerParameter(Description = "Clave de la aplicacion", Required = false)] string claveAplicacion,
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
            var respuesta = _genService.ListarAplicaciones(idAplicacion, claveAplicacion, paginaParametros);

            respuesta.Datos = ProcesarPagina(respuesta.Datos);

            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("RecuperarArchivo")]
        [SwaggerOperation(OperationId = "RecuperarArchivo", Summary = "RecuperarArchivo", Description = "Permite recuperar un archivo")]
        [Produces(MediaTypeNames.Application.Json, new[] { "application/octet-stream" })]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(FileContentResult))]
        public IActionResult RecuperarArchivo([FromQuery, SwaggerParameter(Description = "Tabla", Required = true)] string tabla,
            [FromQuery, SwaggerParameter(Description = "Campo", Required = true)] string campo,
            [FromQuery, SwaggerParameter(Description = "Referencia", Required = true)] string referencia,
            [FromQuery, SwaggerParameter(Description = "Versión", Required = false)] int? version)
        {
            var respuesta = _genService.RecuperarArchivo(tabla, campo, referencia, version);

            if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return ProcesarRespuesta(respuesta);
            }

            return ProcesarArchivo(respuesta.Datos);
        }

        [HttpPost("GuardarArchivo")]
        [SwaggerOperation(OperationId = "GuardarArchivo", Summary = "GuardarArchivo", Description = "Permite guardar un archivo")]
        [Consumes("multipart/form-data")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Dato>))]
        public IActionResult GuardarArchivo([FromQuery, SwaggerParameter(Description = "Tabla", Required = true)] string tabla,
            [FromQuery, SwaggerParameter(Description = "Campo", Required = true)] string campo,
            [FromQuery, SwaggerParameter(Description = "Referencia", Required = true)] string referencia,
            [FromForm] GuardarArchivoRequestBody requestBody)
        {
            var respuesta = _genService.GuardarArchivo(tabla, campo, referencia, ProcesarArchivo(requestBody));
            return ProcesarRespuesta(respuesta);
        }

        [AllowAnonymous]
        [HttpGet("RecuperarTexto")]
        [SwaggerOperation(OperationId = "RecuperarTexto", Summary = "RecuperarTexto", Description = "Obtiene un texto definido en el sistema")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(Respuesta<Dato>))]
        public IActionResult RecuperarTexto([FromQuery, SwaggerParameter(Description = "Referencia del texto", Required = true)] string referencia)
        {
            var respuesta = _genService.RecuperarTexto(referencia);
            return ProcesarRespuesta(respuesta);
        }

        [HttpGet("ReporteVersionSistema")]
        [SwaggerOperation(OperationId = "ReporteVersionSistema", Summary = "ReporteVersionSistema", Description = "Obtiene un reporte con la versión actual del sistema", Tags = new[] { "Gen", "Rep" })]
        [Produces(MediaTypeNames.Application.Json, new[] { "application/octet-stream" })]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(FileContentResult))]
        public IActionResult ReporteVersionSistema([FromQuery, SwaggerParameter(Description = "Formato del reporte", Required = true)] FormatoReporte formato)
        {
            var respuesta = _genService.ReporteVersionSistema(formato);

            if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return ProcesarRespuesta(respuesta);
            }

            return ProcesarArchivo(respuesta.Datos);
        }

        [HttpGet("ReporteListarSignificados")]
        [SwaggerOperation(OperationId = "ReporteListarSignificados", Summary = "ReporteListarSignificados", Description = "Obtiene un reporte con los significados dentro de un dominio", Tags = new[] { "Gen", "Rep" })]
        [Produces(MediaTypeNames.Application.Json, new[] { "application/octet-stream" })]
        [SwaggerResponse(StatusCodes.Status200OK, RiskConstants.SWAGGER_RESPONSE_200, typeof(FileContentResult))]
        public IActionResult ReporteListarSignificados([FromQuery, SwaggerParameter(Description = "Formato del reporte", Required = true)] FormatoReporte formato,
            [FromQuery, SwaggerParameter(Description = "Dominio", Required = false)] string dominio)
        {
            var respuesta = _genService.ReporteListarSignificados(formato, dominio);

            if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return ProcesarRespuesta(respuesta);
            }

            return ProcesarArchivo(respuesta.Datos);
        }
    }
}
