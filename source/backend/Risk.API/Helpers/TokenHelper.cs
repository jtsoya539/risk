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

using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Cryptography;
using Microsoft.AspNetCore.Http;

namespace Risk.API.Helpers
{
    public static class TokenHelper
    {
        public static string GenerarRefreshToken(int size = 32)
        {
            var randomNumber = new byte[size];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(randomNumber);
                return Convert.ToBase64String(randomNumber);
            }
        }

        public static string GenerarTokenDispositivo()
        {
            return DateTime.Now.Ticks.ToString() + "-" + Guid.NewGuid().ToString();
        }

        public static string ObtenerUsuarioDeAccessToken(string accessToken)
        {
            string usuario = string.Empty;

            JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();
            if (tokenHandler.CanReadToken(accessToken))
            {
                JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(accessToken);
                usuario = jwtToken.Claims.First(claim => claim.Type == "unique_name").Value;
            }

            return usuario;
        }

        public static string ObtenerClaveAplicacionDeHeaders(IHeaderDictionary headers)
        {
            string claveAplicacion = string.Empty;

            string riskAppKeyHeader = headers[RiskConstants.HEADER_RISK_APP_KEY];
            if (!string.IsNullOrEmpty(riskAppKeyHeader))
            {
                claveAplicacion = riskAppKeyHeader;
            }

            return claveAplicacion;
        }

        public static string ObtenerAccessTokenDeHeaders(IHeaderDictionary headers)
        {
            string accessToken = string.Empty;

            string authHeader = headers[RiskConstants.HEADER_AUTHORIZATION];
            if (!string.IsNullOrEmpty(authHeader) && authHeader.StartsWith("Bearer", StringComparison.OrdinalIgnoreCase))
            {
                accessToken = authHeader.Substring("Bearer".Length).Trim();
            }

            return accessToken;
        }
    }
}