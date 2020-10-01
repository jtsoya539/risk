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
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using Risk.API.Exceptions;
using Risk.API.Helpers;
using Risk.API.Models;

namespace Risk.API.Middlewares
{
    public static class RiskExceptionHandlerMiddlewareExtensions
    {
        public static void UseRiskExceptionHandler(this IApplicationBuilder builder)
        {
            builder.UseExceptionHandler(appError =>
            {
                appError.Run(async context =>
                {
                    context.Response.StatusCode = StatusCodes.Status500InternalServerError;
                    context.Response.ContentType = MediaTypeNames.Application.Json;
                    var exceptionHandlerFeature = context.Features.Get<IExceptionHandlerFeature>();
                    if (exceptionHandlerFeature != null)
                    {
                        var exception = exceptionHandlerFeature.Error;
                        var respuesta = new Respuesta<Dato>();
                        if (exception is RiskDbException)
                        {
                            respuesta.Codigo = RiskConstants.CODIGO_DB_EXCEPTION;
                            respuesta.Mensaje = exception.Message;
                        }
                        else if (exception is RiskApiException)
                        {
                            respuesta.Codigo = RiskConstants.CODIGO_API_EXCEPTION;
                            respuesta.Mensaje = exception.Message;
                        }
                        else
                        {
                            respuesta.Codigo = RiskConstants.CODIGO_EXCEPTION;
                            respuesta.Mensaje = "Error inesperado";
                        }

                        await context.Response.WriteAsync(JsonConvert.SerializeObject(respuesta));
                    }
                });
            });
        }
    }
}