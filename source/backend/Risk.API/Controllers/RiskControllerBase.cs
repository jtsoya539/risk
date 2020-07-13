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
using System.Web;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Risk.API.Helpers;
using Risk.API.Models;

namespace Risk.API.Controllers
{
    public class RiskControllerBase : ControllerBase
    {
        protected readonly IConfiguration _configuration;
        private readonly bool _enableHttpStatusCodes;

        public RiskControllerBase(IConfiguration configuration)
        {
            _configuration = configuration;
            _enableHttpStatusCodes = _configuration.GetValue<bool>("EnableHttpStatusCodes");
        }

        public IActionResult ProcesarRespuesta<T>(Respuesta<T> respuesta)
        {
            if (respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return Ok(respuesta); // 200 OK
            }
            else
            {
                if (_enableHttpStatusCodes)
                {
                    if (respuesta.Codigo.Equals(RiskConstants.CODIGO_ERROR_INESPERADO))
                        return StatusCode(StatusCodes.Status500InternalServerError, respuesta); // 500 Internal Server Error
                    else if (respuesta.Codigo.Equals(RiskConstants.CODIGO_SERVICIO_NO_IMPLEMENTADO))
                        return StatusCode(StatusCodes.Status501NotImplemented, respuesta); // 501 Not Implemented
                    else
                        return BadRequest(respuesta); // 400 Bad Request
                }
                else
                {
                    return Ok(respuesta); // 200 OK
                }
            }
        }

        public Pagina<T> ProcesarPagina<T>(Pagina<T> pagina)
        {
            Pagina<T> resp;
            if (pagina == null)
            {
                resp = null;
            }
            else
            {
                resp = pagina;

                int port = -1;
                if (Request.Host.Port.HasValue)
                {
                    port = Request.Host.Port.Value;
                }

                var uriBuilder = new UriBuilder(Request.Scheme, Request.Host.Host, port, Request.Path.ToString(), Request.QueryString.ToString());
                var query = HttpUtility.ParseQueryString(uriBuilder.Query);

                query["pagina"] = resp.PaginaActual;
                uriBuilder.Query = query.ToString();
                resp.PaginaActual = uriBuilder.ToString();

                query["pagina"] = resp.PaginaSiguiente;
                uriBuilder.Query = query.ToString();
                resp.PaginaSiguiente = uriBuilder.ToString();

                query["pagina"] = resp.PaginaUltima;
                uriBuilder.Query = query.ToString();
                resp.PaginaUltima = uriBuilder.ToString();

                query["pagina"] = resp.PaginaPrimera;
                uriBuilder.Query = query.ToString();
                resp.PaginaPrimera = uriBuilder.ToString();

                query["pagina"] = resp.PaginaAnterior;
                uriBuilder.Query = query.ToString();
                resp.PaginaAnterior = uriBuilder.ToString();
            }
            return resp;
        }
    }
}