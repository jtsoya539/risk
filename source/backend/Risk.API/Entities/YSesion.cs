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

using Newtonsoft.Json;
using Risk.API.Attributes;
using Risk.API.Models;

namespace Risk.API.Entities
{
    public class YSesion : IEntity
    {
        [JsonProperty("id_sesion")]
        public long IdSesion { get; set; }
        [JsonProperty("estado")]
        public string Estado { get; set; }
        [JsonProperty("access_token")]
        public string AccessToken { get; set; }
        [JsonProperty("refresh_token")]
        public string RefreshToken { get; set; }
        [JsonProperty("tiempo_expiracion_access_token")]
        public int TiempoExpiracionAccessToken { get; set; }
        [JsonProperty("tiempo_expiracion_refresh_token")]
        public int TiempoExpiracionRefreshToken { get; set; }

        public IModel ConvertToModel()
        {
            return new Sesion
            {
                IdSesion = this.IdSesion,
                Estado = this.Estado.GetEnumValue<EstadoSesion>(),
                AccessToken = this.AccessToken,
                RefreshToken = this.RefreshToken,
                TiempoExpiracionAccessToken = this.TiempoExpiracionAccessToken,
                TiempoExpiracionRefreshToken = this.TiempoExpiracionRefreshToken
            };
        }
    }
}