using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;

namespace Risk.API.Services
{
    public class RiskSecurityTokenValidator : ISecurityTokenValidator
    {
        private int _maximumTokenSizeInBytes = TokenValidationParameters.DefaultMaximumTokenSizeInBytes;
        private readonly IAutService _autService;
        private JwtSecurityTokenHandler _tokenHandler;

        public bool CanValidateToken
        {
            get
            {
                return true;
            }
        }

        public int MaximumTokenSizeInBytes
        {
            get
            {
                return _maximumTokenSizeInBytes;
            }
            set
            {
                _maximumTokenSizeInBytes = value;
            }
        }

        public RiskSecurityTokenValidator(IAutService autService)
        {
            _autService = autService;
            _tokenHandler = new JwtSecurityTokenHandler();
        }

        public bool CanReadToken(string securityToken)
        {
            return _tokenHandler.CanReadToken(securityToken);
        }

        public ClaimsPrincipal ValidateToken(string securityToken, TokenValidationParameters validationParameters, out SecurityToken validatedToken)
        {
            var respuesta = _autService.ValidarSesion(securityToken);

            if (!respuesta.Codigo.Equals("0"))
            {
                throw new Microsoft.IdentityModel.Tokens.SecurityTokenValidationException(respuesta.Mensaje);

            }

            return _tokenHandler.ValidateToken(securityToken, validationParameters, out validatedToken);
        }
    }
}