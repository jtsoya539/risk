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

using Risk.API.Entities;
using Swashbuckle.AspNetCore.Annotations;

namespace Risk.API.Models
{
    [SwaggerSchema("Agrupa datos de una sesión")]
    public class Sesion : IModel
    {
        [SwaggerSchema("Identificador de la sesion")]
        public long IdSesion { get; set; }
        [SwaggerSchema("Estado de la sesion")]
        public string Estado { get; set; }
        [SwaggerSchema("Access Token de la sesion")]
        public string AccessToken { get; set; }
        [SwaggerSchema("Refresh Token de la sesion")]
        public string RefreshToken { get; set; }
        [SwaggerSchema("Tiempo de expiración del Access Token en segundos")]
        public int TiempoExpiracionAccessToken { get; set; }
        [SwaggerSchema("Tiempo de expiración del Refresh Token en horas")]
        public int TiempoExpiracionRefreshToken { get; set; }

        public IEntity ConvertToEntity()
        {
            throw new System.NotImplementedException();
        }
    }
}