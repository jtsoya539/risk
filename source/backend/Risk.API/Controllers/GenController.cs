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

using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net.Mime;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Risk.API.Entities;
using Risk.API.Models;
using Risk.API.Services;
using Swashbuckle.AspNetCore.Annotations;

namespace Risk.API.Controllers
{
    [SwaggerTag("Servicios Web del dominio GENERAL", "https://github.com/jtsoya539")]
    [Authorize(Roles = "ADMINISTRADOR,USUARIO")]
    [Route("Api/[controller]")]
    [ApiController]
    public class GenController : ControllerBase
    {
        private readonly IGenService _genService;
        private readonly IConfiguration _configuration;

        public GenController(IGenService genService, IConfiguration configuration)
        {
            _genService = genService;
            _configuration = configuration;
        }

        [HttpGet("ValorParametro")]
        [SwaggerOperation(Summary = "ValorParametro", Description = "Servicio para obtener el valor de un parámetro", OperationId = "ValorParametro")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(YRespuesta<YDato>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(YRespuesta<YDato>))]
        [SwaggerResponse(StatusCodes.Status401Unauthorized, "Sin permiso para realizar operación")]
        public IActionResult ValorParametro([SwaggerParameter(Description = "Identificador del parámetro", Required = true)][FromQuery] string parametro)
        {
            var respuesta = _genService.ValorParametro(parametro);
            if (!respuesta.Codigo.Equals("0"))
            {
                return BadRequest(respuesta);
            }
            return Ok(respuesta);
        }

        [HttpGet("SignificadoCodigo")]
        [SwaggerOperation(Summary = "SignificadoCodigo", Description = "Servicio para obtener el significado de un código dentro de un dominio", OperationId = "SignificadoCodigo")]
        [Produces(MediaTypeNames.Application.Json)]
        [SwaggerResponse(StatusCodes.Status200OK, "Operación exitosa", typeof(YRespuesta<YDato>))]
        [SwaggerResponse(StatusCodes.Status400BadRequest, "Operación con error", typeof(YRespuesta<YDato>))]
        [SwaggerResponse(StatusCodes.Status401Unauthorized, "Sin permiso para realizar operación")]
        public IActionResult SignificadoCodigo([SwaggerParameter(Description = "Dominio", Required = true)][FromQuery] string dominio, [SwaggerParameter(Description = "Código", Required = true)][FromQuery] string codigo)
        {
            var respuesta = _genService.SignificadoCodigo(dominio, codigo);
            if (!respuesta.Codigo.Equals("0"))
            {
                return BadRequest(respuesta);
            }
            return Ok(respuesta);
        }
    }
}
