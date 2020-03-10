using Microsoft.AspNetCore.Http;
using Risk.API.Services;
using System.Globalization;
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
            if (!context.Request.Headers.Keys.Contains("Risk-App-Key"))
            {
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                await context.Response.WriteAsync("Risk-App-Key missing");
                return;
            }
            else
            {
                var respValidarClaveAplicacion = autService.ValidarClaveAplicacion(context.Request.Headers["Risk-App-Key"]);

                if (!respValidarClaveAplicacion.Codigo.Equals("0"))
                {
                    context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                    await context.Response.WriteAsync("Invalid Risk-App-Key");
                    return;
                }
            }

            // Call the next delegate/middleware in the pipeline
            await _next(context);
        }
    }
}