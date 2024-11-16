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
using System.Text;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Tokens;
using Risk.API.Helpers;
using Risk.API.Models;
using Risk.API.Services;
using Risk.Common.Helpers;

namespace Risk.API.Middlewares
{
    public class RiskTokenHandler : TokenHandler
    {
        private readonly ICacheHelper _cacheHelper;
        private readonly IAutService _autService;
        private JwtSecurityTokenHandler _tokenHandler;

        public RiskTokenHandler(ICacheHelper cacheHelper, IAutService autService)
        {
            _cacheHelper = cacheHelper;
            _autService = autService;
            _tokenHandler = new JwtSecurityTokenHandler();
        }

        public override async Task<TokenValidationResult> ValidateTokenAsync(string token, TokenValidationParameters validationParameters)
        {
            TokenValidationResult tokenValidationResult;

            var signingKey = Encoding.ASCII.GetBytes(_cacheHelper.GetDbConfigValue("CLAVE_VALIDACION_ACCESS_TOKEN"));
            validationParameters.IssuerSigningKey = new SymmetricSecurityKey(signingKey);

            tokenValidationResult = await _tokenHandler.ValidateTokenAsync(token, validationParameters);

            Respuesta<Dato> respuesta;

            if (!tokenValidationResult.IsValid)
            {
                if (tokenValidationResult.Exception != null)
                {
                    EstadoSesion estadoSesion = EstadoSesion.Invalido;
                    if (tokenValidationResult.Exception is SecurityTokenExpiredException)
                    {
                        estadoSesion = EstadoSesion.Expirado;
                    }

                    _autService.Version = string.Empty;
                    respuesta = _autService.CambiarEstadoSesion(token, estadoSesion);
                    throw tokenValidationResult.Exception;
                }
            }

            _autService.Version = string.Empty;
            respuesta = _autService.ValidarSesion(token);

            if (!respuesta.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                throw new SecurityTokenValidationException(respuesta.Mensaje);
            }

            return tokenValidationResult;
        }
    }
}