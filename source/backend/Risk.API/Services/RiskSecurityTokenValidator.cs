using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;

namespace Risk.API.Services
{
    public class RiskSecurityTokenValidator : ISecurityTokenValidator
    {
        public bool CanValidateToken => throw new System.NotImplementedException();

        public int MaximumTokenSizeInBytes { get => throw new System.NotImplementedException(); set => throw new System.NotImplementedException(); }

        private readonly IAutService _autService;

        public RiskSecurityTokenValidator(IAutService autService)
        {
            _autService = autService;
        }

        public bool CanReadToken(string securityToken)
        {
            throw new System.NotImplementedException();
        }

        public ClaimsPrincipal ValidateToken(string securityToken, TokenValidationParameters validationParameters, out SecurityToken validatedToken)
        {
            throw new System.NotImplementedException();
        }
    }
}