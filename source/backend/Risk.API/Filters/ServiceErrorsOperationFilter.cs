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

using System.Collections.Generic;
using System.Net.Mime;
using Microsoft.AspNetCore.Http;
using Microsoft.OpenApi.Models;
using Risk.API.Models;
using Risk.Common.Helpers;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace Risk.API.Filters
{
    public class ServiceErrorsOperationFilter : IOperationFilter
    {
        public void Apply(OpenApiOperation operation, OperationFilterContext context)
        {
            var content = new Dictionary<string, OpenApiMediaType>
            {
                [MediaTypeNames.Application.Json] = new OpenApiMediaType
                {
                    Schema = context.SchemaGenerator.GenerateSchema(typeof(Respuesta<Dato>), context.SchemaRepository)
                }
            };


            if (!operation.Responses.ContainsKey(StatusCodes.Status400BadRequest.ToString()))
            {
                operation.Responses.Add(StatusCodes.Status400BadRequest.ToString(), new OpenApiResponse
                {
                    Description = RiskConstants.SWAGGER_RESPONSE_400,
                    Content = content
                });
            }

            if (!operation.Responses.ContainsKey(StatusCodes.Status500InternalServerError.ToString()))
            {
                operation.Responses.Add(StatusCodes.Status500InternalServerError.ToString(), new OpenApiResponse
                {
                    Description = RiskConstants.SWAGGER_RESPONSE_500,
                    Content = content
                });
            }

            if (!operation.Responses.ContainsKey(StatusCodes.Status501NotImplemented.ToString()))
            {
                operation.Responses.Add(StatusCodes.Status501NotImplemented.ToString(), new OpenApiResponse
                {
                    Description = RiskConstants.SWAGGER_RESPONSE_501,
                    Content = content
                });
            }
        }
    }
}