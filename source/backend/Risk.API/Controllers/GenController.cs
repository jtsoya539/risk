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

        [SwaggerOperation(Summary = "Summary",
            Description = "Description",
            OperationId = "ValorParametro")]
        [HttpGet("ValorParametro")]
        public IActionResult ValorParametro([SwaggerParameter(Description = "Description", Required = true)][FromQuery] string parametro)
        {
            YRespuesta<YDato> respuesta = _genService.ValorParametro(parametro);
            return Ok(respuesta);
        }

        [SwaggerOperation(Summary = "Summary",
            Description = "Description",
            OperationId = "SignificadoCodigo")]
        [HttpGet("SignificadoCodigo")]
        public IActionResult SignificadoCodigo([SwaggerParameter(Description = "Description", Required = true)][FromQuery] string dominio, [SwaggerParameter(Description = "Description", Required = true)][FromQuery] string codigo)
        {
            YRespuesta<YDato> respuesta = _genService.SignificadoCodigo(dominio, codigo);
            return Ok(respuesta);
        }
    }
}
