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
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net.Mail;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Http;
using Microsoft.IdentityModel.Tokens;
using Risk.API.Models;
using Risk.API.Services;

namespace Risk.API.Helpers
{
    public static class TokenHelper
    {
        public static string GenerarAccessToken(string usuario, IAutService autService, IGenService genService)
        {
            var respDatosUsuario = autService.DatosUsuario(usuario);
            if (!respDatosUsuario.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return string.Empty;
            }

            Usuario datosUsuario = respDatosUsuario.Datos;

            // Crea la lista de claims (pertenencias, características) del usuario
            List<Claim> claims = new List<Claim>();

            claims.Add(new Claim(ClaimTypes.Name, datosUsuario.Alias));
            claims.Add(new Claim(ClaimTypes.GivenName, datosUsuario.Nombre ?? ""));
            claims.Add(new Claim(ClaimTypes.Surname, datosUsuario.Apellido ?? ""));
            claims.Add(new Claim(ClaimTypes.Email, datosUsuario.DireccionCorreo ?? ""));
            //claimsList.Add(new Claim(ClaimTypes.HomePhone, usuario.NumeroTelefono ?? ""));

            // Agrega los roles del usuario a la lista de claims
            foreach (var rol in datosUsuario.Roles)
            {
                claims.Add(new Claim(ClaimTypes.Role, rol.Nombre));
            }

            var respTiempoExpiracionToken = autService.TiempoExpiracionToken(TipoToken.AccessToken);
            if (!respTiempoExpiracionToken.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return string.Empty;
            }
            int tiempoExpiracion = int.Parse(respTiempoExpiracionToken.Datos.Contenido);

            var respValorParametro = genService.ValorParametro("CLAVE_VALIDACION_ACCESS_TOKEN");
            if (!respValorParametro.Codigo.Equals(RiskConstants.CODIGO_OK))
            {
                return string.Empty;
            }
            var signingKey = Encoding.ASCII.GetBytes(respValorParametro.Datos.Contenido);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims.ToArray()),
                Expires = DateTime.UtcNow.AddSeconds(tiempoExpiracion),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(signingKey), SecurityAlgorithms.HmacSha256Signature)
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var createdToken = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(createdToken);
        }

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

            string riskAppKeyHeader = null;
            if (headers.Keys.Contains(RiskConstants.HEADER_RISK_APP_KEY))
            {
                riskAppKeyHeader = headers[RiskConstants.HEADER_RISK_APP_KEY];
            }
            else if (headers.Keys.Contains(RiskConstants.HEADER_RISK_APP_KEY.ToLower()))
            {
                riskAppKeyHeader = headers[RiskConstants.HEADER_RISK_APP_KEY.ToLower()];
            }
            else if (headers.Keys.Contains(RiskConstants.HEADER_RISK_APP_KEY.ToUpper()))
            {
                riskAppKeyHeader = headers[RiskConstants.HEADER_RISK_APP_KEY.ToUpper()];
            }

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

        public static string ObtenerVersionDeHeaders(IHeaderDictionary headers)
        {
            string version = string.Empty;

            string riskServiceVersionHeader = null;
            if (headers.Keys.Contains(RiskConstants.HEADER_RISK_SERVICE_VERSION))
            {
                riskServiceVersionHeader = headers[RiskConstants.HEADER_RISK_SERVICE_VERSION];
            }
            else if (headers.Keys.Contains(RiskConstants.HEADER_RISK_SERVICE_VERSION.ToLower()))
            {
                riskServiceVersionHeader = headers[RiskConstants.HEADER_RISK_SERVICE_VERSION.ToLower()];
            }
            else if (headers.Keys.Contains(RiskConstants.HEADER_RISK_SERVICE_VERSION.ToUpper()))
            {
                riskServiceVersionHeader = headers[RiskConstants.HEADER_RISK_SERVICE_VERSION.ToUpper()];
            }

            if (!string.IsNullOrEmpty(riskServiceVersionHeader))
            {
                version = riskServiceVersionHeader;
            }

            return version;
        }

        public static UsuarioExterno ObtenerUsuarioDeTokenGoogle(string idToken)
        {
            UsuarioExterno usuario = null;

            JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();
            if (tokenHandler.CanReadToken(idToken))
            {
                JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(idToken);
                string idExterno = jwtToken.Claims.First(claim => claim.Type == "sub").Value;
                string nombre = jwtToken.Claims.First(claim => claim.Type == "given_name").Value;
                string apellido = jwtToken.Claims.First(claim => claim.Type == "family_name").Value;
                string direccionCorreo = jwtToken.Claims.First(claim => claim.Type == "email").Value;

                MailAddress addr = new MailAddress(direccionCorreo);
                string username = addr.User;
                string domain = addr.Host;

                usuario = new UsuarioExterno
                {
                    Alias = username,
                    Nombre = nombre,
                    Apellido = apellido,
                    DireccionCorreo = direccionCorreo,
                    Origen = OrigenSesion.Google,
                    IdExterno = idExterno
                };
            }

            return usuario;
        }
    }
}