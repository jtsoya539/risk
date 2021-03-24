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
using System.IO;
using System.Net;
using System.Net.Mime;
using System.Web;
using iText.Html2pdf;
using iText.Html2pdf.Attach.Impl;
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

        protected IActionResult ProcesarRespuesta<T>(Respuesta<T> respuesta)
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
                    else if (respuesta.Codigo.Equals(RiskConstants.CODIGO_ERROR_PERMISO))
                        return StatusCode(StatusCodes.Status401Unauthorized, respuesta); // 401 Unauthorized
                    else
                        return BadRequest(respuesta); // 400 Bad Request
                }
                else
                {
                    return Ok(respuesta); // 200 OK
                }
            }
        }

        protected FileContentResult ProcesarArchivo(Archivo archivo)
        {
            byte[] contenido = null;
            if (archivo.Contenido != null)
            {
                contenido = GZipHelper.Decompress(Convert.FromBase64String(archivo.Contenido));
                if (archivo.TipoMime.Contains("text/", StringComparison.OrdinalIgnoreCase))
                {
                    contenido = EncodingHelper.ConvertToUTF8(contenido, _configuration["OracleConfiguration:CharacterSet"]);
                }
            }
            else if (archivo.Url != null)
            {
                using (var webClient = new WebClient())
                {
                    contenido = webClient.DownloadData(archivo.Url);
                }
            }

            if (archivo.Extension.Equals(RiskConstants.FORMATO_HTML, StringComparison.OrdinalIgnoreCase) &&
                HtmlHelper.ObtenerMetaContent(contenido, "risk:format").Equals(RiskConstants.FORMATO_PDF, StringComparison.OrdinalIgnoreCase))
            {
                contenido = PdfHelper.ConvertToPdf(contenido);
                archivo.Extension = RiskConstants.FORMATO_PDF.ToLower();
                archivo.TipoMime = MediaTypeNames.Application.Pdf;
            }

            return File(contenido, archivo.TipoMime, string.Concat(archivo.Nombre, ".", archivo.Extension));
        }

        protected Archivo ProcesarArchivo(GuardarArchivoRequestBody requestBody)
        {
            string contenido = string.Empty;
            string url = string.Empty;

            if (requestBody.Archivo != null)
            {
                if (requestBody.Archivo.Length > 0)
                {
                    using (var ms = new MemoryStream())
                    {
                        requestBody.Archivo.CopyTo(ms);
                        contenido = Convert.ToBase64String(GZipHelper.Compress(ms.ToArray()));
                    }
                }
            }
            else if (requestBody.Url != null)
            {
                url = requestBody.Url;
            }


            return new Archivo
            {
                Contenido = contenido,
                Url = url,
                Nombre = requestBody.Nombre,
                Extension = requestBody.Extension
            };
        }

        protected Pagina<T> ProcesarPagina<T>(Pagina<T> pagina)
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