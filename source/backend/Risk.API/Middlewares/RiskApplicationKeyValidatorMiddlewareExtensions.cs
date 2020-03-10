using Microsoft.AspNetCore.Builder;

namespace Risk.API.Middlewares
{
    public static class RiskApplicationKeyValidatorMiddlewareExtensions
    {
        public static IApplicationBuilder UseRiskApplicationKeyValidator(
            this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<RiskApplicationKeyValidatorMiddleware>();
        }
    }
}