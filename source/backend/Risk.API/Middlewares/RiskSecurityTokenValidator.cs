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

using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using Risk.API.Helpers;
using Risk.API.Models;
using Risk.API.Services;

namespace Risk.API.Middlewares
{
    public class RiskSecurityTokenValidator : ISecurityTokenValidator
    {
        private int _maximumTokenSizeInBytes = TokenValidationParameters.DefaultMaximumTokenSizeInBytes;
        private readonly IAutService _autService;
        private readonly IGenService _genService;
        private JwtSecurityTokenHandler _tokenHandler;

        public RiskSecurityTokenValidator(IAutService autService, IGenService genService)
        {
            _autService = autService;
            _genService = genService;
            _tokenHandler = new JwtSecurityTokenHandler();
        }

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

        public bool CanReadToken(string securityToken)
        {
            return _tokenHandler.CanReadToken(securityToken);
        }

        public ClaimsPrincipal ValidateToken(string securityToken, TokenValidationParameters validationParameters, out SecurityToken validatedToken)
        {
            ClaimsPrincipal claimsPrincipal;
            Respuesta<Dato> respuesta;

            respuesta = _genService.ValorParametro("CLAVE_VALIDACION_ACCESS_TOKEN");
            if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                throw new SecurityTokenValidationException(respuesta.Mensaje);
            }
            var signingKey = Encoding.ASCII.GetBytes(respuesta.Datos.Contenido);
            validationParameters.IssuerSigningKey = new SymmetricSecurityKey(signingKey);

            try
            {
                claimsPrincipal = _tokenHandler.ValidateToken(securityToken, validationParameters, out validatedToken);
            }
            catch (SecurityTokenExpiredException)
            {
                respuesta = _autService.CambiarEstadoSesion(securityToken, EstadoSesion.Expirado);
                throw;
            }
            catch (SecurityTokenValidationException)
            {
                respuesta = _autService.CambiarEstadoSesion(securityToken, EstadoSesion.Invalido);
                throw;
            }

            respuesta = _autService.ValidarSesion(securityToken);

            if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                throw new SecurityTokenValidationException(respuesta.Mensaje);
            }

            return claimsPrincipal;
        }
    }
}