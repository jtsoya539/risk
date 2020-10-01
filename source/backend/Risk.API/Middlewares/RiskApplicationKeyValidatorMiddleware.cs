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

using Microsoft.AspNetCore.Http;
using Risk.API.Helpers;
using Risk.API.Services;
using System.Net.Mime;
using System.Threading.Tasks;

namespace Risk.API.Middlewares
{
    public class RiskApplicationKeyValidatorMiddleware
    {
        private readonly RequestDelegate _next;

        public RiskApplicationKeyValidatorMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context, IAutService autService)
        {
            if (context.Request.Path.StartsWithSegments(new PathString("/Api")))
            {
                string claveAplicacion = TokenHelper.ObtenerClaveAplicacionDeHeaders(context.Request.Headers);

                if (string.IsNullOrEmpty(claveAplicacion))
                {
                    context.Response.StatusCode = StatusCodes.Status403Forbidden;
                    context.Response.ContentType = MediaTypeNames.Text.Plain;
                    await context.Response.WriteAsync($"Missing {RiskConstants.HEADER_RISK_APP_KEY}");
                    return;
                }
                else
                {
                    var respValidarClaveAplicacion = autService.ValidarClaveAplicacion(claveAplicacion);

                    if (!respValidarClaveAplicacion.Codigo.Equals(RiskConstants.CODIGO_OK))
                    {
                        context.Response.StatusCode = StatusCodes.Status403Forbidden;
                        context.Response.ContentType = MediaTypeNames.Text.Plain;
                        await context.Response.WriteAsync($"Invalid {RiskConstants.HEADER_RISK_APP_KEY}");
                        return;
                    }
                }
            }

            // Call the next delegate/middleware in the pipeline
            await _next(context);
        }
    }
}