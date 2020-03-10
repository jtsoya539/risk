using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using Risk.API.Entities;
using Risk.API.Services;

namespace Risk.API.Middlewares
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
            ClaimsPrincipal claimsPrincipal;
            YRespuesta<YDato> respuesta;

            try
            {
                claimsPrincipal = _tokenHandler.ValidateToken(securityToken, validationParameters, out validatedToken);
            }
            catch (SecurityTokenExpiredException)
            {
                respuesta = _autService.CambiarEstadoSesion(securityToken, "X");
                throw;
            }
            catch (SecurityTokenValidationException)
            {
                respuesta = _autService.CambiarEstadoSesion(securityToken, "I");
                throw;
            }

            respuesta = _autService.ValidarSesion(securityToken);

            if (!respuesta.Codigo.Equals("0"))
            {
                throw new SecurityTokenValidationException(respuesta.Mensaje);
            }

            return claimsPrincipal;
        }
    }
}