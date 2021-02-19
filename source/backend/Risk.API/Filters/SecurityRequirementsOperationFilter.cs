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
using System.Linq;
using System.Net.Mime;
using Microsoft.AspNetCore.Authorization;
using Microsoft.OpenApi.Models;
using Risk.API.Attributes;
using Risk.API.Helpers;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace Risk.API.Filters
{
    public class SecurityRequirementsOperationFilter : IOperationFilter
    {
        public void Apply(OpenApiOperation operation, OperationFilterContext context)
        {
            var securityRequirement = new OpenApiSecurityRequirement();

            var content = new Dictionary<string, OpenApiMediaType>
            {
                [MediaTypeNames.Text.Plain] = new OpenApiMediaType
                {
                    Schema = new OpenApiSchema()
                    {
                        Type = "string"
                    }
                }
            };

            var allowAnyClientAttributes = context.MethodInfo.GetCustomAttributes(true).OfType<AllowAnyClientAttribute>();

            if (!allowAnyClientAttributes.Any())
            {
                // Add OpenApi Security Scheme
                securityRequirement.Add(new OpenApiSecurityScheme
                {
                    Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = RiskConstants.SECURITY_SCHEME_RISK_APP_KEY }
                },
                new List<string>());

                // Add Http Response
                if (!operation.Responses.ContainsKey("403"))
                {
                    operation.Responses.Add("403", new OpenApiResponse
                    {
                        Description = "Aplicación no autorizada",
                        Content = content
                    });
                }
            }

            var authorizeAttributes = context.MethodInfo.DeclaringType.GetCustomAttributes(true).Union(context.MethodInfo.GetCustomAttributes(true)).OfType<AuthorizeAttribute>();
            var allowAnonymousAttributes = context.MethodInfo.GetCustomAttributes(true).OfType<AllowAnonymousAttribute>();

            if (authorizeAttributes.Any() && !allowAnonymousAttributes.Any())
            {
                // Add OpenApi Security Scheme
                securityRequirement.Add(new OpenApiSecurityScheme
                {
                    Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = RiskConstants.SECURITY_SCHEME_ACCESS_TOKEN }
                },
                new List<string>());

                // Add Http Response
                if (!operation.Responses.ContainsKey("401"))
                {
                    operation.Responses.Add("401", new OpenApiResponse
                    {
                        Description = "Operación no autorizada",
                        Content = content
                    });
                }
            }

            // Add OpenApi Security Requirement
            if (operation.Security == null)
            {
                operation.Security = new List<OpenApiSecurityRequirement>();
            }
            operation.Security.Add(securityRequirement);
        }
    }
}